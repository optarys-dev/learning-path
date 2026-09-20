using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public class LearningRouteConfiguration : IEntityTypeConfiguration<LearningRoute>
{
    public void Configure(EntityTypeBuilder<LearningRoute> builder)
    {
        builder.ToTable("learning_routes");
        builder.HasKey(x => x.RouteId);
        builder.Property(x => x.RouteId).HasColumnName("route_id").ValueGeneratedNever();
        builder.Property(x => x.UserId).HasColumnName("user_id").HasMaxLength(36).IsRequired();
        builder.HasOne(x => x.User).WithMany(x => x.Routes).HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(x => new { x.UserId, x.CreatedAt });
        builder.Property(x => x.Goal).HasColumnName("goal").HasMaxLength(1000).IsRequired();
        builder.Property(x => x.RecommendationMethod).HasColumnName("recommendation_method").HasMaxLength(80).IsRequired();
        builder.Property(x => x.Explanation).HasColumnName("explanation").HasMaxLength(4000);
        builder.Property(x => x.PreferencesSnapshot).HasColumnName("preferences_snapshot").HasColumnType("jsonb").IsRequired();
        builder.Property(x => x.CreatedAt).HasColumnName("created_at").IsRequired();
    }
}
