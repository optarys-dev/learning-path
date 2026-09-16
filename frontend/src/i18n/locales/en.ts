import type { TranslationSchema } from './es';

export const en = {
  layout: {
    skip: 'Skip to content', navigation: 'Main navigation',
    openMenu: 'Menu', closeMenu: 'Close menu', home: 'Home', catalog: 'Catalog', myPath: 'My path',
    footer: 'Learn at your own pace. Build your next step.',
    retry: 'Try again', loading: 'Loading…',
    error: 'Something went wrong', errorDescription: 'We could not display this section. Please try again.',
    homeDescription: 'Your space to discover what to learn and move forward with a clear direction.',
    catalogDescription: 'Explore learning opportunities from DevTalles.',
    myPathDescription: 'View your learning path and next steps here.',
    comingSoon: 'We are preparing this space', comingSoonDescription: 'This section will be available soon.',
    notFound: 'Page not found', notFoundDescription: 'This address does not match an available page.',
    notFoundState: 'Find your way back', notFoundHelp: 'Return home to keep exploring.', backHome: 'Back to home',
  },
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
