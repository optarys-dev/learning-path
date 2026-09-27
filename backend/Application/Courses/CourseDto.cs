using System.Linq.Expressions;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;

namespace CodeQuest2026.Server.Application.Courses;

/// <summary>Datos básicos para presentar un curso, sin metadatos de aprendizaje ni embeddings.</summary>
public sealed record CourseDto(
    long CourseId,
    string Slug,
    string Title,
    string? Level,
    string ImageUrl,
    string ImageAlt,
    string CourseUrl,
    string[]? CatalogKinds = null);

internal static class CourseMapping
{
    public static readonly Expression<Func<Course, CourseDto>> Projection = course => new CourseDto(
        course.CourseId,
        course.Slug,
        course.Title,
        course.Level,
        course.ImageUrl,
        course.ImageAlt,
        course.CourseUrl,
        course.CatalogKinds);
}
