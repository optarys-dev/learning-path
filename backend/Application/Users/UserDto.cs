namespace CodeQuest2026.Server.Application.Users;

/// <summary>Perfil local sincronizado con la cuenta de Discord autenticada.</summary>
/// <param name="UserId">Identificador interno estable de CodeQuest.</param>
/// <param name="DiscordId">Identificador público de la cuenta de Discord.</param>
/// <param name="Username">Nombre de usuario actual en Discord.</param>
/// <param name="DisplayName">Nombre visible configurado en Discord.</param>
/// <param name="Avatar">Hash del avatar de Discord; puede ser nulo.</param>
/// <param name="CreatedAt">Fecha UTC de creación del usuario local.</param>
/// <param name="LastLoginAt">Fecha UTC del último inicio de sesión.</param>
public sealed record UserDto(
    string UserId,
    string DiscordId,
    string Username,
    string? DisplayName,
    string? Avatar,
    DateTimeOffset CreatedAt,
    DateTimeOffset LastLoginAt);
