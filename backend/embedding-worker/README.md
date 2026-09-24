# API de embeddings

API local con FastAPI para generar embeddings de preferencias con un modelo de Hugging Face. La tarea `embedding_cli.py index` genera y guarda los embeddings de cursos en PostgreSQL con pgvector.

Este worker es el componente responsable de:

- indexar textos de cursos y guardar vectores en la base de datos
- exponer `POST /embed-preferences` mediante FastAPI
- usar un modelo local de `sentence-transformers` sin depender de un servicio externo

## Requisitos

- Python 3.10+
- PostgreSQL con pgvector habilitado
- Acceso a internet para descargar el modelo de Hugging Face por primera vez

## Estructura

- `embedding_cli.py`: comandos de indexación y arranque de Uvicorn
- `worker.py`: acceso compatible para los comandos anteriores
- `api.py`: validación HTTP y endpoints FastAPI
- `embedding_service.py`: carga del modelo, preparación del texto y generación de vectores
- `test_embedding_service.py`: pruebas del servicio y la API
- `requirements.txt`: dependencias del proyecto
- `requirements-test.txt`: dependencias de pruebas HTTP

## Instalación

En Windows PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

## Variables de entorno

```powershell
$env:DATABASE_URL="postgresql://usuario:password@host:5432/dbname"
$env:EMBEDDING_MODEL="Qwen/Qwen3-Embedding-0.6B"
$env:EMBEDDING_REVISION="main"
$env:EMBEDDING_DEVICE="cpu"
$env:EMBEDDING_HOST="127.0.0.1"
$env:EMBEDDING_PORT="8765"
```

### Descripción

- `DATABASE_URL`: cadena de conexión de PostgreSQL.
- `EMBEDDING_MODEL`: nombre del modelo de Hugging Face a usar.
- `EMBEDDING_REVISION`: rama o revisión del modelo.
- `EMBEDDING_DEVICE`: `cpu` o `cuda` según el hardware disponible.
- `EMBEDDING_HOST`: interfaz donde escucha Uvicorn; por defecto `127.0.0.1`, accesible solo desde este equipo.
- `EMBEDDING_PORT`: puerto local de Uvicorn; por defecto `8765`. La URL configurada en .NET debe apuntar al mismo host y puerto.

Estas dos variables son opcionales. `index` consulta PostgreSQL y no abre un puerto;
solo `serve` inicia el servidor HTTP que .NET utiliza para solicitar vectores.

## Uso

### 1) Indexar cursos

```powershell
python embedding_cli.py index
```

Este comando:

- consulta los cursos activos desde la base de datos
- arma un texto descriptivo para cada curso
- genera su embedding con el modelo local
- guarda el vector en la tabla `course_embeddings`
- actualiza solo si el contenido cambió

### 2) Iniciar la API de embeddings

```powershell
python embedding_cli.py serve
```

`worker.py index` y `worker.py serve` siguen funcionando como accesos compatibles.
`serve` arranca Uvicorn con FastAPI. También se
puede iniciar directamente desde `embedding-worker/`:

```powershell
python -m uvicorn api:app --host 127.0.0.1 --port 8765
```

El modelo se carga antes de aceptar peticiones. La API escucha solo en
`http://127.0.0.1:8765` por defecto y expone:

```http
POST /embed-preferences
GET /health
GET /docs
```

FastAPI es un proceso independiente de la API .NET. `embedding_cli.py serve` inicia
únicamente este servicio de embeddings; `embedding_cli.py index` se ejecuta y termina.

`/health` devuelve 200 cuando terminó la carga del modelo. `/docs` muestra la
documentación interactiva de FastAPI. El servicio no tiene autenticación; mantener
el host en loopback o detrás de una red privada. La API .NET conserva su URL
predeterminada `http://127.0.0.1:8765/`.

### Payload esperado

```json
{
  "goal": "Quiero aprender desarrollo backend con Python",
  "interests": ["Python", "APIs", "Bases de datos"],
  "experienceLevel": "Principiante"
}
```

### Respuesta esperada

```json
{
  "model": "hf/Qwen/Qwen3-Embedding-0.6B@main/course-text-v1",
  "dimensions": 1024,
  "embedding": [0.12, -0.45, 0.98]
}
```

## Pruebas

```powershell
python -m pip install -r requirements-test.txt
python -m unittest test_embedding_service.py
```

## Observaciones importantes

- Los embeddings se normalizan antes de guardarse o devolverlos.
- La consulta de preferencias agrega una instrucción especial para mejorar la relevancia semántica.
- Si el modelo no está disponible o falla al generar el embedding, el servicio responde con `503`.
- Si la solicitud del cliente es inválida, responde con `400`.
- El JSON de `POST /embed-preferences` conserva `model`, `dimensions` y `embedding`.
- `embedding_cli.py index` sigue siendo una tarea explícita; la API no modifica el catálogo.
- `POST /embed-preferences` delega la inferencia a `EmbeddingService`; la API .NET realiza la búsqueda en pgvector.

## Flujo típico

1. El backend consulta cursos activos.
2. El worker genera embeddings con el modelo local.
3. Las búsquedas por similitud usan los vectores almacenados en PostgreSQL.
4. El servicio HTTP produce embeddings de preferencias para consultas del usuario.

## Troubleshooting

### Error de conexión a PostgreSQL

Verifica que `DATABASE_URL` sea correcta y que `pgvector` esté instalado y habilitado en la base de datos.

### El modelo tarda mucho en cargar

La primera ejecución descarga el modelo desde Hugging Face y puede tardar varios minutos dependiendo de la red y del hardware.

### Error `ModuleNotFoundError`

Asegúrate de activar el entorno virtual y ejecutar:

```powershell
pip install -r requirements.txt
```
