namespace CodeQuest2026.Server.Application.Users;

/// <summary>Perfil local asociado al usuario interno autenticado.</summary>
/// <param name="UserId">Identificador interno estable de CodeQuest.</param>
/// <param name="DiscordId">Identificador público de la cuenta de Discord.</param>
/// <param name="Username">Nombre de usuario actual en Discord.</param>
/// <param name="DisplayName">Nombre visible configurado en Discord.</param>
/// <param name="Avatar">Hash del avatar de Discord; puede ser nulo.</param>
/// <param name="CreatedAt">Fecha UTC de creación del usuario local.</param>
/// <param name="LastLoginAt">Fecha UTC del último inicio de sesión.</param>
/// <param name="IsNewUser">Indica que todavía no guardó sus preferencias iniciales.</param>
public sealed record UserDto(
    string UserId,
    string? DiscordId,
    string Username,
    string? DisplayName,
    string? Avatar,
    DateTimeOffset CreatedAt,
    DateTimeOffset LastLoginAt,
    bool IsNewUser);
