# CODE QUEST 2026

CODE QUEST es una aplicación que recomienda rutas de aprendizaje usando cursos reales de DevTalles. Cada persona responde un cuestionario sobre sus objetivos, experiencia y conocimientos previos; con esa información, el sistema propone una ruta ordenada de cursos y permite guardar su progreso.

## Tecnologías

- Frontend: React con TypeScript.
- Backend: C# con ASP.NET Core Web API.
- Base de datos: PostgreSQL con Entity Framework Core.
- Autenticación: Discord OAuth.

## Estructura del repositorio

```text
backend/          API de ASP.NET Core
frontend/         Aplicación React
database/seeds/   Semillas y scripts de base de datos
docs/             Documentación funcional y técnica
```

## Estado actual

El repositorio se encuentra en fase de preparación. Las primeras tareas son definir el cuestionario, clasificar el catálogo de cursos y crear la base de la API y del cliente.

## Configuración local

1. En `frontend/`, copia `.env.example` como `.env` y conserva `VITE_API_BASE_URL=http://localhost:5107`.
2. Ejecuta la API con `dotnet run --project backend/CodeQuest2026.Server.csproj`.
3. En otra terminal, entra a `frontend/`, ejecuta `npm install` y después `npm run dev`.
4. Abre `http://localhost:5173`. La pantalla inicial debe indicar que la API está conectada.
5. Nunca subas claves, tokens, secretos de Discord ni cadenas de conexión reales al repositorio.

La API permite solicitudes únicamente desde `http://localhost:5173` durante desarrollo. La lista de orígenes se configura en `backend/appsettings.json`, bajo `Cors:AllowedOrigins`.

## Docker Compose

`compose.yaml` inicia PostgreSQL con pgvector, la API .NET y el servicio FastAPI de embeddings.
Desde la raíz, copia `.env.example` a `.env` y cambia `POSTGRES_PASSWORD`.
El puerto público de la API es `8080` por defecto; PostgreSQL solo se publica en
`127.0.0.1:5432` para las migraciones locales. FastAPI solo es accesible desde
la red interna de Compose. El primer arranque descarga el modelo de Hugging Face.

Para preparar una base nueva en PowerShell:

```powershell
Copy-Item .env.example .env
# Edita POSTGRES_PASSWORD en .env antes de continuar.
docker compose up -d postgres
Push-Location backend
$env:ConnectionStrings__DefaultConnection = 'Host=localhost;Port=5432;Database=codequest2026;Username=codequest;Password=TU_PASSWORD'
dotnet tool restore --tool-manifest dotnet-tools.json
dotnet ef database update --context AppDbContext
Remove-Item Env:ConnectionStrings__DefaultConnection
Pop-Location
docker compose build embeddings
docker compose run --rm embeddings python embedding_cli.py index
docker compose up -d --build
```

Ajusta el puerto, usuario y base de la cadena local si cambiaste `POSTGRES_PORT`,
`POSTGRES_USER` o `POSTGRES_DB`. `index` es una tarea explícita: repítela cuando
cambie el catálogo o el modelo. Comprueba `http://localhost:8080/health/api` y
`http://localhost:8080/health/db`. El servicio Python responde en su
`/health` interno. El contenedor .NET se ejecuta en modo `Development` para
permitir OAuth local por HTTP; en este modo expone Swagger en `/swagger`.

## Documentación

La documentación del proyecto se guarda en `docs/`. Los scripts de catálogo, clasificación y prerrequisitos se guardan en `database/seeds/`.

## Colaboración

Las reglas de ramas, commits y Pull Requests están en [CONTRIBUTING.md](CONTRIBUTING.md).
