using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace CodeQuest2026.Server.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection ConfigureService(this IServiceCollection services, IConfiguration configuration)
    {
        string? connectionString =
            configuration.GetConnectionString("DefaultConnection") ??
            Environment.GetEnvironmentVariable("DefaultConnection");

        ArgumentNullException.ThrowIfNullOrWhiteSpace(connectionString, "ConnectionStrings");

        services.AddDbContext<AppDbContext>(
            options => options.UseNpgsql(connectionString, postgres =>
            {
                postgres.UseVector();
                postgres.CommandTimeout(120);
                postgres.EnableRetryOnFailure(2, TimeSpan.FromSeconds(10), null);
            })
        );
        services.AddHealthChecks()
            .AddCheck("api", () => HealthCheckResult.Healthy(), tags: ["api"])
            .AddNpgSql(connectionString, name: "postgresql", tags: ["db"], timeout: TimeSpan.FromSeconds(5));
        return services;
    }
}
