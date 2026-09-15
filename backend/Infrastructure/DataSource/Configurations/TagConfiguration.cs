using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public class TagConfiguration : IEntityTypeConfiguration<Tag>
{
    public void Configure(EntityTypeBuilder<Tag> builder)
    {
        builder.ToTable("tags");
        builder.HasKey(item => item.TagId).HasName("tags_pkey");
        builder.Property(item => item.TagId).HasColumnName("tag_id").UseIdentityAlwaysColumn();
        builder.Property(item => item.Name).HasColumnName("name").HasMaxLength(100).IsRequired();
        builder.Property(item => item.Slug).HasColumnName("slug").HasMaxLength(100).IsRequired();
        builder.HasIndex(item => item.Slug).IsUnique().HasDatabaseName("ix_tags_slug");

        builder.HasMany(item => item.Courses)
            .WithMany(course => course.Tags)
            .UsingEntity<Dictionary<string, object>>(
                "CourseTag",
                join => join.HasOne<Course>().WithMany().HasForeignKey("course_id").OnDelete(DeleteBehavior.Cascade),
                join => join.HasOne<Tag>().WithMany().HasForeignKey("tag_id").OnDelete(DeleteBehavior.Cascade),
                join =>
                {
                    join.ToTable("course_tags");
                    join.HasKey("course_id", "tag_id").HasName("course_tags_pkey");
                    // Reverse of the primary key: find course IDs for a tag.
                    join.HasIndex("tag_id", "course_id")
                        .HasDatabaseName("ix_course_tags_tag_id_course_id");
                });
    }
}
