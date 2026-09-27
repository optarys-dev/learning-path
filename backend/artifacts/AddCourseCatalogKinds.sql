START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260927044619_AddCourseCatalogKinds') THEN
    ALTER TABLE courses ADD catalog_kinds text[] NOT NULL DEFAULT (ARRAY[]::text[]);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260927044619_AddCourseCatalogKinds') THEN
    ALTER TABLE courses ADD CONSTRAINT ck_courses_catalog_kinds CHECK (catalog_kinds <@ ARRAY['course', 'free', 'mini-course', 'pro-exclusive', 'legacy', 'in-development']::text[]);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260927044619_AddCourseCatalogKinds') THEN
    UPDATE courses AS target
    SET catalog_kinds = source.kinds
    FROM (VALUES
        ('https://cursos.devtalles.com/courses/angular', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/Angular_socket_bun', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/angular-avanzado', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/angular-cero-experto', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/angular-moderno', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/angular-pro', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/Astro', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/claude-code-guia-completa', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/codex', ARRAY['in-development']::text[]),
        ('https://cursos.devtalles.com/courses/csharp', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/dart-cero-hasta-detalles', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/django', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/docker-guia-practica', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/expo-gemini', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/fastapi', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/flutter-avanzado', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/flutter-bloc', ARRAY['course', 'mini-course', 'pro-exclusive']::text[]),
        ('https://cursos.devtalles.com/courses/Flutter-Gemini', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/flutter-Intermedio', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/flutter-movil-cero-a-experto', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/flutter-movil-intermedio', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/flutter-web', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/git-github-control-versiones', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/git-github-control-versiones-desde-cero', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/go-microservicios', ARRAY['in-development']::text[]),
        ('https://cursos.devtalles.com/courses/golang-backend-profesional', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/golang-fundamentos-lenguaje', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/ia-para-developers', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/Ingenier%C3%ADa-de-prompts', ARRAY['course', 'mini-course']::text[]),
        ('https://cursos.devtalles.com/courses/Java', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/java-avanzado', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/javascript-moderno', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/kafka-springboot-event-driven', ARRAY['in-development']::text[]),
        ('https://cursos.devtalles.com/courses/laravel-ai', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/legacy-react-cero-a-experto', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/legacy-react-native', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/mas-DevTalles', ARRAY['pro-exclusive']::text[]),
        ('https://cursos.devtalles.com/courses/n8n-mcp', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/nest', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/nest-graphql', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/nestjs-microservicios', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/nestjs-reportes', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/NestJS-Testing', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/NET-Backend', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/net-pruebascompletas', ARRAY['course', 'mini-course', 'pro-exclusive']::text[]),
        ('https://cursos.devtalles.com/courses/netfullstack', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/nextjs', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/nextpagesrouter', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/node-cero-experto', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/node-clean-architecture', ARRAY['course', 'mini-course', 'pro-exclusive']::text[]),
        ('https://cursos.devtalles.com/courses/nodejs-de-cero-a-experto', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/nuxt', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/open-code-guia-completa', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/openai', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/openai-angular-nestjs', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/patrones-diseno', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/patrones-diseno-agentico', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/PHP-moderno', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/programacion-para-principiantes', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/PWA', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/python', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/python-ia-aplicada', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/python-n8n-automatiza-rutinas', ARRAY['course', 'mini-course', 'pro-exclusive']::text[]),
        ('https://cursos.devtalles.com/courses/qwik-introduccion', ARRAY['course', 'free']::text[]),
        ('https://cursos.devtalles.com/courses/react-cero-experto', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/React-con-Socket-io', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/react-de-cero', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/react-native', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/react-native-expo', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/react-pro', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/react-router', ARRAY['course', 'free']::text[]),
        ('https://cursos.devtalles.com/courses/react-sockets', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/reactivex-rxjs', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/riverpod-con-anotaciones', ARRAY['course', 'free', 'mini-course']::text[]),
        ('https://cursos.devtalles.com/courses/shadcn-ui', ARRAY['course', 'free']::text[]),
        ('https://cursos.devtalles.com/courses/solid-clean-code', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/spring-AI', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/spring-boot', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/spring-boot-microservicios', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/spring-boot-patrones-arquitectura', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/springboot-mvc-hexagonal', ARRAY['course', 'mini-course', 'pro-exclusive']::text[]),
        ('https://cursos.devtalles.com/courses/sql-con-postgres', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/tailwindcss-para-desarrolladores', ARRAY['course', 'mini-course', 'pro-exclusive']::text[]),
        ('https://cursos.devtalles.com/courses/tanstack-query', ARRAY['course', 'free']::text[]),
        ('https://cursos.devtalles.com/courses/typescript-guia-completa', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/vibe-coding', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/visual-studio-code', ARRAY['course', 'free']::text[]),
        ('https://cursos.devtalles.com/courses/vue-cero-a-experto', ARRAY['course']::text[]),
        ('https://cursos.devtalles.com/courses/vue-js', ARRAY['legacy']::text[]),
        ('https://cursos.devtalles.com/courses/zustand-gestor-de-estado-para-react', ARRAY['course', 'mini-course']::text[])
    ) AS source(course_url, kinds)
    WHERE target.course_url = source.course_url
      AND cardinality(target.catalog_kinds) = 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260927044619_AddCourseCatalogKinds') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260927044619_AddCourseCatalogKinds', '10.0.12');
    END IF;
END $EF$;
COMMIT;
