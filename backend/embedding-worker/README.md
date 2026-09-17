# Embedding Worker

Servicio local para generar embeddings de cursos y preferencias usando un modelo de Hugging Face y almacenarlos en PostgreSQL con soporte de pgvector.

Este worker es el componente responsable de:

- indexar textos de cursos y guardar vectores en la base de datos
- exponer un endpoint para generar embeddings de preferencias
- usar un modelo local de `sentence-transformers` sin depender de un servicio externo

## Requisitos

- Python 3.10+
- PostgreSQL con pgvector habilitado
- Acceso a internet para descargar el modelo de Hugging Face por primera vez

## Estructura

- `worker.py`: lógica principal del worker
- `test_worker.py`: pruebas unitarias del comportamiento esperado
- `requirements.txt`: dependencias del proyecto

## Instalación

En Windows PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
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
- `EMBEDDING_HOST`: IP de escucha del servicio HTTP.
- `EMBEDDING_PORT`: puerto del servicio HTTP.

## Uso

### 1) Indexar cursos

```powershell
python worker.py index
```

Este comando:

- consulta los cursos activos desde la base de datos
- arma un texto descriptivo para cada curso
- genera su embedding con el modelo local
- guarda el vector en la tabla `course_embeddings`
- actualiza solo si el contenido cambió

### 2) Servir embeddings de preferencias

```powershell
python worker.py serve
```

Esto levanta un servidor HTTP en `http://127.0.0.1:8765` y expone el endpoint:

```http
POST /embed-preferences
```

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
python -m unittest test_worker.py
```

## Observaciones importantes

- Los embeddings se normalizan antes de guardarse o devolverlos.
- La consulta de preferencias agrega una instrucción especial para mejorar la relevancia semántica.
- Si el modelo no está disponible o falla al generar el embedding, el servicio responde con `503`.
- Si la solicitud del cliente es inválida, responde con `400`.

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
