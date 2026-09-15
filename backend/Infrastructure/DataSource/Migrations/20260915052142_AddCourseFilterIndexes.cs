using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodeQuest2026.Server.Infrastructure.DataSource.Migrations
{
    /// <inheritdoc />
    public partial class AddCourseFilterIndexes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_course_tags_tag_id",
                table: "course_tags");

            migrationBuilder.DropIndex(
                name: "ix_course_categories_category_id",
                table: "course_categories");

            migrationBuilder.AlterDatabase()
                .Annotation("Npgsql:PostgresExtension:pg_trgm", ",,");

            migrationBuilder.CreateIndex(
                name: "ix_courses_is_active_level",
                table: "courses",
                columns: new[] { "is_active", "level" });

            migrationBuilder.CreateIndex(
                name: "ix_courses_title_trgm",
                table: "courses",
                column: "title")
                .Annotation("Npgsql:IndexMethod", "gin")
                .Annotation("Npgsql:IndexOperators", new[] { "gin_trgm_ops" });

            migrationBuilder.CreateIndex(
                name: "ix_course_tags_tag_id_course_id",
                table: "course_tags",
                columns: new[] { "tag_id", "course_id" });

            migrationBuilder.CreateIndex(
                name: "ix_course_categories_category_id_course_id",
                table: "course_categories",
                columns: new[] { "category_id", "course_id" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_courses_is_active_level",
                table: "courses");

            migrationBuilder.DropIndex(
                name: "ix_courses_title_trgm",
                table: "courses");

            migrationBuilder.DropIndex(
                name: "ix_course_tags_tag_id_course_id",
                table: "course_tags");

            migrationBuilder.DropIndex(
                name: "ix_course_categories_category_id_course_id",
                table: "course_categories");

            migrationBuilder.AlterDatabase()
                .OldAnnotation("Npgsql:PostgresExtension:pg_trgm", ",,");

            migrationBuilder.CreateIndex(
                name: "ix_course_tags_tag_id",
                table: "course_tags",
                column: "tag_id");

            migrationBuilder.CreateIndex(
                name: "ix_course_categories_category_id",
                table: "course_categories",
                column: "category_id");
        }
    }
}
