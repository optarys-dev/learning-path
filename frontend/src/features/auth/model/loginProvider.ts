import type { AuthenticatedUser } from './parseSession';

const LOGIN_PROVIDER_KEY = 'codequest-login-provider';

// Presentation hint only: it never determines the authenticated identity.
export function rememberLoginProvider(provider: AuthenticatedUser['provider']): void {
  try { sessionStorage.setItem(LOGIN_PROVIDER_KEY, provider); }
  catch { clearLoginProvider(); }
}

export function loginLoadingTranslationKey(): 'welcome.connecting' | 'login.googleConnecting' | 'login.completingSignIn' {
  try {
    const provider = sessionStorage.getItem(LOGIN_PROVIDER_KEY);
    if (provider === 'Discord') return 'welcome.connecting';
    if (provider === 'Google') return 'login.googleConnecting';
  } catch { /* Use neutral copy when storage is unavailable. */ }
  return 'login.completingSignIn';
}

export function clearLoginProvider(): void {
  try { sessionStorage.removeItem(LOGIN_PROVIDER_KEY); } catch { /* Storage unavailable. */ }
}
