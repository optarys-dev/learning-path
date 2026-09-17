using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Routes.Queries;

public sealed record GetStaticRecommendationQuery(string DiscordId) : IRequest<StaticRecommendationDto?>;

public sealed class GetStaticRecommendationQueryHandler(
    AppDbContext db, IStaticCourseRecommendationEngine engine)
    : IRequestHandler<GetStaticRecommendationQuery, StaticRecommendationDto?>
{
    public async Task<StaticRecommendationDto?> Handle(
        GetStaticRecommendationQuery request, CancellationToken cancellationToken)
    {
        var preference = await db.UserPreferences.AsNoTracking()
            .SingleOrDefaultAsync(x => x.User.DiscordId == request.DiscordId, cancellationToken);
        if (preference is null) return null;

        var courses = await db.Courses.AsNoTracking()
            .Where(x => x.IsActive)
            .Include(x => x.Categories).Include(x => x.Tags)
            .AsSplitQuery()
            .ToListAsync(cancellationToken);
        return engine.Recommend(preference, courses);
    }
}
