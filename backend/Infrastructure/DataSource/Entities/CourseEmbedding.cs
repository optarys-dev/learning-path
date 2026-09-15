using Pgvector;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Entities;

public class CourseEmbedding
{
    public long CourseId { get; set; }
    public Course Course { get; set; } = null!;
    public Vector Embedding { get; set; } = null!;
    public string Model { get; set; } = string.Empty;
    public int Dimensions { get; set; }
    public string ContentHash { get; set; } = string.Empty;
    public DateTime GeneratedAt { get; set; }
}
