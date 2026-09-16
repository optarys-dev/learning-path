using CodeQuest2026.Server.Application.Oauth2.Discord;
using Microsoft.AspNetCore.Authentication.OAuth;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class DiscordConfigurationTests
{
    [Fact]
    public void UsesRootValuesWhenDiscordSectionIsEmpty()
    {
        var options = CreateOptions(new Dictionary<string, string?>
        {
            ["Discord:DISCORD_CLIENT_ID"] = "",
            ["Discord:DISCORD_CLIENT_SECRET"] = " ",
            ["Discord:DISCORD_CALLBACK_PATH"] = "",
            ["DISCORD_CLIENT_ID"] = "root-client",
            ["DISCORD_CLIENT_SECRET"] = "root-secret",
            ["DISCORD_CALLBACK_PATH"] = "/root-callback"
        });

        Assert.Equal("root-client", options.ClientId);
        Assert.Equal("root-secret", options.ClientSecret);
        Assert.Equal("/root-callback", options.CallbackPath.Value);
    }

    [Fact]
    public void DiscordSectionHasPriorityOverRootValues()
    {
        var options = CreateOptions(new Dictionary<string, string?>
        {
            ["Discord:DISCORD_CLIENT_ID"] = "section-client",
            ["Discord:DISCORD_CLIENT_SECRET"] = "section-secret",
            ["Discord:DISCORD_CALLBACK_PATH"] = "/section-callback",
            ["DISCORD_CLIENT_ID"] = "root-client",
            ["DISCORD_CLIENT_SECRET"] = "root-secret",
            ["DISCORD_CALLBACK_PATH"] = "/root-callback"
        });

        Assert.Equal("section-client", options.ClientId);
        Assert.Equal("section-secret", options.ClientSecret);
        Assert.Equal("/section-callback", options.CallbackPath.Value);
    }

    [Fact]
    public void UsesDefaultCallbackWhenNeitherLocationDefinesIt()
    {
        var options = CreateOptions(new Dictionary<string, string?>
        {
            ["DISCORD_CLIENT_ID"] = "client",
            ["DISCORD_CLIENT_SECRET"] = "secret"
        });

        Assert.Equal("/auth/discord/callback", options.CallbackPath.Value);
    }

    private static OAuthOptions CreateOptions(Dictionary<string, string?> values)
    {
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(values)
            .Build();
        var services = new ServiceCollection();
        services.AddLogging();
        services.AddDiscordAuthentication(configuration, isDevelopment: true);

        using var provider = services.BuildServiceProvider();
        return provider.GetRequiredService<IOptionsMonitor<OAuthOptions>>()
            .Get(DiscordAuthentication.Scheme);
    }
}
