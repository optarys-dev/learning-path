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

1. Copia `.env.example` como `.env` para los valores del entorno que use el frontend.
2. El backend utilizará `appsettings.Development.json` o User Secrets para sus valores locales.
3. Nunca subas claves, tokens, secretos de Discord ni cadenas de conexión reales al repositorio.

## Documentación

La documentación del proyecto se guarda en `docs/`. Los scripts de catálogo, clasificación y prerrequisitos se guardan en `database/seeds/`.

## Colaboración

Las reglas de ramas, commits y Pull Requests están en [CONTRIBUTING.md](CONTRIBUTING.md).
