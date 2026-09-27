# Arquitectura de CODE QUEST

## Frontend

- `features/<dominio>/`: pantalla, componentes específicos, hooks, tipos y llamadas a la API de un dominio.
- `components/ui/`: componentes reutilizables que no conocen una funcionalidad concreta.
- `components/layout/`: estructura global, navegación y límites de errores.
- `pages/`: adaptadores de rutas; no contienen lógica de negocio.
- `config/`: configuración transversal, como la URL de la API.
- `i18n/locales/`: todo texto visible debe existir en español e inglés.
- `assets/`: un asset canónico por propósito. Los recursos de marca viven en `assets/codequest`, los de interfaz en `assets/portal` y las banderas en `assets/flags`.

Los componentes no llaman `fetch` directamente. Cada feature usa una carpeta `api/` para sus solicitudes y una carpeta `hooks/` para estados de carga, error y reintento.

## Backend

- `Application/<dominio>/`: DTOs, comandos, consultas y lógica de aplicación.
- `Controllers/`: reciben HTTP, validan los límites de entrada y delegan en Application.
- `Infrastructure/DataSource/`: entidades, configuraciones de Entity Framework, contexto y migraciones.

Los endpoints paginados usan `PagedResultDto<T>`. El cliente debe consumir `items`, `page`, `totalPages` y los indicadores de página siguiente/anterior, en lugar de descargar el catálogo completo.

## Convenciones

- Una responsabilidad por archivo y nombres según intención: `getCatalogCourses`, `useCatalogCourses`, `CatalogPagination`.
- Los componentes de una feature pueden depender de su propia API y tipos; los componentes de `ui` no.
- No duplicar modelos de respuesta: un tipo se define una vez dentro de su feature.
- Estados de carga, vacío y error forman parte de cada pantalla que consume datos remotos.
- Toda funcionalidad nueva debe funcionar en español e inglés, tema claro y oscuro, y móvil.
