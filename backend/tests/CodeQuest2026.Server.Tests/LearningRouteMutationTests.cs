using System.Security.Claims;
using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Application.Routes.Commands;
using CodeQuest2026.Server.Controllers;
using CodeQuest2026.Server.Infrastructure.DataSource.Configurations;
using CodeQuest2026.Server.Infrastructure.DataSource.Context;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Xunit;
using CodeQuest2026.Server.Application.Courses;

namespace CodeQuest2026.Server.Tests;

public sealed class LearningRouteMutationTests : IAsyncLifetime
{
    private readonly SqliteConnection connection = new("Data Source=:memory:");
    private readonly Guid routeId = Guid.NewGuid();
    private ServiceProvider services = null!;
    private IServiceScope scope = null!;
    private AppDbContext Db => scope.ServiceProvider.GetRequiredService<AppDbContext>();

    public async Task InitializeAsync()
    {
        await connection.OpenAsync();
        var options = new DbContextOptionsBuilder<AppDbContext>().UseSqlite(connection).Options;
        var registrations = new ServiceCollection();
        registrations.AddScoped<AppDbContext>(_ => new RouteTestDbContext(options));
        registrations.AddMediatR(options => options.RegisterServicesFromAssemblyContaining<UpdateLearningRouteCommand>());
        services = registrations.BuildServiceProvider();
        scope = services.CreateScope();
        await Db.Database.EnsureCreatedAsync();

        Db.Users.Add(new User { UserId = "owner", DiscordId = "123", Username = "owner" });
        Db.Courses.AddRange(
            new Course
            {
                CourseId = 1,
                Title = "Python",
                CatalogKinds = ["free", "mini-course"],
                Slug = "python",
                Description = "Build reliable data pipelines",
                ImageUrl = "https://example.test/python.png",
                ImageAlt = "Python",
                CourseUrl = "https://example.test/python",
                Categories = [new Category { CategoryId = 1, Name = "Web services", Slug = "web-services" }],
                Tags = [new Tag { TagId = 1, Name = "Django", Slug = "django" }]
            },
            new Course
            {
                CourseId = 2,
                Title = "Backend",
                CatalogKinds = ["pro-exclusive"],
                ImageUrl = "https://example.test/backend.png",
                CourseUrl = "https://example.test/backend"
            },
            new Course { CourseId = 3, Title = "SQL" },
            new Course { CourseId = 4, Title = "Inactive", IsActive = false });
        Db.LearningRoutes.Add(new LearningRoute
        {
            RouteId = routeId,
            UserId = "owner",
            Goal = "Original",
            Explanation = "Original explanation",
            RecommendationMethod = "semantic-groq-v2",
            PreferencesSnapshot = "{\"goal\":\"Original\"}",
            CreatedAt = DateTimeOffset.Parse("2026-01-01T00:00:00Z"),
            Courses = [
                new() { CourseId = 1, Position = 1, Reason = "First" },
                new() { CourseId = 2, Position = 2, Reason = "Second" }
            ]
        });
        await Db.SaveChangesAsync();
        Db.ChangeTracker.Clear();
    }

    [Fact]
    public async Task ManualRouteUsesProvidedGoalAndCourseOrder()
    {
        var response = await Controller("owner").Save(new SaveLearningRouteRequest
        {
            Goal = " Backend desde cero ",
            RecommendationMethod = "manual-v1",
            Explanation = " Ruta elegida manualmente ",
            Courses =
            [
                new() { CourseId = 2 },
                new() { CourseId = 1 }
            ]
        }, default);

        var route = Assert.IsType<LearningRouteDto>(Assert.IsType<CreatedAtActionResult>(response.Result).Value);
        Assert.Equal("Backend desde cero", route.Goal);
        Assert.Equal("manual-v1", route.RecommendationMethod);
        Assert.Equal(new long[] { 2, 1 }, route.Courses.Select(course => course.CourseId));
        Assert.Equal(new[] { "pro-exclusive" }, route.Courses[0].CatalogKinds);
        Assert.Equal(new[] { "free", "mini-course" }, route.Courses[1].CatalogKinds);
    }

    [Fact]
    public async Task UpdateSwapsPositionsAndPreservesProvenance()
    {
        var response = await Controller("owner").Update(routeId, Request(2, 1), default);
        var route = Assert.IsType<LearningRouteDto>(Assert.IsType<OkObjectResult>(response.Result).Value);
        Assert.Equal(new long[] { 2, 1 }, route.Courses.Select(course => course.CourseId));
        Assert.Equal(new[] { 1, 2 }, route.Courses.Select(course => course.Position));
        Assert.Equal("Updated", route.Goal);
        Assert.Equal("Updated explanation", route.Explanation);
        Assert.Equal("Updated reason", route.Courses[0].Reason);
        Assert.Equal("semantic-groq-v2", route.RecommendationMethod);
        Assert.Equal("https://example.test/backend.png", route.Courses[0].ImageUrl);
        Assert.Equal("https://example.test/backend", route.Courses[0].CourseUrl);
        Assert.Equal(new[] { "pro-exclusive" }, route.Courses[0].CatalogKinds);

        var stored = await Db.LearningRoutes.AsNoTracking().Include(route => route.Courses).SingleAsync();
        Assert.Equal("{\"goal\":\"Original\"}", stored.PreferencesSnapshot);
        Assert.Equal(DateTimeOffset.Parse("2026-01-01T00:00:00Z"), stored.CreatedAt);
        Assert.Equal(2, stored.Courses.Single(course => course.Position == 1).CourseId);
    }

    [Fact]
    public async Task ProgressPersistsAndSurvivesReorderingWhileNewCoursesStartAtZero()
    {
        var response = await Controller("owner").UpdateCourseProgress(routeId, 1,
            new() { ProgressPercentage = 65 }, default);
        var updated = Assert.IsType<LearningRouteDto>(Assert.IsType<OkObjectResult>(response.Result).Value);
        Assert.Equal(65, updated.Courses.Single(course => course.CourseId == 1).ProgressPercentage);
        Assert.Equal(32.5m, updated.ProgressPercentage);

        var edited = await Controller("owner").Update(routeId, Request(2, 1, 3), default);
        var route = Assert.IsType<LearningRouteDto>(Assert.IsType<OkObjectResult>(edited.Result).Value);
        Assert.Equal(new[] { 0, 65, 0 }, route.Courses.Select(course => course.ProgressPercentage));
        Assert.Equal(21.67m, route.ProgressPercentage);
        var detail = Assert.IsType<LearningRouteDto>(
            Assert.IsType<OkObjectResult>((await Controller("owner").GetById(routeId, default)).Result).Value);
        Assert.Equal(65, detail.Courses.Single(course => course.CourseId == 1).ProgressPercentage);
        Assert.Equal(21.67m, detail.ProgressPercentage);
        var routes = Assert.IsAssignableFrom<IReadOnlyList<LearningRouteDto>>(
            Assert.IsType<OkObjectResult>((await Controller("owner").List(default)).Result).Value);
        Assert.Equal(65, Assert.Single(routes).Courses.Single(course => course.CourseId == 1).ProgressPercentage);
        Assert.Equal(21.67m, Assert.Single(routes).ProgressPercentage);
        var json = System.Text.Json.JsonSerializer.SerializeToElement(detail,
            new System.Text.Json.JsonSerializerOptions(System.Text.Json.JsonSerializerDefaults.Web));
        Assert.Equal(21.67m, json.GetProperty("progressPercentage").GetDecimal());
    }

    [Theory]
    [InlineData(0)]
    [InlineData(100)]
    public async Task RouteProgressReflectsAllCoursesAndCourseRemoval(int progress)
    {
        foreach (var courseId in new long[] { 1, 2 })
            await Controller("owner").UpdateCourseProgress(routeId, courseId,
                new() { ProgressPercentage = progress }, default);

        var detail = Assert.IsType<LearningRouteDto>(
            Assert.IsType<OkObjectResult>((await Controller("owner").GetById(routeId, default)).Result).Value);
        Assert.Equal((decimal)progress, detail.ProgressPercentage);

        var edited = await Controller("owner").Update(routeId, Request(2, 3), default);
        var route = Assert.IsType<LearningRouteDto>(Assert.IsType<OkObjectResult>(edited.Result).Value);
        Assert.Equal(progress / 2m, route.ProgressPercentage);
    }

    [Theory]
    [InlineData(-1)]
    [InlineData(101)]
    [InlineData(null)]
    public async Task InvalidProgressDoesNotChangeStoredValue(int? progress)
    {
        Assert.IsType<BadRequestObjectResult>((await Controller("owner").UpdateCourseProgress(
            routeId, 1, new() { ProgressPercentage = progress }, default)).Result);
        Assert.All(await Db.LearningRouteCourses.AsNoTracking().ToListAsync(), course => Assert.Equal(0, course.ProgressPercentage));
    }

    [Fact]
    public async Task ProgressRequiresOwnerAndCourseMembership()
    {
        var request = new UpdateCourseProgressRequest { ProgressPercentage = 100 };
        Assert.IsType<UnauthorizedObjectResult>((await Controller(null).UpdateCourseProgress(routeId, 1, request, default)).Result);
        Assert.IsType<NotFoundObjectResult>((await Controller("456").UpdateCourseProgress(routeId, 1, request, default)).Result);
        Assert.IsType<NotFoundObjectResult>((await Controller("owner").UpdateCourseProgress(Guid.NewGuid(), 1, request, default)).Result);
        Assert.IsType<NotFoundObjectResult>((await Controller("owner").UpdateCourseProgress(routeId, 3, request, default)).Result);
        Assert.All(await Db.LearningRouteCourses.AsNoTracking().ToListAsync(), course => Assert.Equal(0, course.ProgressPercentage));
    }

    [Fact]
    public async Task ProgressCanCompleteAndResetInactiveSavedCourseWithoutAffectingOtherRoutes()
    {
        var otherRouteId = Guid.NewGuid();
        Db.LearningRoutes.Add(new LearningRoute
        {
            RouteId = otherRouteId, UserId = "owner", Goal = "Other", RecommendationMethod = "test",
            PreferencesSnapshot = "{}", Courses = [new() { CourseId = 1, Position = 1 }]
        });
        await Db.SaveChangesAsync();
        Db.ChangeTracker.Clear();
        await Db.Courses.Where(course => course.CourseId == 1).ExecuteUpdateAsync(setters => setters.SetProperty(course => course.IsActive, false));
        foreach (var progress in new[] { 100, 100, 0 })
        {
            Assert.IsType<OkObjectResult>((await Controller("owner").UpdateCourseProgress(
                routeId, 1, new() { ProgressPercentage = progress }, default)).Result);
            Assert.Equal(progress, (await Db.LearningRouteCourses.AsNoTracking().SingleAsync(course => course.RouteId == routeId && course.CourseId == 1)).ProgressPercentage);
            Assert.Equal(0, (await Db.LearningRouteCourses.AsNoTracking().SingleAsync(course => course.RouteId == otherRouteId)).ProgressPercentage);
        }
    }

    [Fact]
    public async Task UpdateAddsRemovesCoursesAndCanClearExplanation()
    {
        var request = Request(3);
        request.Explanation = null;
        var response = await Controller("owner").Update(routeId, request, default);
        Assert.IsType<OkObjectResult>(response.Result);
        Assert.Equal(3, (await Db.LearningRouteCourses.SingleAsync()).CourseId);
        Assert.Null((await Db.LearningRoutes.AsNoTracking().SingleAsync()).Explanation);
        Assert.Equal(4, await Db.Courses.CountAsync());
    }

    [Theory]
    [InlineData(4)]
    [InlineData(999)]
    public async Task UpdateRejectsUnavailableCoursesWithoutChangingRoute(long id)
    {
        var response = await Controller("owner").Update(routeId, Request(id), default);
        Assert.IsType<BadRequestObjectResult>(response.Result);
        await AssertOriginal();
    }

    [Theory]
    [InlineData("duplicate")]
    [InlineData("empty")]
    [InlineData("too_many")]
    [InlineData("null_courses")]
    [InlineData("null_course")]
    [InlineData("goal")]
    [InlineData("reason")]
    [InlineData("explanation")]
    public async Task UpdateRejectsInvalidContent(string scenario)
    {
        var request = Request(1, 2);
        switch (scenario)
        {
            case "duplicate": request = Request(1, 1); break;
            case "empty": request.Courses = []; break;
            case "too_many": request = Request(Enumerable.Range(1, 31).Select(id => (long)id).ToArray()); break;
            case "null_courses": request.Courses = null!; break;
            case "null_course": request.Courses = [null!]; break;
            case "goal": request.Goal = " "; break;
            case "reason": request.Courses[0].Reason = new string('x', 1001); break;
            case "explanation": request.Explanation = new string('x', 4001); break;
        }

        var response = await Controller("owner").Update(routeId, request, default);
        Assert.IsType<BadRequestObjectResult>(response.Result);
        await AssertOriginal();
    }

    [Fact]
    public async Task DeleteRemovesRouteAndAssociationsButKeepsCatalog()
    {
        Assert.IsType<NoContentResult>(await Controller("owner").Delete(routeId, default));
        Assert.Equal(0, await Db.LearningRoutes.CountAsync());
        Assert.Equal(0, await Db.LearningRouteCourses.CountAsync());
        Assert.Equal(4, await Db.Courses.CountAsync());
        Assert.IsType<NotFoundObjectResult>(await Controller("owner").Delete(routeId, default));
    }

    [Fact]
    public async Task OtherUsersAndMissingRoutesReturnNotFound()
    {
        Assert.IsType<NotFoundObjectResult>(await Controller("456").Delete(routeId, default));
        Assert.IsType<NotFoundObjectResult>((await Controller("456").Update(routeId, Request(3), default)).Result);
        Assert.IsType<NotFoundObjectResult>(await Controller("owner").Delete(Guid.NewGuid(), default));
        Assert.IsType<NotFoundObjectResult>((await Controller("owner").Update(Guid.NewGuid(), Request(3), default)).Result);
        await AssertOriginal();
    }

    [Fact]
    public async Task MissingIdentityReturnsUnauthorized()
    {
        Assert.IsType<UnauthorizedObjectResult>(await Controller(null).Delete(routeId, default));
        Assert.IsType<UnauthorizedObjectResult>((await Controller(null).Update(routeId, Request(3), default)).Result);
        await AssertOriginal();
    }

    [Fact]
    public async Task FailedInsertionRollsBackGoalAndDeletedAssociations()
    {
        await Db.Database.ExecuteSqlRawAsync("""
            CREATE TRIGGER reject_new_course BEFORE INSERT ON learning_route_courses
            WHEN NEW.course_id = 3 BEGIN SELECT RAISE(ABORT, 'test failure'); END;
            """);

        await Assert.ThrowsAsync<DbUpdateException>(() => Controller("owner").Update(routeId, Request(3), default));
        await AssertOriginal();
    }

    private async Task AssertOriginal()
    {
        var route = await Db.LearningRoutes.AsNoTracking().Include(route => route.Courses).SingleAsync();
        Assert.Equal("Original", route.Goal);
        Assert.Equal("Original explanation", route.Explanation);
        Assert.Equal(new long[] { 1, 2 }, route.Courses.OrderBy(course => course.Position).Select(course => course.CourseId));
    }

    [Fact]
    public async Task CatalogPaginatesOnlyActiveCoursesInTitleOrderWithoutMetadata()
    {
        var controller = new CoursesController(scope.ServiceProvider.GetRequiredService<ISender>());
        var response = await controller.List(1, 2, default);
        var page = Assert.IsType<PagedResultDto<CourseDto>>(
            Assert.IsType<OkObjectResult>(response.Result).Value);
        var courses = page.Items;

        Assert.Equal(new long[] { 2, 1 }, courses.Select(course => course.CourseId));
        Assert.Equal(3, page.TotalCount);
        Assert.Equal(2, page.TotalPages);
        Assert.False(page.HasPreviousPage);
        Assert.True(page.HasNextPage);
        Assert.Equal("python", courses[1].Slug);
        Assert.Equal("https://example.test/python.png", courses[1].ImageUrl);
        Assert.Equal("https://example.test/python", courses[1].CourseUrl);
        Assert.Equal(new[] { "free", "mini-course" }, courses[1].CatalogKinds);

        var json = System.Text.Json.JsonSerializer.SerializeToElement(courses[1]);
        Assert.Equal(
            new[] { "CourseId", "Slug", "Title", "Level", "ImageUrl", "ImageAlt", "CourseUrl", "CatalogKinds" },
            json.EnumerateObject().Select(property => property.Name));
    }

    [Fact]
    public async Task CatalogReturnsRequestedPage()
    {
        var controller = new CoursesController(scope.ServiceProvider.GetRequiredService<ISender>());
        var response = await controller.List(2, 2, default);
        var page = Assert.IsType<PagedResultDto<CourseDto>>(
            Assert.IsType<OkObjectResult>(response.Result).Value);

        Assert.Equal(new long[] { 3 }, page.Items.Select(course => course.CourseId));
        Assert.True(page.HasPreviousPage);
        Assert.False(page.HasNextPage);
    }

    [Theory]
    [InlineData("Python")]
    [InlineData("yth")]
    [InlineData("PYTHON")]
    [InlineData("  Python  ")]
    public async Task CatalogSearchMatchesCompletePartialCaseInsensitiveAndTrimmedTitles(string search)
    {
        var page = await Catalog(search);

        Assert.Equal(new long[] { 1 }, page.Items.Select(course => course.CourseId));
        Assert.Equal(1, page.TotalCount);
        Assert.Equal(1, page.TotalPages);
    }

    [Theory]
    [InlineData("pipelines")]
    [InlineData("web services")]
    [InlineData("django")]
    public async Task CatalogSearchMatchesDescriptionCategoryAndTag(string search)
    {
        var page = await Catalog(search);

        Assert.Equal(new long[] { 1 }, page.Items.Select(course => course.CourseId));
        Assert.Equal(1, page.TotalCount);
    }

    [Fact]
    public async Task CatalogSearchTreatsWhitespaceAsNoSearch()
    {
        var page = await Catalog("   ");

        Assert.Equal(3, page.TotalCount);
        Assert.Equal(new long[] { 2, 1, 3 }, page.Items.Select(course => course.CourseId));
    }

    [Fact]
    public async Task CatalogSearchReturnsCoherentEmptyPageWhenNothingMatches()
    {
        var page = await Catalog("does-not-exist");

        Assert.Empty(page.Items);
        Assert.Equal(0, page.TotalCount);
        Assert.Equal(0, page.TotalPages);
        Assert.False(page.HasPreviousPage);
        Assert.False(page.HasNextPage);
    }

    [Fact]
    public async Task CatalogSearchPaginatesTheFilteredSet()
    {
        var courses = await Db.Courses.Where(course => course.IsActive).ToListAsync();
        foreach (var course in courses) course.Title += " Course";
        await Db.SaveChangesAsync();
        Db.ChangeTracker.Clear();

        var page = await Catalog("course", page: 2, pageSize: 2);

        Assert.Equal(new long[] { 3 }, page.Items.Select(course => course.CourseId));
        Assert.Equal(3, page.TotalCount);
        Assert.Equal(2, page.TotalPages);
        Assert.True(page.HasPreviousPage);
        Assert.False(page.HasNextPage);
    }

    [Fact]
    public void CatalogAllowsAnonymousAccess()
    {
        var attributes = typeof(CoursesController).GetCustomAttributes(false);

        Assert.Contains(attributes, attribute => attribute is AllowAnonymousAttribute);
        Assert.DoesNotContain(attributes, attribute => attribute is AuthorizeAttribute);
    }

    [Theory]
    [InlineData(4)]
    [InlineData(999)]
    public async Task CatalogDetailHidesInactiveAndUnknownCourses(long id)
    {
        var controller = new CoursesController(scope.ServiceProvider.GetRequiredService<ISender>());
        Assert.IsType<NotFoundObjectResult>((await controller.GetById(id, default)).Result);
    }

    [Fact]
    public async Task CatalogDetailReturnsBasicCourse()
    {
        var controller = new CoursesController(scope.ServiceProvider.GetRequiredService<ISender>());
        var response = await controller.GetById(1, default);
        var course = Assert.IsType<CourseDto>(Assert.IsType<OkObjectResult>(response.Result).Value);

        Assert.Equal("Python", course.Title);
        Assert.Equal("https://example.test/python", course.CourseUrl);
    }

    [Fact]
    public async Task CatalogReturnsEmptyListWhenNoCoursesAreActive()
    {
        await Db.Courses.ExecuteUpdateAsync(setters => setters.SetProperty(course => course.IsActive, false));
        var controller = new CoursesController(scope.ServiceProvider.GetRequiredService<ISender>());
        var response = await controller.List(cancellationToken: default);
        var page = Assert.IsType<PagedResultDto<CourseDto>>(
            Assert.IsType<OkObjectResult>(response.Result).Value);
        var courses = page.Items;

        Assert.Empty(courses);
        Assert.Equal(0, page.TotalCount);
        Assert.Equal(0, page.TotalPages);
        Assert.False(page.HasPreviousPage);
        Assert.False(page.HasNextPage);
    }

    [Fact]
    public async Task RouteDetailAndListIncludeLinksEvenForPreviouslySavedInactiveCourses()
    {
        await Db.Courses.Where(course => course.CourseId == 1)
            .ExecuteUpdateAsync(setters => setters.SetProperty(course => course.IsActive, false));

        var controller = Controller("owner");
        var detail = Assert.IsType<LearningRouteDto>(
            Assert.IsType<OkObjectResult>((await controller.GetById(routeId, default)).Result).Value);
        var routes = Assert.IsAssignableFrom<IReadOnlyList<LearningRouteDto>>(
            Assert.IsType<OkObjectResult>((await controller.List(default)).Result).Value);

        foreach (var route in new[] { detail, Assert.Single(routes) })
        {
            Assert.Equal(new long[] { 1, 2 }, route.Courses.Select(course => course.CourseId));
            Assert.Equal("https://example.test/python.png", route.Courses[0].ImageUrl);
            Assert.Equal("https://example.test/python", route.Courses[0].CourseUrl);
        }

        Assert.IsType<NotFoundObjectResult>((await Controller("456").GetById(routeId, default)).Result);
    }

    private static UpdateLearningRouteRequest Request(params long[] ids) => new()
    {
        Goal = " Updated ",
        Explanation = " Updated explanation ",
        Courses = ids.Select(id => new SaveRouteCourseRequest { CourseId = id, Reason = " Updated reason " }).ToList()
    };

    private async Task<PagedResultDto<CourseDto>> Catalog(string? search, int page = 1, int pageSize = 20)
    {
        var controller = new CoursesController(scope.ServiceProvider.GetRequiredService<ISender>());
        var response = await controller.List(page, pageSize, search, default);
        return Assert.IsType<PagedResultDto<CourseDto>>(
            Assert.IsType<OkObjectResult>(response.Result).Value);
    }

    private RoutesController Controller(string? discordId)
    {
        var context = new DefaultHttpContext();
        if (discordId is not null)
        {
            context.User = new ClaimsPrincipal(new ClaimsIdentity(
                [new Claim(CodeQuest2026.Server.Application.Oauth2.SessionIdentity.UserIdClaim, discordId)], "test"));
        }

        return new RoutesController(scope.ServiceProvider.GetRequiredService<ISender>())
        {
            ControllerContext = new ControllerContext { HttpContext = context }
        };
    }

    public async Task DisposeAsync()
    {
        scope.Dispose();
        await services.DisposeAsync();
        await connection.DisposeAsync();
    }

    private sealed class RouteTestDbContext(DbContextOptions<AppDbContext> options) : AppDbContext(options)
    {
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Ignore<UserPreference>();
            modelBuilder.Ignore<CourseEmbedding>();
            new UserConfiguration().Configure(modelBuilder.Entity<User>());
            new UserExternalLoginConfiguration().Configure(modelBuilder.Entity<UserExternalLogin>());
            modelBuilder.Entity<User>().Ignore(user => user.Preferences);
            new LearningRouteConfiguration().Configure(modelBuilder.Entity<LearningRoute>());
            modelBuilder.Entity<LearningRoute>().Property(route => route.CreatedAt)
                .HasConversion(value => value.UtcTicks, value => new DateTimeOffset(value, TimeSpan.Zero));
            new LearningRouteCourseConfiguration().Configure(modelBuilder.Entity<LearningRouteCourse>());

            var course = modelBuilder.Entity<Course>();
            foreach (var property in typeof(Course).GetProperties())
            {
                if (property.Name is not (
                    nameof(Course.CourseId) or nameof(Course.Title) or nameof(Course.IsActive)
                    or nameof(Course.Slug) or nameof(Course.Level) or nameof(Course.ImageUrl)
                    or nameof(Course.ImageAlt) or nameof(Course.CourseUrl) or nameof(Course.Description)
                    or nameof(Course.CatalogKinds)
                    or nameof(Course.Categories) or nameof(Course.Tags)))
                {
                    course.Ignore(property.Name);
                }
            }
            course.HasKey(course => course.CourseId);
            course.Property(course => course.CourseId).ValueGeneratedNever();
            course.Property(course => course.CatalogKinds).HasConversion(
                value => System.Text.Json.JsonSerializer.Serialize(value, (System.Text.Json.JsonSerializerOptions?)null),
                value => System.Text.Json.JsonSerializer.Deserialize<string[]>(value, (System.Text.Json.JsonSerializerOptions?)null)!);
            var category = modelBuilder.Entity<Category>();
            category.HasKey(item => item.CategoryId);
            category.Property(item => item.CategoryId).ValueGeneratedNever();
            category.Ignore(item => item.Slug);
            var tag = modelBuilder.Entity<Tag>();
            tag.HasKey(item => item.TagId);
            tag.Property(item => item.TagId).ValueGeneratedNever();
            tag.Ignore(item => item.Slug);
            course.HasMany(item => item.Categories).WithMany(item => item.Courses);
            course.HasMany(item => item.Tags).WithMany(item => item.Courses);
        }
    }
}
