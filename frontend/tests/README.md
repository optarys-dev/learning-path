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

Las comprobaciones de navegador documentadas se hicieron manualmente con esta fixture. No son E2E automatizados. El mock no prueba OAuth, autorización del servidor ni concurrencia real de base de datos.

## Regresiones de la extracción

- Editar ruta → Simular arrastre: intercambia los dos primeros cursos, anuncia la nueva posición y habilita Guardar cambios. El botón despacha eventos HTML sobre los componentes reales; no modifica el estado de React directamente.
- Ruta manual: escribir nombre, elegir dos cursos y mover uno; alternar idioma conserva nombre y orden, y traduce Intermedio/Intermediate. Guardar ruta vuelve a la colección con el orden elegido.
- La simulación complementa la prueba física de arrastre; no verifica su implementación nativa en todos los navegadores.
- La suite automática cubre imports/ciclos, traducciones/placeholders, restricciones de selección, orden y payloads, almacenamiento compatible y errores 401/403/códigos del servidor.
