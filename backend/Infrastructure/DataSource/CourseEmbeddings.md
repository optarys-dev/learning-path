# Embeddings locales de cursos

La generación de embeddings vive en [`embedding-worker/`](../../embedding-worker/).
El backend .NET no carga el modelo: consulta al servicio Python para obtener el
vector de las preferencias y realiza la búsqueda por coseno en PostgreSQL.

## Requisitos y ejecución

- PostgreSQL con la migración `AddCourseEmbeddings` y metadatos de cursos importados.
- Python 3.11 o superior y `pip`.
- [Ollama](https://ollama.com/) con `qwen3-embedding:0.6b`.

Desde `backend/`:

```powershell
ollama pull qwen3-embedding:0.6b
python -m venv embedding-worker/.venv
embedding-worker/.venv/Scripts/python -m pip install -r embedding-worker/requirements.txt
$env:DATABASE_URL = 'postgresql://USUARIO:CLAVE@localhost:5432/codequest2026'
embedding-worker/.venv/Scripts/python embedding-worker/worker.py index
embedding-worker/.venv/Scripts/python embedding-worker/worker.py serve
```

En Linux/macOS, usar `embedding-worker/.venv/bin/python`. `index` es una tarea
explícita: repetirla tras actualizar el catálogo. Omite filas cuyo modelo y hash
no cambiaron y confirma cada curso para poder reanudar. `serve` escucha solo en
`127.0.0.1:8765` por defecto. Mantenerlo en una red privada: no tiene autenticación.
Configurar en .NET `EmbeddingService__Url=http://127.0.0.1:8765/` si cambia la
dirección. `GET /routes/recommendation/semantic` requiere sesión y preferencias;
devuelve 409 cuando faltan vectores compatibles y 503 si el servicio no responde.

## Contrato

El worker usa `POST /api/embed` de Ollama con `truncate=false`. Los documentos
incluyen título, nivel, categorías, etiquetas y metadatos con fuente pública o
revisión. Excluye `inferred-seed-v1`. La consulta usa objetivo, intereses y nivel,
con la instrucción de consulta recomendada por Qwen. No incluye habilidades previas
para evitar tratarlas como habilidades que se desea aprender.

Los vectores se identifican como `ollama/<modelo>/course-text-v1`. El backend
solo compara filas con el mismo identificador y dimensión. Cambiar modelo o
formato requiere volver a ejecutar `index`; la tabla guarda un vector por curso.
`ContentHash` es SHA-256 del texto UTF-8. Para 72 cursos se usa búsqueda exacta,
sin HNSW. La similitud coseno mide relevancia, no valida prerrequisitos.

La previsualización semántica no guarda rutas; `POST /routes/generate` todavía
usa el motor `static-v1`.

Referencias: [API de Ollama](https://docs.ollama.com/api/embed),
[Qwen3 Embedding](https://huggingface.co/Qwen/Qwen3-Embedding-0.6B).
