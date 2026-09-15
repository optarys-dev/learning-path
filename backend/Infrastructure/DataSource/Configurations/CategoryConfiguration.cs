using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public class CategoryConfiguration : IEntityTypeConfiguration<Category>
{
    public void Configure(EntityTypeBuilder<Category> builder)
    {
        builder.ToTable("categories");
        builder.HasKey(item => item.CategoryId).HasName("categories_pkey");
        builder.Property(item => item.CategoryId).HasColumnName("category_id").UseIdentityAlwaysColumn();
        builder.Property(item => item.Name).HasColumnName("name").HasMaxLength(100).IsRequired();
        builder.Property(item => item.Slug).HasColumnName("slug").HasMaxLength(100).IsRequired();
        builder.HasIndex(item => item.Slug).IsUnique().HasDatabaseName("ix_categories_slug");

        builder.HasMany(item => item.Courses)
            .WithMany(course => course.Categories)
            .UsingEntity<Dictionary<string, object>>(
                "CourseCategory",
                join => join.HasOne<Course>().WithMany().HasForeignKey("course_id").OnDelete(DeleteBehavior.Cascade),
                join => join.HasOne<Category>().WithMany().HasForeignKey("category_id").OnDelete(DeleteBehavior.Cascade),
                join =>
                {
                    join.ToTable("course_categories");
                    join.HasKey("course_id", "category_id").HasName("course_categories_pkey");
                    // Reverse of the primary key: find course IDs for a category.
                    join.HasIndex("category_id", "course_id")
                        .HasDatabaseName("ix_course_categories_category_id_course_id");
                });
    }
}
