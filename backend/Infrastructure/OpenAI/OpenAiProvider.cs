using CodeQuest2026.Server.Application.Common.AI;
using System.Net.Http.Headers;
using System.Text.Json;

namespace CodeQuest2026.Server.Infrastructure.OpenAI;

public sealed class OpenAiProvider(
    HttpClient http,
    IConfiguration configuration) : IStructuredAiProvider
{
    public string Name => "openai";

    public string Model => string.IsNullOrWhiteSpace(configuration["OpenAI:Model"])
        ? "gpt-5.4-nano"
        : configuration["OpenAI:Model"]!;

    public bool IsConfigured => !string.IsNullOrWhiteSpace(configuration["OpenAI:ApiKey"]);

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
            "https://api.openai.com/v1/responses");

        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", configuration["OpenAI:ApiKey"]);
        request.Content = JsonContent.Create(new
        {
            model = Model,
            store = false,
            instructions = input.Instructions,
            input = input.Input,
            max_output_tokens = input.MaxOutputTokens,
            text = new
            {
                format = new
                {
                    type = "json_schema",
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
        var root = envelope.RootElement;

        if (root.GetProperty("status").GetString() != "completed")
        {
            return new(AiResponseStatus.Incomplete);
        }

        var texts = new List<string>();

        foreach (var output in root.GetProperty("output").EnumerateArray())
        {
            if (output.GetProperty("type").GetString() != "message")
            {
                continue;
            }

            foreach (var part in output.GetProperty("content").EnumerateArray())
            {
                var type = part.GetProperty("type").GetString();

                if (type == "refusal")
                {
                    return new(AiResponseStatus.Refused);
                }

                if (type == "output_text")
                {
                    texts.Add(part.GetProperty("text").GetString()!);
                }
            }
        }

        return texts.Count == 1 && !string.IsNullOrWhiteSpace(texts[0])
            ? new(AiResponseStatus.Completed, texts[0])
            : new(AiResponseStatus.InvalidResponse);
    }
}
