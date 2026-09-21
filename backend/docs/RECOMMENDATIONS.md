# Recomendaciones de rutas

## Flujo semántico

1. Guardar objetivo, intereses y preferencias con `PUT /users/me/preferences`.
2. Consultar `GET /routes/recommendation/semantic` o `GET /routes/recommendation/semantic/v2`.
3. Guardar la propuesta con `POST /routes`, enviando `recommendationMethod`,
   `explanation` y `courses` con sus IDs y razones en el orden propuesto.
4. Consultar las rutas guardadas con `GET /routes` o `GET /routes/{routeId}`.

Estos endpoints requieren sesión de Discord. Las vistas previas no guardan rutas;
`POST /routes` conserva el orden, las razones y una copia de las preferencias.

## Recuperación y orden semántico

El worker Python indexa los cursos con `Qwen/Qwen3-Embedding-0.6B` y genera el vector
de consulta a partir del objetivo, intereses y nivel declarado. La API .NET compara
solo embeddings de cursos activos del mismo modelo y dimensión en pgvector y aplica
el filtro de idioma. Instalación y comandos:
[Embeddings de cursos](../Infrastructure/DataSource/CourseEmbeddings.md).

El motor híbrido combina similitud vectorial con asociaciones de categorías, tags
y títulos. Selecciona hasta seis cursos y sugiere un orden por tema central, nivel
publicado y preparación según habilidades previas y requisitos verificados.
Las puntuaciones representan relevancia relativa, no probabilidades.

Los metadatos marcados `inferred-seed-v1` no acreditan habilidades ni requisitos
verificados. Las asociaciones temáticas no constituyen dependencias obligatorias.
Cuando existen duración y tiempo semanal, se estiman semanas de contenido por curso.

## Refinamiento con IA

La V2 reutiliza la selección semántica y refina el orden y las razones mediante
`IStructuredAiProvider`. Groq está registrado directamente; OpenAI se conserva como
implementación alternativa. El JSON Schema y la validación del backend exigen
exactamente los mismos cursos, sin duplicados ni IDs inventados. Si falla la IA,
se devuelve la propuesta semántica original y un `refinementStatus` explicativo.
Véase [configuración y contrato de la V2](SEMANTIC_V2.md).

## Disponibilidad

El índice debe contener vectores compatibles y el worker debe estar ejecutándose.
Si faltan preferencias o embeddings compatibles, la vista previa devuelve 409.
Los fallos HTTP del worker devuelven 502 o 503. Una búsqueda sin coincidencias puede
devolver `courses: []`; no se puede guardar una ruta vacía.
