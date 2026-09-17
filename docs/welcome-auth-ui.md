# P0-17 — Bienvenida y UI de Discord

## Alcance entregado

Landing en `/` con recorrido conceptual, ejemplo visual de ruta, activos oficiales de Devi, traducciones español/inglés y movimiento reducido. `/login` presenta el punto de acceso explícito con Discord. Reutiliza `AppLayout` con variante `welcome` y `Button` con texto de carga personalizable.

El botón muestra un aviso de disponibilidad próxima. No hace peticiones, no crea sesiones, no guarda tokens y no abre Discord todavía.

## Responsabilidades

- `WelcomeView`: presentación y mensajes de estado.
- `LearningJourney`: ilustración decorativa con activos originales y nodos conceptuales, no cursos reales.
- `DiscordLoginButton`: CTA, foco, estado deshabilitado y texto de conexión.
- `useDiscordLogin`: evita solicitudes duplicadas, maneja fallos/cancelación y aborta al desmontar. Recibe un adaptador opcional; no conoce endpoints.
- `WelcomePage`: título y punto de integración de sesión verificada y destino interno.

## Pendiente con Kevin

Confirmar inicio OAuth (redirección o URL devuelta por API), callback, consulta de sesión, credenciales/cookies, cancelación y destino después del login. El tipo `DiscordLoginAdapter` es un contrato de UI provisional; no representa un endpoint ya acordado. En V1 el acceso es únicamente con Discord.

Usar la configuración existente `VITE_API_BASE_URL` cuando se implemente el adaptador. No agregar secretos Discord al frontend. `sessionNextPath` solo debe provenir de una sesión verificada por el backend; no de parámetros de URL ni almacenamiento usado como prueba de autenticación. La ruta posterior se conectará cuando exista el assessment.

## Vista de estados

Con el servidor de desarrollo, abrir `/dev/welcome`. El selector permite inspeccionar `idle`, `loading`, `error`, `cancelled`, `authenticated` y `unavailable`. Son estados visuales: no autentican ni redirigen. Esta ruta y su importación se excluyen de producción.

## Validación

Build, TypeScript y ESLint. Revisión en navegador de escritorio y 360px: CTA visible, idioma inglés, aviso al pulsar Discord y ausencia de desbordamiento horizontal tras corregir la órbita decorativa.

La integración real y sus pruebas de OAuth quedan pendientes del endpoint. No cerrar P0-17 como autenticación completa hasta probar sesión existente, callback, cancelación y redirección con backend.
