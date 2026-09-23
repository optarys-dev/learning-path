import { useEffect } from 'react';
import { Navigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { LoginView, useDiscordLogin, type DiscordLoginAdapter } from '../features/auth';

export function LoginPage({ adapter, sessionNextPath }: {
  adapter?: DiscordLoginAdapter;
  sessionNextPath?: string;
}) {
  const { t } = useTranslation();
  const { state, login } = useDiscordLogin(adapter);
  useEffect(() => { document.title = `${t('login.navigation')} · CODE QUEST 2026`; }, [t]);
  const nextPath = sessionNextPath ?? (state.status === 'authenticated' ? state.nextPath : undefined);
  if (nextPath?.startsWith('/') && !nextPath.startsWith('//') && !nextPath.includes('\\') && !['/', '/login'].includes(nextPath.split(/[?#]/)[0])) {
    return <Navigate to={nextPath} replace />;
  }
  return <LoginView state={state} onLogin={() => { void login(); }} />;
}
