using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using CodeQuest2026.Server.Infrastructure.OpenAI;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging.Abstractions;
using System.Net;
using System.Text;
using System.Text.Json;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class OpenAiRouteRefinerTests
{
    private static readonly SemanticRecommendationDto Original = new("semantic-graph-v6", "Aprender Python",
        "Original", [new(1, 1, "Python", 0.9, "Original 1", 2), new(2, 2, "Backend", 0.8, "Original 2", 3)]);
    private static readonly Course[] Courses = [new() { CourseId = 1, Title = "Python" },
        new() { CourseId = 2, Title = "Backend", SkillsTaught = ["Unverified skill"] }];
    private const string Valid = """{"explanation":"Tu ruta personalizada","courses":[{"courseId":2,"reason":"Tu objetivo backend"},{"courseId":1,"reason":"Tu interés Python"}]}""";

    [Fact]
    public async Task SendsStrictSchemaAndAppliesOrderPreservingCatalogFields()
    {
        var handler = new StubHandler(Envelope(Valid));
        var result = await Run(handler);
        Assert.Equal("applied", result.RefinementStatus);
        Assert.Equal("semantic-openai-v2", result.Method);
        Assert.Equal(new long[] { 2, 1 }, result.Courses.Select(x => x.CourseId));
        Assert.Equal(new[] { 1, 2 }, result.Courses.Select(x => x.Position));
        Assert.Equal(Original.Courses[1].Score, result.Courses[0].Score);
        Assert.Equal(Original.Courses[1].EstimatedWeeks, result.Courses[0].EstimatedWeeks);
        Assert.Equal(Original.Courses[1].Title, result.Courses[0].Title);
        Assert.Equal("/v1/responses", handler.Path);
        Assert.Equal("Bearer test-key", handler.Authorization);
        using var body = JsonDocument.Parse(handler.Body!);
        var root = body.RootElement;
        Assert.False(root.GetProperty("store").GetBoolean());
        var format = root.GetProperty("text").GetProperty("format");
        Assert.True(format.GetProperty("strict").GetBoolean());
        Assert.Equal("json_schema", format.GetProperty("type").GetString());
        var schema = format.GetProperty("schema");
        Assert.False(schema.GetProperty("additionalProperties").GetBoolean());
        var array = schema.GetProperty("properties").GetProperty("courses");
        Assert.Equal(2, array.GetProperty("minItems").GetInt32());
        Assert.Equal(2, array.GetProperty("maxItems").GetInt32());
        Assert.Equal(new long[] { 1, 2 }, array.GetProperty("items").GetProperty("properties")
            .GetProperty("courseId").GetProperty("enum").EnumerateArray().Select(x => x.GetInt64()));
        var input = root.GetProperty("input").GetString()!;
        Assert.Contains("ExistingSkills", input);
        Assert.DoesNotContain("Unverified skill", input);
        Assert.DoesNotContain("DiscordId", input);
    }

    [Theory]
    [InlineData("{\"explanation\":\"ok\",\"courses\":[{\"courseId\":1,\"reason\":\"a\"},{\"courseId\":1,\"reason\":\"b\"}]}")]
    [InlineData("{\"explanation\":\"ok\",\"courses\":[{\"courseId\":99,\"reason\":\"a\"},{\"courseId\":2,\"reason\":\"b\"}]}")]
    [InlineData("{\"explanation\":\"ok\",\"courses\":[]}")]
    [InlineData("{\"explanation\":\"ok\",\"courses\":[{\"courseId\":1,\"reason\":\"a\"}]}")]
    [InlineData("{\"explanation\":\" \",\"courses\":[]}")]
    [InlineData("{\"explanation\":\"ok\",\"courses\":[],\"extra\":true}")]
    [InlineData("not json")]
    [InlineData("null")]
    public async Task RejectsInvalidOutputAndPreservesOriginal(string output)
    {
        var result = await Run(new StubHandler(Envelope(output)));
        Assert.Equal("invalid_response", result.RefinementStatus);
        Assert.Same(Original.Courses, result.Courses);
        Assert.Equal(Original.Method, result.Method);
        Assert.Null(result.Model);
    }

    [Theory]
    [InlineData("{\"status\":\"incomplete\"}", "incomplete_response")]
    [InlineData("{\"status\":\"completed\",\"output\":[{\"type\":\"message\",\"content\":[{\"type\":\"refusal\",\"refusal\":\"no\"}]}]}", "refused")]
    [InlineData("{}", "invalid_response")]
    public async Task HandlesUnusableEnvelopes(string envelope, string status)
    {
        Assert.Equal(status, (await Run(new StubHandler(envelope))).RefinementStatus);
    }

    [Fact]
    public async Task HandlesRateLimitWithoutRetrying()
    {
        var handler = new StubHandler("secret provider error") { StatusCode = HttpStatusCode.TooManyRequests };
        Assert.Equal("provider_error", (await Run(handler)).RefinementStatus);
        Assert.Equal(1, handler.Calls);
    }

    [Fact]
    public async Task MissingKeyAndEmptyRoutesDoNotCallProvider()
    {
        var handler = new StubHandler(Envelope(Valid));
        Assert.Equal("not_configured", (await Run(handler, key: "")).RefinementStatus);
        Assert.Equal("no_courses", (await Run(handler, original: Original with { Courses = [] })).RefinementStatus);
        Assert.Equal(0, handler.Calls);
    }

    [Fact]
    public async Task TimeoutFallsBackButCallerCancellationPropagates()
    {
        var handler = new StubHandler("") { Error = new TaskCanceledException() };
        Assert.Equal("timeout", (await Run(handler)).RefinementStatus);
        using var cancellation = new CancellationTokenSource();
        cancellation.Cancel();
        await Assert.ThrowsAnyAsync<OperationCanceledException>(() => Run(handler, token: cancellation.Token));
    }

    [Fact]
    public async Task NetworkFailureFallsBack()
    {
        Assert.Equal("provider_unavailable", (await Run(new StubHandler("")
        { Error = new HttpRequestException() })).RefinementStatus);
    }

    private static async Task<SemanticRecommendationV2Dto> Run(StubHandler handler, string key = "test-key",
        SemanticRecommendationDto? original = null, CancellationToken token = default)
    {
        using var http = new HttpClient(handler);
        var configuration = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        { ["OpenAI:ApiKey"] = key }).Build();
        var client = new RouteRefinementService(new OpenAiProvider(http, configuration),
            NullLogger<RouteRefinementService>.Instance);
        return await client.RefineAsync(new UserPreference { Goal = "Aprender Python", ExistingSkills = ["HTML"] },
            original ?? Original, Courses, token);
    }

    private static string Envelope(string output) => JsonSerializer.Serialize(new
    {
        status = "completed",
        output = new[] { new { type = "message",
            content = new[] { new { type = "output_text", text = output } } } }
    });

    private sealed class StubHandler(string response) : HttpMessageHandler
    {
        public string? Body { get; private set; }
        public string? Path { get; private set; }
        public string? Authorization { get; private set; }
        public int Calls { get; private set; }
        public HttpStatusCode StatusCode { get; init; } = HttpStatusCode.OK;
        public Exception? Error { get; init; }
        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            Calls++;
            if (Error is not null) throw Error;
            Path = request.RequestUri!.AbsolutePath;
            Authorization = request.Headers.Authorization?.ToString();
            Body = await request.Content!.ReadAsStringAsync(cancellationToken);
            return new(StatusCode) { Content = new StringContent(response, Encoding.UTF8, "application/json") };
        }
    }
}
