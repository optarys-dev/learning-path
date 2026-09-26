using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Users.Queries;

public sealed record GetCurrentUserQuery(string UserId) : IRequest<UserDto?>;

public sealed class GetCurrentUserQueryHandler(AppDbContext db)
    : IRequestHandler<GetCurrentUserQuery, UserDto?>
{
    public Task<UserDto?> Handle(GetCurrentUserQuery request, CancellationToken cancellationToken) =>
        db.Users.AsNoTracking()
            .Where(user => user.UserId == request.UserId)
            .Select(user => new UserDto(user.UserId, user.DiscordId, user.Username,
                user.DisplayName, user.Avatar, user.CreatedAt, user.LastLoginAt,
                user.Preferences == null))
            .SingleOrDefaultAsync(cancellationToken);
}
