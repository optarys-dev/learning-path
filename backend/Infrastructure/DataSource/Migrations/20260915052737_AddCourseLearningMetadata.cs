using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodeQuest2026.Server.Infrastructure.DataSource.Migrations
{
    /// <inheritdoc />
    public partial class AddCourseLearningMetadata : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "description",
                table: "courses",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "duration_minutes",
                table: "courses",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "language",
                table: "courses",
                type: "character varying(35)",
                maxLength: 35,
                nullable: true);

            migrationBuilder.AddColumn<string[]>(
                name: "learning_outcomes",
                table: "courses",
                type: "text[]",
                nullable: false,
                defaultValueSql: "ARRAY[]::text[]");

            migrationBuilder.AddColumn<string>(
                name: "metadata_source_url",
                table: "courses",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "metadata_verified_at",
                table: "courses",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string[]>(
                name: "prerequisites",
                table: "courses",
                type: "text[]",
                nullable: false,
                defaultValueSql: "ARRAY[]::text[]");

            migrationBuilder.AddColumn<string[]>(
                name: "skills_taught",
                table: "courses",
                type: "text[]",
                nullable: false,
                defaultValueSql: "ARRAY[]::text[]");

            migrationBuilder.AddColumn<string>(
                name: "syllabus",
                table: "courses",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string[]>(
                name: "target_audience",
                table: "courses",
                type: "text[]",
                nullable: false,
                defaultValueSql: "ARRAY[]::text[]");

            migrationBuilder.AddCheckConstraint(
                name: "ck_courses_duration_minutes",
                table: "courses",
                sql: "duration_minutes IS NULL OR duration_minutes > 0");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropCheckConstraint(
                name: "ck_courses_duration_minutes",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "description",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "duration_minutes",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "language",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "learning_outcomes",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "metadata_source_url",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "metadata_verified_at",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "prerequisites",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "skills_taught",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "syllabus",
                table: "courses");

            migrationBuilder.DropColumn(
                name: "target_audience",
                table: "courses");
        }
    }
}
