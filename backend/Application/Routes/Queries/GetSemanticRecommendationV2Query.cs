using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Routes.Queries;

public sealed record GetSemanticRecommendationV2Query(string UserId, IReadOnlyList<long>? ExcludedCourseIds = null) : IRequest<SemanticRecommendationV2Result>;

public sealed record SemanticRecommendationV2Result(
    bool PreferencesRequired,
    bool EmbeddingsAvailable,
    SemanticRecommendationV2Dto? Recommendation);

public sealed class GetSemanticRecommendationV2QueryHandler(
    AppDbContext db,
    GetSemanticRecommendationQueryHandler semantic,
    RouteRefinementService refiner)
    : IRequestHandler<GetSemanticRecommendationV2Query, SemanticRecommendationV2Result>
{
    public async Task<SemanticRecommendationV2Result> Handle(
        GetSemanticRecommendationV2Query request,
        CancellationToken cancellationToken)
    {
        var preference = await db.UserPreferences
            .AsNoTracking()
            .SingleOrDefaultAsync(x => x.UserId == request.UserId, cancellationToken);

        if (preference is null)
        {
            return new(true, false, null);
        }

        var result = await semantic.RecommendAsync(preference, cancellationToken, request.ExcludedCourseIds);

        if (result.Recommendation is null)
        {
            return new(false, result.EmbeddingsAvailable, null);
        }

        var ids = result.Recommendation.Courses.Select(x => x.CourseId).ToArray();

        var courses = await db.Courses
            .AsNoTracking()
            .Where(x => ids.Contains(x.CourseId) && x.IsActive)
            .Include(x => x.Categories)
            .Include(x => x.Tags)
            .AsSplitQuery()
            .ToListAsync(cancellationToken);

        var refined = await refiner.RefineAsync(
            preference,
            result.Recommendation,
            courses,
            cancellationToken);

        return new(false, result.EmbeddingsAvailable, refined);
    }
}
