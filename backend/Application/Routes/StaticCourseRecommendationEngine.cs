using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;

namespace CodeQuest2026.Server.Application.Routes;

public interface IStaticCourseRecommendationEngine
{
    StaticRecommendationDto Recommend(UserPreference preference, IReadOnlyList<Course> courses);
}

/// <summary>Clasificador determinista del catálogo, sin llamadas externas ni embeddings.</summary>
public sealed partial class StaticCourseRecommendationEngine : IStaticCourseRecommendationEngine
{
    public const string Method = "static-v1";
    private const int MaxCourses = 6;
    private static readonly HashSet<string> StopWords = new(StringComparer.Ordinal)
    {
        "a", "al", "con", "de", "del", "el", "en", "es", "la", "las", "lo", "los",
        "mi", "para", "por", "que", "quiero", "un", "una", "y", "aprender", "crear",
        "hacer", "curso", "cursos", "desarrollar"
    };

    public StaticRecommendationDto Recommend(UserPreference preference, IReadOnlyList<Course> courses)
    {
        var goalTokens = Tokens(preference.Goal);
        var interestTerms = preference.Interests.Where(x => !string.IsNullOrWhiteSpace(x))
            .Select(x => (Text: x.Trim(), Tokens: Tokens(x)))
            .Where(x => x.Tokens.Count > 0).ToArray();
        var skillTokens = Tokens(string.Join(' ', preference.ExistingSkills));

        var scored = courses.Where(x => x.IsActive && LanguageMatches(preference.PreferredLanguage, x.Language))
            .Select(course => Score(course, goalTokens, interestTerms, skillTokens, preference.ExperienceLevel))
            .Where(x => x.Score > 0)
            .OrderByDescending(x => x.Score).ThenBy(x => x.Course.CourseId)
            .Take(MaxCourses)
            .OrderBy(x => LevelRank(x.Course.Level))
            .ThenByDescending(x => x.Score).ThenBy(x => x.Course.CourseId)
            .ToList();

        var recommended = scored.Select((x, index) => new RecommendedCourseDto(
            x.Course.CourseId, index + 1, x.Course.Title, Math.Round(x.Score, 2), x.Reason,
            x.Course.DurationMinutes is > 0 && preference.MinutesPerWeek is > 0
                ? (int)Math.Ceiling((double)x.Course.DurationMinutes.Value / preference.MinutesPerWeek.Value)
                : null)).ToList();

        return new StaticRecommendationDto(Method, preference.Goal,
            "Coincidencias de objetivo e intereses con el catálogo; orden sugerido por nivel. " +
            "Los prerrequisitos inferidos no se tratan como dependencias confirmadas.", recommended);
    }

    private static ScoredCourse Score(Course course, HashSet<string> goal,
        (string Text, HashSet<string> Tokens)[] interests, HashSet<string> skills, string? experience)
    {
        var title = Tokens(course.Title);
        var labels = Tokens(string.Join(' ', course.Categories.Select(x => x.Name)
            .Concat(course.Tags.Select(x => x.Name))));
        var taught = Tokens(string.Join(' ', course.SkillsTaught));
        var description = Tokens(course.Description ?? string.Empty);
        var prerequisites = Tokens(string.Join(' ', course.Prerequisites));
        var trustworthyMetadata = course.MetadataVerifiedAt is not null
            && course.MetadataOrigin != "inferred-seed-v1";
        var score = 0d;
        var matchedInterests = new List<string>();

        foreach (var interest in interests)
        {
            if (interest.Tokens.Overlaps(title) || interest.Tokens.Overlaps(labels))
            {
                score += 8;
                matchedInterests.Add(interest.Text);
            }
            else if (interest.Tokens.Overlaps(taught))
            {
                score += trustworthyMetadata ? 4 : 1;
                matchedInterests.Add(interest.Text);
            }
        }

        var goalMatches = goal.Intersect(title).Count();
        score += goalMatches * 5;
        score += goal.Intersect(labels).Count() * 4;
        score += goal.Intersect(taught).Count() * (trustworthyMetadata ? 2 : 0.5);
        score += goal.Intersect(description).Count() * (trustworthyMetadata ? 0.5 : 0.1);

        // An inferred prerequisite is a weak readiness hint, never a hard dependency.
        score += Math.Min(2, skills.Intersect(prerequisites).Count())
            * (trustworthyMetadata ? 0.75 : 0.1);
        if (IsBeginner(experience) && LevelRank(course.Level) == 2) score *= 0.35;

        var reason = matchedInterests.Count > 0
            ? $"Coincide con tus intereses: {string.Join(", ", matchedInterests.Take(3))}."
            : goalMatches > 0 || goal.Overlaps(labels)
                ? "Coincide con los temas de tu objetivo de aprendizaje."
                : "Desarrolla habilidades relacionadas con tu objetivo de aprendizaje.";
        return new ScoredCourse(course, score, reason);
    }

    private static bool LanguageMatches(string? preferred, string? actual) =>
        string.IsNullOrWhiteSpace(preferred) || string.IsNullOrWhiteSpace(actual)
        || preferred.Split('-')[0].Equals(actual.Split('-')[0], StringComparison.OrdinalIgnoreCase);

    private static bool IsBeginner(string? level) =>
        level is not null && (Normalize(level).Contains("principiante")
            || Normalize(level).Contains("inicial") || Normalize(level).Contains("beginner"));

    private static int LevelRank(string? level) => Normalize(level ?? string.Empty) switch
    {
        "principiante" => 0,
        "intermedio" => 1,
        "avanzado" => 2,
        _ => 1
    };

    private static HashSet<string> Tokens(string input)
    {
        var decomposed = input.ToLowerInvariant().Normalize(NormalizationForm.FormD);
        var text = new StringBuilder(decomposed.Length);
        foreach (var character in decomposed)
            if (CharUnicodeInfo.GetUnicodeCategory(character) != UnicodeCategory.NonSpacingMark)
                text.Append(character);
        var normalized = text.ToString().Replace("c#", "csharp").Replace(".net", "dotnet")
            .Replace("node.js", "nodejs");
        return WordPattern().Matches(normalized).Select(x => x.Value)
            .Where(x => x.Length > 1 && !StopWords.Contains(x)).ToHashSet(StringComparer.Ordinal);
    }

    private static string Normalize(string input) =>
        string.Concat(input.ToLowerInvariant().Normalize(NormalizationForm.FormD)
            .Where(x => CharUnicodeInfo.GetUnicodeCategory(x) != UnicodeCategory.NonSpacingMark));

    [GeneratedRegex("[a-z0-9]+")]
    private static partial Regex WordPattern();

    private sealed record ScoredCourse(Course Course, double Score, string Reason);
}
