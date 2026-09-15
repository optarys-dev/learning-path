# CodeQuest2026 — Backend

Backend ASP.NET Core de CodeQuest2026, un proyecto para recomendar cursos y construir rutas de aprendizaje.

## Estado actual

- Catálogo inicial de 72 cursos de DevTalles.
- 9 categorías y 96 tags relacionados muchos a muchos con cursos.
- Metadatos inferidos para pruebas: descripción, temario sugerido, objetivos, habilidades, prerrequisitos y público.
- Índices de filtrado por estado/nivel, título, categoría y tag.
- Almacenamiento de embeddings mediante pgvector.
- Health checks y documento OpenAPI en desarrollo.

La generación de embeddings, los endpoints de recomendaciones, el cuestionario, la autenticación y el seguimiento de progreso todavía no están implementados en este backend.

## Tecnologías

| Componente | Versión declarada |
| --- | --- |
| .NET / ASP.NET Core | 10 |
| EF Core Design / dotnet-ef | 10.0.12 |
| Npgsql EF Core | 10.0.3 |
| Pgvector.EntityFrameworkCore | 0.3.0 |
| Base de datos | PostgreSQL con vector y pg_trgm |

Ver [proyecto y dependencias](CodeQuest2026.Server.csproj). El proyecto referencia el cliente React de `../frontend`; conservar la estructura del repositorio.

## Configuración local

Ejecutar los comandos en PowerShell desde `backend/`.

### Requisitos

- SDK de .NET 10.
- PostgreSQL accesible con pgvector instalado y pg_trgm disponible.
- Base de datos de desarrollo y usuario con permisos para crear el esquema y habilitar extensiones, o extensiones habilitadas previamente por su administrador.
- Node.js y npm compatibles con el cliente si se ejecuta el frontend o el proxy SPA.

La extensión SQL se llama **vector**. Instalar el paquete NuGet no instala pgvector en el servidor PostgreSQL.

### Conexión

Configurar `ConnectionStrings:DefaultConnection`. Ejemplo para la sesión actual:

```powershell
$env:ConnectionStrings__DefaultConnection = 'Host=localhost;Port=5432;Database=codequest2026;Username=TU_USUARIO;Password=TU_PASSWORD'
$env:ASPNETCORE_ENVIRONMENT = 'Development'
```

Sustituir los valores de ejemplo. La variable de entorno prevalece sobre appsettings.json. Un archivo `.env` no se carga automáticamente en este backend. No guardar credenciales reales en el repositorio.

### Restaurar, compilar y migrar

```powershell
dotnet tool restore --tool-manifest dotnet-tools.json
dotnet restore CodeQuest2026.Server.csproj
dotnet build CodeQuest2026.Server.csproj --no-restore -p:BuildProjectReferences=false
dotnet ef database update --context AppDbContext --no-build
```

BuildProjectReferences=false evita compilar el cliente en este paso, aunque MSBuild todavía puede necesitar resolver su SDK JavaScript.

Las migraciones crean el esquema, habilitan las extensiones e incorporan los seeds. La aplicación no migra automáticamente al iniciar. Para una instalación nueva usar las migraciones: `../database/seeds/Seed Courses.sql` es una referencia histórica con Track y no debe ejecutarse sobre el esquema actual ni antes de la migración inicial.

### Ejecutar solo el backend

Con las variables anteriores, sin activar el perfil del proxy SPA:

```powershell
dotnet run --project CodeQuest2026.Server.csproj --no-build --no-launch-profile --urls http://localhost:5107
```

### Ejecutar con el perfil HTTPS y proxy SPA

Instalar primero las dependencias del cliente ejecutando `npm install` desde `frontend/`. Después, desde `backend/`:

```powershell
dotnet dev-certs https --trust
dotnet run --project CodeQuest2026.Server.csproj --no-build --launch-profile https
```

El perfil escucha en https://localhost:7281 y http://localhost:5107. Activa el proxy SPA configurado para iniciar `npm run dev` en el cliente.

## Comprobar el servicio

| Ruta | Función |
| --- | --- |
| /health/api | Disponibilidad del proceso API. |
| /health/db | Conectividad con PostgreSQL. |
| /health | Todos los health checks registrados. |
| /openapi/v1.json | Documento OpenAPI, solo en Development. |

Para la ejecución HTTP sin perfil:

```powershell
Invoke-WebRequest http://localhost:5107/health/api
Invoke-WebRequest http://localhost:5107/health/db
```

Un health check de base de datos correcto no demuestra que se hayan aplicado las migraciones ni cargado embeddings.

## Estructura

```text
Extensions/                         Registro de servicios
Infrastructure/DataSource/
  Context/                          AppDbContext
  Entities/                         Course, Category, Tag, CourseEmbedding
  Configurations/                   Mapeos, relaciones, restricciones e índices
  Migrations/                       Historial, snapshot y seeds versionados
  CourseMetadata.md                 Metadatos y procedencia
  CourseEmbeddings.md               Configuración y consulta por coseno
docs/MIGRATIONS.md                  Flujo de trabajo de migraciones
```

## Modelo y datos de prueba

Course tiene categorías y tags mediante course_categories y course_tags. Track fue reemplazado por categorías. Cada curso puede tener un CourseEmbedding; mientras no se genere, esa relación estará vacía.

Los registros con MetadataOrigin = inferred-seed-v1 son propuestas para pruebas, no temarios o prerrequisitos confirmados por DevTalles. Idioma, duración y verificación quedan pendientes cuando se desconocen. El seed conserva los metadatos previamente completados.

Los embeddings requieren seleccionar un modelo y generar vectores reales. Comparar únicamente vectores del mismo modelo y dimensiones. Se plantea búsqueda exacta para el catálogo actual; no hay índice HNSW.

## Documentación

- [Crear, aplicar y revertir migraciones](docs/MIGRATIONS.md).
- [Metadatos y seed de pruebas](Infrastructure/DataSource/CourseMetadata.md).
- [Embeddings y búsqueda por coseno](Infrastructure/DataSource/CourseEmbeddings.md).
- [Changelog](CHANGELOG.md).
- [Reglas de colaboración](../CONTRIBUTING.md).

## Validación

Se comprobaron compilación, correspondencia entre modelo y snapshot, generación de SQL y traducción de consultas por coseno. La ejecución contra PostgreSQL debe validarse en una base de desarrollo. No hay una suite persistente de pruebas automatizadas en este backend.

