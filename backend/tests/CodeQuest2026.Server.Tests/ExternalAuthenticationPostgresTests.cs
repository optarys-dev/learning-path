using CodeQuest2026.Server.Application.Users.Commands;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.Extensions.Configuration;
using Npgsql;
using Xunit;

namespace CodeQuest2026.Server.Tests;

// Uses only an explicit test connection or an existing localhost development connection.
// Every test creates and removes its own randomly named schema; no application tables are touched.
public sealed class LocalPostgresFactAttribute : FactAttribute
{
    public LocalPostgresFactAttribute()
    {
        if (TestConnection() is null) Skip = "No local PostgreSQL test connection is configured.";
    }

    internal static string? TestConnection()
    {
        var explicitConnection = Environment.GetEnvironmentVariable("LEARNING_PATH_TEST_POSTGRES");
        if (!string.IsNullOrWhiteSpace(explicitConnection)) return explicitConnection;
        var config = new ConfigurationBuilder().AddUserSecrets<AppDbContext>(optional: true).AddEnvironmentVariables().Build();
        var connection = config.GetConnectionString("DefaultConnection");
        if (string.IsNullOrWhiteSpace(connection)) return null;
        var settings = new NpgsqlConnectionStringBuilder(connection);
        return settings.Host is "localhost" or "127.0.0.1" or "::1" ? connection : null;
    }
}

public sealed class ExternalAuthenticationPostgresTests
{
    [LocalPostgresFact]
    public async Task MigrationPreservesDiscordOwnershipAndRollbackProtectsGoogleAccounts()
    {
        await WithSchema(async connection =>
        {
            await PrepareOldSchema(connection);
            await using var db = Context(connection);
            var migrator = db.GetService<IMigrator>();
            var sql = migrator.GenerateScript("20260923034409_AddLearningRouteCourseProgress", "20260926043325_AddExternalAuthentication");
            await Execute(connection, sql);
            Assert.Equal("legacy-owner", await Scalar(connection, "SELECT user_id FROM user_external_logins WHERE provider = 'Discord' AND provider_user_id = '123'"));
            Assert.Equal("legacy-owner", await Scalar(connection, "SELECT user_id FROM learning_routes WHERE route_id = 'existing-route'"));
            var google = await new SyncExternalUserCommandHandler(db).Handle(
                new SyncExternalUserCommand("Google", "123", "Alice", null, null), default);
            Assert.NotEqual("legacy-owner", google);
            var down = migrator.GenerateScript("20260926043325_AddExternalAuthentication", "20260923034409_AddLearningRouteCourseProgress");
            await Assert.ThrowsAsync<PostgresException>(() => Execute(connection, down));
            // The failing Down transaction must be rolled back before inspecting preservation.
            await Execute(connection, "ROLLBACK;");
            Assert.Equal(2L, await Scalar(connection, "SELECT COUNT(*) FROM users"));
            Assert.Equal(2L, await Scalar(connection, "SELECT COUNT(*) FROM user_external_logins"));
        });
    }

    [LocalPostgresFact]
    public async Task SimultaneousGoogleLoginsCreateExactlyOneUser()
    {
        await WithSchema(async connection =>
        {
            await PrepareOldSchema(connection);
            await using (var db = Context(connection))
                await Execute(connection, db.GetService<IMigrator>().GenerateScript(
                    "20260923034409_AddLearningRouteCourseProgress", "20260926043325_AddExternalAuthentication"));
            var tasks = Enumerable.Range(0, 8).Select(async _ =>
            {
                await using var db = Context(connection);
                return await new SyncExternalUserCommandHandler(db).Handle(
                    new SyncExternalUserCommand("Google", "same-google-sub", "Alice", null, null), default);
            });
            var ids = await Task.WhenAll(tasks);
            Assert.Single(ids.Distinct());
            Assert.Equal(2L, await Scalar(connection, "SELECT COUNT(*) FROM users"));
            Assert.Equal(1L, await Scalar(connection, "SELECT COUNT(*) FROM user_external_logins WHERE provider = 'Google'"));
        });
    }

    private static AppDbContext Context(string connection) => new(new DbContextOptionsBuilder<AppDbContext>()
        .UseNpgsql(connection, options => { options.UseVector(); options.EnableRetryOnFailure(); }).Options);

    private static async Task WithSchema(Func<string, Task> test)
    {
        var connection = LocalPostgresFactAttribute.TestConnection()!;
        var schema = "google_auth_test_" + Guid.NewGuid().ToString("N");
        await Execute(connection, $"CREATE SCHEMA {schema}");
        try
        {
            var scoped = new NpgsqlConnectionStringBuilder(connection) { SearchPath = schema }.ConnectionString;
            await test(scoped);
        }
        finally { await Execute(connection, $"DROP SCHEMA {schema} CASCADE"); }
    }

    private static Task PrepareOldSchema(string connection) => Execute(connection, """
        CREATE TABLE users (user_id varchar(36) PRIMARY KEY, discord_id varchar(20) NOT NULL UNIQUE,
            username varchar(32) NOT NULL, display_name varchar(100), avatar varchar(128),
            created_at timestamptz NOT NULL, last_login_at timestamptz NOT NULL);
        CREATE TABLE learning_routes (route_id text PRIMARY KEY, user_id varchar(36) REFERENCES users(user_id));
        CREATE TABLE "__EFMigrationsHistory" ("MigrationId" varchar(150) PRIMARY KEY, "ProductVersion" varchar(32) NOT NULL);
        INSERT INTO users VALUES ('legacy-owner', '123', 'Alice', NULL, NULL, now(), now());
        INSERT INTO learning_routes VALUES ('existing-route', 'legacy-owner');
        """);

    private static async Task Execute(string connection, string sql)
    {
        await using var db = new NpgsqlConnection(connection);
        await db.OpenAsync();
        await using var command = new NpgsqlCommand(sql, db);
        await command.ExecuteNonQueryAsync();
    }

    private static async Task<object?> Scalar(string connection, string sql)
    {
        await using var db = new NpgsqlConnection(connection);
        await db.OpenAsync();
        await using var command = new NpgsqlCommand(sql, db);
        return await command.ExecuteScalarAsync();
    }
}
