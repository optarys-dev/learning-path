# Guía de colaboración

## Ramas

- `main`: versión estable y demostrable.
- `develop`: integración de cambios ya revisados.
- `feat/...`: nueva funcionalidad. Ejemplo: `feat/catalogo-cursos`.
- `fix/...`: corrección de un problema. Ejemplo: `fix/progreso-ruta`.
- `docs/...`: cambios exclusivos de documentación. Ejemplo: `docs/assessment`.

No se trabaja directamente sobre `main` ni `develop`.

## Commits

Los mensajes se escriben en español y empiezan con un tipo de cambio:

```text
feat: agregar endpoint de catálogo de cursos
fix: corregir cálculo de progreso de una ruta
docs: actualizar reglas del cuestionario
chore: configurar estructura inicial y estándares del proyecto
```

## Pull Requests

Cada Pull Request debe:

1. Tener una descripción breve del cambio.
2. Indicar la issue que cubre, por ejemplo `Closes #3`.
3. Explicar cómo probarlo localmente.
4. Mencionar variables de entorno, migraciones o seeds requeridos.
5. Ser revisado y probado por al menos otra persona antes de integrarse.

## Archivos sensibles

No subir archivos `.env`, claves de Discord, tokens, contraseñas ni cadenas de conexión reales. Usar `.env.example` y configuraciones locales ignoradas por Git.
