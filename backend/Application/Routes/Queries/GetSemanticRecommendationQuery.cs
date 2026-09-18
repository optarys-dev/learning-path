using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.Embeddings;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Pgvector;
using Pgvector.EntityFrameworkCore;

namespace CodeQuest2026.Server.Application.Routes.Queries;

/// <summary>Solicita una vista previa de la ruta semántica para las preferencias del usuario.</summary>
public sealed record GetSemanticRecommendationQuery(string DiscordId) : IRequest<SemanticRecommendationResult>;

/// <summary>Distingue preferencias ausentes, embeddings indisponibles y una recomendación calculada.</summary>
public sealed record SemanticRecommendationResult(bool PreferencesRequired, bool EmbeddingsAvailable,
    StaticRecommendationDto? Recommendation);

/// <summary>Obtiene la similitud vectorial en PostgreSQL y delega el ranking y orden al motor híbrido.</summary>
public sealed class GetSemanticRecommendationQueryHandler(
    AppDbContext db, PreferenceEmbeddingClient embeddings, HybridSemanticRecommendationEngine engine)
    : IRequestHandler<GetSemanticRecommendationQuery, SemanticRecommendationResult>
{
    public async Task<SemanticRecommendationResult> Handle(
        GetSemanticRecommendationQuery request, CancellationToken cancellationToken)
    {
        var preference = await db.UserPreferences.AsNoTracking()
            .SingleOrDefaultAsync(x => x.User.DiscordId == request.DiscordId, cancellationToken);
        if (preference is null) return new(true, false, null);

        // El vector representa objetivo, intereses y nivel; las habilidades existentes se usan después
        // para evaluar preparación y ordenar la ruta, no para generar el embedding de consulta.
        var query = await embeddings.EmbedAsync(preference, cancellationToken);
        var queryVector = new Vector(query.Embedding);
        var preferredLanguage = preference.PreferredLanguage?.Split('-')[0];
        // Solo compara vectores del mismo modelo y dimensión. PostgreSQL calcula coseno:
        // similitud = 1 - distancia_coseno. Se conserva todo el conjunto compatible porque
        // el grafo y la selección necesitan observar el catálogo, no solo los primeros vecinos.
        var matches = await db.CourseEmbeddings.AsNoTracking()
            .Where(x => x.Model == query.Model && x.Dimensions == query.Dimensions && x.Course.IsActive
                && (string.IsNullOrEmpty(preferredLanguage)
                    || x.Course.Language == null
                    || x.Course.Language == preferredLanguage
                    || x.Course.Language.StartsWith(preferredLanguage + "-")))
            .Select(x => new
            {
                x.CourseId,
                Similarity = 1 - x.Embedding.CosineDistance(queryVector)
            })
            .ToListAsync(cancellationToken);
        if (matches.Count == 0)
        {
            // Diferencia un índice compatible vacío de un filtro de idioma sin coincidencias.
            var available = await db.CourseEmbeddings.AsNoTracking().AnyAsync(x =>
                x.Model == query.Model && x.Dimensions == query.Dimensions && x.Course.IsActive,
                cancellationToken);
            return new(false, available, available ? engine.Recommend(preference, []) : null);
        }

        var ids = matches.Select(x => x.CourseId).ToArray();
        // Carga categorías y tags por separado para construir asociaciones observadas sin
        // multiplicar filas por el producto de ambas colecciones en una sola consulta SQL.
        var courses = await db.Courses.AsNoTracking()
            .Where(x => ids.Contains(x.CourseId) && x.IsActive)
            .Include(x => x.Categories).Include(x => x.Tags)
            .AsSplitQuery()
            .ToDictionaryAsync(x => x.CourseId, cancellationToken);
        var candidates = matches.Where(x => courses.ContainsKey(x.CourseId))
            .Select(x => new SemanticCourseCandidate(courses[x.CourseId], x.Similarity))
            .ToArray();
        // El resultado es una vista previa; la persistencia de rutas ocurre en otro flujo.
        return new(false, true, engine.Recommend(preference, candidates));
    }
}
