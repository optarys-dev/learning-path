using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Configurations;

public sealed class UserExternalLoginConfiguration : IEntityTypeConfiguration<UserExternalLogin>
{
    public void Configure(EntityTypeBuilder<UserExternalLogin> builder)
    {
        builder.ToTable("user_external_logins");
        builder.HasKey(x => new { x.Provider, x.ProviderUserId });
        builder.Property(x => x.Provider).HasColumnName("provider").HasMaxLength(20);
        builder.Property(x => x.ProviderUserId).HasColumnName("provider_user_id").HasMaxLength(255);
        builder.Property(x => x.UserId).HasColumnName("user_id").HasMaxLength(36);
        builder.HasOne(x => x.User).WithMany(x => x.ExternalLogins).HasForeignKey(x => x.UserId);
        builder.HasIndex(x => new { x.UserId, x.Provider }).IsUnique();
    }
}
