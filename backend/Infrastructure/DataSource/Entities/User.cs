namespace CodeQuest2026.Server.Infrastructure.DataSource.Entities
{
    public class User
    {
        public string UserId { get; set; } = Guid.NewGuid().ToString();
        public string DiscordId { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string? DisplayName { get; set; }
        public string? Avatar { get; set; }
        public DateTimeOffset CreatedAt { get; set; }
        public DateTimeOffset LastLoginAt { get; set; }
        public UserPreference? Preferences { get; set; }
        public ICollection<LearningRoute> Routes { get; set; } = new List<LearningRoute>();
    }
}
