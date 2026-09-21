namespace CodeQuest2026.Server.Application.Routes;

/// <summary>Vista previa V2. RefinementStatus indica si se aplicó IA o se conservó la ruta original.</summary>
public sealed record SemanticRecommendationV2Dto(
    string Method, string Goal, string Explanation,
    IReadOnlyList<RecommendedCourseDto> Courses,
    string RefinementStatus, string? Model);
