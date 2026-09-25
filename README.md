<p align="center">
  <img src="frontend/src/assets/brand/codequest-2026-mission.png" alt="CODE QUEST 2026" width="420" />
</p>

<h1 align="center">CODE QUEST 2026</h1>

<p align="center">
  Una forma de convertir tus objetivos en una ruta de aprendizaje clara, con cursos reales de DevTalles.
</p>

<p align="center">
  <a href="#qué-es-code-quest">Conoce el proyecto</a> ·
  <a href="#qué-puedes-hacer">Funcionalidades</a> ·
  <a href="#cómo-está-construido">Arquitectura</a> ·
  <a href="#ponerlo-en-marcha">Instalación</a>
</p>

## Qué es CODE QUEST

CODE QUEST ayuda a elegir **qué aprender y en qué orden**. Puedes responder un cuestionario para recibir una ruta recomendada según tu meta, experiencia e intereses, o construir una ruta manualmente con los cursos del catálogo. Después puedes guardarla, ajustarla y seguir tu avance desde un mismo lugar.

Los cursos se estudian en **DevTalles**: CODE QUEST organiza el recorrido, pero no aloja las clases ni sincroniza automáticamente el progreso con la plataforma de cursos.

## Qué puedes hacer

| Área | Experiencia |
| --- | --- |
| Descubrir | Explorar el catálogo de cursos y consultar su información disponible. |
| Personalizar | Iniciar sesión con Discord y completar un perfil con intereses, conocimientos y objetivo. |
| Crear | Generar una propuesta recomendada o elegir y ordenar cursos para crear una ruta manual. |
| Avanzar | Guardar varias rutas, editar sus cursos y marcar cada uno como **No iniciado** o **Completado**. |
| Organizar | Escribir una nota y asignar prioridad normal, media o alta a cada curso. |
| Ajustar | Reemplazar cursos de una ruta y conservar su lugar dentro del recorrido. |
| Compartir | Ver una vista previa y descargar el mapa de la ruta como PNG horizontal, cuadrado o vertical 9:16. Las rutas largas se dividen en varias imágenes. |

La interfaz está disponible en **español e inglés**, con **tema claro y oscuro** y diseño adaptable a móvil y escritorio.

### Un recorrido típico

1. Entras a CODE QUEST y accedes con Discord.
2. Indicas qué quieres aprender y tu punto de partida.
3. Revisas la propuesta de cursos, o creas una ruta desde cero.
4. Guardas la ruta y marcas los cursos que completas.
5. Añades notas, ajustas prioridades y compartes tu mapa cuando quieras.

## Cómo está construido

```text
Navegador (React + TypeScript)
       │
       ├── rutas y progreso ──> API ASP.NET Core ──> PostgreSQL
       │                              │                    └── pgvector: búsqueda semántica
       ├── notas y prioridades ──> localStorage
       └── imágenes PNG ──> generación en el navegador
                                      │
                                      ├── FastAPI + modelo local de embeddings
                                      └── Groq (refinamiento opcional de la recomendación)
```

| Pieza | Responsabilidad |
| --- | --- |
| **Frontend** | React, TypeScript, Vite y React Router para pantallas, navegación y edición de rutas. `i18next` gestiona los dos idiomas. |
| **API** | ASP.NET Core 10 expone el catálogo, autenticación, preferencias, recomendaciones y rutas guardadas. |
| **Datos** | PostgreSQL y Entity Framework Core conservan usuarios, catálogo, rutas y progreso. `pgvector` permite comparar cursos y preferencias. |
| **Embeddings** | Un servicio Python/FastAPI genera los vectores del catálogo y de las preferencias con un modelo local. |
| **IA opcional** | Groq puede refinar el orden y las explicaciones de una propuesta; si no está disponible, se mantiene la recomendación semántica. |

### Decisiones que importan

- **El usuario decide cuándo guardar.** La recomendación es una propuesta editable; no se convierte en ruta guardada hasta confirmarla.
- **El progreso tiene dos estados en la interfaz.** Cada curso se marca como No iniciado (0 %) o Completado (100 %); el resumen de la ruta se calcula a partir de esos cursos.
- **Notas y prioridades son personales y locales.** Se asocian a la ruta y al curso en `localStorage`; no viajan a la API ni se sincronizan entre dispositivos.
- **La recomendación no depende por completo de la IA generativa.** El motor semántico selecciona cursos; el refinamiento con Groq es opcional y tiene una alternativa cuando falla.
- **El contenido sigue en su origen.** CODE QUEST enlaza a los cursos de DevTalles y no copia ni distribuye sus clases.

## Organización del repositorio

```text
frontend/
  src/features/          Autenticación, catálogo, cuestionario y rutas
  src/components/        Componentes compartidos y estructura de la app
  src/styles/            Tokens y estilos globales
  src/i18n/              Textos en español e inglés
  src/assets/            Identidad e ilustraciones
backend/
  Controllers/            Endpoints HTTP
  Application/            Casos de uso, recomendaciones y contratos
  Infrastructure/         Persistencia, migraciones y proveedores externos
  embedding-worker/       Indexación y API de embeddings en Python
  tests/                  Pruebas de la API
database/seeds/           Material de referencia del catálogo
docs/                    Guías de arquitectura, diseño e internacionalización
```

## Ponerlo en marcha

Este ejemplo usa **PowerShell** y ejecuta PostgreSQL en Docker; la API, el worker y el frontend se inician por separado para facilitar el desarrollo. Necesitas Docker, **.NET 10**, Node.js con npm, **Python 3.10+** y una aplicación de Discord OAuth para probar las funciones protegidas.

### 1. Iniciar PostgreSQL

Desde la raíz del repositorio:

```powershell
Copy-Item .env.example .env
# Cambia POSTGRES_PASSWORD en .env por una contraseña local.
docker compose up -d postgres
```

El archivo `.env` de la raíz configura **Docker Compose**; la API .NET no lo carga automáticamente. Si cambias el puerto, usuario o nombre de la base, ajusta también las conexiones de los pasos siguientes.

### 2. Preparar la base de datos e iniciar la API

En otra terminal, desde `backend/`:

```powershell
$env:ConnectionStrings__DefaultConnection = 'Host=localhost;Port=5432;Database=codequest2026;Username=codequest;Password=TU_PASSWORD'
$env:DISCORD_CLIENT_ID = 'TU_CLIENT_ID'
$env:DISCORD_CLIENT_SECRET = 'TU_CLIENT_SECRET'
$env:ASPNETCORE_ENVIRONMENT = 'Development'

dotnet tool restore --tool-manifest dotnet-tools.json
dotnet ef database update --context AppDbContext
dotnet run --launch-profile http
```

Usa aquí la misma contraseña que configuraste en `.env`. Las migraciones crean el esquema y cargan el catálogo inicial; **no ejecutes por separado el SQL histórico de `database/seeds/`**. La API escucha en `http://localhost:5107`; Swagger está en `http://localhost:5107/swagger`.

### 3. Indexar cursos e iniciar el worker

En otra terminal, desde `backend/embedding-worker/`:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
$env:DATABASE_URL = 'postgresql://codequest:TU_PASSWORD@localhost:5432/codequest2026'

python embedding_cli.py index
python embedding_cli.py serve
```

La primera indexación descarga el modelo y puede tardar. El worker queda en `http://127.0.0.1:8765`; vuelve a ejecutar `index` cuando cambie el catálogo o el modelo. La API usa esa URL por defecto.

### 4. Iniciar el frontend

En otra terminal, desde `frontend/`:

```powershell
npm ci
npm run dev
```

Abre **http://localhost:5173**. Deja `VITE_API_BASE_URL` vacío para usar el proxy local de Vite; si necesitas una URL absoluta, configura `frontend/.env` a partir de `frontend/.env.example`.

Para el inicio de sesión, registra en la aplicación de Discord la URL de retorno que uses: `http://localhost:5173/auth/discord/callback` con el proxy de Vite, o `http://localhost:5107/auth/discord/callback` si entras directamente por la API. Consulta la [guía de Discord](backend/docs/DISCORD_OAUTH.md) para HTTPS y despliegue.

> **Refinamiento opcional:** configura `Groq__ApiKey` en la terminal de la API si quieres probar la recomendación refinada. Sin esa clave, la propuesta semántica sigue disponible.

### Docker Compose completo

`compose.yaml` también puede levantar PostgreSQL, el worker y la API con el frontend compilado. La base se **migra antes** del arranque completo y los cursos se **indexan explícitamente**. Los comandos y detalles de red están en el [README del backend](backend/README.md#docker). En producción, el inicio de sesión requiere una URL pública HTTPS.

## Verificaciones y más documentación

```powershell
# Desde frontend/
npm run lint
npm run build

# Desde la raíz
dotnet test CodeQuest2026.slnx
```

- [Backend, endpoints y recomendación](backend/README.md)
- [Worker de embeddings](backend/embedding-worker/README.md)
- [Arquitectura](docs/architecture.md) · [Sistema de diseño](docs/design-system.md) · [Idiomas](docs/i18n.md)
- [Migraciones](backend/docs/MIGRATIONS.md) · [Colaboración](CONTRIBUTING.md)

## Licencia y recursos de terceros

El código propio de este proyecto se publica bajo la [licencia MIT](LICENSE). Los nombres, logos, miniaturas y contenidos de terceros —incluidos los de DevTalles y sus cursos— pertenecen a sus respectivos titulares; su presencia aquí no concede derechos sobre esas marcas o materiales.
