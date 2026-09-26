using MediatR;

namespace CodeQuest2026.Server.Application.Users.Commands;

public sealed record SyncDiscordUserCommand(string DiscordId, string Username,
    string? DisplayName, string? Avatar) : IRequest<string>;

public sealed class SyncDiscordUserCommandHandler(ISender sender) : IRequestHandler<SyncDiscordUserCommand, string>
{
    public Task<string> Handle(SyncDiscordUserCommand request, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(request.DiscordId) || request.DiscordId.Length > 20
            || request.DiscordId.Any(character => character is < '0' or > '9') || request.Avatar?.Length > 128)
            throw new ArgumentException("Discord returned an invalid profile.");
        return sender.Send(new SyncExternalUserCommand("Discord", request.DiscordId,
            request.Username, request.DisplayName, request.Avatar), cancellationToken);
    }
}
