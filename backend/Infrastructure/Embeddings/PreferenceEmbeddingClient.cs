using System.Net.Http.Json;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;

namespace CodeQuest2026.Server.Infrastructure.Embeddings;

public sealed record PreferenceEmbedding(string Model, int Dimensions, float[] Embedding);

/// <summary>Consulta el servicio Python que genera vectores; no carga modelos en la API.</summary>
public sealed class PreferenceEmbeddingClient(HttpClient http)
{
    public async Task<PreferenceEmbedding> EmbedAsync(UserPreference preference, CancellationToken cancellationToken)
    {
        var payload = new
        {
            goal = preference.Goal,
            interests = preference.Interests,
            experienceLevel = preference.ExperienceLevel
        };
        using var response = await http.PostAsJsonAsync("embed-preferences", payload, cancellationToken);
        response.EnsureSuccessStatusCode();
        var result = await response.Content.ReadFromJsonAsync<PreferenceEmbedding>(cancellationToken);
        if (result is null || string.IsNullOrWhiteSpace(result.Model) || result.Model.Length > 200
            || result.Dimensions < 1 || result.Embedding.Length != result.Dimensions
            || result.Embedding.All(x => x == 0) || result.Embedding.Any(x => !float.IsFinite(x)))
            throw new InvalidOperationException("El servicio de embeddings devolvió un vector inválido.");
        return result;
    }
}
