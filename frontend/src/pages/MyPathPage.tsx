import { useEffect, useRef, useState, type DragEvent } from 'react';
import { Navigate } from 'react-router-dom';
import { Sparkles } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import deviProgress from '../assets/assessment/07_progreso_de_la_ruta.svg';
import { Button } from '../components/ui/Button/Button';
import { PageState } from '../components/ui/PageState/PageState';
import { useAuthSession } from '../features/auth';
import { ApiError, isApiError } from '../lib/api';
import { useNotifications } from '../components/notifications';
import { buildSaveRouteRequest, createDraftRoute, getRouteRecommendation, RouteCourseItem, saveRoute,
  type DraftRoute, type DraftRouteCourse } from '../features/routes';
import './MyPathPage.css';

type ProposalOperation = 'idle' | 'regenerating' | 'saving';
type SaveStatus = 'idle' | 'error' | 'saved';

type MyPathState =
  | { status: 'idle' }
  | { status: 'generating' }
  | { status: 'generation-error'; message: string }
  | {
      status: 'proposal';
      route: DraftRoute;
      modified: boolean;
      operation: ProposalOperation;
      generationError: string | null;
      saveStatus: SaveStatus;
      saveError: string | null;
    };

function replaceCourseOrder(route: DraftRoute, courses: DraftRouteCourse[]): DraftRoute {
  return { ...route, courses };
}

export function MyPathPage() {
  const { t } = useTranslation();
  const { user, isLoading: isSessionLoading } = useAuthSession();
  const { notify } = useNotifications();
  const [state, setState] = useState<MyPathState>({ status: 'idle' });
  const [announcement, setAnnouncement] = useState('');
  const generationInFlight = useRef(false);
  const saveInFlight = useRef(false);
  const draggedCourse = useRef<string | null>(null);
  const [draggingCourse, setDraggingCourse] = useState<string | null>(null);
  const courseElements = useRef(new Map<string, HTMLElement>());
  const emptyStateRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    document.title = `${t('myPath.pageTitle')} · CODE QUEST 2026`;
  }, [t]);

  function fallbackError(error: ApiError): string {
    if (error.isUnauthenticated) return t('myPath.errors.unauthorized');
    if (error.isForbidden) return t('myPath.errors.forbidden');
    if (error.kind === 'network') return t('myPath.errors.network');
    if (error.kind === 'invalid-response') return t('myPath.errors.invalidResponse');
    if (error.status === 400) return t('myPath.errors.validation');
    if (error.status !== null && error.status >= 500) return t('myPath.errors.server');
    return t('myPath.errors.http');
  }

  function errorMessage(error: unknown): string {
    return isApiError(error) ? fallbackError(error) : t('myPath.errors.http');
  }

  async function generateRoute(regenerating: boolean) {
    if (generationInFlight.current || saveInFlight.current) return;
    const currentProposal = state.status === 'proposal' ? state : null;
    if (regenerating && currentProposal?.modified && !window.confirm(t('myPath.confirmRegeneration'))) return;

    generationInFlight.current = true;
    if (currentProposal) {
      setState({ ...currentProposal, operation: 'regenerating', generationError: null });
    } else {
      setState({ status: 'generating' });
    }

    try {
      const route = createDraftRoute(await getRouteRecommendation());
      setState({
        status: 'proposal',
        route,
        modified: false,
        operation: 'idle',
        generationError: null,
        saveStatus: 'idle',
        saveError: null,
      });
      setAnnouncement(t('myPath.generatedAnnouncement', { count: route.courses.length }));
    } catch (error) {
      const message = errorMessage(error);
      notify({ tone: 'error', title: t('myPath.generationErrorTitle'), message });
      if (currentProposal) {
        setState({ ...currentProposal, operation: 'idle', generationError: message });
      } else {
        setState({ status: 'generation-error', message });
      }
    } finally {
      generationInFlight.current = false;
    }
  }

  function applyCourseEdit(courses: DraftRouteCourse[], message: string) {
    setState(previous => previous.status === 'proposal' ? {
      ...previous,
      route: replaceCourseOrder(previous.route, courses),
      modified: true,
      generationError: null,
      saveStatus: 'idle',
      saveError: null,
    } : previous);
    setAnnouncement(message);
  }

  function moveCourse(sourceKey: string, targetKey: string) {
    if (state.status !== 'proposal' || state.operation !== 'idle' || state.saveStatus === 'saved') return;
    const sourceIndex = state.route.courses.findIndex(course => course.uiKey === sourceKey);
    const targetIndex = state.route.courses.findIndex(course => course.uiKey === targetKey);
    if (sourceIndex < 0 || targetIndex < 0 || sourceIndex === targetIndex) return;

    const courses = [...state.route.courses];
    const [course] = courses.splice(sourceIndex, 1);
    courses.splice(targetIndex, 0, course);
    applyCourseEdit(courses, t('myPath.movedAnnouncement', { title: course.title, position: targetIndex + 1 }));
  }

  function removeCourse(courseKey: string) {
    if (state.status !== 'proposal' || state.operation !== 'idle' || state.saveStatus === 'saved') return;
    const index = state.route.courses.findIndex(course => course.uiKey === courseKey);
    if (index < 0) return;
    const removed = state.route.courses[index];
    const courses = state.route.courses.filter(course => course.uiKey !== courseKey);
    const focusKey = state.route.courses[index + 1]?.uiKey ?? state.route.courses[index - 1]?.uiKey;
    applyCourseEdit(courses, t('myPath.removedAnnouncement', { title: removed.title }));
    requestAnimationFrame(() => {
      if (focusKey) courseElements.current.get(focusKey)?.focus();
      else emptyStateRef.current?.focus();
    });
  }

  async function saveCurrentRoute() {
    if (state.status !== 'proposal' || state.route.courses.length === 0 ||
      state.operation !== 'idle' || state.saveStatus === 'saved' || saveInFlight.current) return;
    const currentProposal = state;
    saveInFlight.current = true;
    setState({ ...currentProposal, operation: 'saving', saveStatus: 'idle', saveError: null });

    try {
      await saveRoute(buildSaveRouteRequest(currentProposal.route));
      setState({ ...currentProposal, modified: false, operation: 'idle', saveStatus: 'saved', saveError: null });
      setAnnouncement(t('myPath.saveSuccess'));
      notify({ tone: 'success', title: t('myPath.saveSuccess') });
    } catch (error) {
      const message = errorMessage(error);
      setState({ ...currentProposal, operation: 'idle', saveStatus: 'error', saveError: message });
      notify({ tone: 'error', title: t('myPath.errors.http'), message });
    } finally {
      saveInFlight.current = false;
    }
  }

  if (isSessionLoading) {
    return <PageState kind="loading" title={t('myPath.sessionLoading')} />;
  }
  if (user === null) return <Navigate to="/login" replace />;
  if (user.isNewUser) return <Navigate to="/learning-profile" replace />;

  if (state.status === 'generation-error') {
    return (
      <div className="my-path">
        <header className="my-path__page-heading">
          <p>{t('myPath.eyebrow')}</p>
          <h1>{t('myPath.pageTitle')}</h1>
        </header>
        <PageState kind="error" title={t('myPath.generationErrorTitle')} description={state.message}
          onRetry={() => { void generateRoute(false); }} />
      </div>
    );
  }

  if (state.status === 'idle' || state.status === 'generating') {
    const generating = state.status === 'generating';
    return (
      <div className="my-path">
        <section className="my-path__launch" aria-busy={generating}>
          <div className="my-path__launch-copy">
            <p className="my-path__eyebrow"><Sparkles size={16} aria-hidden="true" />{t('myPath.eyebrow')}</p>
            <h1>{t('myPath.initialTitle')}</h1>
            <p>{t('myPath.initialDescription')}</p>
            <Button onClick={() => { void generateRoute(false); }} isLoading={generating}
              loadingLabel={t('myPath.generating')}>
              {t('myPath.generate')}
            </Button>
          </div>
          <img src={deviProgress} alt="" className="my-path__launch-mascot" />
        </section>
      </div>
    );
  }

  const { route, modified, operation, generationError, saveStatus, saveError } = state;
  const locked = operation !== 'idle' || saveStatus === 'saved';
  const empty = route.courses.length === 0;

  return (
    <div className="my-path" aria-busy={operation !== 'idle'}>
      <header className="my-path__route-header">
        <div>
          <p className="my-path__eyebrow"><Sparkles size={16} aria-hidden="true" />{t('myPath.routeEyebrow')}</p>
          <h1>{t('myPath.routeTitle')}</h1>
          <p>{t('myPath.routeDescription')}</p>
        </div>
        <p className="my-path__course-count">{t('myPath.courseCount', { count: route.courses.length })}</p>
      </header>

      <section className="my-path__recommendation" aria-labelledby="recommendation-goal">
        <p>{t('myPath.goalLabel')}</p>
        <h2 id="recommendation-goal">{route.goal}</h2>
        {route.explanation && <p>{route.explanation}</p>}
        {modified && <span className="my-path__modified">{t('myPath.modified')}</span>}
      </section>

      {generationError && <div className="my-path__feedback my-path__feedback--error" role="alert">{generationError}</div>}

      {empty ? (
        <div className="my-path__empty" role="alert" tabIndex={-1} ref={emptyStateRef}>
          <h2>{t('myPath.emptyTitle')}</h2>
          <p>{t('myPath.emptyDescription')}</p>
        </div>
      ) : (
        <ol className="my-path__course-list" aria-label={t('myPath.courseListLabel')}>
          {route.courses.map((course, position) => (
            <RouteCourseItem key={course.uiKey} course={course} position={position}
              courseCount={route.courses.length} locked={locked} dragging={draggingCourse === course.uiKey}
              elementRef={element => {
                if (element) courseElements.current.set(course.uiKey, element);
                else courseElements.current.delete(course.uiKey);
              }}
              onMove={offset => {
                const target = route.courses[position + offset];
                if (target) moveCourse(course.uiKey, target.uiKey);
              }}
              onRemove={() => removeCourse(course.uiKey)}
              onDragStart={(event: DragEvent<HTMLElement>) => {
                draggedCourse.current = course.uiKey;
                setDraggingCourse(course.uiKey);
                event.dataTransfer.effectAllowed = 'move';
                event.dataTransfer.setData('text/plain', course.uiKey);
              }}
              onDragOver={event => {
                if (draggedCourse.current && draggedCourse.current !== course.uiKey) {
                  event.preventDefault();
                  event.dataTransfer.dropEffect = 'move';
                }
              }}
              onDrop={event => {
                event.preventDefault();
                const source = draggedCourse.current ?? event.dataTransfer.getData('text/plain');
                if (source) moveCourse(source, course.uiKey);
                draggedCourse.current = null;
                setDraggingCourse(null);
              }}
              onDragEnd={() => {
                draggedCourse.current = null;
                setDraggingCourse(null);
              }} />
          ))}
        </ol>
      )}

      <div className="my-path__feedback-stack">
        {empty && <p className="my-path__feedback my-path__feedback--error" role="alert">{t('myPath.emptySaveError')}</p>}
        {saveStatus === 'error' && <p className="my-path__feedback my-path__feedback--error" role="alert">{saveError}</p>}
        {saveStatus === 'saved' && <p className="my-path__feedback my-path__feedback--success" role="status">{t('myPath.saveSuccess')}</p>}
      </div>

      <div className="my-path__primary-actions">
        <Button variant="secondary" onClick={() => { void generateRoute(true); }}
          isLoading={operation === 'regenerating'} loadingLabel={t('myPath.regenerating')}
          disabled={operation === 'saving'}>
          {t('myPath.regenerate')}
        </Button>
        <Button onClick={() => { void saveCurrentRoute(); }} isLoading={operation === 'saving'}
          loadingLabel={t('myPath.saving')} disabled={empty || operation === 'regenerating' || saveStatus === 'saved'}>
          {t(saveStatus === 'error' ? 'myPath.retrySave' : 'myPath.save')}
        </Button>
      </div>

      <p className="my-path__sr-only" aria-live="polite" aria-atomic="true">{announcement}</p>
    </div>
  );
}
