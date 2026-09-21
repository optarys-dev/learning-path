using System.Text.Json;

namespace CodeQuest2026.Server.Application.Common.AI;

/// <summary>Proveedor de generación JSON. No conoce cursos ni reglas de recomendación.</summary>
public interface IStructuredAiProvider
{
    string Name { get; }
    string Model { get; }
    bool IsConfigured { get; }

    /// <summary>Solicita JSON conforme al esquema. La cancelación y los errores de transporte se propagan.</summary>
    /// <remarks>El consumidor debe validar el JSON y las reglas de negocio incluso si Status es Completed.</remarks>
    Task<StructuredAiResponse> GenerateAsync(StructuredAiRequest request, CancellationToken cancellationToken);
}

public sealed record StructuredAiRequest(string Instructions, string Input, string SchemaName,
    JsonElement Schema, int MaxOutputTokens = 2500);

public enum AiResponseStatus { Completed, NotConfigured, ProviderError, Incomplete, Refused, InvalidResponse }

/// <summary>Json contiene exclusivamente la salida estructurada, sin el sobre HTTP del proveedor.</summary>
public sealed record StructuredAiResponse(AiResponseStatus Status, string? Json = null);
