using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using CodeQuest2026.Server.Application.Courses;

namespace CodeQuest2026.Server.Application.Routes;

internal static class LearningRouteMapping
{
    public static LearningRouteDto ToDto(LearningRoute route) =>
        new(route.RouteId, route.Goal, route.RecommendationMethod, route.Explanation,
            route.CreatedAt, route.Courses.OrderBy(x => x.Position)
                .Select(x => new RouteCourseDto(
                    x.CourseId,
                    x.Position,
                    x.Course.Title,
                    x.Reason,
                    x.Course.ImageUrl,
                    x.Course.CourseUrl,
                    x.ProgressPercentage,
                    x.Course.CatalogKinds))
                .ToList());

    public static LearningRouteDto ToDto(LearningRoute route, IReadOnlyDictionary<long, CourseDto> courses) =>
        new(route.RouteId, route.Goal, route.RecommendationMethod, route.Explanation,
            route.CreatedAt, route.Courses.OrderBy(x => x.Position)
                .Select(x => new RouteCourseDto(
                    x.CourseId,
                    x.Position,
                    courses[x.CourseId].Title,
                    x.Reason,
                    courses[x.CourseId].ImageUrl,
                    courses[x.CourseId].CourseUrl,
                    x.ProgressPercentage,
                    courses[x.CourseId].CatalogKinds))
                .ToList());
}
