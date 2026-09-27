namespace CodeQuest2026.Server.Infrastructure.DataSource.Entities;

public sealed class UserExternalLogin
{
    public string Provider { get; set; } = string.Empty;
    public string ProviderUserId { get; set; } = string.Empty;
    public string UserId { get; set; } = string.Empty;
    public User User { get; set; } = null!;
}
