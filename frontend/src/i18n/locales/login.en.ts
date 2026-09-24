import type { loginEs } from './login.es';

export const loginEn = {
  navigation: 'Sign in', title: 'Your account, your journey.', eyebrow: 'ONE STEP CLOSER',
  description: 'Sign in with Discord to save your paths and pick up your learning.',
  back: 'Back to welcome', developmentNote: 'We are preparing Discord sign-in. Explore the experience on the welcome page.',
  asideTitle: 'Your learning deserves <accent>continuity.</accent>',
  asideDescription: 'One account to connect your goals, your paths and every step you choose to take.',
  benefitOne: 'Save different learning paths', benefitTwo: 'Mark your progress', benefitThree: 'Pick up where you left off',
  flowTitle: 'WHEN YOU CONTINUE', flowOne: 'Sign in with your Discord account.', flowTwo: 'Return to your journey with your session ready.',
  privacy: 'Discord will identify your account to keep your paths and progress.',
} satisfies { [K in keyof typeof loginEs]: string };
