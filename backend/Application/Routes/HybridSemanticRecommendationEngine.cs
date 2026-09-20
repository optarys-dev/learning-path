using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;

namespace CodeQuest2026.Server.Application.Routes;

/// <summary>Curso activo con similitud coseno (1 - distancia coseno) calculada en PostgreSQL.</summary>
public sealed record SemanticCourseCandidate(Course Course, double Similarity);

/// <summary>Combina proximidad vectorial y relaciones observadas en el catálogo para proponer una ruta.</summary>
/// <remarks>
/// Las categorías y tags describen asociaciones, no un grafo de dependencias confirmado.
/// El puntaje final mide relevancia relativa dentro del catálogo consultado; no es una probabilidad.
/// </remarks>
public sealed partial class HybridSemanticRecommendationEngine
{
    public const string Method = "semantic-graph-v6";
    private const int MaxCourses = 6;
    private const double SemanticWeight = 0.82;
    private const double GraphWeight = 0.18;
    private static readonly HashSet<string> GenericGoalWords = new(StringComparer.Ordinal)
    {
        "a", "al", "aplicacion", "aplicaciones", "aprender", "con", "crear", "curso",
        "cursos", "de", "del", "desarrollar", "el", "en", "hacer", "la", "las",
        "lo", "los", "para", "por", "que", "quiero", "software", "un", "una", "y"
    };
    private static readonly HashSet<string> KnowledgeMarkers = new(StringComparer.Ordinal)
    {
        "basico", "basicos", "basica", "basicas", "conocimiento", "conocimientos",
        "dominio", "experiencia", "fundamentos", "manejo", "requerido", "requiere", "saber"
    };
    // Expansiones explícitas y acotadas: una intención web puede cubrir frontend/backend,
    // pero con menos peso que una categoría mencionada literalmente.
    private static readonly IReadOnlyDictionary<string, string[]> CategoryAliases =
        new Dictionary<string, string[]>(StringComparer.Ordinal)
        {
            ["web"] = ["frontend", "backend"]
        };
    private static readonly IReadOnlyDictionary<string, string> TagAliases =
        new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["js"] = "javascript"
        };

    /// <summary>Detecta intención, puntúa candidatos, selecciona hasta seis y ordena la ruta.</summary>
    /// <remarks>
    /// La intención de catálogo se obtiene del objetivo e intereses; si el objetivo nombra
    /// un tema, ese tema define el núcleo de la ruta por encima de otros intereses.
    /// El nivel de experiencia
    /// declarado ya participa en el embedding de consulta, pero aquí no tiene un peso explícito:
    /// el nivel publicado de cada curso determina parte del orden pedagógico. Las habilidades
    /// existentes afectan preparación y orden. La selección agrega diversidad temática.
    /// </remarks>
    public StaticRecommendationDto Recommend(UserPreference preference, IReadOnlyList<SemanticCourseCandidate> candidates)
    {
        if (candidates.Count == 0)
            return new(Method, preference.Goal, "No hay cursos con embeddings compatibles.", []);

        var goalTokens = Tokens(preference.Goal);
        var queryTokens = Tokens(string.Join(' ', new[] { preference.Goal }.Concat(preference.Interests)));
        var categories = candidates.SelectMany(x => x.Course.Categories).DistinctBy(x => x.CategoryId).ToArray();
        var tags = candidates.SelectMany(x => x.Course.Tags).DistinctBy(x => x.TagId).ToArray();
        var tagTopics = tags.Select(x => new Topic(x.Name, Tokens(x.Name))).ToArray();
        var matchedCategories = new Dictionary<long, double>();
        var domainTerms = new HashSet<string>(StringComparer.Ordinal);
        foreach (var category in categories)
        {
            if (ContainsLabel(queryTokens, category.Name))
            {
                matchedCategories[category.CategoryId] = 1;
                domainTerms.UnionWith(Tokens(category.Name).Where(x => !GenericGoalWords.Contains(x)));
                continue;
            }
            foreach (var alias in CategoryAliases)
            {
                if (!queryTokens.Contains(alias.Key) || !IsNamed(category.Name, alias.Value)) continue;
                matchedCategories[category.CategoryId] = 0.45;
                domainTerms.Add(alias.Key);
                break;
            }
        }
        var matchedTags = new Dictionary<long, double>();
        foreach (var tag in tags)
        {
            if (ContainsLabel(queryTokens, tag.Name) || TagAliases.Any(alias =>
                queryTokens.Contains(alias.Key) && IsNamed(tag.Name, alias.Value)))
                matchedTags[tag.TagId] = 1;
        }
        var compoundIntent = matchedCategories.Count > 0 && matchedTags.Count > 0;
        // Los tags del objetivo prevalecen sobre los intereses al definir el tema central.
        var goalTagIds = tags.Where(tag => matchedTags.ContainsKey(tag.TagId)
            && (ContainsLabel(goalTokens, tag.Name) || TagAliases.Any(alias =>
                goalTokens.Contains(alias.Key) && IsNamed(tag.Name, alias.Value))))
            .Select(tag => tag.TagId).ToHashSet();
        var focusedIntent = compoundIntent && goalTagIds.Count > 0;
        var topicTagIds = focusedIntent ? goalTagIds : matchedTags.Keys.ToHashSet();
        var specificGoalWords = queryTokens.Where(x => !GenericGoalWords.Contains(x)).ToHashSet();

        // Cuenta coocurrencias categoría-tag entre cursos candidatos. La asociación posterior
        // se normaliza por la frecuencia del tag o la categoría; no crea aristas de prerrequisito.
        var categoryTagCounts = new Dictionary<(long CategoryId, long TagId), int>();
        var categoryCounts = new Dictionary<long, int>();
        var tagCounts = new Dictionary<long, int>();
        foreach (var candidate in candidates)
        {
            foreach (var category in candidate.Course.Categories)
            {
                categoryCounts[category.CategoryId] = categoryCounts.GetValueOrDefault(category.CategoryId) + 1;
                foreach (var tag in candidate.Course.Tags)
                {
                    var key = (category.CategoryId, tag.TagId);
                    categoryTagCounts[key] = categoryTagCounts.GetValueOrDefault(key) + 1;
                }
            }
            foreach (var tag in candidate.Course.Tags)
                tagCounts[tag.TagId] = tagCounts.GetValueOrDefault(tag.TagId) + 1;
        }

        var ranked = candidates.Select(candidate =>
        {
            var course = candidate.Course;
            var titleTokens = Tokens(course.Title);
            var requiredTopics = RequiredTopics(course, tagTopics);
            // Coincidencia directa con categoría/tag o con palabras específicas del título.
            var graphScore = course.Categories.Select(x => matchedCategories.GetValueOrDefault(x.CategoryId))
                .Concat(course.Tags.Select(x => matchedTags.GetValueOrDefault(x.TagId)))
                .DefaultIfEmpty(0).Max();
            if (specificGoalWords.Overlaps(titleTokens))
                graphScore = Math.Max(graphScore, 1);
            if (compoundIntent)
            {
                // Para una intención categoría + tema: ambos = 1; fundamentos del tema = 0.85;
                // solo dominio = 0.35; solo tema = 0.15. No se suman coincidencias parciales.
                // Un requisito de entrada no demuestra que el curso enseñe el tema solicitado.
                var hasTopic = course.Tags.Any(x => topicTagIds.Contains(x.TagId));
                var hasDomain = course.Categories.Any(x => matchedCategories.ContainsKey(x.CategoryId))
                    || domainTerms.Overlaps(titleTokens);
                var teachesFoundation = hasTopic && course.Categories.Any(x =>
                    IsNamed(x.Name, "fundamentos"));
                graphScore = hasTopic && hasDomain ? 1
                    : teachesFoundation ? 0.85
                    : hasDomain ? 0.35
                    : hasTopic ? 0.15 : 0;
            }
            else if (graphScore < 1)
            {
                // Asociación indirecta: 0.4 * peso de coincidencia * coocurrencias / frecuencia.
                // Se toma el máximo para evitar que muchos tags genéricos inflen el puntaje.
                foreach (var tag in course.Tags)
                    foreach (var category in matchedCategories)
                        graphScore = Math.Max(graphScore,
                            0.4 * category.Value * categoryTagCounts.GetValueOrDefault((category.Key, tag.TagId))
                            / tagCounts[tag.TagId]);
                foreach (var category in course.Categories)
                    foreach (var tag in matchedTags)
                        graphScore = Math.Max(graphScore,
                            0.4 * tag.Value * categoryTagCounts.GetValueOrDefault((category.CategoryId, tag.Key))
                            / categoryCounts[category.CategoryId]);
            }

            // Normaliza la similitud coseno [-1, 1] a [0, 1] y combina 82 % vector / 18 % grafo.
            // Un título Legacy no solicitado recibe una penalización fija de 0.08.
            var semanticScore = Math.Clamp((candidate.Similarity + 1) / 2, 0, 1);
            var score = SemanticWeight * semanticScore + GraphWeight * graphScore;
            if (!queryTokens.Contains("legacy") && titleTokens.Contains("legacy"))
                score = Math.Max(0, score - 0.08);
            return new RankedCourse(course, score, graphScore, requiredTopics);
        }).ToList();

        // Cuando el objetivo nombra el tema y existe un curso central, evita completar
        // artificialmente seis posiciones con tecnologías que solo comparten el dominio.
        var coreCount = focusedIntent ? ranked.Count(x => x.GraphScore >= 0.8) : 0;
        if (coreCount > 0)
            ranked.RemoveAll(x => x.GraphScore < 0.35);

        // Selección voraz: puntaje final + hasta 0.06 por tags nuevos - hasta 0.06 por
        // requisitos temáticos aún desconocidos. Las habilidades enseñadas actualizan el estado.
        var selected = new List<RankedCourse>(Math.Min(MaxCourses, ranked.Count));
        var coveredTags = new HashSet<long>();
        var knownSkills = Tokens(string.Join(' ', preference.ExistingSkills));
        while (selected.Count < MaxCourses && ranked.Count > 0)
        {
            if (coreCount > 0 && selected.Count(x => x.GraphScore is >= 0.35 and < 0.8) >= 1)
                ranked.RemoveAll(x => x.GraphScore < 0.8);
            if (ranked.Count == 0) break;
            var next = ranked[0];
            var best = SelectionScore(next, coveredTags, knownSkills);
            for (var index = 1; index < ranked.Count; index++)
            {
                var candidate = ranked[index];
                var score = SelectionScore(candidate, coveredTags, knownSkills);
                if (score > best || score == best && candidate.Course.CourseId < next.Course.CourseId)
                {
                    next = candidate;
                    best = score;
                }
            }
            selected.Add(next);
            ranked.Remove(next);
            foreach (var tag in next.Course.Tags) coveredTags.Add(tag.TagId);
            AddTaughtSkills(knownSkills, next.Course);
        }

        // Reordena la selección: centrales primero, luego nivel publicado del curso
        // (principiante, intermedio, avanzado), proporción de requisitos pendientes,
        // relevancia e ID. No compara ese nivel con ExperienceLevel; recalcula preparación
        // tras cada curso colocado.
        var ordered = new List<RankedCourse>(selected.Count);
        // El motivo enumera requisitos publicados todavía no cubiertos; nunca bloquean cursos.
        knownSkills = Tokens(string.Join(' ', preference.ExistingSkills));
        while (selected.Count > 0)
        {
            var next = selected.OrderBy(x => compoundIntent && x.GraphScore < 0.8 ? 1 : 0)
                .ThenBy(x => LevelRank(x.Course.Level))
                .ThenBy(x => MissingRatio(x.RequiredTopics, knownSkills))
                .ThenByDescending(x => x.Score)
                .ThenBy(x => x.Course.CourseId).First();
            ordered.Add(next);
            selected.Remove(next);
            AddTaughtSkills(knownSkills, next.Course);
        }

        knownSkills = Tokens(string.Join(' ', preference.ExistingSkills));
        var recommended = ordered.Select((item, index) =>
        {
            var missing = item.RequiredTopics.Where(x => !x.Tokens.IsSubsetOf(knownSkills))
                .Select(x => x.Name).ToArray();
            var reason = item.GraphScore > 0
                ? "Coincide con temas relacionados del catálogo y con tu objetivo."
                : "Su contenido es semánticamente similar a tu objetivo e intereses.";
            if (missing.Length > 0)
                reason += $" Revisa los requisitos publicados: {string.Join(", ", missing)}.";
            AddTaughtSkills(knownSkills, item.Course);
            return new RecommendedCourseDto(item.Course.CourseId, index + 1,
                item.Course.Title, Math.Round(item.Score, 4), reason,
                item.Course.DurationMinutes is > 0 && preference.MinutesPerWeek is > 0
                    ? (int)Math.Ceiling((double)item.Course.DurationMinutes.Value / preference.MinutesPerWeek.Value)
                    : null);
        }).ToArray();

        var explanation = focusedIntent && coreCount > 0
            ? "Similitud coseno y asociaciones del catálogo; se priorizan cursos que combinan " +
              "la categoría y el tema solicitados, con un curso complementario como máximo. " +
              "Los requisitos publicados orientan el orden, sin bloquear cursos."
            : "Similitud coseno y asociaciones observadas entre categorías, tags y cursos; " +
              "orden sugerido por nivel. Los requisitos publicados son señales de preparación, no bloqueos.";
        return new(Method, preference.Goal, explanation, recommended);
    }

    private static double Novelty(Course course, HashSet<long> coveredTags, double graphScore)
    {
        if (graphScore == 0 || course.Tags.Count == 0) return 0;
        return 0.06 * course.Tags.Count(x => !coveredTags.Contains(x.TagId)) / course.Tags.Count;
    }

    private static double SelectionScore(RankedCourse course, HashSet<long> coveredTags,
        HashSet<string> knownSkills) => course.Score
        + Novelty(course.Course, coveredTags, course.GraphScore)
        - 0.06 * MissingRatio(course.RequiredTopics, knownSkills);

    private static double MissingRatio(IReadOnlyList<Topic> topics, HashSet<string> knownSkills) =>
        topics.Count == 0 ? 0 : (double)topics.Count(x => !x.Tokens.IsSubsetOf(knownSkills)) / topics.Count;

    // Solo propaga habilidades de metadatos verificados. Un tag del título puede representar
    // aprendizaje si el mismo tema no figura como requisito de conocimiento del curso.
    private static void AddTaughtSkills(HashSet<string> knownSkills, Course course)
    {
        if (course.MetadataVerifiedAt is null || course.MetadataOrigin == "inferred-seed-v1") return;
        knownSkills.UnionWith(Tokens(string.Join(' ', course.SkillsTaught)));
        var titleTokens = Tokens(course.Title);
        foreach (var tag in course.Tags)
        {
            if (!ContainsLabel(titleTokens, tag.Name)) continue;
            var isRequired = course.Prerequisites.Any(x => IsKnowledgeRequirement(x)
                && ContainsLabel(Tokens(x), tag.Name));
            if (!isRequired) knownSkills.UnionWith(Tokens(tag.Name));
        }
    }

    // Extrae temas del catálogo mencionados en requisitos de conocimiento publicados y
    // verificados. Es una heurística textual; no deduce dependencias obligatorias entre cursos.
    private static Topic[] RequiredTopics(Course course, Topic[] topics)
    {
        if (course.MetadataVerifiedAt is null || course.MetadataOrigin == "inferred-seed-v1") return [];
        return course.Prerequisites.Where(IsKnowledgeRequirement)
            .SelectMany(requirement =>
            {
                var tokens = Tokens(requirement);
                return topics.Where(topic => topic.Tokens.Count > 0 && topic.Tokens.IsSubsetOf(tokens));
            })
            .DistinctBy(x => x.Name)
            .ToArray();
    }

    // Excluye frases negativas u opcionales antes de reconocer marcadores de conocimiento.
    private static bool IsKnowledgeRequirement(string text)
    {
        var tokens = Tokens(text);
        if (tokens.Contains("sin") || tokens.Contains("ningun")
            || tokens.Contains("no") && (tokens.Contains("necesario") || tokens.Contains("necesaria")
                || tokens.Contains("necesita") || tokens.Contains("necesitan")
                || tokens.Contains("requiere") || tokens.Contains("requieren")
                || tokens.Contains("obligatorio"))
            || tokens.Contains("opcional") || tokens.Contains("deseable")) return false;
        return tokens.Overlaps(KnowledgeMarkers);
    }

    private static bool ContainsLabel(HashSet<string> text, string label)
    {
        var labelTokens = Tokens(label);
        return labelTokens.Count > 0 && labelTokens.IsSubsetOf(text);
    }

    private static bool IsNamed(string name, params string[] names)
    {
        var tokens = Tokens(name);
        return names.Any(tokens.Contains);
    }

    // Comparación sin mayúsculas ni diacríticos, con nombres técnicos normalizados.
    private static HashSet<string> Tokens(string input)
    {
        var normalized = input.ToLowerInvariant().Normalize(NormalizationForm.FormD);
        var text = new StringBuilder(normalized.Length);
        foreach (var character in normalized)
            if (CharUnicodeInfo.GetUnicodeCategory(character) != UnicodeCategory.NonSpacingMark)
                text.Append(character);
        return WordPattern().Matches(text.ToString().Replace("c#", "csharp")
                .Replace(".net", "dotnet").Replace("node.js", "nodejs"))
            .Select(x => x.Value).ToHashSet(StringComparer.Ordinal);
    }

    private static int LevelRank(string? level) => level?.ToLowerInvariant() switch
    {
        "principiante" => 0,
        "avanzado" => 2,
        _ => 1
    };

    [GeneratedRegex("[a-z0-9]+")]
    private static partial Regex WordPattern();

    private sealed record Topic(string Name, HashSet<string> Tokens);
    private sealed record RankedCourse(Course Course, double Score, double GraphScore,
        IReadOnlyList<Topic> RequiredTopics);
}
