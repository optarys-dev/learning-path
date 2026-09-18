# Embeddings de cursos

La integración usa Pgvector.EntityFrameworkCore 0.3.0 y `UseVector()` en Npgsql.
La extensión de PostgreSQL se llama `vector`, no `pgvector`.

## Aplicación

El servidor PostgreSQL debe tener pgvector instalado/disponible. La migración
AddCourseEmbeddings ejecuta `CREATE EXTENSION IF NOT EXISTS vector`; el usuario
de migraciones necesita permiso para habilitarla.

- PostgreSQL con la migración `AddCourseEmbeddings` y metadatos de cursos importados.
- Python 3.11 o superior y `pip`.
- Dependencias de Python en `embedding-worker/requirements.txt`. El modelo
  `Qwen/Qwen3-Embedding-0.6B` se descarga desde Hugging Face en el primer uso.

Desde `backend/`:

```powershell
dotnet ef database update --context AppDbContext
python -m venv embedding-worker/.venv
embedding-worker/.venv/Scripts/python -m pip install -r embedding-worker/requirements.txt
$env:DATABASE_URL = 'postgresql://USUARIO:CLAVE@localhost:5432/codequest2026'
embedding-worker/.venv/Scripts/python embedding-worker/embedding_cli.py index
embedding-worker/.venv/Scripts/python embedding-worker/embedding_cli.py serve
```

`serve` inicia la API FastAPI en Uvicorn. El endpoint compatible es
`POST /embed-preferences`; `GET /health` indica si el modelo terminó de cargar y
`GET /docs` expone la documentación interactiva. Desde `embedding-worker/` también
se puede ejecutar `python -m uvicorn api:app --host 127.0.0.1 --port 8765`.

La migración crea course_embeddings sin filas. No genera vectores sintéticos:
se necesita seleccionar un modelo y ejecutar un proceso de embeddings real.

## Modelo

El worker carga `Qwen/Qwen3-Embedding-0.6B` mediante `SentenceTransformer` y
genera los vectores localmente. Los documentos incluyen título, nivel, categorías,
etiquetas y metadatos con fuente pública o revisión. Omite los metadatos inferidos
de `inferred-seed-v1`. La consulta usa objetivo, intereses y nivel,
con la instrucción de consulta recomendada por Qwen. No incluye habilidades previas
para evitar tratarlas como habilidades que se desea aprender.

Los vectores se identifican como `hf/<modelo>@<revisión>/course-text-v1`. El backend
solo compara filas con el mismo identificador y dimensión. Cambiar modelo o
formato requiere volver a ejecutar `index`; la tabla guarda un vector por curso.
`ContentHash` es SHA-256 del texto UTF-8. Para 72 cursos se usa búsqueda exacta,
sin HNSW. La similitud coseno mide relevancia, no valida prerrequisitos.

## Consulta por coseno

Con queryVector obtenido del mismo modelo, dimensiones coincidentes y vector
finito distinto de cero:

```csharp
using Microsoft.EntityFrameworkCore;
using Pgvector.EntityFrameworkCore;

var results = await db.CourseEmbeddings
    .AsNoTracking()
    .Where(item => item.Model == model
        && item.Dimensions == dimensions
        && item.Course.IsActive)
    .OrderBy(item => item.Embedding.CosineDistance(queryVector))
    .ThenBy(item => item.CourseId)
    .Select(item => new
    {
        item.CourseId,
        item.Course.Title,
        Similarity = 1 - item.Embedding.CosineDistance(queryVector)
    })
    .Take(10)
    .ToListAsync();
```

La similitud no es una probabilidad. Para los 72 cursos se usa búsqueda exacta,
con índice B-tree por Model y Dimensions. No hay índice HNSW por ahora: al elegir
un modelo y medir la necesidad, fijar vector(n) y agregar vector_cosine_ops en
otra migración. Los índices actuales de categorías, tags y títulos se conservan.

Modelo: [Qwen3 Embedding](https://huggingface.co/Qwen/Qwen3-Embedding-0.6B).
