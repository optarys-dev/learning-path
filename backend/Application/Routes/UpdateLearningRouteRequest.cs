using System.ComponentModel.DataAnnotations;

namespace CodeQuest2026.Server.Application.Routes;

/// <summary>Reemplaza los campos editables de una ruta. El orden de Courses define las posiciones.</summary>
public sealed class UpdateLearningRouteRequest
{
    [Required, StringLength(1000, MinimumLength = 1)]
    public string Goal { get; set; } = string.Empty;

    [StringLength(4000)]
    public string? Explanation { get; set; }

    [Required, MinLength(1), MaxLength(30)]
    public List<SaveRouteCourseRequest> Courses { get; set; } = [];
}
