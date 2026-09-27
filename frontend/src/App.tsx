import { appRoutes } from '@/config/navigation';
import { lazy, useEffect } from 'react';
import { Route, Routes } from 'react-router-dom';

import { AppLayout } from './components/layout/AppLayout';
import { finishStartup } from './components/layout/startupTransition';
import { ProtectedRoute } from './features/auth/components/ProtectedRoute';
import { LoginCallbackPage } from './pages/LoginCallbackPage';
import { LoginPage } from './pages/LoginPage';
import { SectionPage } from './pages/SectionPage';
import { WelcomePage } from './pages/WelcomePage';

const CatalogPage = lazy(() => import('./features/catalog/pages/CatalogPage').then(module => ({ default: module.CatalogPage })));
const QuestionnairePage = lazy(() => import('./features/questionnaire/pages/QuestionnairePage').then(module => ({ default: module.QuestionnairePage })));
const MyPathPage = lazy(() => import('./features/routes/pages/MyPathPage').then(module => ({ default: module.MyPathPage })));
const ManualRoutePage = lazy(() => import('./features/routes/pages/ManualRoutePage').then(module => ({ default: module.ManualRoutePage })));
const SavedRouteDetailPage = lazy(() => import('./features/routes/pages/SavedRouteDetailPage').then(module => ({ default: module.SavedRouteDetailPage })));

const WelcomePreviewPage = import.meta.env.DEV
  ? lazy(() => import('./pages/WelcomePreviewPage'))
  : null;

function App() {
  useEffect(finishStartup, []);
  return (
    <Routes>
      <Route element={<AppLayout variant="welcome" />}>
        <Route index element={<WelcomePage />} />
        <Route path={appRoutes.login} element={<LoginPage />} />
        <Route path={appRoutes.loginCallback} element={<LoginCallbackPage />} />
        {WelcomePreviewPage && <Route path="dev/welcome" element={<WelcomePreviewPage />} />}
      </Route>
      <Route element={<AppLayout />}>
        <Route path={appRoutes.catalog} element={<CatalogPage />} />
        <Route path="*" element={<SectionPage section="notFound" />} />
      </Route>
      <Route element={<ProtectedRoute />}>
        <Route element={<AppLayout />}>
          <Route path={appRoutes.createRoute} element={<ManualRoutePage />} />
          <Route path={appRoutes.manualRoute} element={<ManualRoutePage />} />
          <Route path={appRoutes.proposal} element={<MyPathPage mode="proposal" autoGenerate />} />
          <Route path={appRoutes.savedRoutes} element={<MyPathPage mode="collection" />} />
          <Route path={appRoutes.savedRoutePattern} element={<SavedRouteDetailPage />} />
          <Route path={appRoutes.learningProfile} element={<QuestionnairePage />} />
        </Route>
      </Route>
    </Routes>
  );
}

export default App;
