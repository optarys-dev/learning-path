using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public class LearningRouteCourseConfiguration : IEntityTypeConfiguration<LearningRouteCourse>
{
    public void Configure(EntityTypeBuilder<LearningRouteCourse> builder)
    {
        builder.ToTable("learning_route_courses", table =>
            table.HasCheckConstraint("ck_learning_route_courses_position", "position > 0"));
        builder.HasKey(x => new { x.RouteId, x.CourseId });
        builder.Property(x => x.RouteId).HasColumnName("route_id");
        builder.Property(x => x.CourseId).HasColumnName("course_id");
        builder.Property(x => x.Position).HasColumnName("position");
        builder.Property(x => x.Reason).HasColumnName("reason").HasMaxLength(1000);
        builder.HasIndex(x => new { x.RouteId, x.Position }).IsUnique();
        builder.HasOne(x => x.Route).WithMany(x => x.Courses).HasForeignKey(x => x.RouteId).OnDelete(DeleteBehavior.Cascade);
        builder.HasOne(x => x.Course).WithMany().HasForeignKey(x => x.CourseId).OnDelete(DeleteBehavior.Restrict);
    }
}
