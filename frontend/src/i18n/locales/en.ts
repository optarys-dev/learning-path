import type { TranslationSchema } from './es';
import { landingEn } from './landing.en';
import { loginEn } from './login.en';

export const en = {
  landing: landingEn,
  login: loginEn,
  welcome: {
    pageTitle: 'Your next learning path',
    eyebrow: 'Your next learning mission',
    title: 'Your next path', titleAccent: 'starts here.',
    description: 'Tell us what you want to learn and we will help you build a path using real DevTalles courses.',
    continue: 'Continue with Discord', connecting: 'Connecting to Discord…', retry: 'Retry with Discord',
    purpose: 'We use Discord to identify your account and save your learning paths and progress.',
    error: 'We could not sign you in with Discord. Please try again.',
    cancelled: 'Sign-in was not completed. You can try again whenever you are ready.',
    unavailable: 'Discord sign-in will be available soon.',
    session: 'You are signed in. Preparing your next step…',
    signature: 'Real courses. A path made for you.',
    journeyCaption: 'Every step matters', start: 'Start', foundations: 'Foundations', specialize: 'Specialization', goal: 'Your goal',
    deviNote: 'A good starting point changes everything.',
  },
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
