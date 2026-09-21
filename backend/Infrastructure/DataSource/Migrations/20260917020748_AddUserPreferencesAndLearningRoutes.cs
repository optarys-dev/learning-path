using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodeQuest2026.Server.Infrastructure.DataSource.Migrations
{
    /// <inheritdoc />
    public partial class AddUserPreferencesAndLearningRoutes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "learning_routes",
                columns: table => new
                {
                    route_id = table.Column<Guid>(type: "uuid", nullable: false),
                    user_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    goal = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                    recommendation_method = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: false),
                    explanation = table.Column<string>(type: "character varying(4000)", maxLength: 4000, nullable: true),
                    preferences_snapshot = table.Column<string>(type: "jsonb", nullable: false),
                    created_at = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_learning_routes", x => x.route_id);
                    table.ForeignKey(
                        name: "FK_learning_routes_users_user_id",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "user_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "user_preferences",
                columns: table => new
                {
                    user_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    goal = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                    experience_level = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: true),
                    interests = table.Column<string[]>(type: "text[]", nullable: false),
                    existing_skills = table.Column<string[]>(type: "text[]", nullable: false),
                    preferred_language = table.Column<string>(type: "character varying(35)", maxLength: 35, nullable: true),
                    minutes_per_week = table.Column<int>(type: "integer", nullable: true),
                    updated_at = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_preferences", x => x.user_id);
                    table.CheckConstraint("ck_user_preferences_minutes_per_week", "minutes_per_week IS NULL OR minutes_per_week > 0");
                    table.ForeignKey(
                        name: "FK_user_preferences_users_user_id",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "user_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "learning_route_courses",
                columns: table => new
                {
                    route_id = table.Column<Guid>(type: "uuid", nullable: false),
                    course_id = table.Column<long>(type: "bigint", nullable: false),
                    position = table.Column<int>(type: "integer", nullable: false),
                    reason = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_learning_route_courses", x => new { x.route_id, x.course_id });
                    table.CheckConstraint("ck_learning_route_courses_position", "position > 0");
                    table.ForeignKey(
                        name: "FK_learning_route_courses_courses_course_id",
                        column: x => x.course_id,
                        principalTable: "courses",
                        principalColumn: "course_id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_learning_route_courses_learning_routes_route_id",
                        column: x => x.route_id,
                        principalTable: "learning_routes",
                        principalColumn: "route_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_learning_route_courses_course_id",
                table: "learning_route_courses",
                column: "course_id");

            migrationBuilder.CreateIndex(
                name: "IX_learning_route_courses_route_id_position",
                table: "learning_route_courses",
                columns: new[] { "route_id", "position" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_learning_routes_user_id_created_at",
                table: "learning_routes",
                columns: new[] { "user_id", "created_at" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "learning_route_courses");

            migrationBuilder.DropTable(
                name: "user_preferences");

            migrationBuilder.DropTable(
                name: "learning_routes");
        }
    }
}
