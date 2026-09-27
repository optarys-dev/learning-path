namespace CodeQuest2026.Server.Application.Common;

/// <summary>Stable error codes exposed by the HTTP API.</summary>
public static class ApiErrorCodes
{
    public const string Validation = "validation_error";
    public const string Unauthenticated = "unauthenticated";
    public const string UserNotRegistered = "user_not_registered";
    public const string Forbidden = "forbidden";
    public const string Internal = "internal_error";
    public const string InvalidPreferences = "invalid_preferences";
    public const string InvalidRoute = "invalid_route";
    public const string EmbeddingUnavailable = "embedding_service_unavailable";
    public const string EmbeddingFailed = "embedding_service_error";
}
