using CodeQuest2026.Server.Application.Common.AI;
using System.Net.Http.Headers;
using System.Text.Json;

namespace CodeQuest2026.Server.Infrastructure.Groq;

public sealed class GroqProvider(
    HttpClient http,
    IConfiguration configuration) : IStructuredAiProvider
{
    public string Name => "groq";

    public string Model => string.IsNullOrWhiteSpace(configuration["Groq:Model"])
        ? "openai/gpt-oss-20b"
        : configuration["Groq:Model"]!;

    public bool IsConfigured => !string.IsNullOrWhiteSpace(configuration["Groq:ApiKey"]);

    public async Task<StructuredAiResponse> GenerateAsync(
        StructuredAiRequest input,
        CancellationToken cancellationToken)
    {
        if (!IsConfigured)
        {
            return new(AiResponseStatus.NotConfigured);
        }

        using var request = new HttpRequestMessage(
            HttpMethod.Post,
            "https://api.groq.com/openai/v1/chat/completions");

        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", configuration["Groq:ApiKey"]);
        request.Content = JsonContent.Create(new
        {
            model = Model,
            stream = false,
            max_completion_tokens = input.MaxOutputTokens,
            messages = new[]
            {
                new { role = "system", content = input.Instructions },
                new { role = "user", content = input.Input }
            },
            response_format = new
            {
                type = "json_schema",
                json_schema = new
                {
                    name = input.SchemaName,
                    strict = true,
                    schema = input.Schema
                }
            }
        });

        using var response = await http.SendAsync(request, cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            return new(AiResponseStatus.ProviderError);
        }

        var responseBody = await response.Content.ReadAsStringAsync(cancellationToken);
        using var envelope = JsonDocument.Parse(responseBody);
        var choices = envelope.RootElement.GetProperty("choices");

        if (choices.GetArrayLength() != 1)
        {
            return new(AiResponseStatus.InvalidResponse);
        }

        var choice = choices[0];
        var finishReason = choice.GetProperty("finish_reason").GetString();

        if (finishReason == "content_filter")
        {
            return new(AiResponseStatus.Refused);
        }

        if (finishReason != "stop")
        {
            return new(AiResponseStatus.Incomplete);
        }

        var message = choice.GetProperty("message");

        if (message.TryGetProperty("refusal", out var refusal)
            && refusal.ValueKind != JsonValueKind.Null
            && !string.IsNullOrWhiteSpace(refusal.GetString()))
        {
            return new(AiResponseStatus.Refused);
        }

        var json = message.GetProperty("content").GetString();

        return string.IsNullOrWhiteSpace(json)
            ? new(AiResponseStatus.InvalidResponse)
            : new(AiResponseStatus.Completed, json);
    }
}
