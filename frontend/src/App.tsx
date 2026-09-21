import { Navigate, Route, Routes, useLocation } from 'react-router-dom';
import { useAuthSession } from './features/auth/useAuthSession';
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

function App() {
  const { user, isLoading } = useAuthSession();
  const { pathname } = useLocation();
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
        <Route path="my-path" element={<SectionPage section="myPath" />} />
        <Route path="learning-profile" element={<QuestionnairePage />} />
        <Route path="*" element={<SectionPage section="notFound" />} />
      </Route>
    </Routes>
  );
}

export default App;
