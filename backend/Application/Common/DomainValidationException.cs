namespace CodeQuest2026.Server.Application.Common;

/// <summary>Represents an expected validation failure in the application layer.</summary>
public sealed class DomainValidationException(string code) : Exception(code)
{
    public string Code { get; } = code;
}
