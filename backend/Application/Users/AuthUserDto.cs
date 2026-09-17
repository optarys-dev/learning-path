namespace CodeQuest2026.Server.Application.Users;

/// <summary>Resumen del usuario asociado a la sesión actual.</summary>
/// <param name="Id">Identificador de Discord conservado por compatibilidad con el cliente.</param>
/// <param name="UserId">Identificador interno estable de CodeQuest.</param>
/// <param name="Username">Nombre de usuario actual en Discord.</param>
/// <param name="DisplayName">Nombre visible configurado en Discord.</param>
/// <param name="Avatar">Hash del avatar de Discord; puede ser nulo.</param>
public sealed record AuthUserDto(
    string Id,
    string UserId,
    string Username,
    string? DisplayName,
    string? Avatar);
