using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Users.Commands;

public sealed record SyncDiscordUserCommand(
    string DiscordId, string Username, string? DisplayName, string? Avatar) : IRequest;

public sealed class SyncDiscordUserCommandHandler(AppDbContext db)
    : IRequestHandler<SyncDiscordUserCommand>
{
    public async Task Handle(SyncDiscordUserCommand request, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(request.DiscordId) || request.DiscordId.Length > 20
            || request.DiscordId.Any(character => character is < '0' or > '9'))
            throw new ArgumentException("Discord returned an invalid user identifier.");
        if (string.IsNullOrWhiteSpace(request.Username) || request.Username.Length > 32
            || request.DisplayName?.Length > 100 || request.Avatar?.Length > 128)
            throw new ArgumentException("Discord returned an invalid user profile.");

        var userId = Guid.NewGuid().ToString();
        var now = DateTimeOffset.UtcNow;

        //Consulta atomica para insertar o actualizar un usuario en la base de datos
        await db.Database.ExecuteSqlInterpolatedAsync($"""
            INSERT INTO users (user_id, discord_id, username, display_name, avatar, created_at, last_login_at)
            VALUES ({userId}, {request.DiscordId}, {request.Username}, {request.DisplayName}, {request.Avatar}, {now}, {now})
            ON CONFLICT (discord_id) DO UPDATE SET
                username = EXCLUDED.username,
                display_name = EXCLUDED.display_name,
                avatar = EXCLUDED.avatar,
                last_login_at = GREATEST(users.last_login_at, EXCLUDED.last_login_at)
            """, cancellationToken);
    }
}
