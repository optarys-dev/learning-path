using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class HybridSemanticRecommendationEngineTests
{
    private readonly HybridSemanticRecommendationEngine engine = new();

    [Fact]
    public void CatalogBadgesArePreservedWithoutChangingRecommendationRanking()
    {
        var candidates = new[] { Candidate(1, "APIs con Go", 0.85), Candidate(2, "APIs con Python", 0.75) };
        var preference = new UserPreference { Goal = "Aprender APIs" };
        var original = engine.Recommend(preference, candidates);
        candidates[0].Course.CatalogKinds = ["pro-exclusive"];
        candidates[1].Course.CatalogKinds = ["free", "mini-course"];

        var result = engine.Recommend(preference, candidates);

        Assert.Equal(original.Courses.Select(course => (course.CourseId, course.Score)), result.Courses.Select(course => (course.CourseId, course.Score)));
        Assert.Equal(new[] { "pro-exclusive" }, result.Courses.Single(course => course.CourseId == 1).CatalogKinds);
        Assert.Equal(new[] { "free", "mini-course" }, result.Courses.Single(course => course.CourseId == 2).CatalogKinds);
    }

    [Fact]
    public void CategoryMatchRaisesCoursesFromTheRequestedArea()
    {
        var backend = new Category { CategoryId = 1, Name = "Backend" };
        var frontend = new Category { CategoryId = 2, Name = "Frontend" };
        var preference = new UserPreference { Goal = "Aprender Backend" };
        var result = engine.Recommend(preference,
        [
            Candidate(1, "Frontend avanzado", 0.85, frontend),
            Candidate(2, "APIs con Go", 0.75, backend)
        ]);

        Assert.Equal(HybridSemanticRecommendationEngine.Method, result.Method);
        Assert.True(result.Courses.Single(x => x.CourseId == 2).Score >
                    result.Courses.Single(x => x.CourseId == 1).Score);
    }

    [Fact]
    public void CategoryRouteCoversDifferentObservedTagsBeforeRepeatingOne()
    {
        var backend = new Category { CategoryId = 1, Name = "Backend" };
        var apis = new Tag { TagId = 1, Name = "APIs" };
        var sql = new Tag { TagId = 2, Name = "SQL" };
        var preference = new UserPreference { Goal = "Aprender Backend" };
        var candidates = Enumerable.Range(1, 6)
            .Select(id => Candidate(id, $"API {id}", 0.8, backend, apis))
            .Append(Candidate(7, "Bases de datos", 0.8, backend, sql)).ToArray();

        var result = engine.Recommend(preference, candidates);

        Assert.Equal(6, result.Courses.Count);
        Assert.Contains(result.Courses, x => x.CourseId == 7);
    }

    [Fact]
    public void SharedTagConnectsCoursesOutsideTheMatchedCategory()
    {
        var backend = new Category { CategoryId = 1, Name = "Backend" };
        var tools = new Category { CategoryId = 2, Name = "Herramientas" };
        var docker = new Tag { TagId = 1, Name = "Docker" };
        var result = engine.Recommend(new UserPreference { Goal = "Aprender Backend" },
        [
            Candidate(1, "Contenedores para APIs", 0.8, backend, docker),
            Candidate(2, "Docker", 0.8, tools, docker),
            Candidate(3, "Editor de código", 0.8, tools)
        ]);

        Assert.True(result.Courses.Single(x => x.CourseId == 2).Score >
                    result.Courses.Single(x => x.CourseId == 3).Score);
    }

    [Fact]
    public void BroadWebGoalPrioritizesWebCoursesOverUnrelatedSemanticNeighbors()
    {
        var frontend = new Category { CategoryId = 1, Name = "Frontend" };
        var backend = new Category { CategoryId = 2, Name = "Backend" };
        var fundamentals = new Category { CategoryId = 3, Name = "Fundamentos" };
        var ai = new Category { CategoryId = 4, Name = "Inteligencia artificial" };
        var javascript = new Tag { TagId = 1, Name = "JavaScript" };
        var preference = new UserPreference
        {
            Goal = "Quiero aprender a desarrollar aplicaciones web",
            Interests = ["web", "js"]
        };
        var result = engine.Recommend(preference,
        [
            Candidate(68, "JavaScript Moderno: Guía para dominar el lenguaje", 0.64,
                fundamentals, javascript),
            Candidate(61, "Programación para principiantes: Primeros pasos", 0.59, fundamentals),
            Candidate(11, "Vibe Coding: De forma responsable", 0.53, ai),
            Candidate(35, "Java: Explora el lenguaje desde cero", 0.49, fundamentals),
            Candidate(65, "Legacy Flutter Web: Aplicaciones y páginas web profesionales", 0.64,
                frontend),
            Candidate(21, "Nuxt: El marco de trabajo web progresivo", 0.60, frontend),
            Candidate(30, "Django: Crea aplicaciones web robustas con Python", 0.58, backend),
            Candidate(41, "Astro: El framework para sitios web orientados al contenido", 0.57,
                frontend),
            Candidate(51, "Node Js: De cero a experto", 0.55, backend)
        ]);

        Assert.Equal(6, result.Courses.Count);
        Assert.Contains(result.Courses, x => x.CourseId == 21);
        Assert.Contains(result.Courses, x => x.CourseId == 30);
        Assert.Contains(result.Courses, x => x.CourseId == 41);
        Assert.DoesNotContain(result.Courses, x => x.CourseId is 11 or 35 or 61);
    }

    [Fact]
    public void PythonWebGoalStartsWithPythonAndExcludesAutomation()
    {
        var backend = new Category { CategoryId = 1, Name = "Backend" };
        var frontend = new Category { CategoryId = 2, Name = "Frontend" };
        var fundamentals = new Category { CategoryId = 3, Name = "Fundamentos" };
        var automation = new Category { CategoryId = 4, Name = "Automatización" };
        var python = new Tag { TagId = 1, Name = "Python" };
        var javascript = new Tag { TagId = 2, Name = "JavaScript" };
        var basics = Candidate(32, "Python: Fundamentos hasta los detalles", 0.55,
            fundamentals, python);
        basics.Course.Level = "Principiante";
        basics.Course.MetadataVerifiedAt = DateTime.UtcNow;
        basics.Course.Prerequisites = ["Acceso a internet para instalar Python"];
        var django = Candidate(30, "Django: Crea aplicaciones web robustas con Python", 0.68,
            backend, python);
        django.Course.MetadataVerifiedAt = DateTime.UtcNow;
        django.Course.Prerequisites = ["Conocimientos básicos de Python"];
        var fastApi = Candidate(23, "FastAPI: Crea APIs eficientes con Python", 0.58,
            backend, python);
        fastApi.Course.MetadataVerifiedAt = DateTime.UtcNow;
        fastApi.Course.Prerequisites = ["Python básico"];
        var n8n = Candidate(18, "Python + n8n: Automatiza rutinas cotidianas", 0.53,
            automation, python);
        n8n.Course.MetadataVerifiedAt = DateTime.UtcNow;
        n8n.Course.Prerequisites = ["Conocimientos de Python a nivel básico (requerido)"];

        var result = engine.Recommend(new UserPreference
        {
            Goal = "Aprender a desarrollar aplicaciones web con python",
            Interests = ["JavaScript", "web"]
        },
        [
            Candidate(68, "JavaScript Moderno: Guía para dominar el lenguaje", 0.62,
                fundamentals, javascript),
            django,
            Candidate(41, "Astro: El framework para sitios web", 0.55, frontend),
            fastApi,
            Candidate(21, "Nuxt: El marco de trabajo web progresivo", 0.58, frontend),
            n8n,
            basics
        ]);

        Assert.Equal(HybridSemanticRecommendationEngine.Method, result.Method);
        Assert.Equal(32, result.Courses[0].CourseId);
        Assert.Contains(result.Courses, x => x.CourseId == 30);
        Assert.Contains(result.Courses, x => x.CourseId == 23);
        Assert.DoesNotContain(result.Courses, x => x.CourseId == 68);
        Assert.DoesNotContain(result.Courses, x => x.CourseId == 18);
        Assert.DoesNotContain("Revisa los requisitos publicados: Python",
            result.Courses.Single(x => x.CourseId == 30).Reason);
    }

    [Fact]
    public void BackendGoGoalUsesTheSameCompoundRule()
    {
        var backend = new Category { CategoryId = 1, Name = "Backend" };
        var fundamentals = new Category { CategoryId = 2, Name = "Fundamentos" };
        var automation = new Category { CategoryId = 3, Name = "Automatización" };
        var go = new Tag { TagId = 1, Name = "Go" };
        var python = new Tag { TagId = 2, Name = "Python" };
        var result = engine.Recommend(new UserPreference { Goal = "Aprender backend con Go" },
        [
            Candidate(1, "Go: Fundamentos", 0.55, fundamentals, go),
            Candidate(2, "Go Backend Profesional", 0.65, backend, go),
            Candidate(3, "Automatización con Go", 0.7, automation, go),
            Candidate(4, "Python Backend", 0.6, backend, python)
        ]);

        Assert.Contains(result.Courses, x => x.CourseId == 1);
        Assert.Contains(result.Courses, x => x.CourseId == 2);
        Assert.DoesNotContain(result.Courses, x => x.CourseId == 3);
    }

    [Fact]
    public void ExplicitTechnologyGoalDoesNotFillRouteWithOtherTechnologies()
    {
        var backend = new Category { CategoryId = 1, Name = "Backend" };
        var frontend = new Category { CategoryId = 2, Name = "Frontend" };
        var fundamentals = new Category { CategoryId = 3, Name = "Fundamentos" };
        var python = new Tag { TagId = 1, Name = "Python" };
        var javascript = new Tag { TagId = 2, Name = "JavaScript" };
        var django = Candidate(30, "Django: aplicaciones web con Python", 0.74, backend, python);
        var javascriptCourse = Candidate(68, "JavaScript Moderno", 0.85, fundamentals, javascript);
        javascriptCourse.Course.MetadataVerifiedAt = DateTime.UtcNow;
        javascriptCourse.Course.Prerequisites = ["Conocimientos de Python"];

        var result = engine.Recommend(new UserPreference
        {
            Goal = "Aprender a desarrollar aplicaciones web con python",
            Interests = ["JavaScript", "web"]
        },
        [
            javascriptCourse,
            Candidate(41, "Astro: sitios web", 0.82, frontend),
            Candidate(51, "Node Js", 0.81, backend),
            django,
            Candidate(21, "Nuxt", 0.8, frontend),
            Candidate(55, "Qwik", 0.79, frontend)
        ]);

        Assert.Equal(30, result.Courses[0].CourseId);
        Assert.Contains(result.Courses, x => x.CourseId == 30);
        Assert.DoesNotContain(result.Courses, x => x.CourseId == 68);
        Assert.True(result.Courses.Count <= 2);
    }

    [Fact]
    public void VerifiedRequirementFavorsPreparatoryCourseAndDoesNotBlock()
    {
        var python = new Tag { TagId = 1, Name = "Python" };
        var introduction = Candidate(1, "Introducción a Python", 0.7, tag: python);
        introduction.Course.MetadataVerifiedAt = DateTime.UtcNow;
        introduction.Course.SkillsTaught = ["Python"];
        var advanced = Candidate(2, "APIs con Python", 0.9, tag: python);
        advanced.Course.MetadataVerifiedAt = DateTime.UtcNow;
        advanced.Course.Prerequisites = ["Se requiere conocimiento de Python"];

        var result = engine.Recommend(new UserPreference { Goal = "Aprender APIs" },
            [advanced, introduction]);

        Assert.Equal([1L, 2L], result.Courses.Select(x => x.CourseId));
        Assert.DoesNotContain("Revisa los requisitos", result.Courses[1].Reason);
    }

    [Fact]
    public void NegatedAndInferredRequirementsDoNotCreateDependencies()
    {
        var git = new Tag { TagId = 1, Name = "Git" };
        var course = Candidate(1, "Git desde cero", 0.8, tag: git);
        course.Course.MetadataVerifiedAt = DateTime.UtcNow;
        course.Course.Prerequisites = ["No se necesita conocimiento de Git"];

        var result = engine.Recommend(new UserPreference { Goal = "Aprender Git" }, [course]);

        Assert.DoesNotContain("Revisa los requisitos", result.Courses[0].Reason);
        course.Course.MetadataVerifiedAt = null;
        course.Course.MetadataOrigin = "inferred-seed-v1";
        course.Course.Prerequisites = ["Se requiere conocimiento de Git"];
        result = engine.Recommend(new UserPreference { Goal = "Aprender Git" }, [course]);
        Assert.DoesNotContain("Revisa los requisitos", result.Courses[0].Reason);
    }

    private static SemanticCourseCandidate Candidate(long id, string title, double similarity,
        Category? category = null, Tag? tag = null)
    {
        var course = new Course { CourseId = id, Title = title, Level = "Intermedio" };
        if (category is not null) course.Categories.Add(category);
        if (tag is not null) course.Tags.Add(tag);
        return new(course, similarity);
    }
}
