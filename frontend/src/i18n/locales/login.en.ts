import type { loginEs } from './login.es';

export const loginEn = {
  navigation: 'Sign in', title: 'Good to see you here.', eyebrow: 'YOUR LEARNING SPACE',
  description: 'Choose how to sign in. Your next steps are waiting.',
  accountInfo: 'About your accounts',
  sceneLabel: 'A place for your journey',
  googleContinue: 'Continue with Google', googleConnecting: 'Connecting to Google…',
  googleError: 'We could not complete Google sign-in. Please try again.',
  back: 'Back to welcome', developmentNote: 'We are preparing Discord sign-in. Explore the experience on the welcome page.',
  asideTitle: 'Your next chapter <accent>starts here.</accent>',
  asideDescription: 'One account to connect your goals, your paths and every step you choose to take.',
  benefitOne: 'Your paths', benefitTwo: 'Your progress', benefitThree: 'Your pace',
  flowTitle: 'WHEN YOU CONTINUE', flowOne: 'Choose the account you want to sign in with.', flowTwo: 'Return to your journey with your session ready.',
  privacy: 'Each account keeps its own paths and progress. We do not merge accounts from different providers.',
} satisfies { [K in keyof typeof loginEs]: string };
