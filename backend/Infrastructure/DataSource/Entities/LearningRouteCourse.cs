namespace CodeQuest2026.Server.Infrastructure.DataSource.Entities;

public class LearningRouteCourse
{
    public Guid RouteId { get; set; }
    public LearningRoute Route { get; set; } = null!;
    public long CourseId { get; set; }
    public Course Course { get; set; } = null!;
    public int Position { get; set; }
    public string? Reason { get; set; }
}
