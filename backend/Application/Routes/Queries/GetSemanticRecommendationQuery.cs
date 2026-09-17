using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.Embeddings;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Pgvector;
using Pgvector.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Routes.Queries;

public sealed record GetSemanticRecommendationQuery(string DiscordId) : IRequest<SemanticRecommendationResult>;
public sealed record SemanticRecommendationResult(bool PreferencesRequired, bool EmbeddingsAvailable,
    StaticRecommendationDto? Recommendation);

public sealed class GetSemanticRecommendationQueryHandler(AppDbContext db, PreferenceEmbeddingClient embeddings)
    : IRequestHandler<GetSemanticRecommendationQuery, SemanticRecommendationResult>
{
    public async Task<SemanticRecommendationResult> Handle(
        GetSemanticRecommendationQuery request, CancellationToken cancellationToken)
    {
        var preference = await db.UserPreferences.AsNoTracking()
            .SingleOrDefaultAsync(x => x.User.DiscordId == request.DiscordId, cancellationToken);
        if (preference is null) return new(true, false, null);

        var query = await embeddings.EmbedAsync(preference, cancellationToken);
        var queryVector = new Vector(query.Embedding);
        var preferredLanguage = preference.PreferredLanguage?.Split('-')[0];
        var available = await db.CourseEmbeddings.AsNoTracking().AnyAsync(x =>
            x.Model == query.Model && x.Dimensions == query.Dimensions && x.Course.IsActive,
            cancellationToken);
        if (!available) return new(false, false, null);

        var candidates = await db.CourseEmbeddings.AsNoTracking()
            .Where(x => x.Model == query.Model && x.Dimensions == query.Dimensions && x.Course.IsActive
                && (string.IsNullOrEmpty(preferredLanguage)
                    || x.Course.Language == null
                    || x.Course.Language == preferredLanguage
                    || x.Course.Language.StartsWith(preferredLanguage + "-")))
            .OrderBy(x => x.Embedding.CosineDistance(queryVector)).ThenBy(x => x.CourseId)
            .Select(x => new
            {
                x.CourseId,
                x.Course.Title,
                x.Course.Level,
                x.Course.DurationMinutes,
                Similarity = 1 - x.Embedding.CosineDistance(queryVector)
            })
            .Take(6).ToListAsync(cancellationToken);

        static int LevelRank(string? level) => level switch
        {
            "Principiante" => 0, "Avanzado" => 2, _ => 1
        };
        var ordered = candidates.OrderBy(x => LevelRank(x.Level))
            .ThenByDescending(x => x.Similarity).ThenBy(x => x.CourseId)
            .Select((x, index) => new RecommendedCourseDto(x.CourseId, index + 1, x.Title,
                Math.Round(x.Similarity, 4), "Su contenido es semánticamente similar a tu objetivo e intereses.",
                x.DurationMinutes is > 0 && preference.MinutesPerWeek is > 0
                    ? (int)Math.Ceiling((double)x.DurationMinutes.Value / preference.MinutesPerWeek.Value)
                    : null)).ToList();
        return new(false, true, new StaticRecommendationDto("semantic-v1", preference.Goal,
            "Búsqueda por coseno con embeddings locales; orden sugerido por nivel. La similitud no garantiza prerrequisitos.",
            ordered));
    }
}
