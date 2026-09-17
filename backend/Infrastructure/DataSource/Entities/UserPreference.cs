namespace CodeQuest2026.Server.Infrastructure.DataSource.Entities;

public class UserPreference
{
    public string UserId { get; set; } = string.Empty;
    public User User { get; set; } = null!;
    public string Goal { get; set; } = string.Empty;
    public string? ExperienceLevel { get; set; }
    public string[] Interests { get; set; } = [];
    public string[] ExistingSkills { get; set; } = [];
    public string? PreferredLanguage { get; set; }
    public int? MinutesPerWeek { get; set; }
    public DateTimeOffset UpdatedAt { get; set; }
}
