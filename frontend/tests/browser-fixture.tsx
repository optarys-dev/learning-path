// Development-only regression fixture. Every API request stays in memory; no team data is read or changed.
import { StrictMode, useState } from 'react';
import { createRoot } from 'react-dom/client';
import { MemoryRouter } from 'react-router-dom';
import '../src/i18n';
import '../src/index.css';
import '../src/features/routes/pages/MyPathPage.css';
import { AuthSessionProvider } from '../src/features/auth/context/AuthSessionProvider';
import { NotificationProvider } from '../src/components/notifications';
import { SavedRouteDetailPage } from '../src/features/routes/pages/SavedRouteDetailPage';
import { RouteNoteDialog } from '../src/features/routes/components/RouteNoteDialog';
import { Route, Routes } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

const courses = [1, 2, 3].map(courseId => ({ courseId, slug: 'course-' + courseId, title: 'Curso ' + courseId,
  level: null, imageAlt: '', imageUrl: '', courseUrl: 'https://example.com/course-' + courseId }));
let saved = { routeId: 'fixture', goal: 'Ruta de prueba', recommendationMethod: 'manual', explanation: 'Datos ficticios',
  createdAt: '2026-09-26T12:00:00Z', courses: courses.slice(0, 2).map((course, index) => ({ ...course, courseId: String(course.courseId), position: index + 1, reason: null, progressPercentage: 0 })) };
let catalogFails = false;
const requests: string[] = [];
const assetFetch = window.fetch.bind(window);
window.fetch = async (input, options = {}) => {
  const url = new URL(String(input), window.location.origin);
  const apiRequest = ['/auth', '/courses', '/routes', '/users'].some(prefix => url.pathname === prefix || url.pathname.startsWith(prefix + '/'));
  if (!apiRequest && (url.origin === window.location.origin || url.protocol === 'data:' ||
    url.origin === 'https://fonts.googleapis.com' || url.origin === 'https://fonts.gstatic.com')) return assetFetch(input, options);
  requests.push((options.method ?? 'GET') + ' ' + url.pathname);
  await new Promise<void>((resolve, reject) => {
    const timer = window.setTimeout(resolve, url.pathname.includes('/progress') ? 500 : 50);
    options.signal?.addEventListener('abort', () => { clearTimeout(timer); reject(new DOMException('Aborted', 'AbortError')); }, { once: true });
  });
  if (url.pathname === '/auth/me') return Response.json({ id: 'google-fixture', userId: 'fixture-user', username: 'Review', displayName: null, avatar: null, avatarUrl: null, provider: 'Google', isNewUser: false });
  if (url.pathname === '/courses' && catalogFails) { catalogFails = false; return Response.json({ detail: 'Fixture failure' }, { status: 503 }); }
  if (url.pathname === '/courses') return Response.json({ items: courses, page: 1, pageSize: 100, totalCount: 3, totalPages: 1, hasNextPage: false, hasPreviousPage: false });
  if (url.pathname.endsWith('/progress')) {
    const courseId = url.pathname.split('/')[4];
    const body = JSON.parse(String(options.body)) as { progressPercentage: number };
    saved = { ...saved, courses: saved.courses.map(course => course.courseId === courseId ? { ...course, progressPercentage: body.progressPercentage } : course) };
    return Response.json(saved);
  }
  if (url.pathname === '/routes/fixture') {
    if (options.method === 'PUT') {
      const body = JSON.parse(String(options.body)) as { goal: string; explanation: string; courses: { courseId: string; reason: null }[] };
      saved = { ...saved, goal: body.goal, explanation: body.explanation, courses: body.courses.map((item, index) => {
        const catalog = courses.find(course => String(course.courseId) === item.courseId)!;
        return { ...catalog, ...item, position: index + 1, progressPercentage: saved.courses.find(course => course.courseId === item.courseId)?.progressPercentage ?? 0 };
      }) };
    }
    return Response.json(saved);
  }
  return Response.json({ detail: 'Unconfigured fixture request' }, { status: 404 });
};

export function Fixture() {
  const { i18n } = useTranslation();
  const [dark, setDark] = useState(false);
  const [log, setLog] = useState('');
  const [failure, setFailure] = useState(false);
  const [blockedNote, setBlockedNote] = useState(false);
  return <><nav aria-label="Fixture controls" style={{ padding: '1rem', display: 'flex', gap: '1rem' }}>
    <button onClick={() => { document.documentElement.dataset.theme = dark ? 'light' : 'dark'; setDark(!dark); }}>Alternar tema</button>
    <button onClick={() => { void i18n.changeLanguage(i18n.language === 'es' ? 'en' : 'es'); }}>Alternar idioma</button>
    <button onClick={() => { catalogFails = !failure; setFailure(!failure); }}>Catálogo: {failure ? 'error' : 'correcto'}</button>
    <button onClick={() => setBlockedNote(true)}>Nota sin almacenamiento</button>
    <button onClick={() => setLog(requests.join('\n'))}>Ver solicitudes</button>
  </nav><pre aria-label="Requests">{log}</pre><Routes>
    <Route path="*" element={<SavedRouteDetailPage />} />
    <Route path="/tests/routes/:routeId" element={<SavedRouteDetailPage />} />
  </Routes>{blockedNote && <RouteNoteDialog courseTitle="Nota de prueba" onClose={() => setBlockedNote(false)} onSave={() => { throw new Error('Storage blocked'); }} onDelete={() => { throw new Error('Storage blocked'); }} />}</>;
}
const root = createRoot(document.getElementById('root')!);
root.render(<StrictMode><MemoryRouter initialEntries={['/tests/routes/fixture']}><AuthSessionProvider><NotificationProvider><Fixture /></NotificationProvider></AuthSessionProvider></MemoryRouter></StrictMode>);

if (import.meta.hot) import.meta.hot.dispose(() => { root.unmount(); window.fetch = assetFetch; });
