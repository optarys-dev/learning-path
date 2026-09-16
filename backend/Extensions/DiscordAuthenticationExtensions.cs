using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;

namespace CodeQuest2026.Server.Extensions;

public static class DiscordAuthenticationExtensions
{
    public const string Scheme = "Discord";

    public static IServiceCollection AddDiscordAuthentication(
        this IServiceCollection services, IConfiguration configuration, bool isDevelopment)
    {
        services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
            .AddCookie(options =>
            {
                options.Cookie.Name = "CodeQuest.Session";
                options.Cookie.HttpOnly = true;
                options.Cookie.SameSite = SameSiteMode.Lax;
                options.Cookie.SecurePolicy = isDevelopment
                    ? CookieSecurePolicy.SameAsRequest : CookieSecurePolicy.Always;
                options.ExpireTimeSpan = TimeSpan.FromHours(8);
                options.SlidingExpiration = false;
                options.Events.OnRedirectToLogin = context =>
                {
                    context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                    return Task.CompletedTask;
                };
                options.Events.OnRedirectToAccessDenied = context =>
                {
                    context.Response.StatusCode = StatusCodes.Status403Forbidden;
                    return Task.CompletedTask;
                };
            })
            .AddOAuth(Scheme, options =>
            {
                options.ClientId = configuration["Discord:DISCORD_CLIENT_ID"] ?? "";
                options.ClientSecret = configuration["Discord:DISCORD_CLIENT_SECRET"] ?? "";
                options.CallbackPath = configuration["Discord:DISCORD_CALLBACK_PATH"] ?? "";
                options.AuthorizationEndpoint = "https://discord.com/oauth2/authorize";
                options.TokenEndpoint = "https://discord.com/api/oauth2/token";
                options.UserInformationEndpoint = "https://discord.com/api/v10/users/@me";
                options.Scope.Add("identify");
                options.SaveTokens = false;
                // Discord returns a top-level GET, so Lax supports local HTTP too.
                options.CorrelationCookie.SameSite = SameSiteMode.Lax;
                options.CorrelationCookie.SecurePolicy = isDevelopment
                    ? CookieSecurePolicy.SameAsRequest : CookieSecurePolicy.Always;
                options.ClaimActions.MapJsonKey(ClaimTypes.NameIdentifier, "id");
                options.ClaimActions.MapJsonKey(ClaimTypes.Name, "username");
                options.ClaimActions.MapJsonKey("discord:global_name", "global_name");
                options.ClaimActions.MapJsonKey("discord:avatar", "avatar");
                options.Events.OnCreatingTicket = async context =>
                {
                    using var request = new HttpRequestMessage(HttpMethod.Get, context.Options.UserInformationEndpoint);
                    request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", context.AccessToken);
                    using var response = await context.Backchannel.SendAsync(request, context.HttpContext.RequestAborted);
                    response.EnsureSuccessStatusCode();
                    using var user = JsonDocument.Parse(await response.Content.ReadAsStringAsync(context.HttpContext.RequestAborted));
                    if (!user.RootElement.TryGetProperty("id", out var id) || string.IsNullOrWhiteSpace(id.GetString()))
                        throw new InvalidOperationException("Discord did not return a user identifier.");
                    context.RunClaimActions(user.RootElement);
                };
                options.Events.OnRemoteFailure = async context =>
                {
                    context.HandleResponse();
                    context.Response.StatusCode = StatusCodes.Status400BadRequest;
                    await context.Response.WriteAsJsonAsync(new
                    {
                        error = "discord_authentication_failed",
                        message = "No se pudo completar el inicio de sesión. Inténtalo de nuevo desde /api/auth/discord."
                    });
                };
            });
        services.AddAuthorization();
        return services;
    }
}
