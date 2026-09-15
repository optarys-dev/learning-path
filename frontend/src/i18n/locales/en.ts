import type { TranslationSchema } from './es';

export const en = {
  app: {
    name: 'CODE QUEST 2026',
  },
  language: {
    label: 'Language',
    english: 'English',
    spanish: 'Spanish',
  },
  status: {
    apiAndDatabaseConnected: '🟢 API and PostgreSQL are connected',
    apiLabel: 'API: {{url}}',
    apiUnavailable: '🔴 Unable to connect to the API',
    checking: 'Checking API and PostgreSQL connection…',
    databaseUnavailable: '🟡 API is connected, but PostgreSQL is unavailable',
    pageTitle: 'Technical foundation ready to integrate',
  },
  errors: {
    apiBaseUrlMissing: 'The API URL is missing. Check frontend/.env.example.',
  },
} satisfies TranslationSchema;
