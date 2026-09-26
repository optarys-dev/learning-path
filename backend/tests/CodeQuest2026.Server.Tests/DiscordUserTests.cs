using CodeQuest2026.Server.Application.Users.Commands;
using CodeQuest2026.Server.Application.Users.Queries;
using CodeQuest2026.Server.Controllers;
using CodeQuest2026.Server.Infrastructure.DataSource.Configurations;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Security.Claims;
using CodeQuest2026.Server.Application.Oauth2;
using CodeQuest2026.Server.Application.Oauth2.Discord;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using CodeQuest2026.Server.Application.Oauth2.Google;
using Microsoft.AspNetCore.Authentication.OAuth;
using System.Text.Json;
using Xunit;

namespace CodeQuest2026.Server.Tests;

// SQLite exercises persistence locally; PostgreSQL migrations still need a development DB.
public sealed class DiscordUserTests : IAsyncLifetime
{
    private readonly SqliteConnection connection = new("Data Source=:memory:");
    private ServiceProvider provider = null!;
    private AsyncServiceScope scope;
    private ISender Sender => scope.ServiceProvider.GetRequiredService<ISender>();

    public async Task InitializeAsync()
    {
        await connection.OpenAsync();
        connection.CreateFunction<string, string, string>("GREATEST", (left, right) =>
            string.CompareOrdinal(left, right) >= 0 ? left : right);
        await using var command = connection.CreateCommand();
        command.CommandText = """
            CREATE TABLE users (
                user_id TEXT PRIMARY KEY, discord_id TEXT NULL UNIQUE,
                username TEXT NOT NULL, display_name TEXT NULL, avatar TEXT NULL,
                created_at TEXT NOT NULL, last_login_at TEXT NOT NULL);
            CREATE TABLE user_preferences (user_id TEXT PRIMARY KEY);
            CREATE TABLE user_external_logins (provider TEXT NOT NULL, provider_user_id TEXT NOT NULL,
                user_id TEXT NOT NULL REFERENCES users(user_id), PRIMARY KEY(provider, provider_user_id), UNIQUE(user_id, provider));
            """;
        await command.ExecuteNonQueryAsync();
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseSqlite(connection)
            .Options;
        var services = new ServiceCollection();
        services.AddLogging();
        services.AddDiscordAuthentication(new ConfigurationBuilder().AddInMemoryCollection(
            new Dictionary<string, string?> { ["DISCORD_CLIENT_ID"] = "test", ["DISCORD_CLIENT_SECRET"] = "test" }).Build(), true);
        services.AddGoogleAuthentication(new ConfigurationBuilder().AddInMemoryCollection(
            new Dictionary<string, string?> { ["Google:ClientId"] = "test", ["Google:ClientSecret"] = "test" }).Build(), true);
        services.AddScoped<AppDbContext>(_ => new UserTestDbContext(options));
        services.AddMediatR(options => options.RegisterServicesFromAssemblyContaining<SyncDiscordUserCommand>());
        provider = services.BuildServiceProvider();
        scope = provider.CreateAsyncScope();
    }

    [Fact]
    public async Task FirstLoginCreatesUserAndNextLoginUpdatesSameUser()
    {
        var id = await Sender.Send(new SyncDiscordUserCommand("123456789012345678", "first", "First", "avatar"));
        var first = await Sender.Send(new GetCurrentUserQuery(id));
        Assert.NotNull(first);
        Assert.True(Guid.TryParse(first.UserId, out _));
        Assert.True(first.IsNewUser);

        await Sender.Send(new SyncDiscordUserCommand(first.DiscordId!, "renamed", null, null));
        var updated = await Sender.Send(new GetCurrentUserQuery(first.UserId));
        Assert.NotNull(updated);
        Assert.Equal(first.UserId, updated.UserId);
        Assert.Equal(first.CreatedAt, updated.CreatedAt);
        Assert.True(updated.LastLoginAt >= first.LastLoginAt);
        Assert.Equal("renamed", updated.Username);
        Assert.Null(updated.DisplayName);
        Assert.Null(updated.Avatar);
        Assert.Equal(1, await scope.ServiceProvider.GetRequiredService<AppDbContext>().Users.CountAsync());
    }

    [Theory]
    [InlineData("", "valid")]
    [InlineData("not-a-snowflake", "valid")]
    [InlineData("123", "")]
    public async Task InvalidProfileDoesNotCreateUser(string id, string username)
    {
        await Assert.ThrowsAsync<ArgumentException>(() =>
            Sender.Send(new SyncDiscordUserCommand(id, username, null, null)));
        Assert.Equal(0, await scope.ServiceProvider.GetRequiredService<AppDbContext>().Users.CountAsync());
    }

    [Fact]
    public async Task SavingPreferencesClearsNewUserFlag()
    {
        var id = await Sender.Send(new SyncDiscordUserCommand("123", "alice", null, null));
        var first = await Sender.Send(new GetCurrentUserQuery(id));
        Assert.NotNull(first);
        Assert.True(first.IsNewUser);
        await using var command = connection.CreateCommand();
        command.CommandText = "INSERT INTO user_preferences (user_id) VALUES ($userId)";
        command.Parameters.AddWithValue("$userId", first.UserId);
        await command.ExecuteNonQueryAsync();
        var updated = await Sender.Send(new GetCurrentUserQuery(id));
        Assert.NotNull(updated);
        Assert.False(updated.IsNewUser);
    }

    [Fact]
    public async Task CurrentUserReturnsOnlyProfileFromAuthenticatedDiscordId()
    {
        var id = await Sender.Send(new SyncDiscordUserCommand("123", "alice", null, null));
        await Sender.Send(new SyncDiscordUserCommand("456", "bob", null, null));
        var controller = new UsersController(Sender)
        {
            ControllerContext = new ControllerContext
            {
                HttpContext = new DefaultHttpContext
                {
                    User = new ClaimsPrincipal(new ClaimsIdentity(
                    [new Claim(CodeQuest2026.Server.Application.Oauth2.SessionIdentity.UserIdClaim, id)], "test"))
                }
            }
        };
        var result = await controller.Me(CancellationToken.None);
        var user = Assert.IsType<CodeQuest2026.Server.Application.Users.UserDto>(
            Assert.IsType<OkObjectResult>(result.Result).Value);
        Assert.Equal("alice", user.Username);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("999")]
    public async Task MissingIdentityOrUnregisteredSessionReturnsUnauthorized(string? id)
    {
        var context = new DefaultHttpContext();
        if (id is not null)
            context.User = new ClaimsPrincipal(new ClaimsIdentity(
                [new Claim(ClaimTypes.NameIdentifier, id)], "test"));
        var controller = new UsersController(Sender)
        {
            ControllerContext = new ControllerContext { HttpContext = context }
        };
        var result = await controller.Me(CancellationToken.None);
        Assert.True(result.Result is UnauthorizedResult or UnauthorizedObjectResult);
    }

    [Fact]
    public async Task GoogleLoginsReuseTheirUserAndNeverMergeWithDiscord()
    {
        var discord = await Sender.Send(new SyncDiscordUserCommand("123", "Same Name", null, null));
        var google = await Sender.Send(new SyncExternalUserCommand("Google", "123", "Same Name", "Google Name", "https://example.test/avatar"));
        var repeated = await Sender.Send(new SyncExternalUserCommand("Google", "123", "Updated", null, null));
        Assert.NotEqual(discord, google);
        Assert.Equal(google, repeated);
        var profile = await Sender.Send(new GetCurrentUserQuery(google));
        Assert.NotNull(profile);
        Assert.Null(profile.DiscordId);
        Assert.Equal("Updated", profile.Username);
        Assert.Equal(2, await scope.ServiceProvider.GetRequiredService<AppDbContext>().Users.CountAsync());
        Assert.Equal(2, await scope.ServiceProvider.GetRequiredService<AppDbContext>().UserExternalLogins.CountAsync());
    }

    [Fact]
    public async Task ExistingDiscordUserRetainsInternalIdOnFirstExternalLogin()
    {
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        db.Users.Add(new User { UserId = "existing-owner", DiscordId = "123", Username = "Old" });
        await db.SaveChangesAsync();
        var id = await Sender.Send(new SyncDiscordUserCommand("123", "Updated", null, null));
        Assert.Equal("existing-owner", id);
        Assert.Equal(1, await db.Users.CountAsync());
        Assert.Equal("existing-owner", (await db.UserExternalLogins.SingleAsync()).UserId);
    }

    [Fact]
    public async Task LegacyDiscordCookieIsUpgradedToInternalIdentity()
    {
        var id = await Sender.Send(new SyncDiscordUserCommand("123", "Alice", null, null));
        var identity = new ClaimsIdentity([new Claim(ClaimTypes.NameIdentifier, "123")], "Cookies");
        var context = CreateCookieContext(identity);
        await context.Options.Events.OnValidatePrincipal(context);
        Assert.Equal(id, context.Principal?.GetUserId());
        Assert.Equal("Discord", context.Principal?.FindFirstValue(SessionIdentity.ProviderClaim));
        Assert.True(context.ShouldRenew);
    }

    [Fact]
    public async Task GoogleCookieResolvesInternalUserAndDeletedUserIsRejected()
    {
        var id = await Sender.Send(new SyncExternalUserCommand("Google", "google-sub", "Alice", null, null));
        var identity = new ClaimsIdentity([new Claim(ClaimTypes.NameIdentifier, "google-sub"),
            new Claim(SessionIdentity.UserIdClaim, id), new Claim(SessionIdentity.ProviderClaim, "Google")], "Cookies");
        var context = CreateCookieContext(identity);
        await context.Options.Events.OnValidatePrincipal(context);
        Assert.NotNull(context.Principal);
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        db.Users.Remove(await db.Users.SingleAsync());
        await db.SaveChangesAsync();
        var deletedContext = CreateCookieContext(identity);
        await deletedContext.Options.Events.OnValidatePrincipal(deletedContext);
        Assert.Null(deletedContext.Principal);
    }

    private CookieValidatePrincipalContext CreateCookieContext(ClaimsIdentity identity)
    {
        var options = scope.ServiceProvider.GetRequiredService<IOptionsMonitor<CookieAuthenticationOptions>>().Get("Cookies");
        return new CookieValidatePrincipalContext(new DefaultHttpContext { RequestServices = scope.ServiceProvider },
            new AuthenticationScheme("Cookies", null, typeof(CookieAuthenticationHandler)), options,
            new AuthenticationTicket(new ClaimsPrincipal(identity), new AuthenticationProperties(), "Cookies"));
    }

    [Fact]
    public async Task GoogleTicketUsesTrustedUserInfoAndProducesInternalSessionClaims()
    {
        var context = GoogleTicket("""{"sub":"google-sub","name":"Alice","picture":"https://example.test/alice.png"}""");
        await context.Options.Events.OnCreatingTicket(context);
        Assert.Equal("Google", context.Identity?.FindFirst(SessionIdentity.ProviderClaim)?.Value);
        Assert.Equal("google-sub", context.Identity?.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        var id = context.Identity?.FindFirst(SessionIdentity.UserIdClaim)?.Value;
        Assert.NotNull(id);
        var user = await Sender.Send(new GetCurrentUserQuery(id));
        Assert.NotNull(user);
        Assert.Equal("Alice", user.Username);
        Assert.Equal("https://example.test/alice.png", user.Avatar);
        Assert.Null(user.DiscordId);
    }

    [Fact]
    public async Task GoogleTicketWithoutSubjectCannotCreateAccount()
    {
        var context = GoogleTicket("""{"sub":"","name":"Alice"}""");
        await Assert.ThrowsAsync<InvalidOperationException>(() => context.Options.Events.OnCreatingTicket(context));
        Assert.Equal(0, await scope.ServiceProvider.GetRequiredService<AppDbContext>().Users.CountAsync());
    }

    private OAuthCreatingTicketContext GoogleTicket(string json)
    {
        var options = scope.ServiceProvider.GetRequiredService<IOptionsMonitor<OAuthOptions>>().Get("Google");
        var backchannel = new HttpClient(new GoogleProfileHandler(json));
        options.Backchannel = backchannel;
        var tokens = OAuthTokenResponse.Success(JsonDocument.Parse("""{"access_token":"test-token","token_type":"Bearer"}"""));
        return new OAuthCreatingTicketContext(new ClaimsPrincipal(new ClaimsIdentity("Google")), new AuthenticationProperties(),
            new DefaultHttpContext { RequestServices = scope.ServiceProvider },
            new AuthenticationScheme("Google", null, typeof(OAuthHandler<OAuthOptions>)), options, backchannel,
            tokens, JsonDocument.Parse("{}").RootElement);
    }

    private sealed class GoogleProfileHandler(string json) : HttpMessageHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            Assert.Equal("https://openidconnect.googleapis.com/v1/userinfo", request.RequestUri?.ToString());
            Assert.Equal("Bearer", request.Headers.Authorization?.Scheme);
            Assert.Equal("test-token", request.Headers.Authorization?.Parameter);
            return Task.FromResult(new HttpResponseMessage(System.Net.HttpStatusCode.OK) { Content = new StringContent(json) });
        }
    }

    public async Task DisposeAsync()
    {
        await scope.DisposeAsync();
        await provider.DisposeAsync();
        await connection.DisposeAsync();
    }

    private sealed class UserTestDbContext(DbContextOptions<AppDbContext> options)
        : AppDbContext(options)
    {
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Ignore<Course>();
            modelBuilder.Ignore<Category>();
            modelBuilder.Ignore<Tag>();
            modelBuilder.Ignore<CourseEmbedding>();
            modelBuilder.Ignore<LearningRoute>();
            modelBuilder.Ignore<LearningRouteCourse>();
            new UserConfiguration().Configure(modelBuilder.Entity<CodeQuest2026.Server.Infrastructure.DataSource.Entities.User>());
            new UserExternalLoginConfiguration().Configure(modelBuilder.Entity<UserExternalLogin>());
            modelBuilder.Entity<UserPreference>(builder =>
            {
                builder.ToTable("user_preferences");
                builder.HasKey(x => x.UserId);
                builder.Property(x => x.UserId).HasColumnName("user_id");
                builder.Ignore(x => x.Goal);
                builder.Ignore(x => x.ExperienceLevel);
                builder.Ignore(x => x.Interests);
                builder.Ignore(x => x.ExistingSkills);
                builder.Ignore(x => x.PreferredLanguage);
                builder.Ignore(x => x.MinutesPerWeek);
                builder.Ignore(x => x.UpdatedAt);
                builder.HasOne(x => x.User).WithOne(x => x.Preferences)
                    .HasForeignKey<UserPreference>(x => x.UserId);
            });
        }
    }
}
