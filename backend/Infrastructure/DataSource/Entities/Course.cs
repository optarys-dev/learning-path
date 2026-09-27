namespace CodeQuest2026.Server.Infrastructure.DataSource.Entities;

public class Course
{
    public long CourseId { get; set; }
    public string Slug { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string CourseUrl { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
    public string ImageAlt { get; set; } = string.Empty;
    public string? Level { get; set; }
    /// <summary>Categorías verificadas del catálogo; vacías si aún se desconocen. Pueden solaparse.</summary>
    public string[] CatalogKinds { get; set; } = [];
    public string Topics { get; set; } = "[]";
    public string? Description { get; set; }
    public string? Syllabus { get; set; }
    public string[] LearningOutcomes { get; set; } = [];
    public string[] SkillsTaught { get; set; } = [];
    public string[] Prerequisites { get; set; } = [];
    public string[] TargetAudience { get; set; } = [];
    public string? Language { get; set; }
    public int? DurationMinutes { get; set; }
    public string? MetadataSourceUrl { get; set; }
    public string? MetadataOrigin { get; set; }
    public DateTime? MetadataVerifiedAt { get; set; }
    public bool IsActive { get; set; } = true;
    public DateOnly SourceVerifiedAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public ICollection<Category> Categories { get; set; } = new List<Category>();
    public ICollection<Tag> Tags { get; set; } = new List<Tag>();
    public CourseEmbedding? Embedding { get; set; }
}
