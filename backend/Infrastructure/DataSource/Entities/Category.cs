namespace CodeQuest2026.Server.Infrastructure.DataSource.Entities;

public class Category
{
    public long CategoryId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public ICollection<Course> Courses { get; set; } = new List<Course>();
}

