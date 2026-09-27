using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodeQuest2026.Server.Infrastructure.DataSource.Migrations
{
    /// <inheritdoc />
    public partial class AddCourseCatalogKinds : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string[]>(
                name: "catalog_kinds",
                table: "courses",
                type: "text[]",
                nullable: false,
                defaultValueSql: "ARRAY[]::text[]");

            migrationBuilder.AddCheckConstraint(
                name: "ck_courses_catalog_kinds",
                table: "courses",
                sql: "catalog_kinds <@ ARRAY['course', 'free', 'mini-course', 'pro-exclusive', 'legacy', 'in-development']::text[]");

            migrationBuilder.Sql(SeedSql);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropCheckConstraint(
                name: "ck_courses_catalog_kinds",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "catalog_kinds",
                table: "courses");
        }
    }
}
