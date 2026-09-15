using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public class CourseConfiguration : IEntityTypeConfiguration<Course>
{
    public void Configure(EntityTypeBuilder<Course> builder)
    {
        builder.ToTable("courses", table =>
        {
            table.HasCheckConstraint("ck_courses_duration_minutes", "duration_minutes IS NULL OR duration_minutes > 0");
            table.HasCheckConstraint("ck_courses_level", "level IS NULL OR level IN ('Principiante', 'Intermedio', 'Avanzado')");
            table.HasCheckConstraint("ck_courses_url", "course_url LIKE 'https://cursos.devtalles.com/courses/%'");
            table.HasCheckConstraint("ck_courses_image_url", "image_url LIKE 'https://import.cdn.thinkific.com/%'");
        });

        builder.HasKey(course => course.CourseId).HasName("courses_pkey");
        builder.Property(course => course.CourseId).HasColumnName("course_id").UseIdentityAlwaysColumn();
        builder.Property(course => course.Slug).HasColumnName("slug").HasMaxLength(160).IsRequired();
        builder.HasAlternateKey(course => course.Slug).HasName("courses_slug_key");
        builder.Property(course => course.Title).HasColumnName("title").HasMaxLength(255).IsRequired();
        builder.Property(course => course.CourseUrl).HasColumnName("course_url").HasColumnType("text").IsRequired();
        builder.Property(course => course.ImageUrl).HasColumnName("image_url").HasColumnType("text").IsRequired();
        builder.Property(course => course.ImageAlt).HasColumnName("image_alt").HasMaxLength(255).IsRequired();
        builder.Property(course => course.Level).HasColumnName("level").HasMaxLength(20);
        builder.Property(course => course.Topics).HasColumnName("topics").HasColumnType("jsonb").HasDefaultValueSql("'[]'::jsonb").IsRequired();
        builder.Property(course => course.Description).HasColumnName("description").HasColumnType("text");
        builder.Property(course => course.Syllabus).HasColumnName("syllabus").HasColumnType("text");
        builder.Property(course => course.LearningOutcomes).HasColumnName("learning_outcomes").HasColumnType("text[]").HasDefaultValueSql("ARRAY[]::text[]").IsRequired();
        builder.Property(course => course.SkillsTaught).HasColumnName("skills_taught").HasColumnType("text[]").HasDefaultValueSql("ARRAY[]::text[]").IsRequired();
        builder.Property(course => course.Prerequisites).HasColumnName("prerequisites").HasColumnType("text[]").HasDefaultValueSql("ARRAY[]::text[]").IsRequired();
        builder.Property(course => course.TargetAudience).HasColumnName("target_audience").HasColumnType("text[]").HasDefaultValueSql("ARRAY[]::text[]").IsRequired();
        builder.Property(course => course.Language).HasColumnName("language").HasMaxLength(35);
        builder.Property(course => course.DurationMinutes).HasColumnName("duration_minutes");
        builder.Property(course => course.MetadataSourceUrl).HasColumnName("metadata_source_url").HasColumnType("text");
        builder.Property(course => course.MetadataOrigin).HasColumnName("metadata_origin").HasMaxLength(40);
        builder.Property(course => course.MetadataVerifiedAt).HasColumnName("metadata_verified_at").HasColumnType("timestamp with time zone");
        builder.Property(course => course.IsActive).HasColumnName("is_active").HasDefaultValue(true);
        builder.Property(course => course.SourceVerifiedAt).HasColumnName("source_verified_at").HasColumnType("date");
        builder.Property(course => course.CreatedAt).HasColumnName("created_at").HasColumnType("timestamp with time zone").HasDefaultValueSql("NOW()");
        builder.Property(course => course.UpdatedAt).HasColumnName("updated_at").HasColumnType("timestamp with time zone").HasDefaultValueSql("NOW()");

        // Catalog filters: active status, optionally narrowed by level.
        builder.HasIndex(course => new { course.IsActive, course.Level })
            .HasDatabaseName("ix_courses_is_active_level");

        // Supports title searches with LIKE/ILIKE '%term%'.
        builder.HasIndex(course => course.Title)
            .HasDatabaseName("ix_courses_title_trgm")
            .HasMethod("gin")
            .HasOperators("gin_trgm_ops");
    }
}
