using Microsoft.EntityFrameworkCore;
using CodeQuest2026.Server.Infrastructure.DataSource.Entities;

namespace CodeQuest2026.Server.Infrastructure.DataSource.Context;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Course> Courses => Set<Course>();
    public DbSet<User> Users => Set<User>();
    public DbSet<UserPreference> UserPreferences => Set<UserPreference>();
    public DbSet<LearningRoute> LearningRoutes => Set<LearningRoute>();
    public DbSet<LearningRouteCourse> LearningRouteCourses => Set<LearningRouteCourse>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Tag> Tags => Set<Tag>();
    public DbSet<CourseEmbedding> CourseEmbeddings => Set<CourseEmbedding>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.HasPostgresExtension("vector");
        modelBuilder.HasPostgresExtension("pg_trgm");
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }
}
