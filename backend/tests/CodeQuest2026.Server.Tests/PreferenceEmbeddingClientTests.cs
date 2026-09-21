using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using CodeQuest2026.Server.Infrastructure.Embeddings;
using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class PreferenceEmbeddingClientTests
{
    [Fact]
    public async Task SendsJsonWithContentLengthRequiredByPythonWorker()
    {
        var handler = new RecordingHandler();
        using var http = new HttpClient(handler) { BaseAddress = new Uri("http://127.0.0.1:8765/") };
        var client = new PreferenceEmbeddingClient(http);

        var result = await client.EmbedAsync(new UserPreference
        {
            Goal = "Aprender Python",
            Interests = ["Backend"],
            ExperienceLevel = "Principiante"
        }, CancellationToken.None);

        Assert.Equal(2, result.Dimensions);
        Assert.Equal("/embed-preferences", handler.Path);
        Assert.Equal("application/json", handler.ContentType);
        Assert.True(handler.ContentLength > 0);
        Assert.Equal(handler.ContentLength, handler.BodyLength);
        Assert.Equal("Aprender Python", handler.Goal);
    }

    private sealed class RecordingHandler : HttpMessageHandler
    {
        public string? Path { get; private set; }
        public string? ContentType { get; private set; }
        public long? ContentLength { get; private set; }
        public int BodyLength { get; private set; }
        public string? Goal { get; private set; }

        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request, CancellationToken cancellationToken)
        {
            Path = request.RequestUri?.AbsolutePath;
            ContentType = request.Content?.Headers.ContentType?.MediaType;
            ContentLength = request.Content?.Headers.ContentLength;
            var body = await request.Content!.ReadAsByteArrayAsync(cancellationToken);
            BodyLength = body.Length;
            using var document = JsonDocument.Parse(body);
            Goal = document.RootElement.GetProperty("goal").GetString();
            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = JsonContent.Create(new
                {
                    model = "hf/test",
                    dimensions = 2,
                    embedding = new[] { 0.6f, 0.8f }
                })
            };
        }
    }
}
