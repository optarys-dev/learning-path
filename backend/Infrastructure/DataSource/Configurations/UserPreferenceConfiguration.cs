using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public class UserPreferenceConfiguration : IEntityTypeConfiguration<UserPreference>
{
    public void Configure(EntityTypeBuilder<UserPreference> builder)
    {
        builder.ToTable("user_preferences", table =>
            table.HasCheckConstraint("ck_user_preferences_minutes_per_week", "minutes_per_week IS NULL OR minutes_per_week > 0"));
        builder.HasKey(x => x.UserId);
        builder.Property(x => x.UserId).HasColumnName("user_id").HasMaxLength(36);
        builder.HasOne(x => x.User).WithOne(x => x.Preferences).HasForeignKey<UserPreference>(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
        builder.Property(x => x.Goal).HasColumnName("goal").HasMaxLength(1000).IsRequired();
        builder.Property(x => x.ExperienceLevel).HasColumnName("experience_level").HasMaxLength(40);
        builder.Property(x => x.Interests).HasColumnName("interests").HasColumnType("text[]").IsRequired();
        builder.Property(x => x.ExistingSkills).HasColumnName("existing_skills").HasColumnType("text[]").IsRequired();
        builder.Property(x => x.PreferredLanguage).HasColumnName("preferred_language").HasMaxLength(35);
        builder.Property(x => x.MinutesPerWeek).HasColumnName("minutes_per_week");
        builder.Property(x => x.UpdatedAt).HasColumnName("updated_at").IsRequired();
    }
}
