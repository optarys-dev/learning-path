using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Users.Commands;
using CodeQuest2026.Server.Infrastructure;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using Microsoft.EntityFrameworkCore;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Json;

namespace CodeQuest2026.Server.Application.Oauth2.Discord;

public static class DiscordAuthentication
{
    public const string Scheme = "Discord";

    public static IServiceCollection AddDiscordAuthentication(
        this IServiceCollection services, IConfiguration configuration, bool isDevelopment)
    {
        var clientId = GetDiscordSetting(configuration, "DISCORD_CLIENT_ID");
        var clientSecret = GetDiscordSetting(configuration, "DISCORD_CLIENT_SECRET");
        var callbackPath = GetDiscordSetting(
            configuration,
            "DISCORD_CALLBACK_PATH",
            "/auth/discord/callback");

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
                options.Events.OnRedirectToLogin = async context =>
                {
                    await ApiProblemDetailsFactory.WriteAsync(context.Response.HttpContext,
                        StatusCodes.Status401Unauthorized, ApiErrorCodes.Unauthenticated);
                };
                options.Events.OnRedirectToAccessDenied = async context =>
                {
                    await ApiProblemDetailsFactory.WriteAsync(context.Response.HttpContext,
                        StatusCodes.Status403Forbidden, ApiErrorCodes.Forbidden);
                };
                options.Events.OnValidatePrincipal = async context =>
                {
                    var db = context.HttpContext.RequestServices.GetRequiredService<AppDbContext>();
                    var internalId = context.Principal?.GetUserId();
                    if (internalId is not null)
                    {
                        if (!await db.Users.AnyAsync(x => x.UserId == internalId, context.HttpContext.RequestAborted))
                            context.RejectPrincipal();
                        return;
                    }
                    // Upgrade existing Discord cookies without requiring another login.
                    var discordId = context.Principal?.FindFirstValue(ClaimTypes.NameIdentifier);
                    var userId = await db.Users.Where(x => x.DiscordId == discordId && discordId != null)
                        .Select(x => x.UserId).SingleOrDefaultAsync(context.HttpContext.RequestAborted);
                    if (userId is null || context.Principal?.Identity is not ClaimsIdentity identity)
                    {
                        context.RejectPrincipal();
                        return;
                    }
                    identity.AddClaim(new Claim(SessionIdentity.UserIdClaim, userId));
                    identity.AddClaim(new Claim(SessionIdentity.ProviderClaim, Scheme));
                    context.ShouldRenew = true;
                };
            })
            .AddOAuth(Scheme, options =>
            {
                options.ClientId = clientId;
                options.ClientSecret = clientSecret;
                options.CallbackPath = callbackPath;
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
                    var userId = await context.HttpContext.RequestServices.GetRequiredService<ISender>().Send(
                        new SyncDiscordUserCommand(
                            id.GetString()!,
                            context.Identity!.FindFirst(ClaimTypes.Name)?.Value ?? "",
                            context.Identity.FindFirst("discord:global_name")?.Value,
                            context.Identity.FindFirst("discord:avatar")?.Value),
                        context.HttpContext.RequestAborted);
                    context.Identity!.AddClaim(new Claim(SessionIdentity.UserIdClaim, userId));
                    context.Identity.AddClaim(new Claim(SessionIdentity.ProviderClaim, Scheme));
                };
                options.Events.OnRemoteFailure = async context =>
                {
                    context.HandleResponse();
                    await ApiProblemDetailsFactory.WriteAsync(context.Response.HttpContext,
                        StatusCodes.Status400BadRequest, "discord_authentication_failed",
                        "No se pudo completar el inicio de sesión. Inténtalo de nuevo desde /auth/discord.");
                };
            });
        services.AddAuthorization();
        return services;
    }

    public static IApplicationBuilder UseDiscordHttpsCallback(
        this IApplicationBuilder app,
        IConfiguration configuration,
        bool isDevelopment)
    {
        var configuredValue = GetDiscordSetting(configuration, "DISCORD_FORCE_HTTPS_CALLBACK");
        var forceHttps = string.IsNullOrWhiteSpace(configuredValue)
            ? !isDevelopment
            : bool.TryParse(configuredValue, out var parsedValue)
                ? parsedValue
                : throw new InvalidOperationException(
                    "Discord:DISCORD_FORCE_HTTPS_CALLBACK must be true or false.");

        if (!forceHttps)
            return app;

        var callbackPath = new PathString(GetDiscordSetting(
            configuration,
            "DISCORD_CALLBACK_PATH",
            "/auth/discord/callback"));

        return app.Use(async (context, next) =>
        {
            var isDiscordChallenge = context.Request.Path.Equals("/auth/discord");
            var isDiscordCallback = context.Request.Path.Equals(callbackPath);

            if (isDiscordChallenge || isDiscordCallback)
                context.Request.Scheme = Uri.UriSchemeHttps;

            await next(context);
        });
    }

    private static string GetDiscordSetting(
        IConfiguration configuration,
        string key,
        string defaultValue = "")
    {
        var sectionValue = configuration[$"Discord:{key}"];
        if (!string.IsNullOrWhiteSpace(sectionValue))
            return sectionValue;

        var rootValue = configuration[key];
        return string.IsNullOrWhiteSpace(rootValue) ? defaultValue : rootValue;
    }
}
