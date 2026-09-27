START TRANSACTION;
ALTER TABLE users ALTER COLUMN discord_id DROP NOT NULL;

ALTER TABLE users ALTER COLUMN avatar TYPE character varying(2048);

CREATE TABLE user_external_logins (
    provider character varying(20) NOT NULL,
    provider_user_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL,
    CONSTRAINT "PK_user_external_logins" PRIMARY KEY (provider, provider_user_id),
    CONSTRAINT "FK_user_external_logins_users_user_id" FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX "IX_user_external_logins_user_id_provider" ON user_external_logins (user_id, provider);

INSERT INTO user_external_logins (provider, provider_user_id, user_id)
SELECT 'Discord', discord_id, user_id FROM users WHERE discord_id IS NOT NULL;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260926043325_AddExternalAuthentication', '10.0.12');

COMMIT;
