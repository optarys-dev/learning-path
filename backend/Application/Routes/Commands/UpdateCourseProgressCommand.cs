using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Routes.Commands;

public enum UpdateCourseProgressStatus { Updated, NotFound, InvalidProgress }
public sealed record UpdateCourseProgressResult(UpdateCourseProgressStatus Status, LearningRouteDto? Route = null);
public sealed record UpdateCourseProgressCommand(string UserId, Guid RouteId, long CourseId,
    UpdateCourseProgressRequest Request) : IRequest<UpdateCourseProgressResult>;

public sealed class UpdateCourseProgressCommandHandler(AppDbContext db)
    : IRequestHandler<UpdateCourseProgressCommand, UpdateCourseProgressResult>
{
    public async Task<UpdateCourseProgressResult> Handle(UpdateCourseProgressCommand command,
        CancellationToken cancellationToken)
    {
        if (command.Request.ProgressPercentage is not int progress || progress is < 0 or > 100)
            return new(UpdateCourseProgressStatus.InvalidProgress);

        var strategy = db.Database.CreateExecutionStrategy();
        return await strategy.ExecuteAsync(async () =>
        {
            await using var transaction = await db.Database.BeginTransactionAsync(cancellationToken);
            // Mismo bloqueo de la fila padre que usa la edición de la ruta: evita perder
            // progreso si sus asociaciones se reemplazan mientras se actualiza el avance.
            var ownedRoute = await db.LearningRoutes
                .Where(route => route.RouteId == command.RouteId && route.UserId == command.UserId)
                .ExecuteUpdateAsync(setters => setters.SetProperty(route => route.Goal, route => route.Goal),
                    cancellationToken);
            if (ownedRoute == 0) return new UpdateCourseProgressResult(UpdateCourseProgressStatus.NotFound);

            var updated = await db.LearningRouteCourses
                .Where(course => course.RouteId == command.RouteId && course.CourseId == command.CourseId)
                .ExecuteUpdateAsync(setters => setters.SetProperty(course => course.ProgressPercentage, progress),
                    cancellationToken);
            if (updated == 0) return new UpdateCourseProgressResult(UpdateCourseProgressStatus.NotFound);

            var route = await db.LearningRoutes.AsNoTracking()
                .Include(route => route.Courses).ThenInclude(course => course.Course)
                .SingleAsync(route => route.RouteId == command.RouteId, cancellationToken);
            await transaction.CommitAsync(cancellationToken);
            return new UpdateCourseProgressResult(UpdateCourseProgressStatus.Updated, LearningRouteMapping.ToDto(route));
        });
    }
}
