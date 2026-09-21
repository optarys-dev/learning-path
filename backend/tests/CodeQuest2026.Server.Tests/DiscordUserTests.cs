using CodeQuest2026.Server.Application.Users.Commands;
using CodeQuest2026.Server.Application.Users.Queries;
using CodeQuest2026.Server.Controllers;
using CodeQuest2026.Server.Infrastructure.DataSource.Configurations;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Security.Claims;
using Xunit;

namespace CodeQuest2026.Server.Tests;

// SQLite exercises persistence locally; PostgreSQL migrations still need a development DB.
public sealed class DiscordUserTests : IAsyncLifetime
{
    private readonly SqliteConnection connection = new("Data Source=:memory:");
    private ServiceProvider provider = null!;
    private AsyncServiceScope scope;
    private ISender Sender => scope.ServiceProvider.GetRequiredService<ISender>();

    public async Task InitializeAsync()
    {
        await connection.OpenAsync();
        connection.CreateFunction<string, string, string>("GREATEST", (left, right) =>
            string.CompareOrdinal(left, right) >= 0 ? left : right);
        await using var command = connection.CreateCommand();
        command.CommandText = """
            CREATE TABLE users (
                user_id TEXT PRIMARY KEY, discord_id TEXT NOT NULL UNIQUE,
                username TEXT NOT NULL, display_name TEXT NULL, avatar TEXT NULL,
                created_at TEXT NOT NULL, last_login_at TEXT NOT NULL);
            CREATE TABLE user_preferences (user_id TEXT PRIMARY KEY);
            """;
        await command.ExecuteNonQueryAsync();
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseSqlite(connection)
            .Options;
        var services = new ServiceCollection();
        services.AddScoped<AppDbContext>(_ => new UserTestDbContext(options));
        services.AddMediatR(options => options.RegisterServicesFromAssemblyContaining<SyncDiscordUserCommand>());
        provider = services.BuildServiceProvider();
        scope = provider.CreateAsyncScope();
    }

    [Fact]
    public async Task FirstLoginCreatesUserAndNextLoginUpdatesSameUser()
    {
        await Sender.Send(new SyncDiscordUserCommand("123456789012345678", "first", "First", "avatar"));
        var first = await Sender.Send(new GetCurrentUserQuery("123456789012345678"));
        Assert.NotNull(first);
        Assert.True(Guid.TryParse(first.UserId, out _));
        Assert.True(first.IsNewUser);

        await Sender.Send(new SyncDiscordUserCommand(first.DiscordId, "renamed", null, null));
        var updated = await Sender.Send(new GetCurrentUserQuery(first.DiscordId));
        Assert.NotNull(updated);
        Assert.Equal(first.UserId, updated.UserId);
        Assert.Equal(first.CreatedAt, updated.CreatedAt);
        Assert.True(updated.LastLoginAt >= first.LastLoginAt);
        Assert.Equal("renamed", updated.Username);
        Assert.Null(updated.DisplayName);
        Assert.Null(updated.Avatar);
        Assert.Equal(1, await scope.ServiceProvider.GetRequiredService<AppDbContext>().Users.CountAsync());
    }

    [Theory]
    [InlineData("", "valid")]
    [InlineData("not-a-snowflake", "valid")]
    [InlineData("123", "")]
    public async Task InvalidProfileDoesNotCreateUser(string id, string username)
    {
        await Assert.ThrowsAsync<ArgumentException>(() =>
            Sender.Send(new SyncDiscordUserCommand(id, username, null, null)));
        Assert.Equal(0, await scope.ServiceProvider.GetRequiredService<AppDbContext>().Users.CountAsync());
    }

    [Fact]
    public async Task SavingPreferencesClearsNewUserFlag()
    {
        await Sender.Send(new SyncDiscordUserCommand("123", "alice", null, null));
        var first = await Sender.Send(new GetCurrentUserQuery("123"));
        Assert.NotNull(first);
        Assert.True(first.IsNewUser);
        await using var command = connection.CreateCommand();
        command.CommandText = "INSERT INTO user_preferences (user_id) VALUES ($userId)";
        command.Parameters.AddWithValue("$userId", first.UserId);
        await command.ExecuteNonQueryAsync();
        var updated = await Sender.Send(new GetCurrentUserQuery("123"));
        Assert.NotNull(updated);
        Assert.False(updated.IsNewUser);
    }

    [Fact]
    public async Task CurrentUserReturnsOnlyProfileFromAuthenticatedDiscordId()
    {
        await Sender.Send(new SyncDiscordUserCommand("123", "alice", null, null));
        await Sender.Send(new SyncDiscordUserCommand("456", "bob", null, null));
        var controller = new UsersController(Sender)
        {
            ControllerContext = new ControllerContext
            {
                HttpContext = new DefaultHttpContext
                {
                    User = new ClaimsPrincipal(new ClaimsIdentity(
                    [new Claim(ClaimTypes.NameIdentifier, "123")], "test"))
                }
            }
        };
        var result = await controller.Me(CancellationToken.None);
        var user = Assert.IsType<CodeQuest2026.Server.Application.Users.UserDto>(
            Assert.IsType<OkObjectResult>(result.Result).Value);
        Assert.Equal("alice", user.Username);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("999")]
    public async Task MissingIdentityOrUnregisteredSessionReturnsUnauthorized(string? id)
    {
        var context = new DefaultHttpContext();
        if (id is not null)
            context.User = new ClaimsPrincipal(new ClaimsIdentity(
                [new Claim(ClaimTypes.NameIdentifier, id)], "test"));
        var controller = new UsersController(Sender)
        {
            ControllerContext = new ControllerContext { HttpContext = context }
        };
        var result = await controller.Me(CancellationToken.None);
        Assert.True(result.Result is UnauthorizedResult or UnauthorizedObjectResult);
    }

    public async Task DisposeAsync()
    {
        await scope.DisposeAsync();
        await provider.DisposeAsync();
        await connection.DisposeAsync();
    }

    private sealed class UserTestDbContext(DbContextOptions<AppDbContext> options)
        : AppDbContext(options)
    {
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Ignore<Course>();
            modelBuilder.Ignore<Category>();
            modelBuilder.Ignore<Tag>();
            modelBuilder.Ignore<CourseEmbedding>();
            modelBuilder.Ignore<LearningRoute>();
            modelBuilder.Ignore<LearningRouteCourse>();
            new UserConfiguration().Configure(modelBuilder.Entity<CodeQuest2026.Server.Infrastructure.DataSource.Entities.User>());
            modelBuilder.Entity<UserPreference>(builder =>
            {
                builder.ToTable("user_preferences");
                builder.HasKey(x => x.UserId);
                builder.Property(x => x.UserId).HasColumnName("user_id");
                builder.Ignore(x => x.Goal);
                builder.Ignore(x => x.ExperienceLevel);
                builder.Ignore(x => x.Interests);
                builder.Ignore(x => x.ExistingSkills);
                builder.Ignore(x => x.PreferredLanguage);
                builder.Ignore(x => x.MinutesPerWeek);
                builder.Ignore(x => x.UpdatedAt);
                builder.HasOne(x => x.User).WithOne(x => x.Preferences)
                    .HasForeignKey<UserPreference>(x => x.UserId);
            });
        }
    }
}
