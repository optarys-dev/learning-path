using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class StaticCourseRecommendationEngineTests
{
    private readonly StaticCourseRecommendationEngine engine = new();

    [Fact]
    public void RecommendsRelevantActiveCoursesInLearningOrder()
    {
        var preference = new UserPreference
        {
            Goal = "Aprender Python",
            ExperienceLevel = "Principiante",
            Interests = ["Python"],
            PreferredLanguage = "es",
            MinutesPerWeek = 60
        };
        var courses = new[]
        {
            Course(1, "Python avanzado", "Avanzado", "es", 120),
            Course(2, "Python desde cero", "Principiante", "es", 90),
            Course(3, "Cocina básica", "Principiante", "es", 60),
            Course(4, "Python in English", "Principiante", "en", 60),
            Course(5, "Python inactivo", "Principiante", "es", 60, false)
        };

        var result = engine.Recommend(preference, courses);

        Assert.Equal("static-v1", result.Method);
        Assert.Equal([2L, 1L], result.Courses.Select(x => x.CourseId));
        Assert.Equal([1, 2], result.Courses.Select(x => x.Position));
        Assert.Equal(2, result.Courses[0].EstimatedWeeks);
        Assert.Contains("Python", result.Courses[0].Reason);
    }

    [Fact]
    public void DoesNotInventMatchesWhenCatalogIsUnrelated()
    {
        var preference = new UserPreference { Goal = "Aprender astronomía", Interests = [] };
        var result = engine.Recommend(preference, [Course(1, "Introducción a C#", "Principiante", null, null)]);
        Assert.Empty(result.Courses);
    }

    private static Course Course(long id, string title, string level, string? language,
        int? duration, bool active = true) => new()
    {
        CourseId = id, Title = title, Level = level, Language = language,
        DurationMinutes = duration, IsActive = active
    };
}
