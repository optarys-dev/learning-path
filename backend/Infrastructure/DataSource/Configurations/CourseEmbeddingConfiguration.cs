using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public class CourseEmbeddingConfiguration : IEntityTypeConfiguration<CourseEmbedding>
{
    public void Configure(EntityTypeBuilder<CourseEmbedding> builder)
    {
        builder.ToTable("course_embeddings", table =>
        {
            table.HasCheckConstraint("ck_course_embeddings_dimensions", "dimensions > 0 AND vector_dims(embedding) = dimensions");
            table.HasCheckConstraint("ck_course_embeddings_nonzero", "(embedding <#> embedding) < 0");
            table.HasCheckConstraint("ck_course_embeddings_model", "length(btrim(model)) > 0");
            table.HasCheckConstraint("ck_course_embeddings_content_hash", "content_hash ~ '^[0-9a-f]{64}$'");
        });

        builder.HasKey(item => item.CourseId).HasName("course_embeddings_pkey");
        builder.Property(item => item.CourseId).HasColumnName("course_id").ValueGeneratedNever();
        // Exact search supports different dimensions until a model is selected.
        builder.Property(item => item.Embedding).HasColumnName("embedding").HasColumnType("vector").IsRequired();
        builder.Property(item => item.Model).HasColumnName("model").HasMaxLength(200).IsRequired();
        builder.Property(item => item.Dimensions).HasColumnName("dimensions");
        builder.Property(item => item.ContentHash).HasColumnName("content_hash").HasMaxLength(64).IsRequired();
        builder.Property(item => item.GeneratedAt).HasColumnName("generated_at").HasColumnType("timestamp with time zone").HasDefaultValueSql("NOW()");
        builder.HasOne(item => item.Course).WithOne(course => course.Embedding)
            .HasForeignKey<CourseEmbedding>(item => item.CourseId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(item => new { item.Model, item.Dimensions }).HasDatabaseName("ix_course_embeddings_model_dimensions");
    }
}
