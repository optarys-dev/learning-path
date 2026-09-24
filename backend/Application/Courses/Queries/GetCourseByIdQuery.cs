using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Courses.Queries;

public sealed record GetCourseByIdQuery(long CourseId) : IRequest<CourseDto?>;

public sealed class GetCourseByIdQueryHandler(AppDbContext db)
    : IRequestHandler<GetCourseByIdQuery, CourseDto?>
{
    public async Task<CourseDto?> Handle(
        GetCourseByIdQuery request,
        CancellationToken cancellationToken)
    {
        return await db.Courses
            .AsNoTracking()
            .Where(course => course.CourseId == request.CourseId && course.IsActive)
            .Select(CourseMapping.Projection)
            .SingleOrDefaultAsync(cancellationToken);
    }
}
