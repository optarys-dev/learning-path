using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Routes.Queries;

public sealed record GetLearningRoutesQuery(string DiscordId) : IRequest<IReadOnlyList<LearningRouteDto>>;

public sealed class GetLearningRoutesQueryHandler(AppDbContext db)
    : IRequestHandler<GetLearningRoutesQuery, IReadOnlyList<LearningRouteDto>>
{
    public async Task<IReadOnlyList<LearningRouteDto>> Handle(
        GetLearningRoutesQuery request, CancellationToken cancellationToken)
    {
        var routes = await db.LearningRoutes.AsNoTracking()
            .Where(x => x.User.DiscordId == request.DiscordId)
            .Include(x => x.Courses).ThenInclude(x => x.Course)
            .OrderByDescending(x => x.CreatedAt).ThenByDescending(x => x.RouteId)
            .ToListAsync(cancellationToken);
        return routes.Select(LearningRouteMapping.ToDto).ToList();
    }
}
