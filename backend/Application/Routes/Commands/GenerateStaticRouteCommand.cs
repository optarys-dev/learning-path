using CodeQuest2026.Server.Application.Routes.Queries;
using MediatR;

namespace CodeQuest2026.Server.Application.Routes.Commands;

public enum GenerateRouteStatus { Created, PreferencesRequired, NoMatches, CourseUnavailable }
public sealed record GenerateRouteResult(GenerateRouteStatus Status, LearningRouteDto? Route = null);
public sealed record GenerateStaticRouteCommand(string DiscordId) : IRequest<GenerateRouteResult>;

public sealed class GenerateStaticRouteCommandHandler(ISender sender)
    : IRequestHandler<GenerateStaticRouteCommand, GenerateRouteResult>
{
    public async Task<GenerateRouteResult> Handle(
        GenerateStaticRouteCommand request, CancellationToken cancellationToken)
    {
        var recommendation = await sender.Send(
            new GetStaticRecommendationQuery(request.DiscordId), cancellationToken);
        if (recommendation is null) return new(GenerateRouteStatus.PreferencesRequired);
        if (recommendation.Courses.Count == 0) return new(GenerateRouteStatus.NoMatches);

        var save = await sender.Send(new SaveLearningRouteCommand(request.DiscordId,
            new SaveLearningRouteRequest
            {
                RecommendationMethod = recommendation.Method,
                Explanation = recommendation.Explanation,
                Courses = recommendation.Courses.Select(x => new SaveRouteCourseRequest
                {
                    CourseId = x.CourseId,
                    Reason = x.Reason
                }).ToList()
            }), cancellationToken);
        return save.Status switch
        {
            SaveRouteStatus.Created => new(GenerateRouteStatus.Created, save.Route),
            SaveRouteStatus.PreferencesRequired => new(GenerateRouteStatus.PreferencesRequired),
            _ => new(GenerateRouteStatus.CourseUnavailable)
        };
    }
}
