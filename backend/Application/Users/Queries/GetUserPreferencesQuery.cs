using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Users.Queries;

public sealed record GetUserPreferencesQuery(string DiscordId) : IRequest<UserPreferenceDto?>;

public sealed class GetUserPreferencesQueryHandler(AppDbContext db)
    : IRequestHandler<GetUserPreferencesQuery, UserPreferenceDto?>
{
    public Task<UserPreferenceDto?> Handle(GetUserPreferencesQuery request, CancellationToken cancellationToken) =>
        db.UserPreferences.AsNoTracking()
            .Where(x => x.User.DiscordId == request.DiscordId)
            .Select(x => new UserPreferenceDto(x.Goal, x.ExperienceLevel, x.Interests,
                x.ExistingSkills, x.PreferredLanguage, x.MinutesPerWeek, x.UpdatedAt))
            .SingleOrDefaultAsync(cancellationToken);
}
