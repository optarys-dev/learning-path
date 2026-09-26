using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Json;
using CodeQuest2026.Server.Application.Users.Commands;
using MediatR;
using Microsoft.AspNetCore.Authentication;

namespace CodeQuest2026.Server.Application.Oauth2.Google;

public static class GoogleAuthentication
{
    public const string Scheme = "Google";
    public static bool IsConfigured(IConfiguration configuration) =>
        !string.IsNullOrWhiteSpace(configuration["Google:ClientId"])
        && !string.IsNullOrWhiteSpace(configuration["Google:ClientSecret"]);

    public static IServiceCollection AddGoogleAuthentication(this IServiceCollection services,
        IConfiguration configuration, bool isDevelopment)
    {
        if (!IsConfigured(configuration)) return services;
        services.AddAuthentication().AddOAuth(Scheme, options =>
        {
            options.ClientId = configuration["Google:ClientId"]!;
            options.ClientSecret = configuration["Google:ClientSecret"]!;
            options.CallbackPath = "/auth/google/callback";
            options.AuthorizationEndpoint = "https://accounts.google.com/o/oauth2/v2/auth";
            options.TokenEndpoint = "https://oauth2.googleapis.com/token";
            options.UserInformationEndpoint = "https://openidconnect.googleapis.com/v1/userinfo";
            options.Scope.Add("openid");
            options.Scope.Add("profile");
            options.UsePkce = true;
            options.SaveTokens = false;
            options.CorrelationCookie.SameSite = SameSiteMode.Lax;
            options.CorrelationCookie.SecurePolicy = isDevelopment ? CookieSecurePolicy.SameAsRequest : CookieSecurePolicy.Always;
            options.Events.OnCreatingTicket = async context =>
            {
                using var request = new HttpRequestMessage(HttpMethod.Get, context.Options.UserInformationEndpoint);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", context.AccessToken);
                using var response = await context.Backchannel.SendAsync(request, context.HttpContext.RequestAborted);
                response.EnsureSuccessStatusCode();
                using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync(context.HttpContext.RequestAborted));
                var profile = document.RootElement;
                var subject = profile.GetProperty("sub").GetString();
                if (string.IsNullOrWhiteSpace(subject)) throw new InvalidOperationException("Google returned no subject.");
                var name = profile.TryGetProperty("name", out var nameValue) ? nameValue.GetString() : null;
                var picture = profile.TryGetProperty("picture", out var pictureValue) ? pictureValue.GetString() : null;
                // The provider subject is the identity. Email never merges accounts.
                var username = string.IsNullOrWhiteSpace(name) ? "Google user" : name[..Math.Min(name.Length, 32)];
                var displayName = name is null ? null : name[..Math.Min(name.Length, 100)];
                if (picture is not null && (!Uri.TryCreate(picture, UriKind.Absolute, out var image) || image.Scheme != "https")) picture = null;
                var userId = await context.HttpContext.RequestServices.GetRequiredService<ISender>().Send(
                    new SyncExternalUserCommand(Scheme, subject, username, displayName, picture), context.HttpContext.RequestAborted);
                context.Identity!.AddClaim(new Claim(ClaimTypes.NameIdentifier, subject));
                context.Identity.AddClaim(new Claim(ClaimTypes.Name, username));
                context.Identity.AddClaim(new Claim(SessionIdentity.UserIdClaim, userId));
                context.Identity.AddClaim(new Claim(SessionIdentity.ProviderClaim, Scheme));
            };
            options.Events.OnRemoteFailure = context =>
            {
                context.HandleResponse();
                var returnUrl = context.Properties?.RedirectUri;
                var loginUrl = Uri.TryCreate(returnUrl, UriKind.Absolute, out var target)
                    ? target.GetLeftPart(UriPartial.Authority) + "/login?authError=google"
                    : "/login?authError=google";
                context.Response.Redirect(loginUrl);
                return Task.CompletedTask;
            };
        });
        return services;
    }
}
