# CodeQuest2026 — Backend

API para recomendar cursos y construir rutas de aprendizaje según objetivos,
intereses y conocimientos previos. Combina **búsqueda semántica**, **asociaciones
del catálogo** y **refinamiento opcional con IA**.

## Índice

- [Descripción general](#descripcion-general)
- [Inicio rápido](#inicio-rapido)
- [API y flujo de uso](#api-y-flujo)
- [Estrategia de recomendación](#estrategia)
- [Proveedores de IA](#proveedores)
- [Estructura del proyecto](#estructura)
- [Docker](#docker)
- [Pruebas y comprobaciones](#pruebas)
- [Documentación](#documentacion)

<a id="descripcion-general"></a>

## Descripción general

| Capacidad | Implementación |
| --- | --- |
| Autenticación | Discord OAuth y cookie de sesión. |
| Preferencias | Objetivo, intereses, experiencia, habilidades, idioma y tiempo disponible. |
| Catálogo inicial | 72 cursos de DevTalles, 9 categorías y 96 tags. |
| Recomendación | Embeddings locales, pgvector y asociaciones categoría–tag. |
| Refinamiento V2 | Groq organiza los cursos y personaliza las razones con JSON Schema estricto. |
| Rutas | Guardado explícito, consulta y copia de las preferencias utilizadas. |

El cuestionario y el seguimiento de progreso aún no están implementados.

<details>
<summary>Tecnologías y procedencia de los datos</summary>

| Componente | Versión declarada |
| --- | --- |
| .NET / ASP.NET Core | 10 |
| EF Core Design / dotnet-ef | 10.0.12 |
| Npgsql EF Core | 10.0.3 |
| Pgvector.EntityFrameworkCore | 0.3.0 |
| PostgreSQL | Extensiones `vector` y `pg_trgm`. |
| Worker | Python, FastAPI y sentence-transformers. |

Las versiones se declaran en [el proyecto](CodeQuest2026.Server.csproj). El backend
se compila de forma independiente; el cliente React está en `../frontend`.

El catálogo tiene relaciones muchos a muchos mediante `course_categories` y
`course_tags`, metadatos públicos con fuente y fecha, e índices de filtrado.
Los registros `inferred-seed-v1` son datos de prueba, no temarios ni requisitos
confirmados. El seed conserva los metadatos previamente completados.
Cada curso puede tener un embedding; las migraciones no generan los vectores.

</details>

<a id="inicio-rapido"></a>

## Inicio rápido

Ejecutar los comandos en **PowerShell desde `backend/`**, salvo donde se indique.

### 1. Preparar los requisitos

- SDK de .NET 10.
- PostgreSQL con `vector` y `pg_trgm`, y permisos para aplicar las migraciones.
- Python 3.10+ y [dependencias del worker](embedding-worker/README.md#instalación).
- [Credenciales de Discord](docs/DISCORD_OAUTH.md) para las rutas autenticadas.
- Clave de Groq si se desea aplicar el refinamiento V2.

Node.js y npm son necesarios solo para ejecutar o compilar el frontend.
Instalar el paquete NuGet de pgvector no instala la extensión de PostgreSQL.

### 2. Configurar el backend

```powershell
$env:ASPNETCORE_ENVIRONMENT = 'Development'
$env:ConnectionStrings__DefaultConnection = 'Host=localhost;Port=5432;Database=codequest2026;Username=TU_USUARIO;Password=TU_PASSWORD'
$env:EmbeddingService__Url = 'http://127.0.0.1:8765/'

# Opcional: refinamiento de la V2
$env:Groq__ApiKey = 'TU_CLAVE_GROQ'
$env:Groq__Model = 'openai/gpt-oss-20b'
```

Configurar también Discord según [su guía](docs/DISCORD_OAUTH.md). La URL del worker
y el modelo de Groq del ejemplo son los predeterminados. Las variables de entorno
prevalecen sobre `appsettings.json`; también se puede usar .NET User Secrets.
El backend no carga archivos `.env` automáticamente. No guardar claves reales en el repositorio.

### 3. Compilar y aplicar las migraciones

```powershell
dotnet tool restore --tool-manifest dotnet-tools.json
dotnet restore CodeQuest2026.Server.csproj
dotnet build CodeQuest2026.Server.csproj --no-restore
dotnet ef database update --context AppDbContext --no-build
```

Las migraciones crean el esquema y los seeds. La aplicación no migra al iniciar.
El archivo histórico `../database/seeds/Seed Courses.sql` no debe ejecutarse sobre
el esquema actual. Más información en [Migraciones](docs/MIGRATIONS.md).

### 4. Indexar cursos e iniciar el worker

En una terminal con el entorno Python del worker activado:

```powershell
$env:DATABASE_URL = 'postgresql://TU_USUARIO:TU_PASSWORD@localhost:5432/codequest2026'
python embedding-worker/embedding_cli.py index
python embedding-worker/embedding_cli.py serve
```

Usar la misma base de datos que .NET. `index` es una tarea puntual; `serve` permanece
activo en `127.0.0.1:8765`. El modelo se descarga en el primer uso.
Ver [instalación y opciones del worker](embedding-worker/README.md).

### 5. Iniciar la API

En la terminal donde se configuró el backend:

```powershell
dotnet run --project CodeQuest2026.Server.csproj --no-build --no-launch-profile --urls http://localhost:5107
```

Abrir [Swagger](http://localhost:5107/swagger) para explorar los endpoints.

<details>
<summary>Perfil HTTPS y frontend local</summary>

```powershell
dotnet dev-certs https --trust
dotnet run --project CodeQuest2026.Server.csproj --no-build --launch-profile https
```

El perfil escucha en `https://localhost:7281` y `http://localhost:5107`.
El frontend se ejecuta por separado desde `frontend/` con `npm install` y
`npm run dev`. Configurar `Cors:AllowedOrigins` para su origen; el valor local es
`http://localhost:5173`.

</details>

<a id="api-y-flujo"></a>

## API y flujo de uso

**Iniciar sesión → guardar preferencias → consultar una propuesta → guardar la ruta.**

| Método | Endpoint | Función |
| --- | --- | --- |
| GET | `/auth/discord` | Iniciar sesión con Discord. |
| GET | `/auth/me` | Consultar la sesión. |
| GET / PUT | `/users/me/preferences` | Consultar o guardar preferencias. |
| GET | `/routes/recommendation/semantic` | Obtener una propuesta semántica. |
| GET | `/routes/recommendation/semantic/v2` | Refinar el orden y las razones con IA. |
| POST | `/routes` | Guardar la propuesta elegida. |
| GET | `/routes` | Listar las rutas guardadas. |
| GET | `/routes/{routeId}` | Consultar una ruta propia. |

Las preferencias y rutas requieren sesión de Discord. Las dos recomendaciones
son **vistas previas**: para persistir una, enviar su `method` como
`recommendationMethod`, junto con `explanation` y `courses` (IDs y razones) a
`POST /routes`. Se acepta de 1 a 30 cursos activos, sin duplicados, en el orden
solicitado. La respuesta es `201 Created` con un encabezado `Location`.

<details>
<summary>Sesión, respuestas y errores</summary>

`isNewUser` en `/auth/me` y `/users/me` es verdadero hasta guardar las preferencias.
Para probar rutas protegidas en Swagger, completar `/auth/discord` en el mismo
navegador. La cookie HttpOnly se envía automáticamente.

La propuesta semántica incluye `method`, `goal`, `explanation` y `courses`.
La V2 agrega `refinementStatus` y `model`; estos indican si se aplicó IA.
Los errores usan `{ "error": "código", "message": "descripción" }`.
Los errores inesperados devuelven HTTP 500 con `internal_error` y se registran
sin exponer detalles internos al cliente.

</details>

<a id="estrategia"></a>

## Estrategia de recomendación

El motor `semantic-graph-v6` selecciona hasta seis cursos. El grafo representa
**asociaciones temáticas del catálogo**, no dependencias obligatorias entre cursos.

```mermaid
flowchart TD
    C["Cursos + metadatos"] --> E["Embeddings locales en pgvector"]
    P["Objetivo + intereses + experiencia"] --> Q["Embedding de consulta"]
    E --> S["Búsqueda por coseno y filtro de idioma"]
    Q --> S
    S --> G["Asociaciones categoría-tag"]
    G --> R["82 % semántica + 18 % asociaciones"]
    R --> O["Selección y orden según preparación"]
    O --> V1["Propuesta semántica"]
    V1 --> AI["V2: refinamiento con IA y validación JSON"]
    AI --> V2["Propuesta refinada o propuesta original si falla"]
```

| Etapa | Estrategia |
| --- | --- |
| Indexación | Texto del curso → vector normalizado; hash SHA-256 para evitar regeneraciones sin cambios. |
| Recuperación | Coseno sobre todos los cursos activos compatibles con modelo, dimensiones e idioma. |
| Grafo | Coocurrencias categoría–tag calculadas en memoria sobre los candidatos. |
| Selección | Relevancia híbrida, diversidad temática y requisitos pendientes. |
| Orden | Tema central, nivel publicado, preparación y relevancia. |
| V2 | Reorganiza los mismos cursos y personaliza las razones con un esquema estricto. |

<details>
<summary>Detalle técnico: embeddings, preferencias, grafo, fórmulas y orden pedagógico</summary>

### 1. Construcción e indexación de embeddings

[`course_text`](embedding-worker/embedding_service.py) prepara un texto etiquetado
por curso con título, nivel, categorías y tags. Categorías y tags se ordenan para
mantener estable la representación. Descripción, temario, resultados, habilidades,
requisitos y público se incorporan cuando el origen no es `inferred-seed-v1` y hay
una URL de fuente o una fecha de verificación. Los campos vacíos se omiten.

`EmbeddingService` carga `Qwen/Qwen3-Embedding-0.6B` mediante `sentence-transformers`
y genera vectores normalizados. El identificador almacenado incluye modelo,
revisión y versión del texto: `hf/{modelo}@{revision}/course-text-v1`.

[`embedding_cli.py index`](embedding-worker/embedding_cli.py) calcula un SHA-256
del texto de cada curso activo. Si coinciden el identificador del modelo y el hash
almacenados, omite la generación; en otro caso actualiza el vector, dimensiones,
hash y fecha en `course_embeddings`. Para reproducibilidad conviene fijar una
revisión del modelo: el valor predeterminado `main` puede cambiar sin que cambie
el identificador guardado. Si cambia la preparación del texto, se debe versionar
su formato y volver a indexar.

### 2. Consulta semántica y uso de las preferencias

El worker construye el texto de consulta con objetivo, intereses y experiencia.
Le añade la instrucción de recuperación
`Represent the learning goal for retrieving relevant courses` y lo convierte en
un vector con el mismo modelo utilizado para los cursos.

| Preferencia | Uso en la recomendación |
| --- | --- |
| Objetivo e intereses | Embedding de consulta y detección de categorías y temas. |
| Experiencia declarada | Embedding de consulta; el motor híbrido no le asigna otro peso explícito. |
| Habilidades previas | Preparación, selección y orden; no forman parte del embedding de consulta. |
| Idioma preferido | Filtro de cursos antes de construir las asociaciones. Se permiten cursos sin idioma registrado. |
| Minutos por semana | Estimación de semanas de contenido; no elimina cursos por duración. |

[`GetSemanticRecommendationQuery`](Application/Routes/Queries/GetSemanticRecommendationQuery.cs)
calcula en PostgreSQL `similitud = 1 - distancia_coseno` para todos los cursos
activos con modelo y dimensiones compatibles que pasan el filtro de idioma.
No limita primero a los vecinos más próximos: las asociaciones y la selección
posterior necesitan observar todo ese conjunto. La búsqueda actual es exacta,
sin índice HNSW ni umbral mínimo de similitud.

### 3. Construcción del grafo de asociaciones

Las relaciones persistidas son **curso–categoría** y **curso–tag**. En cada consulta,
el motor construye en memoria una proyección **categoría–tag** a partir de los
cursos candidatos. No se almacena un grafo adicional ni se ejecuta un recorrido
de dependencias entre cursos.

Para cada candidato se cuenta una aparición de sus categorías y tags, y una
coocurrencia por cada par categoría–tag presente en él. Si un curso pertenece a
Backend y tiene el tag Python, aumenta el contador del par `(Backend, Python)`.
Estos contadores se calculan sobre el conjunto filtrado de la consulta; cambiar
el idioma o los cursos disponibles puede cambiar las asociaciones.

El objetivo y los intereses se normalizan sin mayúsculas ni acentos, con nombres
como `c#`, `.net` y `node.js` normalizados. Una categoría mencionada directamente
recibe peso `1`; la expansión `web → frontend/backend` recibe `0.45`. Los tags
coincidentes reciben `1`, incluido el alias `js → javascript`.

Sin intención compuesta, `graphScore` toma la mayor coincidencia de categoría o tag;
una palabra específica compartida con el título puede elevarlo a `1`. Si todavía
es menor que `1`, se consideran asociaciones indirectas:

```text
Desde una categoría solicitada hacia un tag del curso:
  asociación = 0.4 × peso_categoría × coocurrencias(categoría, tag) / frecuencia(tag)

Desde un tag solicitado hacia una categoría del curso:
  asociación = 0.4 × peso_tag × coocurrencias(categoría, tag) / frecuencia(categoría)
```

Se conserva el máximo entre la coincidencia inicial y estas asociaciones; no se
suman todas las coincidencias. Así, acumular tags no aumenta por sí solo la puntuación.

Cuando se reconoce una **categoría y un tema**, se sustituye ese cálculo por:

| Relación del curso con la intención | graphScore |
| --- | ---: |
| Coincide con tema y dominio | 1.00 |
| Coincide con tema y pertenece a Fundamentos | 0.85 |
| Coincide solo con dominio | 0.35 |
| Coincide solo con tema | 0.15 |
| No coincide | 0.00 |

El tema se reconoce por tags; el dominio, por categorías o términos de dominio
en el título. Si el objetivo nombra tags concretos, estos prevalecen sobre otros
intereses al definir el tema central. Mencionar una tecnología como requisito no
demuestra que el curso la enseñe. El grafo expresa asociaciones temáticas, no
prerrequisitos obligatorios ni relaciones extraídas por un LLM.

### 4. Puntuación y selección de cursos

El motor combina ambas señales:

```text
semanticScore = clamp((similitud_coseno + 1) / 2, 0, 1)
score = 0.82 × semanticScore + 0.18 × graphScore
```

Un título que contiene `legacy` recibe una penalización de `0.08`, con mínimo `0`,
si el usuario no lo pidió en objetivo o intereses. `score` es relevancia relativa,
no una probabilidad ni un porcentaje de compatibilidad.

La selección es iterativa: en cada paso elige el curso con mayor valor de:

```text
selectionScore = score + bono_novedad - penalización_preparación
bono_novedad = 0.06 × proporción_de_tags_aún_no_cubiertos
penalización_preparación = 0.06 × proporción_de_requisitos_temáticos_pendientes
```

El bono es cero si el curso no tiene tags o su `graphScore` es cero. La proporción
de requisitos pendientes es cero cuando no se detectan requisitos. Tras elegir
un curso, se actualizan los tags cubiertos y las habilidades atribuidas a la ruta.
Los empates se resuelven por menor ID de curso.

Si hay intención compuesta con tema explícito en el objetivo y existen cursos
centrales (`graphScore >= 0.8`), se excluyen los candidatos por debajo de `0.35`
y se permite como máximo un complemento entre `0.35` y `0.8`. La ruta puede
tener menos de seis cursos.

### 5. Orden pedagógico y requisitos

La selección se reordena tomando las habilidades iniciales del usuario y
actualizándolas después de cada curso. Las prioridades son, en este orden:

1. Cursos centrales antes que complementarios cuando existe intención compuesta.
2. Nivel publicado: principiante, intermedio y avanzado; valores desconocidos se
   ubican en el grupo intermedio.
3. Menor proporción de requisitos temáticos pendientes.
4. Mayor `score` y, como desempate, menor ID.

Los requisitos se detectan mediante coincidencias textuales con temas del catálogo
en frases de conocimiento, excluyendo formulaciones negativas u opcionales. Esta
heurística exige metadatos verificados y origen distinto de `inferred-seed-v1`.
La propagación de habilidades usa `SkillsTaught` y tags presentes en el título
que no figuren como requisito de conocimiento, bajo la misma condición de verificación.

Ese estado representa una progresión sugerida, no cursos completados realmente.
Los requisitos pendientes se muestran en las razones y no bloquean cursos. No hay
una ordenación topológica ni garantía de que todos los prerrequisitos queden cubiertos.
Las semanas estimadas son `ceil(duración_minutos / minutos_semanales)` cuando ambos
valores son positivos; en otro caso son `null`.

### 6. Refinamiento y explicación con IA

La V2 entrega los cursos seleccionados y las preferencias a `RouteRefinementService`.
El proveedor recibe contexto textual y el JSON Schema, no los vectores ni todo el
catálogo. Puede reorganizar la selección y redactar razones, pero no agregar ni
quitar cursos. El backend conserva los datos originales y recalcula las posiciones
según el arreglo validado. Ante un fallo conserva la propuesta del motor semántico.

La validez estructural del JSON no acredita la calidad pedagógica de las razones.
Los pesos y heurísticas actuales deben evaluarse con perfiles y objetivos reales.
La implementación del cálculo está en
[`HybridSemanticRecommendationEngine`](Application/Routes/HybridSemanticRecommendationEngine.cs);
el contrato de generación y sus límites se describen en [la guía V2](docs/SEMANTIC_V2.md).

</details>

<a id="proveedores"></a>

## Proveedores de IA

`GroqProvider` implementa [IStructuredAiProvider](Application/Common/AI/IStructuredAiProvider.cs)
y se registra como servicio **scoped**, con `HttpClient` administrado, en
[ServiceCollectionExtensions.cs](Extensions/ServiceCollectionExtensions.cs).
`RouteRefinementService` prepara el contexto y valida el resultado.

| Ajuste | Valor actual |
| --- | --- |
| Proveedor registrado | Groq |
| Modelo predeterminado | `openai/gpt-oss-20b` |
| Credencial | `Groq__ApiKey` |
| Modelo configurable | `Groq__Model` |
| Tiempo límite | 30 segundos |
| Límite de salida | 2500 tokens |
| Caché / reintentos automáticos | No incluidos |

La V2 valida el [JSON Schema](Application/Routes/route-refinement.schema.json)
y los IDs antes de aplicar cambios. Si se aplica Groq, devuelve
`method: semantic-groq-v2` y `refinementStatus: applied`. Si falta la clave o falla
la IA, conserva la propuesta semántica original. Los fallos del worker de embeddings
siguen siendo errores del flujo previo.

Para cambiar de proveedor, sustituir su registro en código. `OpenAiProvider` está
disponible y usa `OpenAI:ApiKey` y `OpenAI:Model`; no existe un selector por variable
de entorno. Ver [contrato, configuración y estados de la V2](docs/SEMANTIC_V2.md).

<a id="estructura"></a>

## Estructura del proyecto

```text
Application/
  Common/AI/                       Contrato común de proveedores
  Routes/                          Motor, refinamiento, DTOs y JSON Schema
    Queries/                       Búsquedas y consultas de rutas
    Commands/                      Guardado de rutas
Controllers/                       Endpoints HTTP
Extensions/                        Registro de servicios
Infrastructure/
  DataSource/                      Entidades, EF Core, migraciones y seeds
  Embeddings/                      Cliente HTTP del worker
  Groq/                            Proveedor de IA registrado
  OpenAI/                          Implementación alternativa
embedding-worker/                  Indexación local y API FastAPI
tests/CodeQuest2026.Server.Tests/   Pruebas del backend
docs/                              Guías específicas
```

<a id="docker"></a>

## Docker

La imagen reúne frontend y API .NET. **PostgreSQL y el worker se ejecutan por separado.**

<details>
<summary>Comandos de construcción, ejecución y configuración de red</summary>

### Construir y ejecutar la imagen

El `Dockerfile` está en la raíz de la solución, junto a `CodeQuest2026.slnx`.
Desde esa carpeta:

```powershell
docker build -t codequest:local .
$env:ConnectionStrings__DefaultConnection = 'Host=host.docker.internal;Port=5432;Database=codequest2026;Username=TU_USUARIO;Password=TU_PASSWORD'
docker run --rm --name codequest -p 5107:8080 -e ConnectionStrings__DefaultConnection codequest:local
```

La etapa Node.js ejecuta `npm ci` y `npm run build`. Su carpeta `dist` se copia a
`backend/wwwroot` dentro de la construcción, antes de `dotnet publish`, para generar
el manifiesto de recursos estáticos. La imagen final sirve React y la API mediante
ASP.NET Core, sin necesitar Node.js en ejecución. No se genera `wwwroot` en el equipo anfitrión.
`VITE_API_BASE_URL=/` se establece durante la compilación para que React consulte la
API en el mismo origen. Se puede cambiar con `--build-arg VITE_API_BASE_URL=https://tu-api`.

Abrir `http://localhost:5107/` para el frontend y `/health/api` para comprobar la API.
La ejecución usa Production y HTTP en el puerto interno 8080. HTTPS requiere un proxy
que termine TLS o certificados configurados por separado. Las migraciones de la base
de datos se aplican por separado.

Los archivos `appsettings*.json` y `.env*` se excluyen de la imagen; proporcionar la
configuración mediante variables de entorno. `host.docker.internal` apunta al equipo
anfitrión en Docker Desktop; para PostgreSQL remoto, usar su hostname.

El worker de embeddings se ejecuta por separado y no está incluido en esta imagen.
Configurar `EmbeddingService__Url` con una dirección accesible desde el contenedor
y pasar `Groq__ApiKey` para habilitar el refinamiento V2. `127.0.0.1` dentro del
contenedor apunta al propio contenedor, no al worker del equipo anfitrión.

</details>

<a id="pruebas"></a>

## Pruebas y comprobaciones

Desde `backend/`:

```powershell
dotnet test tests/CodeQuest2026.Server.Tests
Invoke-WebRequest http://localhost:5107/health/api
Invoke-WebRequest http://localhost:5107/health/db
```

| Ruta | Comprobación |
| --- | --- |
| `/health/api` | Disponibilidad de la API. |
| `/health/db` | Conexión con PostgreSQL. |
| `/health` | Todos los health checks. |
| `/swagger` | Panel de pruebas, solo en Development. |
| `/openapi/v1.json` y `/swagger/v1/swagger.json` | Documentos OpenAPI, solo en Development. |

Las pruebas de Groq y OpenAI simulan HTTP y no requieren claves ni consumen crédito.
Cubren esquema, conservación de cursos y manejo de fallos. Las pruebas del worker
están en `embedding-worker/test_embedding_service.py`; ver [su guía](embedding-worker/README.md).

Un health check correcto no verifica migraciones ni embeddings. La conexión real
con los proveedores, la inferencia del modelo y la calidad pedagógica requieren
validación en el entorno de destino.

<a id="documentacion"></a>

## Documentación

| Guía | Contenido |
| --- | --- |
| [Discord OAuth](docs/DISCORD_OAUTH.md) | Credenciales, sesión y pruebas. |
| [Migraciones](docs/MIGRATIONS.md) | Crear, aplicar y revertir cambios de base de datos. |
| [Metadatos](Infrastructure/DataSource/CourseMetadata.md) | Procedencia y datos inferidos de prueba. |
| [Embeddings](Infrastructure/DataSource/CourseEmbeddings.md) | Configuración, indexación y consulta por coseno. |
| [Worker](embedding-worker/README.md) | Instalación y ejecución de FastAPI. |
| [Recomendaciones](docs/RECOMMENDATIONS.md) | Flujo semántico y guardado de rutas. |
| [V2 y proveedores](docs/SEMANTIC_V2.md) | Contrato común, esquema y estados de respuesta. |
| [Changelog](CHANGELOG.md) | Historial de cambios. |
| [Colaboración](../CONTRIBUTING.md) | Reglas del repositorio. |
