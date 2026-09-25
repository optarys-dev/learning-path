using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Courses.Queries;

public sealed record GetCoursesQuery(int Page, int PageSize, string? Search = null) : IRequest<PagedResultDto<CourseDto>>
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

        IQueryable<Course> activeCourses = db.Courses
            .AsNoTracking()
            .Where(course => course.IsActive);

        var search = string.IsNullOrWhiteSpace(request.Search) ? null : request.Search.Trim();
        if (search is not null)
        {
            if (db.Database.IsNpgsql())
            {
                var pattern = $"%{search}%";
                activeCourses = activeCourses.Where(course =>
                    EF.Functions.ILike(course.Title, pattern)
                    || (course.Description != null && EF.Functions.ILike(course.Description, pattern))
                    || course.Categories.Any(category => EF.Functions.ILike(category.Name, pattern))
                    || course.Tags.Any(tag => EF.Functions.ILike(tag.Name, pattern)));
            }
            else
            {
                var normalizedSearch = search.ToLower();
                activeCourses = activeCourses.Where(course =>
                    course.Title.ToLower().Contains(normalizedSearch)
                    || (course.Description != null && course.Description.ToLower().Contains(normalizedSearch))
                    || course.Categories.Any(category => category.Name.ToLower().Contains(normalizedSearch))
                    || course.Tags.Any(tag => tag.Name.ToLower().Contains(normalizedSearch)));
            }
        }

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
