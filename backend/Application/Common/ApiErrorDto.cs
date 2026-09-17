namespace CodeQuest2026.Server.Application.Common;

/// <summary>Error esperado devuelto por la API.</summary>
/// <param name="Error">Código estable que puede interpretar el cliente.</param>
/// <param name="Message">Descripción legible del error.</param>
public sealed record ApiErrorDto(string Error, string? Message = null);
