using System.Security.Claims;
using CodeQuest2026.Server.Extensions;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
[Route("auth")]
public class AuthController : ControllerBase
{
    [HttpGet("discord")]
    public IActionResult Discord([FromQuery] string? returnUrl = null)
    {
        if (returnUrl is not null && !Url.IsLocalUrl(returnUrl))
            return BadRequest(new { error = "invalid_return_url" });

        return Challenge(new AuthenticationProperties
        {
            RedirectUri = returnUrl ?? "/auth/me"
        }, DiscordAuthenticationExtensions.Scheme);
    }

    [Authorize]
    [HttpGet("me")]
    public IActionResult Me() => Ok(new
    {
        id = User.FindFirstValue(ClaimTypes.NameIdentifier),
        username = User.Identity?.Name,
        displayName = User.FindFirstValue("discord:global_name"),
        avatar = User.FindFirstValue("discord:avatar")
    });
}
