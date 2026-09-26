using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Oauth2.Discord;
using CodeQuest2026.Server.Application.Oauth2;
using CodeQuest2026.Server.Application.Oauth2.Google;
using CodeQuest2026.Server.Application.Users;
using CodeQuest2026.Server.Application.Users.Queries;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
[Route("auth")]
public class AuthController(ISender sender, IConfiguration configuration) : ControllerBase
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
        if (!IsAllowedReturnUrl(returnUrl))
            return BadRequest(new ApiErrorDto("invalid_return_url", "La URL de retorno no está permitida."));

        // A valid Code Quest session does not need a new OAuth challenge. This avoids
        // showing Discord's authorization screen again when a signed-in user reaches
        // the login entry point a second time.
        if (User.Identity?.IsAuthenticated == true)
            return Redirect(returnUrl ?? "/auth/me");

        return Challenge(new AuthenticationProperties
        {
            RedirectUri = returnUrl ?? "/auth/me"
        }, DiscordAuthentication.Scheme);
    }

    [HttpGet("providers")]
    public IActionResult Providers() => Ok(new { google = GoogleAuthentication.IsConfigured(configuration) });

    [HttpGet("google")]
    public IActionResult Google([FromQuery] string? returnUrl = null)
    {
        if (!IsAllowedReturnUrl(returnUrl))
            return BadRequest(new ApiErrorDto("invalid_return_url", "La URL de retorno no está permitida."));
        if (!GoogleAuthentication.IsConfigured(configuration))
            return StatusCode(503, new ApiErrorDto("google_not_configured", "El acceso con Google todavía no está configurado."));
        if (User.Identity?.IsAuthenticated == true) return Redirect(returnUrl ?? "/auth/me");
        return Challenge(new AuthenticationProperties { RedirectUri = returnUrl ?? "/auth/me" }, GoogleAuthentication.Scheme);
    }

    private bool IsAllowedReturnUrl(string? returnUrl)
    {
        if (returnUrl is null) return true;
        if (Url.IsLocalUrl(returnUrl)) return true;
        if (!Uri.TryCreate(returnUrl, UriKind.Absolute, out var target) || target.Scheme is not ("https" or "http")
            || !string.IsNullOrEmpty(target.UserInfo)) return false;
        var origins = configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
        return target.AbsolutePath == "/login/callback" && origins.Any(origin =>
            Uri.TryCreate(origin, UriKind.Absolute, out var allowed) && allowed.GetLeftPart(UriPartial.Authority)
                .Equals(target.GetLeftPart(UriPartial.Authority), StringComparison.OrdinalIgnoreCase));
    }

    /// <summary>Cierra la sesión local creada tras autenticar con Discord.</summary>
    /// <remarks>Elimina la cookie CodeQuest.Session. Puede llamarse aunque la sesión ya haya expirado.</remarks>
    /// <response code="204">La sesión local se cerró.</response>
    [HttpPost("logout")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        return NoContent();
    }

    /// <summary>Obtiene el resumen del usuario de la sesión.</summary>
    /// <remarks>Requiere la cookie CodeQuest.Session creada por /auth/discord.</remarks>
    /// <response code="200">La sesión existe y su usuario está registrado.</response>
    /// <response code="401">Falta la sesión o el usuario ya no existe.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [Authorize]
    [HttpGet("me")]
    [ProducesResponseType<AuthUserDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult<AuthUserDto>> Me(CancellationToken cancellationToken)
    {
        var userId = User.GetUserId();
        if (string.IsNullOrWhiteSpace(userId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión para continuar."));

        var user = await sender.Send(new GetCurrentUserQuery(userId), cancellationToken);
        if (user is null)
            return Unauthorized(new ApiErrorDto("user_not_registered", "Inicia sesión nuevamente."));

        var provider = User.FindFirstValue(SessionIdentity.ProviderClaim) ?? DiscordAuthentication.Scheme;
        var avatarUrl = provider == GoogleAuthentication.Scheme ? user.Avatar : user.Avatar is null ? null
            : $"https://cdn.discordapp.com/avatars/{Uri.EscapeDataString(user.DiscordId!)}/{Uri.EscapeDataString(user.Avatar)}.png?size=80";
        // Keep Discord's public id stable so existing local course notes remain accessible.
        return Ok(new AuthUserDto(user.DiscordId ?? user.UserId, user.UserId, user.Username,
            user.DisplayName, user.Avatar, user.IsNewUser, provider, avatarUrl));
    }
}
