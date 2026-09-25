using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using CodeQuest2026.Server.Application.Courses;

namespace CodeQuest2026.Server.Application.Routes.Commands;

public enum SaveRouteStatus { Created, PreferencesRequired, CourseUnavailable }
public sealed record SaveRouteResult(SaveRouteStatus Status, LearningRouteDto? Route = null);
public sealed record SaveLearningRouteCommand(string DiscordId, SaveLearningRouteRequest Request)
    : IRequest<SaveRouteResult>;

public sealed class SaveLearningRouteCommandHandler(AppDbContext db)
    : IRequestHandler<SaveLearningRouteCommand, SaveRouteResult>
{
    public async Task<SaveRouteResult> Handle(SaveLearningRouteCommand command, CancellationToken cancellationToken)
    {
        var request = command.Request;
        var usesManualMethod = request.RecommendationMethod.Equals("manual-v1", StringComparison.OrdinalIgnoreCase);
        if (string.IsNullOrWhiteSpace(request.RecommendationMethod) || request.RecommendationMethod.Length > 80
            || request.Goal?.Length > 1000
            || usesManualMethod && string.IsNullOrWhiteSpace(request.Goal)
            || request.Explanation?.Length > 4000
            || request.Courses is null || request.Courses.Count is < 1 or > 30
            || request.Courses.Any(x => x is null || x.CourseId <= 0 || x.Reason?.Length > 1000)
            || request.Courses.Select(x => x.CourseId).Distinct().Count() != request.Courses.Count)
            throw new DomainValidationException(ApiErrorCodes.InvalidRoute);

        var manualRoute = usesManualMethod;
        UserPreference? preference = null;
        if (!manualRoute)
        {
            preference = await db.UserPreferences.AsNoTracking()
                .SingleOrDefaultAsync(x => x.User.DiscordId == command.DiscordId, cancellationToken);
            if (preference is null) return new(SaveRouteStatus.PreferencesRequired);
        }

        var userId = preference?.UserId ?? await db.Users.AsNoTracking()
            .Where(user => user.DiscordId == command.DiscordId)
            .Select(user => user.UserId)
            .SingleOrDefaultAsync(cancellationToken);
        if (string.IsNullOrWhiteSpace(userId)) return new(SaveRouteStatus.PreferencesRequired);

        var ids = request.Courses.Select(x => x.CourseId).ToArray();
        var courseDetails = await db.Courses.AsNoTracking()
            .Where(x => ids.Contains(x.CourseId) && x.IsActive)
            .Select(CourseMapping.Projection)
            .ToDictionaryAsync(course => course.CourseId, cancellationToken);
        if (courseDetails.Count != ids.Length) return new(SaveRouteStatus.CourseUnavailable);

        var route = new LearningRoute
        {
            RouteId = Guid.NewGuid(),
            UserId = userId,
            Goal = string.IsNullOrWhiteSpace(request.Goal) ? preference!.Goal : request.Goal.Trim(),
            RecommendationMethod = request.RecommendationMethod.Trim(),
            Explanation = request.Explanation?.Trim(),
            PreferencesSnapshot = preference is null ? "{}" : JsonSerializer.Serialize(new
            {
                preference.Goal,
                preference.ExperienceLevel,
                preference.Interests,
                preference.ExistingSkills,
                preference.PreferredLanguage,
                preference.MinutesPerWeek,
                preference.UpdatedAt
            }),
            CreatedAt = DateTimeOffset.UtcNow,
            Courses = request.Courses.Select((x, index) => new LearningRouteCourse
            {
                CourseId = x.CourseId,
                Position = index + 1,
                Reason = x.Reason?.Trim()
            }).ToList()
        };
        db.LearningRoutes.Add(route);
        await db.SaveChangesAsync(cancellationToken);
        return new(SaveRouteStatus.Created, LearningRouteMapping.ToDto(route, courseDetails));
    }
}
