# Límites del frontend

Estas convenciones acompañan la revisión en `frontend-review.md`. El diseño, los contratos de API y las claves de almacenamiento existentes se conservan.

## Imports y barrels

- `./` para archivos vecinos; `@/` para atravesar carpetas. El alias ya existía en Vite y TypeScript.
- Los barrels representan una API pública pequeña: `components/ui` para controles compartidos y `features/catalog` para carga, tipos y niveles del catálogo.
- No exportar páginas desde barrels de datos: las rutas mantienen sus imports diferidos.
- Dentro de un módulo, importar su implementación directamente para evitar volver a entrar por su propio barrel.
- No añadir `index.ts` a cada carpeta. Los barrels de auth/rutas existentes siguen disponibles; sus consumidores internos usan imports explícitos.

## Constantes con significado

| Concepto | Propietario |
| --- | --- |
| Direcciones de navegación | `src/config/navigation.ts` |
| Endpoints de rutas e IDs codificados | `features/routes/api/paths.ts` |
| Límites, método manual, almacenamiento y evento | `features/routes/model/constants.ts` |
| Códigos de error y claves de traducción | `features/routes/model/routeError.ts` |

Clases CSS, valores únicos de layout y estados tipados locales no necesitan un archivo global de constantes. El límite de tecnologías del cuestionario no es el límite de cursos de una ruta.

## Responsabilidades extraídas

| Unidad | Responsabilidad |
| --- | --- |
| `useCourseReorder` | Orden provisional, destino y confirmación del arrastre; compartido por propuesta y detalle |
| `useCourseDragPreview` | Imagen de arrastre, desplazamiento y limpieza de recursos del DOM |
| `useManualRoute` | Borrador manual y guardado protegido contra envíos simultáneos |
| `manualRoute.ts` / `reorderCourses.ts` | Transformaciones puras, inmutables y probadas |
| `ManualCourseCatalog` | Búsqueda, carga, reintento y selección del catálogo |
| `ManualCourseSelection` | Orden, eliminación y acción de guardar |
| `QuestionOptions` / `validation.ts` | Opciones del cuestionario y reglas de completitud |
| `useRouteError` | Traducción consistente y actualización de sesión ante 401; 403 conserva la sesión |

Tamaño de los archivos respecto a `19ec6e4` (líneas, no una medida de calidad por sí sola):

| Archivo | Antes | Después |
| --- | ---: | ---: |
| MyPathPage | 474 | 354 |
| SavedRouteDetailPage | 396 | 329 |
| QuestionnairePage | 492 | 390 |
| RouteCourseItem | 300 | 151 |
| ManualRoutePage | 96 | 71 |

## Traducciones y verificación

- ES define el contrato de claves; TypeScript exige que EN tenga la misma estructura.
- Las pruebas comprueban claves no vacías, placeholders coincidentes, textos JSX/nombres accesibles estáticos y ausencia de ciclos en imports estáticos de ejecución.
- Tema, progreso, vista de desarrollo y niveles conocidos usan i18next. Códigos conocidos del servidor se traducen; errores desconocidos tienen un mensaje localizado seguro.
- Marcas, tecnologías, nombres de cursos, notas y explicaciones recibidas del servidor conservan su contenido. Traducir ese contenido exige soporte de datos; no se inventa una traducción ni un nivel para valores desconocidos.
- Las claves de almacenamiento no cambian. Las pruebas verifican compatibilidad de sus valores y orden de los payloads.

Validación: lint, typecheck, 30 pruebas y build correctos. El build todavía avisa de un chunk principal mayor de 500 kB (507.10 kB; gzip 160.28 kB).

Fixture local comprobada en Strict Mode: orden mediante eventos de arrastre, guardado, selección manual, cambio ES/EN sin perder el formulario y navegación a la colección. Todas las peticiones quedan en memoria. Son comprobaciones asistidas, no E2E automatizados; el arrastre físico entre navegadores sigue necesitando prueba manual.

## Siguiente etapa

1. Separar la captura cancelable de imágenes compartidas y probar cierre durante descarga (F18).
2. Aislar las animaciones/mediciones del cuestionario; su página todavía concentra el ciclo de entrada.
3. Completar navegación por teclado del orden y del selector de idioma (F13/F19).
4. Ordenar CSS por propietario y medir el bundle antes de dividirlo más; no añadir caché o memoización sin evidencia.
