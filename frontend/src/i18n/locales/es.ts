export const es = {
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
