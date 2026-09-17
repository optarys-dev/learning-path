import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { PageState } from '../components/ui/PageState/PageState';
import { getCurrentSession } from '../features/auth/session';

export function LoginCallbackPage() {
  const navigate = useNavigate();
  const { t } = useTranslation();

  useEffect(() => {
    const controller = new AbortController();
    void getCurrentSession(controller.signal)
      .then(user => navigate(user ? '/my-path' : '/login', { replace: true }))
      .catch(() => navigate('/login', { replace: true }));
    return () => controller.abort();
  }, [navigate]);

  return <PageState kind="loading" title={t('welcome.connecting')} />;
}
