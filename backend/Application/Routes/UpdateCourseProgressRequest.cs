using System.ComponentModel.DataAnnotations;

namespace CodeQuest2026.Server.Application.Routes;

public sealed class UpdateCourseProgressRequest
{
    /// <summary>Porcentaje entero entre 0 (pendiente) y 100 (completado).</summary>
    [Required, Range(0, 100)]
    public int? ProgressPercentage { get; set; }
}
