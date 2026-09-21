import { Navigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { PageState } from '../components/ui/PageState/PageState';
import { useAuthSession } from '../features/auth/useAuthSession';

export function LoginCallbackPage() {
  const { user, isLoading } = useAuthSession();
  const { t } = useTranslation();

  if (!isLoading) {
    return <Navigate to={user ? (user.isNewUser === true ? '/learning-profile' : '/my-path') : '/login'} replace />;
  }

  return <PageState kind="loading" title={t('welcome.connecting')} />;
}
