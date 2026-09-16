# Layout y navegación

La rama `feat/app-layout` integra la base de i18n para reutilizar las traducciones del PR correspondiente.

## Estructura

- `AppLayout`: cabecera, navegación, selector de idioma, contenido y pie de página.
- `SectionPage`: referencias temporales para Inicio, Catálogo y Mi ruta. No consulta datos ni simula progreso. Sustituir su contenido al implementar cada funcionalidad.
- `PageState`: estados reutilizables `loading`, `empty` y `error`. El estado de error exige una función `onRetry`; cada consulta debe pasar su propia función de reintento.
- `ContentBoundary`: captura errores de renderizado del contenido y permite reintentarlo manteniendo la navegación disponible. Se reinicia al cambiar de ruta. Los errores de peticiones asíncronas deben tratarse en la funcionalidad que las ejecuta.

## Rutas

| URL | Sección |
| --- | --- |
| `/` | Inicio |
| `/catalog` | Catálogo |
| `/my-path` | Mi ruta |
| Cualquier otra | Página no encontrada con regreso al inicio |

No se implementa autenticación en esta tarea. Mi ruta es una referencia temporal, no una pantalla de datos privados.

## Accesibilidad y estilos

Se reutilizan tokens y el logo oficial, conservando sus proporciones. La navegación móvil se despliega debajo de la cabecera a partir de 52rem hacia abajo. Incluye `aria-expanded`, navegación activa, cierre con Escape y retorno del foco al botón. Los cambios de ruta llevan el foco al contenido; existe un enlace para saltar la navegación. Se respeta la preferencia de movimiento reducido. Todos los textos nuevos están en español e inglés.

## Validación

Compilación de producción, TypeScript y ESLint completados. Pendiente la comprobación visual e interactiva en navegador: la sesión de vista previa no conservó la pestaña creada durante la revisión.

Comprobar en escritorio y en 320/390px: abrir/cerrar menú, Escape, navegación por teclado, enlace activo, cambio de idioma y persistencia al recargar, acceso directo a rutas y regreso desde la página 404. Probar el estado de error con un fallo controlado de renderizado y el de carga al integrar una petición real.

La pantalla técnica `ApiStatusPage` se conserva en el código; la página inicial ahora pertenece al layout del producto. Los endpoints del backend no cambian.
