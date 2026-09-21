using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Courses.Queries;

public sealed record GetCoursesQuery : IRequest<IReadOnlyList<CourseDto>>;

public sealed class GetCoursesQueryHandler(AppDbContext db)
    : IRequestHandler<GetCoursesQuery, IReadOnlyList<CourseDto>>
{
    public async Task<IReadOnlyList<CourseDto>> Handle(
        GetCoursesQuery request,
        CancellationToken cancellationToken)
    {
        return await db.Courses
            .AsNoTracking()
            .Where(course => course.IsActive)
            .OrderBy(course => course.Title)
            .ThenBy(course => course.CourseId)
            .Select(CourseMapping.Projection)
            .ToListAsync(cancellationToken);
    }
}
