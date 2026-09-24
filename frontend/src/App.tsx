import { lazy } from 'react';
import { useTranslation } from 'react-i18next';
import { Navigate, Route, Routes, useLocation } from 'react-router-dom';

import { AppLayout } from './components/layout/AppLayout';
import { PageState } from './components/ui/PageState/PageState';
import { ProtectedRoute } from './features/auth/components/ProtectedRoute';
import { useAuthSession } from './features/auth/hooks/useAuthSession';
import { CatalogPage } from './features/catalog/pages/CatalogPage';
import { QuestionnairePage } from './features/questionnaire/pages/QuestionnairePage';
import { MyPathPage } from './features/routes/pages/MyPathPage';
import { SavedRouteDetailPage } from './features/routes/pages/SavedRouteDetailPage';
import { LoginCallbackPage } from './pages/LoginCallbackPage';
import { LoginPage } from './pages/LoginPage';
import { SectionPage } from './pages/SectionPage';
import { WelcomePage } from './pages/WelcomePage';

const WelcomePreviewPage = import.meta.env.DEV
  ? lazy(() => import('./pages/WelcomePreviewPage'))
  : null;
import { SavedRouteDetailPage } from './features/routes/pages/SavedRouteDetailPage';

function App() {
  const { user, isLoading, sessionError, refresh } = useAuthSession();
  const { t } = useTranslation();
  const { pathname } = useLocation();

  if (!isLoading && sessionError) {
    return (
      <PageState
        kind="error"
        title={t('errors.sessionUnavailable')}
        description={t('errors.sessionUnavailableDescription')}
        onRetry={() => { void refresh(); }}
      />
    );
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
        <Route path="catalog" element={<CatalogPage />} />
        <Route path="*" element={<SectionPage section="notFound" />} />
      </Route>
      <Route element={<ProtectedRoute />}>
        <Route element={<AppLayout />}>
          <Route path="create-route" element={<Navigate to="/create-route/proposal" replace />} />
          <Route path="create-route/proposal" element={<MyPathPage mode="proposal" autoGenerate />} />
          <Route path="my-path" element={<MyPathPage mode="collection" />} />
          <Route path="my-path/:routeId" element={<SavedRouteDetailPage />} />
          <Route path="learning-profile" element={<QuestionnairePage />} />
        </Route>
      </Route>
    </Routes>
  );
}

export default App;
