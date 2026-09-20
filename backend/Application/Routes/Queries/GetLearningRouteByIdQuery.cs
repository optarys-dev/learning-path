using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Routes.Queries;

public sealed record GetLearningRouteByIdQuery(string DiscordId, Guid RouteId) : IRequest<LearningRouteDto?>;

public sealed class GetLearningRouteByIdQueryHandler(AppDbContext db)
    : IRequestHandler<GetLearningRouteByIdQuery, LearningRouteDto?>
{
    public async Task<LearningRouteDto?> Handle(
        GetLearningRouteByIdQuery request, CancellationToken cancellationToken)
    {
        var route = await db.LearningRoutes.AsNoTracking()
            .Where(x => x.User.DiscordId == request.DiscordId)
            .Include(x => x.Courses).ThenInclude(x => x.Course)
            .SingleOrDefaultAsync(x => x.RouteId == request.RouteId, cancellationToken);
        return route is null ? null : LearningRouteMapping.ToDto(route);
    }
}
