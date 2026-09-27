using CodeQuest2026.Server.Application.Oauth2.Google;
using CodeQuest2026.Server.Controllers;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.OAuth;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class GoogleAuthenticationTests
{
    [Fact]
    public async Task MissingCredentialsDoNotRegisterGoogleOrPreventOtherProviders()
    {
        var configuration = new ConfigurationBuilder().Build();
        var services = new ServiceCollection();
        services.AddLogging();
        services.AddAuthentication().AddCookie();
        services.AddGoogleAuthentication(configuration, true);
        await using var provider = services.BuildServiceProvider();
        Assert.Null(await provider.GetRequiredService<IAuthenticationSchemeProvider>().GetSchemeAsync("Google"));
        Assert.NotNull(await provider.GetRequiredService<IAuthenticationSchemeProvider>().GetSchemeAsync("Cookies"));
        Assert.False(GoogleAuthentication.IsConfigured(configuration));
    }

    [Fact]
    public void GoogleUsesServerOAuthWithPkceAndDoesNotStoreTokens()
    {
        var services = new ServiceCollection();
        services.AddLogging();
        services.AddAuthentication().AddCookie();
        services.AddGoogleAuthentication(Configuration(), true);
        using var provider = services.BuildServiceProvider();
        var options = provider.GetRequiredService<IOptionsMonitor<OAuthOptions>>().Get("Google");
        Assert.True(options.UsePkce);
        Assert.False(options.SaveTokens);
        Assert.Equal("/auth/google/callback", options.CallbackPath.Value);
        Assert.Contains("openid", options.Scope);
        Assert.Contains("profile", options.Scope);
        Assert.DoesNotContain("email", options.Scope);
    }

    [Theory]
    [InlineData("https://evil.example/login/callback")]
    [InlineData("//evil.example")]
    [InlineData("https://frontend.example/other")]
    [InlineData("https://frontend.example@evil.example/login/callback")]
    public void BothProvidersRejectUntrustedReturnUrls(string returnUrl)
    {
        var controller = Controller();
        Assert.IsType<BadRequestObjectResult>(controller.Google(returnUrl));
        Assert.IsType<BadRequestObjectResult>(controller.Discord(returnUrl));
    }

    [Theory]
    [InlineData("/login/callback")]
    [InlineData("https://frontend.example/login/callback")]
    public void GoogleChallengesOnlyForTrustedReturnUrls(string returnUrl)
    {
        var challenge = Assert.IsType<ChallengeResult>(Controller().Google(returnUrl));
        Assert.Equal("Google", Assert.Single(challenge.AuthenticationSchemes));
        Assert.Equal(returnUrl, challenge.Properties?.RedirectUri);
    }

    private static IConfiguration Configuration() => new ConfigurationBuilder().AddInMemoryCollection(
        new Dictionary<string, string?> { ["Google:ClientId"] = "test", ["Google:ClientSecret"] = "test",
            ["Cors:AllowedOrigins:0"] = "https://frontend.example" }).Build();

    private static AuthController Controller()
    {
        var services = new ServiceCollection();
        services.AddMediatR(options => options.RegisterServicesFromAssemblyContaining<AuthController>());
        var sender = services.BuildServiceProvider().GetRequiredService<ISender>();
        var context = new ControllerContext { HttpContext = new DefaultHttpContext(),
            RouteData = new Microsoft.AspNetCore.Routing.RouteData(),
            ActionDescriptor = new Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor() };
        return new AuthController(sender, Configuration()) { ControllerContext = context, Url = new UrlHelper(context) };
    }
}
