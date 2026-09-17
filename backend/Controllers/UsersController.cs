using System.Security.Claims;
using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Users;
using CodeQuest2026.Server.Application.Users.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[Authorize]
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
    [HttpGet("me")]
    [ProducesResponseType<UserDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<UserDto>> Me(CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized();

        var user = await sender.Send(new GetCurrentUserQuery(discordId), cancellationToken);
        if (user is null)
            return Unauthorized(new { error = "user_not_registered", message = "Inicia sesión nuevamente con Discord." });

        return Ok(user);
    }
}
