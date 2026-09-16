using System.Security.Claims;
using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Users;
using CodeQuest2026.Server.Application.Users.Queries;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using CodeQuest2026.Server.Application.Oauth2.Discord;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
[Route("auth")]
public class AuthController(ISender sender) : ControllerBase
{
    /// <summary>Inicia el registro o inicio de sesión con Discord.</summary>
    /// <remarks>
    /// Redirige al usuario a Discord. Debe abrirse mediante navegación del navegador;
    /// no está diseñado para ejecutarse con una petición AJAX desde Swagger UI.
    /// Al completar OAuth se crea o actualiza el usuario y se emite la cookie de sesión.
    /// </remarks>
    /// <param name="returnUrl">Ruta local a la que volver al finalizar. Por defecto: /auth/me.</param>
    /// <response code="302">Redirección al formulario de autorización de Discord.</response>
    /// <response code="400">La ruta de retorno no es local.</response>
    [HttpGet("discord")]
    [ProducesResponseType(StatusCodes.Status302Found)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status400BadRequest)]
    public IActionResult Discord([FromQuery] string? returnUrl = null)
    {
        if (returnUrl is not null && !Url.IsLocalUrl(returnUrl))
            return BadRequest(new { error = "invalid_return_url" });

        return Challenge(new AuthenticationProperties
        {
            RedirectUri = returnUrl ?? "/auth/me"
        }, DiscordAuthentication.Scheme);
    }

    /// <summary>Obtiene el resumen del usuario de la sesión.</summary>
    /// <remarks>Requiere la cookie CodeQuest.Session creada por /auth/discord.</remarks>
    /// <response code="200">La sesión existe y su usuario está registrado.</response>
    /// <response code="401">Falta la sesión o el usuario ya no existe.</response>
    [Authorize]
    [HttpGet("me")]
    [ProducesResponseType<AuthUserDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<AuthUserDto>> Me(CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized();

        var user = await sender.Send(new GetCurrentUserQuery(discordId), cancellationToken);
        if (user is null)
            return Unauthorized(new { error = "user_not_registered", message = "Inicia sesión nuevamente con Discord." });

        // Preserve the existing session response: id remains the Discord ID.
        return Ok(new AuthUserDto(user.DiscordId, user.UserId, user.Username,
            user.DisplayName, user.Avatar));
    }
}
