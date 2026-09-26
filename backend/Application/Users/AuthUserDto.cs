namespace CodeQuest2026.Server.Application.Users;

/// <summary>Resumen del usuario asociado a la sesión actual.</summary>
/// <param name="Id">Discord ID por compatibilidad; UserId para cuentas Google.</param>
/// <param name="UserId">Identificador interno estable de CodeQuest.</param>
/// <param name="Username">Nombre de la cuenta externa.</param>
/// <param name="DisplayName">Nombre visible del proveedor.</param>
/// <param name="Avatar">Hash Discord o URL Google; preferir AvatarUrl en clientes.</param>
/// <param name="IsNewUser">Indica que todavía no guardó sus preferencias iniciales.</param>
/// <param name="Provider">Proveedor externo que inició esta sesión.</param>
/// <param name="AvatarUrl">URL del avatar lista para mostrar.</param>
public sealed record AuthUserDto(
    string Id,
    string UserId,
    string Username,
    string? DisplayName,
    string? Avatar,
    bool IsNewUser,
    string Provider,
    string? AvatarUrl);
