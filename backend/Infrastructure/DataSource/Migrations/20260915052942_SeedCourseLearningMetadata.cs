using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodeQuest2026.Server.Infrastructure.DataSource.Migrations
{
    /// <inheritdoc />
    public partial class SeedCourseLearningMetadata : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "metadata_origin",
                table: "courses",
                type: "character varying(40)",
                maxLength: 40,
                nullable: true);

            SeedMetadata(migrationBuilder);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            RemoveSeedMetadata(migrationBuilder);

            migrationBuilder.DropColumn(
                name: "metadata_origin",
                table: "courses");
        }
    }
}
