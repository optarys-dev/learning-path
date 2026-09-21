using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using System.Net.Http.Headers;
using System.Text.Json;

namespace CodeQuest2026.Server.Infrastructure.Embeddings;

public sealed record PreferenceEmbedding(string Model, int Dimensions, float[] Embedding);

/// <summary>Envía objetivo, intereses y nivel de experiencia al servicio Python de embeddings.</summary>
public sealed class PreferenceEmbeddingClient(HttpClient http)
{
    public async Task<PreferenceEmbedding> EmbedAsync(
        UserPreference preference,
        CancellationToken cancellationToken)
    {
        var payload = new
        {
            goal = preference.Goal,
            interests = preference.Interests,
            experienceLevel = preference.ExperienceLevel
        };

        var json = JsonSerializer.SerializeToUtf8Bytes(payload);

        using var content = new ByteArrayContent(json);
        content.Headers.ContentLength = json.Length;
        content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

        using var response = await http.PostAsync("embed-preferences", content, cancellationToken);
        response.EnsureSuccessStatusCode();

        var result = await response.Content.ReadFromJsonAsync<PreferenceEmbedding>(cancellationToken);

        if (result is null
            || string.IsNullOrWhiteSpace(result.Model)
            || result.Model.Length > 200
            || result.Dimensions < 1
            || result.Embedding.Length != result.Dimensions
            || result.Embedding.All(x => x == 0)
            || result.Embedding.Any(x => !float.IsFinite(x)))
        {
            throw new InvalidOperationException("El servicio de embeddings devolvió un vector inválido.");
        }

        return result;
    }
}
