using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Pgvector;

#nullable disable

namespace CodeQuest2026.Server.Infrastructure.DataSource.Migrations
{
    /// <inheritdoc />
    public partial class AddCourseEmbeddings : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterDatabase()
                .Annotation("Npgsql:PostgresExtension:pg_trgm", ",,")
                .Annotation("Npgsql:PostgresExtension:vector", ",,")
                .OldAnnotation("Npgsql:PostgresExtension:pg_trgm", ",,");

            migrationBuilder.CreateTable(
                name: "course_embeddings",
                columns: table => new
                {
                    course_id = table.Column<long>(type: "bigint", nullable: false),
                    embedding = table.Column<Vector>(type: "vector", nullable: false),
                    model = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    dimensions = table.Column<int>(type: "integer", nullable: false),
                    content_hash = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: false),
                    generated_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "NOW()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("course_embeddings_pkey", x => x.course_id);
                    table.CheckConstraint("ck_course_embeddings_content_hash", "content_hash ~ '^[0-9a-f]{64}$'");
                    table.CheckConstraint("ck_course_embeddings_dimensions", "dimensions > 0 AND vector_dims(embedding) = dimensions");
                    table.CheckConstraint("ck_course_embeddings_model", "length(btrim(model)) > 0");
                    table.CheckConstraint("ck_course_embeddings_nonzero", "(embedding <#> embedding) < 0");
                    table.ForeignKey(
                        name: "FK_course_embeddings_courses_course_id",
                        column: x => x.course_id,
                        principalTable: "courses",
                        principalColumn: "course_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_course_embeddings_model_dimensions",
                table: "course_embeddings",
                columns: new[] { "model", "dimensions" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "course_embeddings");

            migrationBuilder.AlterDatabase()
                .Annotation("Npgsql:PostgresExtension:pg_trgm", ",,")
                .OldAnnotation("Npgsql:PostgresExtension:pg_trgm", ",,")
                .OldAnnotation("Npgsql:PostgresExtension:vector", ",,");
        }
    }
}
