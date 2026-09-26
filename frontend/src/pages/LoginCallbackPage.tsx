import { Navigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { PageState } from '../components/ui/PageState/PageState';
import { useAuthSession } from '../features/auth/hooks/useAuthSession';

export function LoginCallbackPage() {
  const { user, isLoading, sessionError, refresh } = useAuthSession();
  const { t } = useTranslation();

  if (sessionError) return <PageState kind="error" title={t('errors.sessionUnavailable')}
    description={t('errors.sessionUnavailableDescription')} onRetry={() => { void refresh(); }} />;

  if (!isLoading) {
    return <Navigate to={user ? (user.isNewUser === true ? '/create-route' : '/my-path') : '/login'} replace />;
  }

  return <PageState kind="loading" title={t('welcome.connecting')} />;
}
