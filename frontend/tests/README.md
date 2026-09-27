# Pruebas del frontend

Desde frontend: `npm run lint`, `npm run typecheck`, `npm test`, `npm run build`.

La suite automática usa node:test y compila únicamente modelos/utilidades con TypeScript instalado. No consulta servicios ni escribe en la base. `.test-build` es temporal e ignorado por Git.

## Fixture de interacción

Ejecutar Vite y abrir `/tests/dialogs.html`. Es una entrada de desarrollo, fuera del build productivo. Monta componentes reales con StrictMode; todas las llamadas de API están reemplazadas por respuestas en memoria. No permite acceso a datos reales.

1. Editar ruta, cambiar nombre, alternar idioma: el nombre se conserva y Ver solicitudes no muestra GET adicional por idioma.
2. Abrir opciones y reemplazar Curso 1 por Curso 3: no hay PUT; Guardar cambios genera PUT y sale de edición.
3. Marcar completado: durante 500ms los otros controles/mutaciones quedan deshabilitados.
4. Catálogo: error hace fallar la próxima carga; abrir Reemplazar, ver error y usar reintento para recuperar alternativas.
5. Nota sin almacenamiento abre un editor cuyo guardado falla intencionalmente. Escribir y guardar: error anunciado y texto conservado.
6. Modal: Tab/Shift+Tab entre extremos, Escape y retorno al disparador; foco inicial en textarea. Alternar tema y revisar claro/oscuro. Probar nota a 390x844.
7. Compartir ruta genera un PNG en memoria. No usar share del sistema ni descargar para verificar la preview.
8. Catálogo de prueba: alternar categorías muestra los cursos y badges correspondientes; Gratis muestra Curso 1 y Exclusivo PRO muestra Curso 2. Ver solicitudes permite comprobar `catalogKind` sin consultar la API real.

Las comprobaciones de navegador documentadas se hicieron manualmente con esta fixture. No son E2E automatizados. El mock no prueba OAuth, autorización del servidor ni concurrencia real de base de datos.

## Menú público móvil y exportación

Abrir `/tests/navigation.html` en Vite. Monta el layout y la landing reales en un iframe
de ancho configurable, con sesión ficticia y sin peticiones a la API.

- Sin sesión, a 320/390px: abrir el menú muestra Inicio, Cómo funciona, Tu experiencia,
  Preguntas y Catálogo; tema e idioma quedan agrupados y el login está visible.
- El menú no desplaza el contenido. Cierra al navegar, tocar fuera o pulsar Escape;
  Escape devuelve el foco al botón. Pasar a 1440px y volver no conserva el menú abierto.
- Repetir en español/inglés, claro/oscuro y con sesión ficticia para comparar la navegación.
- «Preview six-course image» genera un único PNG con seis cursos. Probar los tres
  formatos, cerrar el modal, alternar idioma y volver a abrirlo: objetivo, resumen y estados cambian;
  los nombres oficiales se conservan. No pulsar compartir ni descargar para verificar.

## Regresiones de la extracción

- Editar ruta → Simular arrastre: intercambia los dos primeros cursos, anuncia la nueva posición y habilita Guardar cambios. El botón despacha eventos HTML sobre los componentes reales; no modifica el estado de React directamente.
- Ruta manual: escribir nombre, elegir dos cursos y mover uno; alternar idioma conserva nombre y orden, y traduce Intermedio/Intermediate. Guardar ruta vuelve a la colección con el orden elegido.
- La simulación complementa la prueba física de arrastre; no verifica su implementación nativa en todos los navegadores.
- La suite automática cubre imports/ciclos, traducciones/placeholders, restricciones de selección, orden y payloads, almacenamiento compatible y errores 401/403/códigos del servidor.

## Arranque inicial

Abrir `/tests/startup.html`: usa el HTML y los estilos reales de arranque. Alternar tema
e idioma permite revisar los cuatro casos, también a 320px. «Start React» carga la
entrada real y debe retirar el loader con una salida suave. Se mantiene al menos
1,1 segundos desde el inicio y luego desvanece durante 240ms, sin depender de la
petición de sesión. La página se renderiza debajo; el teclado no accede a controles
tapados. La fixture simula una sesión anónima.
Las pruebas automáticas comprueban preferencias persistidas, valores desconocidos
y almacenamiento bloqueado. En cargas lentas no se agrega otro segundo de espera.
