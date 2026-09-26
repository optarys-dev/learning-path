import type { loginEs } from './login.es';

export const loginEn = {
  navigation: 'Sign in', title: 'Your account, your journey.', eyebrow: 'ONE STEP CLOSER',
  description: 'Sign in to save your paths and pick up your learning.',
  googleContinue: 'Continue with Google', googleConnecting: 'Connecting to Google…',
  googleError: 'We could not complete Google sign-in. Please try again.',
  back: 'Back to welcome', developmentNote: 'We are preparing Discord sign-in. Explore the experience on the welcome page.',
  asideTitle: 'Your learning deserves <accent>continuity.</accent>',
  asideDescription: 'One account to connect your goals, your paths and every step you choose to take.',
  benefitOne: 'Save different learning paths', benefitTwo: 'Mark your progress', benefitThree: 'Pick up where you left off',
  flowTitle: 'WHEN YOU CONTINUE', flowOne: 'Choose the account you want to sign in with.', flowTwo: 'Return to your journey with your session ready.',
  privacy: 'Each account keeps its own paths and progress. We do not merge accounts from different providers.',
} satisfies { [K in keyof typeof loginEs]: string };
