using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Routes.Commands;

public sealed record DeleteLearningRouteCommand(string DiscordId, Guid RouteId) : IRequest<bool>;

public sealed class DeleteLearningRouteCommandHandler(AppDbContext db)
    : IRequestHandler<DeleteLearningRouteCommand, bool>
{
    public async Task<bool> Handle(
        DeleteLearningRouteCommand request,
        CancellationToken cancellationToken)
    {
        // La FK elimina las asociaciones de la ruta, no los cursos del catálogo.
        var deleted = await db.LearningRoutes
            .Where(route => route.RouteId == request.RouteId && route.User.DiscordId == request.DiscordId)
            .ExecuteDeleteAsync(cancellationToken);

        return deleted > 0;
    }
}
