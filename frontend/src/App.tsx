import { lazy } from 'react';
import { Route, Routes } from 'react-router-dom';

import { AppLayout } from './components/layout/AppLayout';
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
          <Route path="create-route" element={<ManualRoutePage />} />
          <Route path="create-route/manual" element={<ManualRoutePage />} />
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
