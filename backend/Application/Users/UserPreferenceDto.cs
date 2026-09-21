using System.ComponentModel.DataAnnotations;

namespace CodeQuest2026.Server.Application.Users;

/// <summary>Preferencias que se usan para construir recomendaciones de aprendizaje.</summary>
/// <param name="Goal">Objetivo que desea alcanzar el usuario.</param>
/// <param name="ExperienceLevel">Nivel declarado por el usuario; null si no lo indicó.</param>
/// <param name="Interests">Temas que le interesan.</param>
/// <param name="ExistingSkills">Habilidades que ya domina.</param>
/// <param name="PreferredLanguage">Idioma preferido, por ejemplo es o en.</param>
/// <param name="MinutesPerWeek">Tiempo disponible por semana en minutos.</param>
/// <param name="UpdatedAt">Última actualización en UTC.</param>
public sealed record UserPreferenceDto(
    string Goal,
    string? ExperienceLevel,
    string[] Interests,
    string[] ExistingSkills,
    string? PreferredLanguage,
    int? MinutesPerWeek,
    DateTimeOffset UpdatedAt);

/// <summary>Datos para crear o reemplazar las preferencias del usuario.</summary>
public sealed class SaveUserPreferenceRequest
{
    /// <summary>Objetivo de aprendizaje. Obligatorio, hasta 1000 caracteres.</summary>
    [Required, StringLength(1000, MinimumLength = 1)]
    public string Goal { get; set; } = string.Empty;
    /// <summary>Nivel de experiencia declarado; opcional.</summary>
    [StringLength(40)] public string? ExperienceLevel { get; set; }
    /// <summary>Temas de interés; hasta 30 elementos.</summary>
    [Required] public string[] Interests { get; set; } = [];
    /// <summary>Habilidades previas; hasta 30 elementos.</summary>
    [Required] public string[] ExistingSkills { get; set; } = [];
    /// <summary>Idioma preferido, por ejemplo es o en.</summary>
    [StringLength(35)] public string? PreferredLanguage { get; set; }
    /// <summary>Minutos disponibles por semana, entre 1 y 10080.</summary>
    [Range(1, 10080)] public int? MinutesPerWeek { get; set; }
}
