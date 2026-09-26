using System.Security.Claims;

namespace CodeQuest2026.Server.Application.Oauth2;

public static class SessionIdentity
{
    public const string UserIdClaim = "codequest:user_id";
    public const string ProviderClaim = "codequest:provider";
    public static string? GetUserId(this ClaimsPrincipal principal) => principal.FindFirstValue(UserIdClaim);
}
