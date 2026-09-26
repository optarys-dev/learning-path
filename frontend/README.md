# Frontend · Learning Path / CODE QUEST 2026

Cliente React, TypeScript y Vite.

## Ejecutar

1. Configurar `.env` a partir de `.env.example` sin versionar secretos.
2. Instalar desde lockfile con `npm ci`.
3. Ejecutar `npm run dev`.

La app consulta `/auth/me` para sesión y `/courses` para catálogo; `VITE_API_BASE_URL` define la API. Los endpoints protegidos usan cookie de sesión. No hay redirección obligatoria de cuentas nuevas al cuestionario.

La configuración Rider `Frontend React` vive en `.run/`. Los perfiles de la API están en backend/Properties/launchSettings.json.

## Comprobaciones

- `npm run lint`
- `npm run typecheck`
- `npm test`
- `npm run build`

Tests de contratos/estado y fixture de navegador: [tests/README.md](tests/README.md).
Revisión, hallazgos y fases pendientes: [docs/frontend-review.md](docs/frontend-review.md).
