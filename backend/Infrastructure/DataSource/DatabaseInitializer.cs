using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using Microsoft.EntityFrameworkCore;
using Npgsql;

namespace CodeQuest2026.Server.Infrastructure.DataSource;

public static class DatabaseInitializer
{
    private const string SeedVersion = "initial-catalog-2026-09-26-v1";

    public static async Task RunAsync(IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("ConnectionStrings:DefaultConnection is required.");
        var directory = configuration["DatabaseInitialization:SeedDirectory"] ?? "/seeds";
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseNpgsql(connectionString, postgres => { postgres.UseVector(); postgres.CommandTimeout(300); }).Options;
        await using var db = new AppDbContext(options);
        await db.Database.OpenConnectionAsync();
        var connection = (NpgsqlConnection)db.Database.GetDbConnection();
        // Serialize initialization across containers, including migrations and the seed marker.
        await ExecuteAsync(connection, "SELECT pg_advisory_lock(20260926, 1);");
        try
        {
            Console.WriteLine("Applying EF Core migrations...");
            await db.Database.MigrateAsync();
            await ApplySeedsAsync(connection, directory);
        }
        finally
        {
            await ExecuteAsync(connection, "SELECT pg_advisory_unlock(20260926, 1);");
        }
    }

    public static async Task ApplySeedsAsync(NpgsqlConnection connection, string directory)
    {
        await using var transaction = await connection.BeginTransactionAsync();
        await ExecuteAsync(connection, """
            CREATE TABLE IF NOT EXISTS public.app_seed_history (
                version text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now()
            );
            """);
        await using var marker = new NpgsqlCommand("SELECT EXISTS (SELECT 1 FROM public.app_seed_history WHERE version = @version)", connection);
        marker.Parameters.AddWithValue("version", SeedVersion);
        if ((bool)(await marker.ExecuteScalarAsync())!)
        {
            Console.WriteLine("Initial catalog and embeddings already loaded; skipping seeds.");
            await transaction.CommitAsync();
            return;
        }

        await ImportAsync(connection, Path.Combine(directory, "Seed DataCourses.sql"),
            ["categories", "tags", "courses", "course_categories", "course_tags"]);
        await ImportAsync(connection, Path.Combine(directory, "Seed Embeddings.sql"), ["course_embeddings"]);

        // Identity sequences are not advanced by explicit seed IDs. Never move an existing sequence backwards.
        foreach (var (table, key) in new[] { ("categories", "category_id"), ("tags", "tag_id"), ("courses", "course_id") })
            await ExecuteAsync(connection, $"""
                SELECT setval(pg_get_serial_sequence('public.{table}', '{key}'),
                    GREATEST((SELECT MAX({key}) FROM public.{table}),
                        nextval(pg_get_serial_sequence('public.{table}', '{key}'))), true);
                """);

        await using var insertMarker = new NpgsqlCommand("INSERT INTO public.app_seed_history (version) VALUES (@version)", connection);
        insertMarker.Parameters.AddWithValue("version", SeedVersion);
        await insertMarker.ExecuteNonQueryAsync();
        await transaction.CommitAsync();
        Console.WriteLine("Database initialization completed.");
    }

    private static async Task ImportAsync(NpgsqlConnection connection, string path, string[] tables)
    {
        Console.WriteLine($"Loading {Path.GetFileName(path)}...");
        var inserts = CatalogSeedDump.Read(await File.ReadAllTextAsync(path), tables.ToHashSet());
        foreach (var table in tables)
        {
            if (!inserts.Any(insert => insert.Table == table))
                throw new InvalidDataException($"Missing data for {table} in {path}.");
            await ExecuteAsync(connection, $"CREATE TEMP TABLE seed_{table} (LIKE public.{table}) ON COMMIT DROP;");
        }
        foreach (var insert in inserts) await ExecuteAsync(connection, insert.Sql);

        // Parent rows precede relationships, regardless of pg_dump's table ordering.
        foreach (var table in tables)
        {
            var columns = CatalogSeedDump.Columns[table];
            var names = string.Join(", ", columns);
            var relationship = table is "course_categories" or "course_tags";
            if (relationship)
                await ExecuteAsync(connection, $"DELETE FROM public.{table} WHERE course_id IN (SELECT course_id FROM seed_courses);");
            var conflict = relationship ? "ON CONFLICT DO NOTHING" :
                $"ON CONFLICT ({columns[0]}) DO UPDATE SET " +
                string.Join(", ", columns.Skip(1).Select(column => $"{column} = EXCLUDED.{column}"));
            await ExecuteAsync(connection, $"INSERT INTO public.{table} ({names}) OVERRIDING SYSTEM VALUE SELECT {names} FROM seed_{table} WHERE true {conflict};");
            Console.WriteLine($"Loaded {inserts.Count(insert => insert.Table == table)} rows into {table}.");
        }
    }

    private static async Task ExecuteAsync(NpgsqlConnection connection, string sql)
    {
        await using var command = new NpgsqlCommand(sql, connection) { CommandTimeout = 300 };
        await command.ExecuteNonQueryAsync();
    }
}
