export const es = {
  layout: {
    skip: 'Saltar al contenido', navigation: 'Navegación principal',
    openMenu: 'Menú', closeMenu: 'Cerrar menú', home: 'Inicio', catalog: 'Catálogo', myPath: 'Mi ruta',
    footer: 'Aprende a tu ritmo. Construye tu siguiente paso.',
    retry: 'Volver a intentar', loading: 'Cargando…',
    error: 'Algo salió mal', errorDescription: 'No pudimos mostrar esta sección. Inténtalo de nuevo.',
    homeDescription: 'Tu espacio para descubrir qué aprender y avanzar con una dirección clara.',
    catalogDescription: 'Explora las opciones de aprendizaje de DevTalles.',
    myPathDescription: 'Aquí podrás consultar tu ruta de aprendizaje y tus próximos pasos.',
    comingSoon: 'Estamos preparando este espacio',
    comingSoonDescription: 'Esta sección estará disponible próximamente.',
    notFound: 'Página no encontrada', notFoundDescription: 'La dirección que abriste no corresponde a una página disponible.',
    notFoundState: 'Retoma tu camino', notFoundHelp: 'Vuelve al inicio para seguir explorando.', backHome: 'Volver al inicio',
  },
  app: {
    name: 'CODE QUEST 2026',
  },
  language: {
    label: 'Idioma',
    english: 'English',
    spanish: 'Español',
  },
  status: {
    apiAndDatabaseConnected: '🟢 API y PostgreSQL conectados correctamente',
    apiLabel: 'API: {{url}}',
    apiUnavailable: '🔴 No se pudo conectar con la API',
    checking: 'Comprobando conexión con la API y PostgreSQL…',
    databaseUnavailable: '🟡 API conectada, pero PostgreSQL no responde',
    pageTitle: 'Base técnica lista para integrar',
  },
  errors: {
    apiBaseUrlMissing: 'Falta configurar la URL de la API. Revisa frontend/.env.example.',
  },
} as const;

type ToStringValues<T> = {
  [K in keyof T]: T[K] extends Record<string, unknown> ? ToStringValues<T[K]> : string;
};

export type TranslationSchema = ToStringValues<typeof es>;
