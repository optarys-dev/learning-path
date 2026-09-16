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

## Documentación

La documentación del proyecto se guarda en `docs/`. Los scripts de catálogo, clasificación y prerrequisitos se guardan en `database/seeds/`.

## Colaboración

Las reglas de ramas, commits y Pull Requests están en [CONTRIBUTING.md](CONTRIBUTING.md).
