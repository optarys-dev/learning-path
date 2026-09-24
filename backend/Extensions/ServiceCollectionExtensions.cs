using CodeQuest2026.Server.Application.Common.AI;
using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Application.Routes.Queries;
using CodeQuest2026.Server.Application.Users.Commands;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.Embeddings;
using CodeQuest2026.Server.Infrastructure.Groq;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace CodeQuest2026.Server.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection ConfigureService(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddMediatR(options =>
            options.RegisterServicesFromAssemblyContaining<SyncDiscordUserCommand>());
        services.AddSingleton<HybridSemanticRecommendationEngine>();
        services.AddScoped<GetSemanticRecommendationQueryHandler>();
        services.AddHttpClient<GroqProvider>(client =>
        {
            client.Timeout = TimeSpan.FromSeconds(30);
        });

        services.AddScoped<IStructuredAiProvider>(provider =>
            provider.GetRequiredService<GroqProvider>());
        services.AddScoped<RouteRefinementService>();

        var embeddingServiceUrl = configuration["EmbeddingService:Url"] ?? "http://127.0.0.1:8765/";
        services.AddHttpClient<PreferenceEmbeddingClient>(client =>
        {
            client.BaseAddress = new Uri(embeddingServiceUrl);
            client.Timeout = TimeSpan.FromSeconds(130);
        });
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
