using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.ToTable("users");
        builder.HasKey(user => user.UserId).HasName("users_pkey");
        builder.Property(user => user.UserId).HasColumnName("user_id").HasMaxLength(36).ValueGeneratedNever();
        builder.Property(user => user.DiscordId).HasColumnName("discord_id").HasMaxLength(20);
        builder.HasIndex(user => user.DiscordId).IsUnique().HasDatabaseName("ix_users_discord_id");
        builder.Property(user => user.Username).HasColumnName("username").HasMaxLength(32).IsRequired();
        builder.Property(user => user.DisplayName).HasColumnName("display_name").HasMaxLength(100);
        builder.Property(user => user.Avatar).HasColumnName("avatar").HasMaxLength(2048);
        builder.Property(user => user.CreatedAt).HasColumnName("created_at").IsRequired();
        builder.Property(user => user.LastLoginAt).HasColumnName("last_login_at").IsRequired();
    }
}
