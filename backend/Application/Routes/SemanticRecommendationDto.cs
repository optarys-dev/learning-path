namespace CodeQuest2026.Server.Application.Routes;

/// <summary>Resultado de una recomendación semántica.</summary>
/// <param name="Method">Versión del algoritmo utilizado.</param>
/// <param name="Goal">Objetivo guardado del usuario.</param>
/// <param name="Explanation">Cómo se eligieron y ordenaron los cursos.</param>
/// <param name="Courses">Cursos recomendados en el orden propuesto.</param>
public sealed record SemanticRecommendationDto(
    string Method, string Goal, string Explanation,
    IReadOnlyList<RecommendedCourseDto> Courses);

/// <summary>Curso recomendado con puntuación y motivo explicable.</summary>
/// <param name="CourseId">Identificador del curso activo.</param>
/// <param name="Position">Posición sugerida, empezando en 1.</param>
/// <param name="Title">Título del curso.</param>
/// <param name="Score">Puntuación interna de relevancia; no es una probabilidad.</param>
/// <param name="Reason">Motivo de la selección.</param>
/// <param name="EstimatedWeeks">Semanas estimadas según duración publicada y tiempo semanal; null si falta alguno.</param>
/// <param name="ImageUrl">Miniatura del curso; null si no dispone de imagen.</param>
public sealed record RecommendedCourseDto(
    long CourseId, int Position, string Title, double Score, string Reason, int? EstimatedWeeks,
    string? ImageUrl = null);
