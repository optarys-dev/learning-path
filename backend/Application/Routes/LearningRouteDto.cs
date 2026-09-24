using System.ComponentModel.DataAnnotations;

namespace CodeQuest2026.Server.Application.Routes;

/// <summary>Curso incluido en una ruta guardada.</summary>
/// <param name="CourseId">Identificador del curso del catálogo.</param>
/// <param name="Position">Posición de aprendizaje, comenzando en 1.</param>
/// <param name="Title">Título actual del curso.</param>
/// <param name="Reason">Motivo por el que se recomendó el curso.</param>
/// <param name="ImageUrl">Enlace a la miniatura actual del curso.</param>
/// <param name="CourseUrl">Enlace a la página web del curso.</param>
/// <param name="ProgressPercentage">Avance entero de 0 a 100 en esta ruta.</param>
public sealed record RouteCourseDto(
    long CourseId,
    int Position,
    string Title,
    string? Reason,
    string ImageUrl,
    string CourseUrl,
    int ProgressPercentage = 0);
/// <summary>Ruta de aprendizaje guardada para el usuario.</summary>
/// <param name="RouteId">Identificador de la ruta.</param>
/// <param name="Goal">Objetivo del usuario al crear la ruta.</param>
/// <param name="RecommendationMethod">Método o versión que generó la recomendación.</param>
/// <param name="Explanation">Explicación general de la ruta.</param>
/// <param name="CreatedAt">Fecha de creación en UTC.</param>
/// <param name="Courses">Cursos ordenados por Position.</param>
public sealed record LearningRouteDto(Guid RouteId, string Goal, string RecommendationMethod,
    string? Explanation, DateTimeOffset CreatedAt, IReadOnlyList<RouteCourseDto> Courses)
{
    /// <summary>Promedio del avance de todos los cursos, con igual peso y redondeado a dos decimales. Sin cursos, devuelve 0.</summary>
    public decimal ProgressPercentage => Courses.Count == 0
        ? 0m
        : Math.Round(Courses.Average(course => (decimal)course.ProgressPercentage), 2, MidpointRounding.AwayFromZero);
}

/// <summary>Resultado de un análisis de recomendación listo para guardar.</summary>
public sealed class SaveLearningRouteRequest
{
    /// <summary>Nombre y versión del método que generó la ruta.</summary>
    [Required, StringLength(80, MinimumLength = 1)]
    public string RecommendationMethod { get; set; } = string.Empty;
    /// <summary>Explicación general de la recomendación; opcional.</summary>
    [StringLength(4000)] public string? Explanation { get; set; }
    /// <summary>Cursos en orden de aprendizaje; de 1 a 30, sin repetidos.</summary>
    [Required] public List<SaveRouteCourseRequest> Courses { get; set; } = [];
}

/// <summary>Curso propuesto para una ruta nueva.</summary>
public sealed class SaveRouteCourseRequest
{
    /// <summary>Identificador de un curso activo del catálogo.</summary>
    [Range(1, long.MaxValue)] public long CourseId { get; set; }
    /// <summary>Motivo para incluirlo en esta posición.</summary>
    [StringLength(1000)] public string? Reason { get; set; }
}
