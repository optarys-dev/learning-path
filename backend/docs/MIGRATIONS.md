# Migraciones Code First

Ejecutar desde backend/, con la conexión configurada según el [README](../README.md).

## Crear una migración

1. Modificar entidades y configuraciones en Infrastructure/DataSource.
2. Agregar el DbSet al contexto cuando corresponda.
3. Compilar y generar una migración con un nombre descriptivo:

```powershell
dotnet build CodeQuest2026.Server.csproj --no-restore -p:BuildProjectReferences=false
dotnet ef migrations add AddCourseDifficulty --context AppDbContext --output-dir Infrastructure/DataSource/Migrations --no-build
```

AddCourseDifficulty es un ejemplo; reemplazarlo por el cambio real. `--no-build` usa el ensamblado compilado: no utilizarlo con cambios de código sin compilar.

EF genera Up/Down, un archivo Designer y actualiza AppDbContextModelSnapshot. Incluir esos archivos en el control de versiones.

## Revisar y validar

Revisar tipos, nulabilidad, valores por defecto, relaciones, índices, restricciones y posible pérdida de datos en Up/Down. Migrar los datos antes de eliminar o convertir columnas. No editar el snapshot manualmente como sustituto de generar una migración.

Compilar de nuevo para incluir la migración recién creada:

```powershell
dotnet build CodeQuest2026.Server.csproj --no-restore -p:BuildProjectReferences=false
dotnet ef migrations has-pending-model-changes --context AppDbContext --no-build
dotnet ef migrations list --context AppDbContext --no-build
```

has-pending-model-changes compara el modelo con el snapshot; no indica si la base está actualizada. migrations list puede consultar la base para determinar qué migraciones están aplicadas.

## Generar SQL para revisión

Ejemplo con dos migraciones reales del proyecto:

```powershell
New-Item -ItemType Directory -Force artifacts
dotnet ef migrations script SeedCourseLearningMetadata AddCourseEmbeddings --context AppDbContext --no-build --output artifacts/AddCourseEmbeddings.sql
```

Para todo el historial, con comprobaciones de migraciones ya aplicadas:

```powershell
dotnet ef migrations script --idempotent --context AppDbContext --no-build --output artifacts/Migrations.sql
```

Revisar el SQL y probarlo en desarrollo. No incluir credenciales. Los scripts idempotentes usan el historial de EF; no corrigen una base creada manualmente sin ese historial.

## Aplicar

```powershell
dotnet ef database update --context AppDbContext --no-build
```

Para detenerse en una migración concreta:

```powershell
dotnet ef database update AddCourseEmbeddings --context AppDbContext --no-build
```

EF registra las migraciones aplicadas en __EFMigrationsHistory. Los seeds están incluidos: no ejecutar el SQL histórico de referencia aparte.

## Quitar una migración no aplicada

Si la última migración todavía no se aplicó a ninguna base compartida:

```powershell
dotnet ef migrations remove --context AppDbContext --no-build
```

Elimina la última migración y ajusta el snapshot; no revierte las entidades. Corregir el modelo y generar otra migración cuando corresponda. No borrar ni reescribir migraciones históricas aplicadas: crear una nueva.

## Revertir una migración aplicada

En desarrollo, tras revisar Down y respaldar los datos necesarios, apuntar a la migración anterior. Este ejemplo elimina la tabla de embeddings y todos sus vectores:

```powershell
dotnet ef database update SeedCourseLearningMetadata --context AppDbContext --no-build
```

**Límite actual:** ReplaceTrackWithCategories lanza NotSupportedException en Down porque no puede reconstruir el Track original desde varias categorías. No se puede retroceder automáticamente a migraciones anteriores a ella ni ejecutar `database update 0` atravesándola. Recuperar ese estado desde un respaldo o continuar con una migración nueva.

## Historial actual

| Migración | Cambio |
| --- | --- |
| InitialCreate | Tabla courses, restricciones y seed de 72 cursos. |
| AddCourseCategoriesAndTags | Categorías, tags, relaciones y seed. |
| ReplaceTrackWithCategories | Conserva Track como categoría y elimina la columna. |
| AddCourseFilterIndexes | Índices de filtrado y pg_trgm para títulos. |
| AddCourseLearningMetadata | Metadatos y validación de duración. |
| SeedCourseLearningMetadata | Metadatos inferidos y MetadataOrigin. |
| AddCourseEmbeddings | Extensión vector y almacenamiento de embeddings. |

## Seeds futuros

- Usar nuevas migraciones para nuevos datos o correcciones.
- Mantener copias fijas de los seeds; no leer archivos externos mutables durante Up.
- Resolver cursos por slug cuando los IDs sean generados por PostgreSQL.
- Proteger datos editados y documentar qué podrá deshacer Down.
- Generar embeddings en un proceso separado; no llamar servicios de IA desde Up/Down.

## Problemas frecuentes

| Problema | Revisión |
| --- | --- |
| No se encuentra dotnet-ef | Ejecutar dotnet tool restore --tool-manifest dotnet-tools.json. |
| No se puede construir el contexto | Verificar ConnectionStrings__DefaultConnection y compilar los cambios. |
| Extension vector is not available | Instalar pgvector en el servidor; NuGet no lo instala. |
| Sin permisos para extensiones | Solicitar al administrador habilitar vector y pg_trgm en esa base. |
| Relation courses already exists | Revisar si se ejecutó el SQL histórico fuera de EF. No borrar datos ni marcar migraciones como aplicadas sin comparar esquemas. |
| No aparecen cambios recientes | Compilar antes de usar --no-build. |
| Error del SDK JavaScript | Restaurar y revisar ../frontend; BuildProjectReferences=false no elimina la resolución de ese SDK. |

