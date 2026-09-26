import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

import { PageState } from '../../../components/ui/PageState/PageState';
import { useAuthSession } from '../hooks/useAuthSession';

export function ProtectedRoute() {
  const { t } = useTranslation();
  const { user, isLoading, sessionError, refresh } = useAuthSession();
  const location = useLocation();

  if (isLoading) {
    return <PageState kind="loading" title={t('layout.loading')} />;
  }

  if (sessionError) return <PageState kind="error" title={t('errors.sessionUnavailable')}
    description={t('errors.sessionUnavailableDescription')} onRetry={() => { void refresh(); }} />;

  if (!user) {
    return <Navigate to="/login" replace state={{ from: location.pathname }} />;
  }

  return <Outlet />;
}
