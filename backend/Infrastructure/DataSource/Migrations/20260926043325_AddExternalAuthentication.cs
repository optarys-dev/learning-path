using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodeQuest2026.Server.Infrastructure.DataSource.Migrations
{
    /// <inheritdoc />
    public partial class AddExternalAuthentication : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "discord_id",
                table: "users",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(20)",
                oldMaxLength: 20);

            migrationBuilder.AlterColumn<string>(
                name: "avatar",
                table: "users",
                type: "character varying(2048)",
                maxLength: 2048,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(128)",
                oldMaxLength: 128,
                oldNullable: true);

            migrationBuilder.CreateTable(
                name: "user_external_logins",
                columns: table => new
                {
                    provider = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    provider_user_id = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    user_id = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_external_logins", x => new { x.provider, x.provider_user_id });
                    table.ForeignKey(
                        name: "FK_user_external_logins_users_user_id",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "user_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_user_external_logins_user_id_provider",
                table: "user_external_logins",
                columns: new[] { "user_id", "provider" },
                unique: true);
            migrationBuilder.Sql("""
                INSERT INTO user_external_logins (provider, provider_user_id, user_id)
                SELECT 'Discord', discord_id, user_id FROM users WHERE discord_id IS NOT NULL;
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("""
                DO $$ BEGIN
                    IF EXISTS (SELECT 1 FROM users WHERE discord_id IS NULL OR length(avatar) > 128) THEN
                        RAISE EXCEPTION 'Cannot roll back external authentication while Google users or long avatars exist. Preserve these accounts and use a forward migration.';
                    END IF;
                END $$;
                """);
            migrationBuilder.DropTable(
                name: "user_external_logins");

            migrationBuilder.AlterColumn<string>(
                name: "discord_id",
                table: "users",
                type: "character varying(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "character varying(20)",
                oldMaxLength: 20,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "avatar",
                table: "users",
                type: "character varying(128)",
                maxLength: 128,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(2048)",
                oldMaxLength: 2048,
                oldNullable: true);
        }
    }
}
