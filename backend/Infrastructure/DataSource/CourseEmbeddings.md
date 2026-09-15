# Embeddings de cursos

La integración usa Pgvector.EntityFrameworkCore 0.3.0 y `UseVector()` en Npgsql.
La extensión de PostgreSQL se llama `vector`, no `pgvector`.

## Aplicación

El servidor PostgreSQL debe tener pgvector instalado/disponible. La migración
AddCourseEmbeddings ejecuta `CREATE EXTENSION IF NOT EXISTS vector`; el usuario
de migraciones necesita permiso para habilitarla. Después ejecutar desde backend:

```powershell
dotnet ef database update
```

La migración crea course_embeddings sin filas. No genera vectores sintéticos:
se necesita seleccionar un modelo y ejecutar un proceso de embeddings real.

## Modelo

- Un embedding por curso; eliminar el curso elimina su embedding.
- Embedding es `vector` sin dimensión fija mientras se selecciona un modelo.
- Dimensions debe coincidir con vector_dims(embedding). No se permiten vectores cero.
- Model debe identificar proveedor/modelo/versión y configuración de generación.
- ContentHash es SHA-256 hexadecimal en minúsculas del texto enviado al modelo.
- GeneratedAt se guarda en UTC.

Al cambiar el contenido, comparar su hash y regenerar el embedding. Al cambiar el
modelo, reemplazar los embeddings; nunca comparar modelos distintos aunque sus
dimensiones coincidan. El hash sirve para detectar cambios, no lo actualiza EF
automáticamente.

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

Referencia: https://github.com/pgvector/pgvector-dotnet
