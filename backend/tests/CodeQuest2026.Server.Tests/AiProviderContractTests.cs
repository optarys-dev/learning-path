using CodeQuest2026.Server.Application.Common.AI;
using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Extensions;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using CodeQuest2026.Server.Infrastructure.Groq;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class AiProviderContractTests
{
    [Fact]
    public void RegistersGroqAsTheOnlyProvider()
    {
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["ConnectionStrings:DefaultConnection"] = "Host=localhost;Database=registration_test"
            })
            .Build();
        var services = new ServiceCollection();
        services.AddSingleton<IConfiguration>(configuration);
        services.AddLogging();
        services.ConfigureService(configuration);

        using var container = services.BuildServiceProvider(new ServiceProviderOptions
        {
            ValidateScopes = true
        });
        using var scope = container.CreateScope();

        var provider = Assert.Single(scope.ServiceProvider.GetServices<IStructuredAiProvider>());
        Assert.IsType<GroqProvider>(provider);
        Assert.Equal("openai/gpt-oss-20b", provider.Model);
        Assert.False(provider.IsConfigured);
        Assert.Same(provider, scope.ServiceProvider.GetRequiredService<IStructuredAiProvider>());
        Assert.NotNull(scope.ServiceProvider.GetRequiredService<RouteRefinementService>());
    }

    [Fact]
    public async Task NewProviderWorksWithoutChangesToRecommendationLogic()
    {
        var provider = new ExampleProvider();
        var service = new RouteRefinementService(provider, NullLogger<RouteRefinementService>.Instance);
        var original = new SemanticRecommendationDto("original", "Python", "Original",
            [new(7, 1, "Python", 0.75, "Original", 2)]);
        var result = await service.RefineAsync(new UserPreference { Goal = "Python" }, original,
            [new Course { CourseId = 7 }], CancellationToken.None);
        Assert.Equal("semantic-example-v2", result.Method);
        Assert.Equal("example-model", result.Model);
        Assert.Equal("applied", result.RefinementStatus);
        Assert.Equal("route_refinement", provider.Request!.SchemaName);
        Assert.Equal(2500, provider.Request.MaxOutputTokens);
        Assert.Equal("object", provider.Request.Schema.GetProperty("type").GetString());
    }

    private sealed class ExampleProvider : IStructuredAiProvider
    {
        public string Name => "example";
        public string Model => "example-model";
        public bool IsConfigured => true;
        public StructuredAiRequest? Request { get; private set; }
        public Task<StructuredAiResponse> GenerateAsync(StructuredAiRequest request, CancellationToken cancellationToken)
        {
            Request = request;
            return Task.FromResult(new StructuredAiResponse(AiResponseStatus.Completed,
                """{"explanation":"Tu ruta Python","courses":[{"courseId":7,"reason":"Refuerza tu interés en Python"}]}"""));
        }
    }
}
