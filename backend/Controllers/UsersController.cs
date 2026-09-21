using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Users;
using CodeQuest2026.Server.Application.Users.Commands;
using CodeQuest2026.Server.Application.Users.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[Authorize]
[ProducesResponseType<ApiErrorDto>(StatusCodes.Status500InternalServerError)]
[ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
[Route("users")]
public class UsersController(ISender sender) : ControllerBase
{
    /// <summary>Obtiene el perfil persistido del usuario autenticado.</summary>
    /// <remarks>
    /// Requiere la cookie CodeQuest.Session. El perfil se crea durante el primer
    /// callback de Discord y se actualiza en cada inicio de sesión posterior.
    /// </remarks>
    /// <response code="200">Perfil sincronizado con Discord.</response>
    /// <response code="401">Falta la sesión o el usuario no está registrado.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [HttpGet("me")]
    [ProducesResponseType<UserDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<UserDto>> Me(CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));

        var user = await sender.Send(new GetCurrentUserQuery(discordId), cancellationToken);
        if (user is null)
            return Unauthorized(new ApiErrorDto("user_not_registered", "Inicia sesión nuevamente con Discord."));

        return Ok(user);
    }

    /// <summary>Consulta las preferencias de aprendizaje del usuario autenticado.</summary>
    /// <remarks>Requiere la cookie CodeQuest.Session. Devuelve 404 si el usuario aún no completó sus preferencias.</remarks>
    /// <response code="200">Preferencias guardadas.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="404">El usuario todavía no tiene preferencias.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [HttpGet("me/preferences")]
    [ProducesResponseType<UserPreferenceDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<UserPreferenceDto>> GetPreferences(CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        var preference = await sender.Send(new GetUserPreferencesQuery(discordId), cancellationToken);
        return preference is null
            ? NotFound(new ApiErrorDto("preferences_not_found", "Todavía no has guardado tus preferencias."))
            : Ok(preference);
    }

    /// <summary>Crea o reemplaza las preferencias de aprendizaje del usuario autenticado.</summary>
    /// <remarks>
    /// Requiere la cookie CodeQuest.Session. Goal es obligatorio. Interests y ExistingSkills
    /// aceptan hasta 30 elementos de 100 caracteres cada uno. MinutesPerWeek va de 1 a 10080.
    /// Al guardar por primera vez, isNewUser pasa a false en /auth/me y /users/me.
    /// </remarks>
    /// <response code="200">Preferencias guardadas.</response>
    /// <response code="400">Datos inválidos; puede devolver error = invalid_preferences o errores de validación.</response>
    /// <response code="401">No hay una sesión válida o el usuario ya no existe.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [HttpPut("me/preferences")]
    [ProducesResponseType<UserPreferenceDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<UserPreferenceDto>> SavePreferences(
        SaveUserPreferenceRequest request, CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        try
        {
            var preference = await sender.Send(
                new SaveUserPreferencesCommand(discordId, request), cancellationToken);
            return preference is null
                ? Unauthorized(new ApiErrorDto("user_not_registered", "Inicia sesión nuevamente con Discord."))
                : Ok(preference);
        }
        catch (ArgumentException exception) when (exception.Message == "invalid_preferences")
        {
            return BadRequest(new ApiErrorDto("invalid_preferences", "Revisa el objetivo, intereses y habilidades enviados."));
        }
    }
}
