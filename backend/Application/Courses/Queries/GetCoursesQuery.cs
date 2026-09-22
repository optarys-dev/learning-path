using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Courses.Queries;

public sealed record GetCoursesQuery(int Page, int PageSize) : IRequest<PagedResultDto<CourseDto>>
{
    public const int DefaultPage = 1;
    public const int DefaultPageSize = 20;
    public const int MaxPageSize = 100;
}

public sealed class GetCoursesQueryHandler(AppDbContext db)
    : IRequestHandler<GetCoursesQuery, PagedResultDto<CourseDto>>
{
    public async Task<PagedResultDto<CourseDto>> Handle(
        GetCoursesQuery request,
        CancellationToken cancellationToken)
    {
        ArgumentOutOfRangeException.ThrowIfLessThan(request.Page, 1);
        ArgumentOutOfRangeException.ThrowIfLessThan(request.PageSize, 1);
        ArgumentOutOfRangeException.ThrowIfGreaterThan(request.PageSize, GetCoursesQuery.MaxPageSize);

        var activeCourses = db.Courses
            .AsNoTracking()
            .Where(course => course.IsActive);
        var totalCount = await activeCourses.CountAsync(cancellationToken);
        var totalPages = totalCount == 0 ? 0 : 1 + (totalCount - 1) / request.PageSize;

        IReadOnlyList<CourseDto> items = request.Page > totalPages
            ? []
            : await activeCourses
                .OrderBy(course => course.Title)
                .ThenBy(course => course.CourseId)
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .Select(CourseMapping.Projection)
                .ToListAsync(cancellationToken);

        return new PagedResultDto<CourseDto>(
            items,
            request.Page,
            request.PageSize,
            totalCount,
            totalPages,
            request.Page > 1 && totalCount > 0,
            request.Page < totalPages);
    }
}
