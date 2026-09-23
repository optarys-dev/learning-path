import { Navigate, Route, Routes, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAuthSession } from './features/auth';
import { AppLayout } from './components/layout/AppLayout';
import { SectionPage } from './pages/SectionPage';
import { WelcomePage } from './pages/WelcomePage';
import { LoginPage } from './pages/LoginPage';
import { LoginCallbackPage } from './pages/LoginCallbackPage';
import { lazy } from 'react';

const WelcomePreviewPage = import.meta.env.DEV
  ? lazy(() => import('./pages/WelcomePreviewPage'))
  : null;
import { QuestionnairePage } from './pages/QuestionnairePage';
import { MyPathPage } from './pages/MyPathPage';
import { PageState } from './components/ui/PageState/PageState';

function App() {
  const { user, isLoading, sessionError, refresh } = useAuthSession();
  const { t } = useTranslation();
  const { pathname } = useLocation();
  if (!isLoading && sessionError) {
    return <PageState kind="error" title={t('errors.sessionUnavailable')}
      description={t('errors.sessionUnavailableDescription')} onRetry={() => { void refresh(); }} />;
  }
  if (!isLoading && user?.isNewUser === true && pathname !== '/learning-profile') {
    return <Navigate to="/learning-profile" replace />;
  }

  return (
    <Routes>
      <Route element={<AppLayout variant="welcome" />}>
        <Route index element={<WelcomePage />} />
        <Route path="login" element={<LoginPage />} />
        <Route path="login/callback" element={<LoginCallbackPage />} />
        {WelcomePreviewPage && <Route path="dev/welcome" element={<WelcomePreviewPage />} />}
      </Route>
      <Route element={<AppLayout />}>
        <Route path="catalog" element={<SectionPage section="catalog" />} />
        <Route path="my-path" element={<MyPathPage />} />
        <Route path="learning-profile" element={<QuestionnairePage />} />
        <Route path="*" element={<SectionPage section="notFound" />} />
      </Route>
    </Routes>
  );
}

export default App;
