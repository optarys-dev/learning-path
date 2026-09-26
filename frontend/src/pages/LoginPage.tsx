import { useEffect, useState } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useDiscordLogin, type DiscordLoginAdapter } from '../features/auth/hooks/useDiscordLogin';
import { LoginView } from '../features/auth/components/LoginView';
import { getLoginProviders, startGoogleLogin } from '../features/auth/api/session';

export function LoginPage({ adapter, sessionNextPath }: {
  adapter?: DiscordLoginAdapter;
  sessionNextPath?: string;
}) {
  const { t } = useTranslation();
  const location = useLocation();
  const [googleAvailable, setGoogleAvailable] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  useEffect(() => {
    if (adapter) return;
    const controller = new AbortController();
    void getLoginProviders(controller.signal).then(providers => setGoogleAvailable(providers.google === true)).catch(() => {});
    return () => controller.abort();
  }, [adapter]);
  const { state, login } = useDiscordLogin(adapter);
  useEffect(() => { document.title = `${t('login.navigation')} · CODE QUEST 2026`; }, [t]);
  const nextPath = sessionNextPath ?? (state.status === 'authenticated' ? state.nextPath : undefined);
  if (nextPath?.startsWith('/') && !nextPath.startsWith('//') && !nextPath.includes('\\') && !['/', '/login'].includes(nextPath.split(/[?#]/)[0])) {
    return <Navigate to={nextPath} replace />;
  }
  return <LoginView state={state} onLogin={() => { if (!googleLoading) void login(); }}
    onGoogleLogin={googleAvailable ? () => { if (googleLoading) return; setGoogleLoading(true); startGoogleLogin(); } : undefined}
    googleLoading={googleLoading} googleError={new URLSearchParams(location.search).get('authError') === 'google'} />;
}
