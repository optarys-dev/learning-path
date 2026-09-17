namespace CodeQuest2026.Server.Infrastructure.DataSource.Entities;

public class LearningRoute
{
    public Guid RouteId { get; set; }
    public string UserId { get; set; } = string.Empty;
    public User User { get; set; } = null!;
    public string Goal { get; set; } = string.Empty;
    public string RecommendationMethod { get; set; } = string.Empty;
    public string? Explanation { get; set; }
    public string PreferencesSnapshot { get; set; } = "[]";
    public DateTimeOffset CreatedAt { get; set; }
    public ICollection<LearningRouteCourse> Courses { get; set; } = new List<LearningRouteCourse>();
}
