# Revisión del frontend Learning Path

Fecha: 26 de septiembre de 2026. Rama: `review/frontend-maintainability`. Base: `20ca572`, desde `feature/landing-experience`, con Git limpio al comenzar. No se modificaron backend, migraciones, base de datos ni secretos. No se añadieron dependencias.

Las referencias de hallazgos corresponden a la **base original**: consultar `git show 20ca572:<archivo>`. Las líneas cambian después de las correcciones. No se encontró evidencia de P0 dentro del frontend inspeccionado; no es una certificación de seguridad del sistema completo.

## 1. Hallazgos, ordenados por severidad

### P1 - Alto — F01. Actualizaciones de progreso que se pisan

- **Archivo y línea:** `frontend/src/features/routes/pages/SavedRouteDetailPage.tsx:163`.
- **Comportamiento e impacto:** dos PATCH pueden solaparse. Cada respuesta sustituye la ruta completa; una respuesta tardía puede mostrar un estado anterior y un rollback puede deshacer otro cambio. No se afirma pérdida permanente en la base: el defecto está en el cliente.
- **Causa:** progreso no participa en `operation/locked`, sin exclusión entre PATCH, PUT y DELETE.
- **Solución:** guarda inmediata y controles deshabilitados durante cualquier mutación; preservar campos del borrador al aplicar progreso.
- **Estado:** corregido. Se comprobó el bloqueo en navegador con PATCH demorado.
- **Verificar:** completar cursos con latencia y guardar/reemplazar durante PATCH; no debe haber mutaciones solapadas y el estado debe coincidir con la respuesta vigente.

### P1 - Alto — F02. Cambiar idioma sobrescribe la edición

- **Archivo y línea:** `frontend/src/features/routes/pages/SavedRouteDetailPage.tsx:80`.
- **Comportamiento e impacto:** cambiar idioma recrea `translatedError`, dispara GET y hace `setDraft(next)`, perdiendo nombre, descripción y orden pendientes. Cambiar routeId también reutiliza transitoriamente el estado anterior.
- **Causa:** efecto de carga dependiente de presentación y objeto user, sin delimitar identidad de pantalla.
- **Solución:** cargar por identidad, `useEffectEvent` para error actualizado, cancelación y componente con key por usuario/ruta.
- **Estado:** corregido. En navegador, nombre pendiente conservado al cambiar idioma y sin GET adicional por idioma.
- **Verificar:** editar, cambiar idioma y navegar entre IDs con respuestas demoradas; no sobrescribir borrador ni mostrar ruta anterior durante carga.

### P1 - Alto — F03. Reemplazar guarda todo el borrador sin solicitarlo

- **Archivo y línea:** `frontend/src/features/routes/pages/SavedRouteDetailPage.tsx:188`.
- **Comportamiento e impacto:** en edición, reemplazar envía PUT del borrador entero y limpia modified. Nombre, eliminaciones y orden quedan persistidos antes de Guardar cambios; Cancelar no los revierte.
- **Causa:** mezcla de modificación local y persistencia inmediata.
- **Solución:** reemplazo local mientras se edita; persistencia inmediata fuera de edición. No heredar progreso ni motivo del curso anterior.
- **Estado:** corregido con helper puro y flujo de navegador: reemplazo no genera PUT; Guardar cambios sí.
- **Verificar:** editar nombre, reemplazar y cancelar; inspeccionar solicitudes y payload. Repetir guardando explícitamente.

### P1 - Alto — F04. Respuestas antiguas recuperan una sesión cerrada

- **Archivo y línea:** `frontend/src/features/auth/context/AuthSessionProvider.tsx:13`.
- **Comportamiento e impacto:** un GET /auth/me anterior a logout/401 puede resolver después y volver a poner user. Strict Mode también inicia trabajo sin descarte. Es inconsistencia de sesión del cliente; no prueba bypass de autorización del servidor.
- **Causa:** sin cancelación ni comprobación de vigencia; logout/401 solo cambian estado.
- **Solución:** coordinador de última solicitud, invalidación al logout/401 y limpieza al desmontar.
- **Estado:** corregido; pruebas automáticas del coordinador. OAuth real no ejecutado.
- **Verificar:** demorar /auth/me, cerrar sesión y resolver la consulta vieja; user debe permanecer null. Repetir con 401 y Strict Mode.

### P2 - Medio — F05. Fallo de sesión bloquea páginas públicas

- **Archivo y línea:** `frontend/src/App.tsx:28`.
- **Comportamiento e impacto:** un fallo de /auth/me reemplaza login y catálogo por error global, aunque son públicos, y elimina su navegación.
- **Causa:** disponibilidad de sesión aplicada como condición global del router.
- **Solución:** manejar error en ProtectedRoute y callback; permitir páginas públicas y evitar redirección del login con sesión no confirmada.
- **Estado:** corregido; verificación estática y compilación. Pendiente integración automatizada de router con sesión fallando.
- **Verificar:** /auth/me=503 y /courses=200; login/catálogo visibles y ruta protegida con reintento.

### P2 - Medio — F06. Rechazos sin manejo en alternativas y selección

- **Archivo y línea:** `frontend/src/features/routes/components/RouteReplaceDialog.tsx:31`; `frontend/src/features/routes/components/RouteCoursePickerDialog.tsx:21`.
- **Comportamiento e impacto:** async con finally sin catch, y cadena then/finally sin catch. Red caída deja lista vacía y rechazo sin manejar; no hay reintento útil.
- **Causa:** carga duplicada y estados sin representar error.
- **Solución:** hook con unión loading/error/ready, cancelación, descarte, vacío y reintento; compartirlo con constructor manual y picker.
- **Estado:** corregido; 503 y reintento exitoso comprobados en navegador.
- **Verificar:** abrir con fallo, reintentar y cerrar mientras carga; mensaje visible y ningún resultado obsoleto al desmontar.

### P2 - Medio — F07. Modales sin aislamiento del foco

- **Archivo y línea:** `frontend/src/features/routes/components/RouteNoteDialog.tsx:22`; también Replace, Picker y SharePreview.
- **Comportamiento e impacto:** div/section con role no encierra Tab ni vuelve consistentemente al disparador; algunos no responden a Escape.
- **Causa:** implementación modal repetida sin comportamiento compartido.
- **Solución:** Dialog nativo en portal, fondo inerte, ciclo Tab/Shift+Tab, Escape, foco inicial y restauración; impedir cierre mientras reemplazo guarda.
- **Estado:** corregido en cuatro diálogos. Teclado y retorno al disparador comprobados en navegador.
- **Verificar:** abrir con teclado, recorrer extremos en ambos sentidos, Escape y clic fuera; comprobar claro/oscuro y móvil.

### P2 - Medio — F08. JSON usado como si ya fuese un tipo interno

- **Archivo y línea:** `frontend/src/features/catalog/api/getCatalogCourses.ts:12`; `frontend/src/features/auth/api/session.ts:17`; `frontend/src/features/routes/api/routes.ts:71`.
- **Comportamiento e impacto:** catálogo y sesión usan aserciones sin validar; progreso inválido se convierte a cero. Datos malformados pueden romper render o producir estados falsos.
- **Causa:** TypeScript no valida JSON en ejecución; displayName era no nullable pese al contrato real.
- **Solución:** validar unknown en parsers puros, nullable reales, IDs seguros, fechas/progreso/paginación válidos y URLs http(s).
- **Estado:** corregido; strict activado y pruebas válidas/malformadas.
- **Verificar:** items:null, ID inválido, proveedor desconocido, displayName:null, fecha inválida y progreso fuera de rango; error comprensible sin crash.

### P2 - Medio — F09. Tres transportes HTTP inconsistentes

- **Archivo y línea:** `frontend/src/features/routes/api/routes.ts:114`; `frontend/src/features/catalog/api/getCatalogCourses.ts:8`.
- **Comportamiento e impacto:** fetch de rutas, catálogo y cliente común difieren en credenciales, ProblemDetails, aborto y 401; errores equivalentes generan comportamientos distintos.
- **Causa:** cada feature replica transporte y transformación de errores.
- **Solución:** cliente existente compartido; adaptador conserva RouteRequestError; conservar AbortError y detail del servidor.
- **Estado:** corregido; pruebas de ProblemDetails/aborto y transporte usado por fixture.
- **Verificar:** 401, 403, 422, HTML 502, JSON inválido y cancelación; revisar error de dominio, mensaje y ausencia de falso error de red.

### P2 - Medio — F10. Notas corruptas y almacenamiento bloqueado

- **Archivo y línea:** `frontend/src/features/routes/model/routeLocalState.ts:14` y `:24`; `frontend/src/features/routes/components/RouteNoteDialog.tsx:29` y `:32`.
- **Comportamiento e impacto:** registros internos sin validar pueden llevar una fecha inválida a Intl y lanzar RangeError. setItem puede fallar por cuota/política; guardar no lo captura.
- **Causa:** solo se valida el contenedor y se supone almacenamiento siempre disponible.
- **Solución:** validar cada nota/fecha/prioridad; conservar editor y texto al fallar, mostrar error y no anunciar éxito.
- **Estado:** corregido; tests de corrupción/escritura fallida y nota conservada en navegador.
- **Verificar:** entradas inválidas y setItem bloqueado: abrir funciona; guardar muestra error con el texto intacto.

### P2 - Medio — F11. Espaciado basado en tokens inexistentes

- **Archivo y línea:** `frontend/src/features/routes/pages/MyPathPage.css:945`, `:949`, `:1203`.
- **Comportamiento e impacto:** --cq-space-5, -7 y -10 no existían. padding/margin/clamp que los usan se invalidan y desaparece espaciado esperado.
- **Causa:** valores introducidos fuera del catálogo de tokens.
- **Solución:** completar escala y comprobar referencias automáticamente.
- **Estado:** corregido: 1.25rem, 1.75rem y 2.5rem; prueba de todos los tokens.
- **Verificar:** npm test; padding calculado del modal de notas 32px en escritorio y ancho móvil sin desbordamiento.

### P2 - Medio — F12. Cuestionario compartido entre cuentas

- **Archivo y línea:** `frontend/src/features/questionnaire/model/draft.ts:5` y `:49`; `frontend/src/features/questionnaire/pages/QuestionnairePage.tsx:57`.
- **Comportamiento e impacto:** otra cuenta en el mismo navegador puede heredar respuestas previas, porque la clave local no identifica propietario.
- **Causa:** load/saveQuestionnaireDraft no reciben usuario; propuestas sí validan userId.
- **Solución:** aislar por userId y definir migración de entradas antiguas sin propietario.
- **Estado:** pendiente. No se atribuyó propiedad ni se borró información antigua por suposición.
- **Verificar:** A contesta, sale, entra B: B no recibe respuestas de A; A recupera su propio borrador.

### P2 - Medio — F13. Reordenamiento sin alternativa de teclado

- **Archivo y línea:** `frontend/src/features/routes/components/RouteCourseItem.tsx:251`.
- **Comportamiento e impacto:** propuesta y detalle permiten ordenar solo con drag nativo; teclado no puede completar esa acción. Constructor manual sí ofrece flechas.
- **Causa:** contrato de movimiento limitado a onDrag*.
- **Solución:** acciones subir/bajar y helper de orden, conservar drag, foco y anuncios.
- **Estado:** pendiente como cambio de interacción separado.
- **Verificar:** ordenar solo con teclado y en dispositivo táctil; respetar límites y anunciar posición.

### P2 - Medio — F14. Generación viva fuera de su pantalla

- **Archivo y línea:** `frontend/src/features/routes/pages/MyPathPage.tsx:137`.
- **Comportamiento e impacto:** salir durante generación deja la promesa viva; respuesta actualiza componente desmontado. Persistir propuesta depende de un efecto que no se ejecutará; puede notificarse un resultado de pantalla abandonada.
- **Causa:** generación sin señal ni comprobación de vigencia/propietario al resolver.
- **Solución:** elegir continuación con persistencia por usuario o cancelación explícita; implementar política con identidad y abortos.
- **Estado:** pendiente; propuesta ya lista sí se conserva, generación que termina tras desmontar no.
- **Verificar:** demorar recomendación, cambiar a manual y volver; comprobar política elegida y ausencia de resultados de otra cuenta.

### P2 - Medio — F15. Responsabilidades y cascada acumuladas

- **Archivo y línea:** `frontend/src/features/routes/pages/MyPathPage.tsx:53`, `:375`; `frontend/src/features/routes/pages/SavedRouteDetailPage.tsx:301`; `frontend/src/features/routes/pages/MyPathPage.css:936`, `:976`, `:1241`.
- **Comportamiento e impacto:** MyPathPage (474 líneas), detalle (371), cuestionario (492) concentran carga, persistencia, edición, drag, foco y presentación. Reordenamiento/animación repetidos; CSS de rutas (1522 líneas) redefine menú/modales varias veces. Cambios locales exigen entender capas alejadas y facilitan regresiones.
- **Causa:** funcionalidad añadida a páginas monolíticas y overrides sobre overrides.
- **Solución:** caracterizar flujos, extraer controlador de edición/orden, separar colección/propuesta y CSS por responsabilidad manteniendo cascada.
- **Estado:** parcial: HTTP, parsers, carga y Dialog separados; división amplia pendiente.
- **Verificar:** guardar/cancelar/reordenar y capturas claro/oscuro/móvil tras cada extracción. No fragmentar JSX únicamente por tamaño.

### P2 - Medio — F16. Módulos funcionales en la carga inicial

- **Archivo y línea:** `frontend/src/App.tsx:10`.
- **Comportamiento e impacto:** JS principal original 688.79 kB (gzip 211.64 kB); se importan páginas de cuestionario/rutas para una visita a landing.
- **Causa:** imports estáticos de todas las páginas; Suspense ya existía en layout.
- **Solución:** lazy por ruta usando fallback actual; optimizar con evidencia, sin memo indiscriminado.
- **Estado:** aplicado; build final 515.49 kB (gzip 162.37 kB). Persiste advertencia >500 kB. Peso de todos los chunks no equivale a peso inicial.
- **Verificar:** build y navegación directa a cada página; medir red/LCP antes de segunda optimización.

### P2 - Medio — F17. Header depende del CSS de una feature

- **Archivo y línea:** `frontend/src/features/welcome/styles/landing-refinements.css:6` y `:81`.
- **Comportamiento e impacto:** reglas del header compartido se importan desde WelcomeView; login/catálogo visitados directamente pueden verse distintos de una navegación desde inicio.
- **Causa:** estilos del layout viven en la feature landing.
- **Solución:** mover solo reglas públicas y su breakpoint a AppLayout.css.
- **Estado:** corregido sin rediseño ni traslado masivo de estilos.
- **Verificar:** login/catálogo en pestaña nueva a 390, 1024 y 1280px; comparar con navegación desde inicio.

### P2 - Medio — F18. Limpieza incompleta de captura y descarga

- **Archivo y línea:** `frontend/src/features/routes/components/RouteSharePreviewDialog.tsx:41`, `:114`, `:130`.
- **Comportamiento e impacto:** preview descarta respuesta tras desmontar, pero downloadAll puede continuar descargando después de cerrar. Espera de imágenes agrega listeners/timeout sin limpiar cuando gana otra rama del race; conversión a blob/canShare queda fuera del catch del share.
- **Causa:** cancelación limitada al efecto de preview; tareas mezcladas con UI.
- **Solución:** servicio de captura cancelable y limpieza; detener descarga al cerrar; capturar fallos y distinguir cancelación nativa.
- **Estado:** pendiente; se unificó contenedor y se comprobó generación del PNG.
- **Verificar:** cerrar durante captura/descarga multipágina, imágenes lentas y canShare/fetch rechazados; no descarga tardía ni rechazo sin manejar.

### P3 - Bajo — F19. Listbox de idioma incompleto

- **Archivo y línea:** `frontend/src/components/ui/LanguageSelector/LanguageSelector.tsx:28`.
- **Comportamiento e impacto:** botones con role=option no implementan flechas, roving tabindex, cierre fuera/Escape. Semántica promete teclado distinto al disponible.
- **Causa:** ARIA de listbox aplicado a disclosure de dos botones.
- **Solución:** disclosure con botones normales y selección anunciada, o listbox completo; cierre y restauración de foco.
- **Estado:** pendiente.
- **Verificar:** abrir/elegir/cerrar con teclado y revisar anuncio con lector de pantalla.

### P3 - Bajo — F20. Timers y preferencias de apariencia

- **Archivo y línea:** `frontend/src/components/notifications/NotificationProvider.tsx:13`; `frontend/src/components/ui/ThemeToggle/ThemeToggle.tsx:23`.
- **Comportamiento e impacto:** timers sobreviven cierre manual/desmontaje; tema escribe storage sin catch. Labels del tema y skeleton siguen en español en UI inglesa.
- **Causa:** sin registro/limpieza de timers y dependencia de almacenamiento disponible; etiquetas literales.
- **Solución:** timers por ID con cancelación, escritura protegida y etiquetas traducidas.
- **Estado:** timers y storage corregidos; traducción pendiente.
- **Verificar:** cerrar/desmontar sin callback tardío; bloquear storage y comprobar tema; revisar etiquetas en inglés.

### P3 - Bajo — F21. Restos y documentación desactualizada

- **Archivo y línea:** `frontend/src/pages/ApiStatusPage.tsx:20`; `frontend/src/features/welcome/components/LandingIntro.tsx:28`; `frontend/README.md:11`.
- **Comportamiento e impacto:** ApiStatusPage no tiene ruta/import activo y es único consumidor de App.css; LandingIntro no tiene consumidor. README habla de GET /health como comportamiento inicial actual. Confunde navegación y mantenimiento.
- **Causa:** restos de plantilla/experiencias anteriores.
- **Solución:** confirmar propósito antes de retirar prototipos; actualizar documentación y comandos.
- **Estado:** documentación actualizada; no se borraron assets/prototipos por suposición.
- **Verificar:** consumidores/imports/referencias externas y build tras una eliminación autorizada.

### P3 - Bajo — F22. Límite de cursos duplicado

- **Archivo y línea:** frontend/src/features/routes/pages/ManualRoutePage.tsx:49; frontend/src/features/routes/pages/SavedRouteDetailPage.tsx:149 (base 20ca572).
- **Comportamiento e impacto:** la misma restricción de 30 cursos aparece en validación/selección y controles de dos páginas; una actualización parcial permite discrepancias entre creación y edición.
- **Causa:** regla compartida expresada como literales locales, sin nombre de dominio.
- **Solución:** constante pequeña MAX_ROUTE_COURSES en el dominio de rutas, reutilizada por esos controles; no unirla al límite de tecnologías del cuestionario, que significa otra cosa.
- **Estado:** pendiente de la siguiente extracción, sin cambiar el límite actual.
- **Verificar:** creación y edición aceptan hasta el mismo límite y rechazan uno adicional; no afecta tecnologías del perfil.

## 2. Bugs corregidos

F01–F11 y F17 corregidos; F15/F16/F20 con mejoras delimitadas. El reemplazo de un curso nuevo no permite PATCH remoto hasta guardar. Inputs de edición se bloquean durante mutación para evitar sobrescribir texto escrito después del envío. Se conserva diseño existente; cambios visuales limitados al espacio que antes resultaba inválido.

## 3. Refactorizaciones realizadas

- Transporte único con adaptador de errores de rutas; endpoints y payloads conservados.
- Parsers de unknown en límites, puros y comprobables sin React/red.
- useAllCatalogCourses comparte carga/error/reintento, sin mezclar selección ni negocio. Sin caché añadida sin política de invalidación.
- Dialog comparte interacción modal; contenido y diseño permanecen en features.
- replaceSavedRouteCourse expresa reemplazo sin heredar datos de otro curso.
- strict=true y displayName nullable; sin any nuevos.
- Lazy de páginas con Suspense existente; landing/login conservados.
- Tokens completos, reglas del header en su propietario y limpieza de recursos.

## 4. Estructura añadida

No se movieron carpetas existentes.

```text
frontend/
  src/components/ui/Dialog/
  src/lib/{validation,urls}.ts
  src/lib/api/latestRequest.ts
  src/features/auth/model/parseSession.ts
  src/features/catalog/model/parseCatalogPage.ts
  src/features/catalog/hooks/useAllCatalogCourses.ts
  src/features/routes/model/{parseRoutes,editSavedRoute}.ts
  tests/
  docs/frontend-review.md
```

## 5. Pruebas añadidas

node:test y TypeScript ya instalado, sin dependencias nuevas. Compilación de módulos puros en .test-build ignorado por Git. Cobertura de contratos, URLs, fechas/progreso inválidos, ProblemDetails/aborto, vigencia de solicitudes, reemplazo inmutable/duplicado, orden/estadísticas, storage corrupto/bloqueado, propuestas por propietario y todos los tokens CSS.

Fixture `/tests/dialogs.html`: componentes reales en Strict Mode y MemoryRouter; todas las llamadas de API y mutaciones se resuelven en memoria. Verificado: idioma conserva edición; reemplazo sin PUT hasta guardar; bloqueo durante PATCH; error/reintento; nota conservada ante storage fallido; Tab/Escape/foco inicial/retorno; claro/oscuro; nota en 390px sin overflow horizontal; PNG generado.

Estas comprobaciones de navegador son **manuales asistidas**, no E2E automatizados. No se usó OAuth real ni se escribió en la base del equipo. Instrucciones reproducibles en `tests/README.md`.

## 6. Inventario, cobertura y comprobaciones

React/ReactDOM 19.2.8, Vite 8.3, TypeScript 6.0.2, React Router 7.13.1. Context de sesión/notificaciones y estado local; sin Redux/React Query/SWR. i18next, Framer Motion, Lucide y html-to-image. CSS propio con tokens/globales/features, sin framework UI. Formularios/validación de cuestionario propios. Fetch JSON con cookie de sesión, VITE_API_BASE_URL; no se tocaron variables de entorno.

| Área | Inspección y conclusión delimitada |
| --- | --- |
| Arquitectura | Árbol completo, entrada/router, features y compartidos inspeccionados. No se detectaron ciclos estáticos locales. Barrels existentes no justifican eliminación masiva. Responsabilidades acumuladas: F15. |
| React | Strict Mode, estados, efectos y handlers revisados. No se observaron mutaciones directas de arrays de estado ni keys aleatorias regeneradas durante render en los flujos inspeccionados. Carreras corregidas; F14/F18 pendientes. |
| TypeScript | No se detectó any en src. Aserciones inseguras de JSON corregidas; quedan casts de drafts/preferencias para caracterizar antes de cambiar. |
| API/datos | Transporte y validación corregidos. Catálogo completo sigue consultando páginas sin caché. No se añadió caché ni invalidación especulativa. |
| Constantes/nombres | Endpoints/rutas/storage/eventos y límites revisados. No se detectó un endpoint escrito de formas incompatibles. Límite de cursos duplicado: F22. Se mantienen constantes por contexto, sin un archivo global gigante. |
| Formularios | Manual exige nombre/limita cursos; cuestionario valida pasos y protege submit. Edición bloquea durante envío. No se verificó cada mensaje 422 contra servidor real. |
| CSS | Tokens corregidos; modal de notas probado en 1280x720 y 390x844. No se certifica todo breakpoint ni contraste global; limpieza de cascada pendiente. |
| Accesibilidad | Skip link, foco de navegación, boundary y tabs de landing inspeccionados. Modales corregidos. Orden/idioma pendientes. No se probó lector de pantalla real. |
| Rendimiento | Build medido antes/después. Hay PNGs emitidos de 537–1027 kB: medir descargas reales antes de conversión. No equivale a afirmar que todos se descarguen en cada visita. |
| Seguridad | No se encontraron dangerouslySetInnerHTML, eval, logs sensibles ni tokens de sesión en storage dentro de src. URLs/JSON validados. npm audit inicial: 0 vulnerabilidades. CORS/CSRF/cookies/autorización/OAuth servidor fuera de alcance. No se leyó configuración secreta. |
| Calidad | No había test script/suite frontend. Lint/build iniciales pasaban con los bugs descritos. Suite nueva enfocada; faltan integración automatizada React y OAuth real. |

### Resultado final de comprobaciones

| Comprobación | Resultado |
| --- | --- |
| Instalación reproducible | npm ci --ignore-scripts --offline: correcta |
| Lint | npm run lint: sin errores ni advertencias |
| Tipos | npm run typecheck: correcto; incluye aplicación y fixture |
| Pruebas | npm test: 15/15, sin fallos ni omitidas |
| Build | npm run build: correcto; advertencia de chunk principal >500 kB |
| Audit de dependencias | 0 vulnerabilidades reportadas, 177 paquetes auditados; snapshot de esta revisión |
| Diff | git diff --check: limpio; cambios solo frontend y ignore del resultado temporal |
| Medida | JS principal 688.79 → 515.49 kB; gzip 211.64 → 162.37 kB. Reducción aproximada 25%/23%; no es una medida de velocidad percibida. |

Las pruebas asistidas usaron exclusivamente datos ficticios en memoria.  Instalación desde lockfile comprobada con npm ci --ignore-scripts --offline; audit se ejecutó separadamente con acceso a registro. No existe .github en esta copia para asumir plataforma CI.

## 7. Riesgos y decisiones de negocio

1. Cuestionario: migración de entradas antiguas sin propietario y conservación tras completar. Aislar cuentas de Google/Discord; no atribuir borrador antiguo por suposición.
2. Generación: ¿cancelar al salir o continuar en segundo plano y recuperar por usuario? Diferente de conservar propuesta ya lista.
3. `preferencesMapping.ts:44` fija es/60 minutos; área, experiencia práctica y legacy se muestran pero no son campos del DTO. ¿Son defaults intencionales y qué respuestas deben influir? El código documenta limitación contractual; no se cambió backend.
4. Progreso: UI binaria completado=100/resto=no iniciado, aunque DTO admite porcentaje. Confirmar si habrá progreso parcial.
5. Notas: locales a este navegador por ruta/curso; sin sincronización. Confirmar expectativa de dispositivos antes de API nueva.
6. Constructor manual: borrador solo en memoria; confirmar persistencia al abandonar la página.
7. Guarda de mutación local no sustituye concurrencia entre dispositivos/pestañas del servidor, fuera de alcance.
8. Validación estricta coincide con contratos inspeccionados; una variante del despliegue debe documentarse/adaptarse explícitamente. No se probó OAuth real ni producción.

## 8. Plan por fases y siguientes pasos

| Fase | Archivos | Beneficio | Riesgo | Verificación / estado |
| --- | --- | --- | --- | --- |
| 1. Bugs y riesgos | AuthSessionProvider, App/ProtectedRoute, SavedRouteDetailPage, diálogos, routeLocalState | Evitar pérdida de edición, guardados ocultos y respuestas antiguas | Medio, flujos centrales | Etapa aplicada. Suite/fixture; añadir E2E de sesión/errores/mutaciones antes del merge. |
| 2. Arquitectura | MyPathPage, SavedRouteDetailPage, QuestionnairePage | Delimitar carga/edición/presentación y colección/propuesta | Medio | Extracciones tras caracterizar flujos; preservar DTO/UX. |
| 3. Reutilización | useAllCatalogCourses, lib/api; futuro reorder/hook de drag | Eliminar cargas/transporte duplicados; compartir orden/FLIP | Bajo aplicado; medio drag | HTTP/catálogo aplicados; tests de límites/foco/táctil para orden. |
| 4. Componentes grandes | Páginas de rutas/cuestionario, RouteCourseItem | Contratos y responsabilidades claros | Medio | Extraer editor/resumen/controlador cuando aíslen comportamiento; no por tamaño solo. |
| 5. Estilos | tokens, AppLayout.css, MyPathPage.css, RouteShareDialog.css, landing-refinements.css | Tokens completos y propiedad correcta; reducir overrides | Medio, cascada | Tokens/nav aplicados. Separación de modales/items/track con capturas light/dark/móvil y orden preservado. |
| 6. Tipos/contratos | parseSession, parseCatalogPage, parseRoutes, draftRoute, PreferencesDto/mapping | Validar límites/estados y reglas reales | Medio si despliegue difiere | Parsers/strict aplicados; fixtures del servidor y decisiones de preferencias. |
| 7. Pruebas/checks | tests, tsconfigs, package.json, futura CI | Suite de regresión reproducible | Bajo | Unitaria aplicada; integración React/E2E con herramienta aprobada y entorno aislado. |
| 8. Rendimiento/UX | App, imágenes, LanguageSelector, captura, caché de catálogo | Menos carga inicial, accesibilidad y tareas limpias | Bajo/medio | Lazy aplicado y medido; medir red/LCP antes de imágenes/caché. |

Prioridad siguiente: aislar borradores y resolver generación → reordenar por teclado → automatizar integración/sesión → dividir controladores/CSS → imágenes/caché medidas → eliminar restos confirmados.
