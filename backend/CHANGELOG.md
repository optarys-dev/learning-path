# Changelog

Cambios del backend de CodeQuest2026. Estas entradas describen el código disponible; no implican que esté aplicado en una base desplegada.

## [Unreleased]

Actualizado al 26 de septiembre de 2026.

### Agregado

- Inicialización en el propio contenedor `web-app` de Docker Compose: aplica migraciones, importa `Seed DataCourses.sql` y después `Seed Embeddings.sql`, antes de iniciar el servidor web. Se activa con `DatabaseInitialization__Enabled=true`. Extrae los datos de los dumps sobre el esquema de EF, combina el catálogo por ID y carga ambos seeds en una transacción. El registro en `app_seed_history` evita repetir la carga inicial en siguientes arranques.
- Progreso por curso mediante `PATCH /routes/{routeId}/courses/{courseId}/progress`: porcentaje entero de 0 a 100, independiente por ruta y restringido a su propietario. Permite completar, reducir o reiniciar el avance.
- `progressPercentage` en cada curso y en la ruta completa, incluido en respuestas de creación, edición, consulta, listado y actualización de progreso. El total es el promedio de todos los cursos, con igual peso y redondeado a dos decimales; una ruta sin cursos devuelve 0.
- Migración `AddLearningRouteCourseProgress`: columna `progress_percentage` con valor inicial 0 y restricción de rango en la base de datos.
- Inicio de sesión con Google mediante `GET /auth/google` y consulta de su disponibilidad mediante `GET /auth/providers`, manteniendo Discord y la cookie `CodeQuest.Session`. Configuración documentada en [Google OAuth](docs/GOOGLE_OAUTH.md).
- Migración `AddExternalAuthentication`: tabla `user_external_logins`, `discord_id` opcional y mayor longitud de avatar. Registra las identidades de Discord existentes sin cambiar sus usuarios ni la propiedad de sus rutas.
- Creación manual mediante `POST /routes` con `recommendationMethod: "manual-v1"`, objetivo obligatorio y de 1 a 30 cursos activos sin duplicados; no requiere preferencias previas.
- Búsqueda paginada mediante `GET /courses?search=...` en título, descripción, categorías y etiquetas de cursos activos.
- `imageUrl` en los cursos recomendados de las vistas previas semánticas y V2.
- Catálogo básico público mediante `GET /courses` y `GET /courses/{courseId}`, limitado a cursos activos y sin metadatos de aprendizaje; el listado incluye paginación y metadatos de navegación.
- `imageUrl` y `courseUrl` en los cursos de rutas guardadas, incluidas respuestas de consulta, creación y edición.

- Edición de rutas propias mediante `PUT /routes/{routeId}`: objetivo, explicación y cursos ordenados, con actualización transaccional.
- Eliminación de rutas propias mediante `DELETE /routes/{routeId}`, conservando los cursos del catálogo.

- AppDbContext con PostgreSQL/Npgsql y configuraciones separadas por entidad.
- InitialCreate con 72 cursos de DevTalles, restricciones y valores predeterminados.
- Category y Tag con relaciones muchos a muchos: 9 categorías, 96 tags, 90 relaciones de categorías y 187 relaciones de tags.
- Índices por estado/nivel, GIN de trigramas para títulos y compuestos por categoría/curso y tag/curso.
- Metadatos de cursos: descripción, temario, objetivos, habilidades, prerrequisitos, público, idioma, duración, fuente y verificación.
- Seed de metadatos inferidos para 72 cursos, con MetadataOrigin = inferred-seed-v1 y protección frente a datos ya completados.
- Pgvector.EntityFrameworkCore 0.3.0, UseVector y extensión vector.
- CourseEmbedding con relación uno a uno, modelo, dimensiones, hash SHA-256 y fecha; validaciones de dimensiones, vector no cero, modelo y hash.
- Health checks /health, /health/api y /health/db; OpenAPI en desarrollo.
- Manifiesto local de dotnet-ef 10.0.12.
- README del backend, guía de migraciones y documentación de metadatos/embeddings.
- Preferencias de aprendizaje por usuario con `PUT /users/me/preferences` y consulta por `GET /users/me/preferences`.
- Vista previa semántica con `GET /routes/recommendation/semantic` y guardado explícito de propuestas mediante `POST /routes`.
- Worker Python que indexa cursos y genera embeddings de preferencias localmente con `Qwen/Qwen3-Embedding-0.6B` de Hugging Face; la API compara vectores compatibles en pgvector.

### Cambiado

- El servicio `api` de Compose pasa a llamarse `web-app` y se elimina el servicio separado `db-init`. El worker espera a PostgreSQL; `web-app` espera a PostgreSQL y al worker saludables, ejecuta la inicialización y continúa con el servidor web. Se conserva `--initialize-db` para inicializar y salir; fuera de Compose, la inicialización al arrancar depende de `DatabaseInitialization:Enabled`.
- Compose valida con mensajes explícitos las variables obligatorias de PostgreSQL, embeddings, conexión de la API, Discord y Groq. Si faltan o están vacías, detiene el arranque. Las credenciales de Google permanecen opcionales y `DISCORD_FORCE_HTTPS_CALLBACK` conserva `false` como valor predeterminado.
- La conexión de `web-app` se recibe completa mediante `ConnectionStrings__DefaultConnection`, en lugar de construirse con las variables de PostgreSQL. Estas últimas siguen configurando el contenedor de base de datos y el worker.
- Discord recibe sus credenciales, callback obligatorio y opción de forzar HTTPS mediante variables `Discord__...`. Se agregan las variables de Google y las de Groq (`Groq__ApiKey` y `Groq__Model`, obligatorias) al entorno de `web-app`.
- El puerto publicado de `web-app` deja de limitarse a `127.0.0.1`; PostgreSQL conserva esa restricción. El servidor mantiene el puerto HTTP interno 8080 definido en el Dockerfile. Compose ya no pasa `ASPNETCORE_ENVIRONMENT` ni `ASPNETCORE_HTTP_PORTS` explícitamente al contenedor.
- `.env.example` incorpora secciones de Google y Groq y elimina `VITE_API_BASE_URL`, `ASPNETCORE_ENVIRONMENT` y `API_PORT`. Compose publica `web-app` en `8080:8080`. El README principal incorpora requisitos, configuración de credenciales y conexión interna, override de Development para HTTP local, arranque, logs, health checks y apagado conservando volúmenes.
- Las operaciones autenticadas usan el `UserId` interno mediante el claim `codequest:user_id`, independiente del proveedor. Las cookies anteriores de Discord se actualizan para conservar las sesiones existentes.
- Los errores HTTP usan `ProblemDetails` con `code` y `traceId`; los errores de validación incluyen el detalle por campo. Se centralizaron las respuestas de validación de dominio y excepciones imprevistas.
- Editar o reordenar una ruta conserva el progreso de los cursos que permanecen. Los nuevos comienzan en 0; quitar un curso elimina su avance. La edición y la actualización de progreso se coordinan mediante transacciones sobre la misma ruta.
- `POST /routes` acepta un `goal` propio; en rutas no manuales, si se omite, utiliza el objetivo de las preferencias guardadas.
- Iniciar OAuth con una sesión activa evita repetir el reto de autorización. Se permiten retornos locales y `/login/callback` en los orígenes configurados para el frontend.
- La vista previa semántica usa `semantic-graph-v6`: evalúa todos los embeddings elegibles, deriva asociaciones categoría–tag y reconoce títulos y equivalencias `web`/`js`. Cuando el objetivo nombra un tema, este prevalece sobre otros intereses para definir los cursos centrales; los requisitos no cuentan como temas enseñados y, si hay cursos centrales, se limita a un complemento. Se descartan requisitos opcionales o de instalación.
- El servidor HTTP de embeddings pasó de `ThreadingHTTPServer` a FastAPI/Uvicorn. Los comandos principales son `embedding_cli.py index` y `embedding_cli.py serve`; `worker.py` conserva compatibilidad. Se mantiene `POST /embed-preferences` y se agregan `/health` y `/docs`.
- Se extrajo `EmbeddingService` para compartir la carga del modelo, la preparación de textos y la inferencia entre la API FastAPI y la indexación.
- Track se reemplazó por categorías; se conserva la clasificación antes de eliminar la columna.
- Se eliminaron el check y el índice de Track.
- Los índices simples de tablas de relación se reemplazaron por índices compuestos que incluyen CourseId.
- Se corrigió el nombre de la extensión PostgreSQL de pgvector a vector.
- Este changelog reemplaza las notas de scaffolding inicial de Visual Studio.
- Flujo de recomendación unificado en las vistas previas semánticas y guardado explícito mediante `POST /routes`; contrato `SemanticRecommendationDto`.
- README actualizado con el flujo semántico de creación de rutas y la configuración del worker.

### Validación realizada

- Inicialización comprobada en PostgreSQL 17 con pgvector: migraciones y carga de 91 cursos y 91 embeddings; segundo arranque sin recarga ni pérdida de ediciones; fallo intencional de embeddings con reversión de ambos seeds y reintento correcto. Sintaxis de Compose validada. Suite posterior al cambio: 125 pruebas correctas y 2 de integración omitidas por falta de conexión configurada para ellas.
- 26 de septiembre de 2026: `dotnet test tests/CodeQuest2026.Server.Tests --no-restore` completó con 121 pruebas correctas, 2 omitidas y ninguna fallida. Las omitidas requieren conexión PostgreSQL y cubren la migración de autenticación y los inicios de sesión concurrentes con Google.
- Compilación del backend y correspondencia del modelo con el snapshot.
- Generación y revisión de scripts SQL de aplicación y reversión disponibles.
- Cobertura de seeds y traducción SQL de búsqueda por coseno.

### Limitaciones conocidas

- `.env.example` conserva un comentario inicial que describe Google como obligatorio, aunque su sección específica y Compose lo permiten vacío. El ejemplo tampoco incluye `DISCORD_CALLBACK_PATH`, ahora requerido, y su cadena de conexión usa `localhost` y marcadores `{POSTGRES_USER}`/`{POSTGRES_PASSWORD}` que deben reemplazarse; el README principal explica la configuración correcta con `postgres:5432`.
- Definir `ASPNETCORE_ENVIRONMENT` solo en `.env` no lo transmite al contenedor con el Compose actual. La aplicación conserva la redirección HTTPS y las políticas de autenticación según el entorno; estos cambios no eliminan ese comportamiento.
- Aplicar `AddLearningRouteCourseProgress` y `AddExternalAuthentication` antes de utilizar las funcionalidades correspondientes. La validación local no confirma que estén aplicadas en una base desplegada.
- `AddExternalAuthentication` bloquea su reversión si existen usuarios sin Discord o avatares que exceden la longitud anterior, para evitar perder datos.
- ReplaceTrackWithCategories no admite reversión automática.
- Los metadatos inferidos son datos de prueba, no temarios oficiales verificados.
- La migración crea `course_embeddings` vacía; Compose carga los vectores del seed durante la inicialización. En instalaciones sin ese seed, ejecutar `embedding-worker/embedding_cli.py index` para generarlos.
- No se incluye HNSW; la consulta documentada usa búsqueda exacta.
- La aplicación de migraciones, la ejecución contra PostgreSQL y la inferencia real del modelo requieren validación en el entorno de destino.
