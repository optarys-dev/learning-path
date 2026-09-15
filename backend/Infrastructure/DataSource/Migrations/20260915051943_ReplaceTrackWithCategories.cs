using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodeQuest2026.Server.Infrastructure.DataSource.Migrations
{
    /// <inheritdoc />
    public partial class ReplaceTrackWithCategories : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Preserve tracks for every existing course, including courses outside the seed.
            migrationBuilder.Sql(
                """
                INSERT INTO categories (slug, name) VALUES
                    ('fundamentos', 'Fundamentos'),
                    ('frontend', 'Frontend'),
                    ('backend', 'Backend'),
                    ('csharp', 'C# y .NET'),
                    ('datos', 'Datos'),
                    ('ia', 'Inteligencia artificial'),
                    ('movil', 'Desarrollo móvil'),
                    ('herramientas', 'Herramientas'),
                    ('automatizacion', 'Automatización')
                ON CONFLICT (slug) DO NOTHING;

                INSERT INTO course_categories (course_id, category_id)
                SELECT course.course_id, category.category_id
                FROM courses AS course
                JOIN categories AS category ON category.slug = lower(course.track)
                ON CONFLICT (course_id, category_id) DO NOTHING;
                """);

            migrationBuilder.DropIndex(
                name: "ix_courses_track_active",
                table: "courses");

            migrationBuilder.DropCheckConstraint(
                name: "ck_courses_track",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "track",
                table: "courses");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Multiple categories cannot reconstruct the original single track reliably.
            throw new System.NotSupportedException(
                "ReplaceTrackWithCategories cannot be reverted automatically: the original Track cannot be recovered from multiple categories. Restore a database backup to recover it.");
        }
    }
}
