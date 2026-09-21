# Changelog

Cambios del backend de CodeQuest2026. Estas entradas describen el código disponible; no implican que esté aplicado en una base desplegada.

## [Unreleased]

### Agregado

- Catálogo básico autenticado mediante `GET /courses` y `GET /courses/{courseId}`, limitado a cursos activos y sin metadatos de aprendizaje.
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

- Compilación del backend y correspondencia del modelo con el snapshot.
- Generación y revisión de scripts SQL de aplicación y reversión disponibles.
- Cobertura de seeds y traducción SQL de búsqueda por coseno.

### Limitaciones conocidas

- ReplaceTrackWithCategories no admite reversión automática.
- Los metadatos inferidos son datos de prueba, no temarios oficiales verificados.
- La migración crea `course_embeddings` vacía; ejecutar `embedding-worker/embedding_cli.py index` para generar los vectores.
- No se incluye HNSW; la consulta documentada usa búsqueda exacta.
- La aplicación de migraciones, la ejecución contra PostgreSQL y la inferencia real del modelo requieren validación en el entorno de destino.
