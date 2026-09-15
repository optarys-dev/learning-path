# Changelog

Cambios del backend de CodeQuest2026. Estas entradas describen el código disponible; no implican que esté aplicado en una base desplegada.

## [Unreleased]

### Agregado

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

### Cambiado

- Track se reemplazó por categorías; se conserva la clasificación antes de eliminar la columna.
- Se eliminaron el check y el índice de Track.
- Los índices simples de tablas de relación se reemplazaron por índices compuestos que incluyen CourseId.
- Se corrigió el nombre de la extensión PostgreSQL de pgvector a vector.
- Este changelog reemplaza las notas de scaffolding inicial de Visual Studio.

### Validación realizada

- Compilación del backend y correspondencia del modelo con el snapshot.
- Generación y revisión de scripts SQL de aplicación y reversión disponibles.
- Cobertura de seeds y traducción SQL de búsqueda por coseno.

### Limitaciones conocidas

- ReplaceTrackWithCategories no admite reversión automática.
- Los metadatos inferidos son datos de prueba, no temarios oficiales verificados.
- No se generan embeddings todavía; la tabla se crea vacía.
- No se incluye HNSW; la consulta documentada usa búsqueda exacta.
- La aplicación de migraciones y ejecución contra PostgreSQL requieren validación en el entorno de destino.
