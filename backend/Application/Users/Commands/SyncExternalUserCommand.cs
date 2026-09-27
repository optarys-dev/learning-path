using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Users.Commands;

public sealed record SyncExternalUserCommand(string Provider, string ProviderUserId,
    string Username, string? DisplayName, string? Avatar) : IRequest<string>;

public sealed class SyncExternalUserCommandHandler(AppDbContext db) : IRequestHandler<SyncExternalUserCommand, string>
{
    public async Task<string> Handle(SyncExternalUserCommand request, CancellationToken cancellationToken)
    {
        if (request.Provider is not ("Discord" or "Google") || string.IsNullOrWhiteSpace(request.ProviderUserId)
            || request.ProviderUserId.Length > 255 || string.IsNullOrWhiteSpace(request.Username)
            || request.Username.Length > 32 || request.DisplayName?.Length > 100 || request.Avatar?.Length > 2048)
            throw new ArgumentException("The authentication provider returned an invalid profile.");

        return await db.Database.CreateExecutionStrategy().ExecuteAsync(async () =>
        {
            db.ChangeTracker.Clear();
            await using var transaction = await db.Database.BeginTransactionAsync(cancellationToken);
            // Serialize concurrent first logins for this identity across API instances.
            if (db.Database.IsNpgsql())
                await db.Database.ExecuteSqlInterpolatedAsync(
                    $"SELECT pg_advisory_xact_lock(hashtextextended({request.Provider + ":" + request.ProviderUserId}, 0))", cancellationToken);

            var login = await db.UserExternalLogins.Include(x => x.User).SingleOrDefaultAsync(
                x => x.Provider == request.Provider && x.ProviderUserId == request.ProviderUserId, cancellationToken);
            var user = login?.User;
            if (user is null && request.Provider == "Discord")
                user = await db.Users.SingleOrDefaultAsync(x => x.DiscordId == request.ProviderUserId, cancellationToken);
            var now = DateTimeOffset.UtcNow;
            if (user is null)
            {
                user = new User { CreatedAt = now, DiscordId = request.Provider == "Discord" ? request.ProviderUserId : null };
                db.Users.Add(user);
            }
            user.Username = request.Username;
            user.DisplayName = request.DisplayName;
            user.Avatar = request.Avatar;
            user.LastLoginAt = now;
            if (login is null)
                db.UserExternalLogins.Add(new UserExternalLogin { Provider = request.Provider,
                    ProviderUserId = request.ProviderUserId, User = user, UserId = user.UserId });
            await db.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);
            return user.UserId;
        });
    }
}
