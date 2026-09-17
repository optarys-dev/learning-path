using CodeQuest2026.Server.Infrastructure.DataSource.Entities;

namespace CodeQuest2026.Server.Application.Routes;

internal static class LearningRouteMapping
{
    public static LearningRouteDto ToDto(LearningRoute route) =>
        new(route.RouteId, route.Goal, route.RecommendationMethod, route.Explanation,
            route.CreatedAt, route.Courses.OrderBy(x => x.Position)
                .Select(x => new RouteCourseDto(x.CourseId, x.Position, x.Course.Title, x.Reason)).ToList());

    public static LearningRouteDto ToDto(LearningRoute route, IReadOnlyDictionary<long, string> titles) =>
        new(route.RouteId, route.Goal, route.RecommendationMethod, route.Explanation,
            route.CreatedAt, route.Courses.OrderBy(x => x.Position)
                .Select(x => new RouteCourseDto(x.CourseId, x.Position, titles[x.CourseId], x.Reason)).ToList());
}
