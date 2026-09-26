using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using CodeQuest2026.Server.Application.Courses;

namespace CodeQuest2026.Server.Application.Routes.Commands;

public enum UpdateRouteStatus { Updated, NotFound, InvalidRoute, CourseUnavailable }

public sealed record UpdateRouteResult(UpdateRouteStatus Status, LearningRouteDto? Route = null);

public sealed record UpdateLearningRouteCommand(
    string UserId,
    Guid RouteId,
    UpdateLearningRouteRequest Request) : IRequest<UpdateRouteResult>;

public sealed class UpdateLearningRouteCommandHandler(AppDbContext db)
    : IRequestHandler<UpdateLearningRouteCommand, UpdateRouteResult>
{
    public async Task<UpdateRouteResult> Handle(
        UpdateLearningRouteCommand command,
        CancellationToken cancellationToken)
    {
        var request = command.Request;

        if (string.IsNullOrWhiteSpace(request.Goal)
            || request.Goal.Length > 1000
            || request.Explanation?.Length > 4000
            || request.Courses is null
            || request.Courses.Count is < 1 or > 30
            || request.Courses.Any(course => course is null || course.CourseId <= 0 || course.Reason?.Length > 1000)
            || request.Courses.Select(course => course.CourseId).Distinct().Count() != request.Courses.Count)
        {
            return new(UpdateRouteStatus.InvalidRoute);
        }

        // La transacción permite intercambiar posiciones sin violar el índice único
        // (RouteId, Position). La estrategia permite reintentos del proveedor PostgreSQL.
        var strategy = db.Database.CreateExecutionStrategy();

        return await strategy.ExecuteAsync(async () =>
        {
            await using var transaction = await db.Database.BeginTransactionAsync(cancellationToken);

            var route = await db.LearningRoutes
                .AsNoTracking()
                .SingleOrDefaultAsync(
                    route => route.RouteId == command.RouteId && route.UserId == command.UserId,
                    cancellationToken);

            if (route is null)
            {
                return new UpdateRouteResult(UpdateRouteStatus.NotFound);
            }

            var ids = request.Courses.Select(course => course.CourseId).ToArray();
            var courseDetails = await db.Courses
                .AsNoTracking()
                .Where(course => ids.Contains(course.CourseId) && course.IsActive)
                .Select(CourseMapping.Projection)
                .ToDictionaryAsync(course => course.CourseId, cancellationToken);

            if (courseDetails.Count != ids.Length)
            {
                return new UpdateRouteResult(UpdateRouteStatus.CourseUnavailable);
            }

            var goal = request.Goal.Trim();
            var explanation = request.Explanation?.Trim();

            // Actualizar primero la fila padre serializa las ediciones concurrentes de esta ruta.
            var updated = await db.LearningRoutes
                .Where(route => route.RouteId == command.RouteId && route.UserId == command.UserId)
                .ExecuteUpdateAsync(setters => setters
                    .SetProperty(route => route.Goal, goal)
                    .SetProperty(route => route.Explanation, explanation), cancellationToken);

            if (updated == 0)
            {
                return new UpdateRouteResult(UpdateRouteStatus.NotFound);
            }

            var progress = await db.LearningRouteCourses.AsNoTracking()
                .Where(course => course.RouteId == command.RouteId)
                .ToDictionaryAsync(course => course.CourseId, course => course.ProgressPercentage, cancellationToken);

            await db.LearningRouteCourses
                .Where(course => course.RouteId == command.RouteId)
                .ExecuteDeleteAsync(cancellationToken);

            var courses = request.Courses.Select((course, index) => new LearningRouteCourse
            {
                RouteId = command.RouteId,
                CourseId = course.CourseId,
                Position = index + 1,
                ProgressPercentage = progress.GetValueOrDefault(course.CourseId),
                Reason = course.Reason?.Trim()
            }).ToArray();

            try
            {
                db.LearningRouteCourses.AddRange(courses);
                await db.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync(cancellationToken);
            }
            finally
            {
                // Evita entidades residuales si la estrategia vuelve a ejecutar la transacción.
                foreach (var course in courses)
                {
                    db.Entry(course).State = EntityState.Detached;
                }
            }

            route.Goal = goal;
            route.Explanation = explanation;
            route.Courses = courses;

            return new UpdateRouteResult(UpdateRouteStatus.Updated, LearningRouteMapping.ToDto(route, courseDetails));
        });
    }
}
