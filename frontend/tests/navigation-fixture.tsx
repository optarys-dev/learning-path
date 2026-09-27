// Real UI in a sized iframe: no session, database, OAuth, or native sharing is accessed.
import { StrictMode, useState } from 'react';
import { createRoot } from 'react-dom/client';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import i18n from '../src/i18n';
import '../src/index.css';
import { AppLayout } from '../src/components/layout/AppLayout';
import { NotificationProvider } from '../src/components/notifications';
import { AuthSessionContext } from '../src/features/auth/context/authSessionContext';
import { WelcomeView } from '../src/features/welcome/components/WelcomeView';
import { RouteShareDialog } from '../src/features/routes/components/RouteShareDialog';
import type { SavedRoute } from '../src/features/routes/model/types';

const query = new URLSearchParams(location.search);
document.documentElement.dataset.theme = query.get('theme') === 'dark' ? 'dark' : 'light';
void i18n.changeLanguage(query.get('lang') === 'en' ? 'en' : 'es');
const route: SavedRoute = {
  routeId: 'navigation-fixture', goal: 'Desarrollar una aplicación web', explanation: 'Explicación guardada en español.',
  createdAt: '2026-09-27T00:00:00Z', recommendationMethod: 'semantic',
  courses: Array.from({ length: 6 }, (_, index) => ({
    courseId: String(index + 1), position: index + 1, title: `Curso oficial ${index + 1}: React y TypeScript`,
    reason: null, imageUrl: null, courseUrl: null, progressPercentage: index === 0 ? 100 : 0,
  })),
};

export function ExportFixture() {
  const [open, setOpen] = useState(false);
  const { i18n: translator } = useTranslation();
  return <section style={{ padding: '1rem' }}>
    <button onClick={() => setOpen(true)}>Preview six-course image</button>
    <button onClick={() => { void translator.changeLanguage(translator.resolvedLanguage === 'en' ? 'es' : 'en'); }}>Switch export language</button>
    {open && <RouteShareDialog route={route} localState={{ notes: {}, priorities: {} }} onClose={() => setOpen(false)} />}
  </section>;
}

export function ViewportFixture() {
  const [width, setWidth] = useState(390);
  const [theme, setTheme] = useState('light');
  const [language, setLanguage] = useState('en');
  const [signedIn, setSignedIn] = useState(false);
  return <><div style={{ display: 'flex', gap: '.5rem', padding: '1rem', flexWrap: 'wrap' }}>
    {[320, 390, 768, 1088, 1440].map(size => <button key={size} onClick={() => setWidth(size)}>Width {size}</button>)}
    <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>Fixture theme: {theme}</button>
    <button onClick={() => setLanguage(language === 'en' ? 'es' : 'en')}>Fixture language: {language}</button>
    <button onClick={() => setSignedIn(!signedIn)}>Fixture session: {signedIn ? 'signed in' : 'guest'}</button>
  </div><iframe title="Navigation viewport" src={`/tests/navigation.html?frame=1&theme=${theme}&lang=${language}&session=${signedIn ? 'user' : 'guest'}`}
    style={{ display: 'block', width, height: 844, margin: '0 auto', border: '1px solid #888', maxWidth: 'none' }} /></>;
}

const root = createRoot(document.getElementById('root')!);
const user = query.get('session') === 'user' ? { id: 'fixture', userId: 'fixture-user', username: 'Reviewer', displayName: 'Reviewer', provider: 'Google' as const, avatar: null, avatarUrl: null, isNewUser: false } : null;
root.render(<StrictMode>{query.has('frame') ? <MemoryRouter>
  <AuthSessionContext.Provider value={{ user, isLoading: false, sessionError: null, refresh: async () => {}, logout: async () => {}, markPreferencesSaved: () => {} }}>
    <NotificationProvider><Routes><Route element={<AppLayout variant="welcome" />}>
      <Route path="/" element={<><ExportFixture /><WelcomeView /></>} />
      <Route path="*" element={<p>Navigation destination reached.</p>} />
    </Route></Routes></NotificationProvider>
  </AuthSessionContext.Provider>
</MemoryRouter> : <ViewportFixture />}</StrictMode>);

if (import.meta.hot) import.meta.hot.dispose(() => root.unmount());
