using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Users.Commands;

public sealed record SaveUserPreferencesCommand(string DiscordId, SaveUserPreferenceRequest Preferences)
    : IRequest<UserPreferenceDto?>;

public sealed class SaveUserPreferencesCommandHandler(AppDbContext db)
    : IRequestHandler<SaveUserPreferencesCommand, UserPreferenceDto?>
{
    public async Task<UserPreferenceDto?> Handle(SaveUserPreferencesCommand command, CancellationToken cancellationToken)
    {
        var request = command.Preferences;
        if (string.IsNullOrWhiteSpace(request.Goal) || request.Goal.Length > 1000
            || request.Interests is null || request.ExistingSkills is null
            || request.Interests.Length > 30 || request.ExistingSkills.Length > 30
            || request.Interests.Concat(request.ExistingSkills).Any(x => string.IsNullOrWhiteSpace(x) || x.Length > 100))
            throw new DomainValidationException(ApiErrorCodes.InvalidPreferences);

        var userId = await db.Users.AsNoTracking().Where(x => x.DiscordId == command.DiscordId)
            .Select(x => x.UserId).SingleOrDefaultAsync(cancellationToken);
        if (userId is null) return null;

        var preference = await db.UserPreferences.FindAsync([userId], cancellationToken);
        if (preference is null)
        {
            preference = new UserPreference { UserId = userId };
            db.UserPreferences.Add(preference);
        }
        preference.Goal = request.Goal.Trim();
        preference.ExperienceLevel = request.ExperienceLevel?.Trim();
        preference.Interests = request.Interests.Select(x => x.Trim()).Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
        preference.ExistingSkills = request.ExistingSkills.Select(x => x.Trim()).Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
        preference.PreferredLanguage = request.PreferredLanguage?.Trim();
        preference.MinutesPerWeek = request.MinutesPerWeek;
        preference.UpdatedAt = DateTimeOffset.UtcNow;
        await db.SaveChangesAsync(cancellationToken);
        return new UserPreferenceDto(preference.Goal, preference.ExperienceLevel,
            preference.Interests, preference.ExistingSkills, preference.PreferredLanguage,
            preference.MinutesPerWeek, preference.UpdatedAt);
    }
}
