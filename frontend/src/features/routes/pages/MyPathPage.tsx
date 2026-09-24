import { useEffect, useLayoutEffect, useRef, useState, type DragEvent } from 'react';
import { Link, Navigate, useLocation } from 'react-router-dom';
import { Map as MapIcon, Rocket, Sparkles } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import deviProgress from '../../../assets/assessment/07_progreso_de_la_ruta.svg';
import { Button } from '../../../components/ui/Button/Button';
import { PageState } from '../../../components/ui/PageState/PageState';
import { QuestDoodle, QuestSticker } from '../../../components/ui';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import { generateRouteRecommendation, saveRoute } from '../api/routes';
import { RouteCourseItem } from '../components/RouteCourseItem';
import { RouteRaceTrack } from '../components/RouteRaceTrack';
import { SavedRoutesSection } from '../components/SavedRoutesSection';
import { buildSaveRouteRequest, createDraftRoute } from '../model/draftRoute';
import { RouteRequestError, type DraftRoute, type DraftRouteCourse, type RouteRequestErrorKind } from '../model/types';
import './MyPathPage.css';

interface MyPathPageProps {
  mode: 'proposal' | 'collection';
  autoGenerate?: boolean;
}

type ProposalOperation = 'idle' | 'regenerating' | 'saving';
type SaveStatus = 'idle' | 'error' | 'saved';
type DropTarget = { courseKey: string; position: 'before' | 'after' } | null;

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
      savedRouteId: string | null;
    };

function replaceCourseOrder(route: DraftRoute, courses: DraftRouteCourse[]): DraftRoute {
  return { ...route, courses };
}

export function MyPathPage({ mode, autoGenerate = false }: MyPathPageProps) {
  const { t } = useTranslation();
  const { user, isLoading: isSessionLoading, refresh: refreshSession } = useAuthSession();
  const location = useLocation();
  const [state, setState] = useState<MyPathState>({ status: 'idle' });
  const [announcement, setAnnouncement] = useState('');
  const [savedRoutesVersion, setSavedRoutesVersion] = useState(0);
  const routeNotice = (location.state as { routeDeleted?: boolean } | null)?.routeDeleted
    ? t('myPath.routeDeleted')
    : null;
  const generationInFlight = useRef(false);
  const saveInFlight = useRef(false);
  const draggedCourse = useRef<string | null>(null);
  const [draggingCourse, setDraggingCourse] = useState<string | null>(null);
  const [dropTarget, setDropTarget] = useState<DropTarget>(null);
  const [dragCourses, setDragCourses] = useState<DraftRouteCourse[] | null>(null);
  const dragCoursesRef = useRef<DraftRouteCourse[] | null>(null);
  const lastDragTarget = useRef<string | null>(null);
  const reorderRects = useRef<Map<string, DOMRect> | null>(null);
  const courseElements = useRef(new Map<string, HTMLElement>());
  const emptyStateRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    document.title = `${t('myPath.pageTitle')} · CODE QUEST 2026`;
  }, [t]);

  useLayoutEffect(() => {
    const previousRects = reorderRects.current;
    reorderRects.current = null;
    if (!previousRects || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

    courseElements.current.forEach((element, key) => {
      const previous = previousRects.get(key);
      if (!previous) return;
      const current = element.getBoundingClientRect();
      const offsetY = previous.top - current.top;
      if (Math.abs(offsetY) < 1) return;
      element.animate(
        [{ transform: `translateY(${offsetY}px)` }, { transform: 'translateY(0)' }],
        { duration: 180, easing: 'ease-out' },
      );
    });
  }, [dragCourses]);

  function fallbackError(kind: RouteRequestErrorKind): string {
    switch (kind) {
      case 'unauthorized': return t('myPath.errors.unauthorized');
      case 'validation': return t('myPath.errors.validation');
      case 'not-found': return t('myPath.errors.notFound');
      case 'server': return t('myPath.errors.server');
      case 'network': return t('myPath.errors.network');
      case 'invalid-response': return t('myPath.errors.invalidResponse');
      case 'http': return t('myPath.errors.http');
    }
  }

  function errorMessage(error: unknown): string {
    if (error instanceof RouteRequestError && error.kind === 'unauthorized') void refreshSession();
    return error instanceof RouteRequestError
      ? error.apiMessage ?? fallbackError(error.kind)
      : t('myPath.errors.http');
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
      const route = createDraftRoute(await generateRouteRecommendation());
      setState({
        status: 'proposal',
        route,
        modified: false,
        operation: 'idle',
        generationError: null,
        saveStatus: 'idle',
        saveError: null,
        savedRouteId: null,
      });
      setAnnouncement(t('myPath.generatedAnnouncement', { count: route.courses.length }));
    } catch (error) {
      const message = errorMessage(error);
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
      const saved = await saveRoute(buildSaveRouteRequest(currentProposal.route));
      setState({ ...currentProposal, modified: false, operation: 'idle', saveStatus: 'saved', saveError: null,
        savedRouteId: saved.routeId });
      setSavedRoutesVersion(version => version + 1);
      setAnnouncement(t('myPath.saveSuccess'));
    } catch (error) {
      setState({ ...currentProposal, operation: 'idle', saveStatus: 'error', saveError: errorMessage(error) });
    } finally {
      saveInFlight.current = false;
    }
  }

  useEffect(() => {
    if (mode === 'proposal' && autoGenerate && state.status === 'idle') {
      const generationTimer = window.setTimeout(() => { void generateRoute(false); }, 0);
      return () => window.clearTimeout(generationTimer);
    }
    return undefined;
    // The route request is deliberately deferred so navigation can render its loading state first.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [autoGenerate, mode, state.status]);

  if (isSessionLoading) {
    return <PageState kind="loading" title={t('myPath.sessionLoading')} />;
  }
  if (user === null) return <Navigate to="/login" replace />;
  if (user.isNewUser) return <Navigate to="/learning-profile" replace />;

  if (mode === 'collection') {
    return (
      <div className="my-path-page my-path-page--collection">
        <div className="my-path my-path--collection">
          {routeNotice && <p className="my-path__feedback my-path__feedback--success" role="status">{routeNotice}</p>}
          <SavedRoutesSection refreshKey={savedRoutesVersion} />
        </div>
      </div>
    );
  }

  if (state.status === 'generation-error') {
    return (
      <div className="my-path-page my-path-page--proposal">
        <div className="my-path my-path--proposal">
          <header className="my-path__page-heading">
            <p>{t('myPath.eyebrow')}</p>
            <h1 className="cq-journey-title">{t('myPath.pageTitle')}</h1>
          </header>
          <PageState kind="error" title={t('myPath.generationErrorTitle')} description={state.message}
            onRetry={() => { void generateRoute(false); }} />
          {routeNotice && <p className="my-path__feedback my-path__feedback--success" role="status">{routeNotice}</p>}
        </div>
      </div>
    );
  }

  if (state.status === 'idle' || state.status === 'generating') {
    const generating = state.status === 'generating';
    return (
      <div className="my-path-page my-path-page--proposal">
        <div className="my-path my-path--proposal">
          <section className="my-path__launch" aria-busy={generating}>
            <div className="my-path__launch-copy">
              <p className="my-path__eyebrow"><Sparkles size={16} aria-hidden="true" />{t('myPath.eyebrow')}</p>
              <h1 className="cq-journey-title">{t('myPath.initialTitle')}</h1>
              <p>{t('myPath.initialDescription')}</p>
              <Button onClick={() => { void generateRoute(false); }} isLoading={generating}
                loadingLabel={t('myPath.generating')}>
                {t('myPath.generate')}
              </Button>
            </div>
            <img src={deviProgress} alt="" className="my-path__launch-mascot" />
          </section>
          {routeNotice && <p className="my-path__feedback my-path__feedback--success" role="status">{routeNotice}</p>}
        </div>
      </div>
    );
  }

  const { route, modified, operation, generationError, saveStatus, saveError, savedRouteId } = state;
  const locked = operation !== 'idle' || saveStatus === 'saved';
  const empty = route.courses.length === 0;
  const displayedCourses = dragCourses ?? route.courses;

  return (
    <div className="my-path-page my-path-page--proposal">
      <div className="my-path my-path--proposal" aria-busy={operation !== 'idle'}>
      <header className="my-path__hero">
        <div className="my-path__hero-copy">
          <p className="my-path__eyebrow"><Sparkles size={16} aria-hidden="true" />{t('myPath.routeEyebrow')}</p>
          <h1 className="cq-journey-title">{t('myPath.routeTitle')}</h1>
          <p>{t('myPath.routeDescription')}</p>
          <span className="my-path__hero-orbit" aria-hidden="true"><Rocket size={18} /></span>
        </div>
        <section className="my-path__recommendation" aria-labelledby="recommendation-goal">
          <div className="my-path__recommendation-heading">
            <p>{t('myPath.goalLabel')}</p>
            <p className="my-path__course-count">{t('myPath.courseCount', { count: route.courses.length })}</p>
          </div>
          <h2 id="recommendation-goal">{route.goal}</h2>
          {route.explanation && <p>{route.explanation}</p>}
        </section>
      </header>

      {generationError && <div className="my-path__feedback my-path__feedback--error" role="alert">{generationError}</div>}

      <section className="my-path__route-panel" aria-labelledby="route-panel-title">
        <QuestDoodle kind="route" className="my-path__route-doodle" />
        <div className="my-path__route-panel-header">
          <div className="my-path__route-panel-title">
            <span aria-hidden="true"><MapIcon size={20} /></span>
            <h2 id="route-panel-title">{t('myPath.proposedRoute')}</h2>
            {modified && <QuestSticker tone="progress">{t('myPath.modified')}</QuestSticker>}
          </div>
          <div className="my-path__route-overview">
            <p>{t('myPath.routeSummary', { count: route.courses.length })}</p>
            {!empty && (
              <div className="my-path__route-progress" aria-hidden="true">
                {route.courses.map(course => <span key={course.uiKey} />)}
              </div>
            )}
          </div>
        </div>

        {empty ? (
          <div className="my-path__empty" role="alert" tabIndex={-1} ref={emptyStateRef}>
            <h2>{t('myPath.emptyTitle')}</h2>
            <p>{t('myPath.emptyDescription')}</p>
          </div>
        ) : (
          <div className="my-path__course-track">
            <RouteRaceTrack courseKeys={displayedCourses.map(course => course.uiKey)} />
            <ol className="my-path__course-list" aria-label={t('myPath.courseListLabel')}>
            {displayedCourses.map((course, position) => (
              <RouteCourseItem key={course.uiKey} course={course} position={position}
                locked={locked} dragging={draggingCourse === course.uiKey}
                dropPosition={dropTarget?.courseKey === course.uiKey ? dropTarget.position : null}
                elementRef={element => {
                  if (element) courseElements.current.set(course.uiKey, element);
                  else courseElements.current.delete(course.uiKey);
                }}
                onRemove={() => removeCourse(course.uiKey)}
                onDragStart={(event: DragEvent<HTMLElement>) => {
                  draggedCourse.current = course.uiKey;
                  const initialCourses = [...route.courses];
                  dragCoursesRef.current = initialCourses;
                  setDragCourses(initialCourses);
                  lastDragTarget.current = null;
                  setDraggingCourse(course.uiKey);
                  event.dataTransfer.effectAllowed = 'move';
                  event.dataTransfer.setData('text/plain', course.uiKey);
                }}
                onDragOver={event => {
                  if (draggedCourse.current) {
                    event.preventDefault();
                    event.dataTransfer.dropEffect = 'move';
                  }
                  if (draggedCourse.current && draggedCourse.current !== course.uiKey &&
                    lastDragTarget.current !== course.uiKey) {
                    const currentCourses = dragCoursesRef.current ?? route.courses;
                    const sourceIndex = currentCourses.findIndex(item => item.uiKey === draggedCourse.current);
                    const targetIndex = currentCourses.findIndex(item => item.uiKey === course.uiKey);
                    if (sourceIndex < 0 || targetIndex < 0) return;
                    const nextPosition = sourceIndex < targetIndex ? 'after' : 'before';
                    setDropTarget(previous =>
                      previous?.courseKey === course.uiKey && previous.position === nextPosition
                        ? previous
                        : { courseKey: course.uiKey, position: nextPosition });
                    lastDragTarget.current = course.uiKey;
                    reorderRects.current = new Map(
                      [...courseElements.current].map(([key, element]) => [key, element.getBoundingClientRect()]),
                    );
                    const nextCourses = [...currentCourses];
                    const [dragged] = nextCourses.splice(sourceIndex, 1);
                    nextCourses.splice(targetIndex, 0, dragged);
                    dragCoursesRef.current = nextCourses;
                    setDragCourses(nextCourses);
                  }
                }}
                onDrop={event => {
                  event.preventDefault();
                  const source = draggedCourse.current ?? event.dataTransfer.getData('text/plain');
                  const nextCourses = dragCoursesRef.current;
                  if (source && nextCourses && nextCourses.some((item, index) => item.uiKey !== route.courses[index]?.uiKey)) {
                    const moved = nextCourses.find(item => item.uiKey === source);
                    const finalPosition = nextCourses.findIndex(item => item.uiKey === source);
                    if (moved && finalPosition >= 0) {
                      applyCourseEdit(nextCourses, t('myPath.movedAnnouncement', {
                        title: moved.title,
                        position: finalPosition + 1,
                      }));
                    }
                  }
                  draggedCourse.current = null;
                  dragCoursesRef.current = null;
                  lastDragTarget.current = null;
                  setDraggingCourse(null);
                  setDragCourses(null);
                  setDropTarget(null);
                }}
                onDragEnd={() => {
                  draggedCourse.current = null;
                  dragCoursesRef.current = null;
                  lastDragTarget.current = null;
                  setDraggingCourse(null);
                  setDragCourses(null);
                  setDropTarget(null);
                }} />
            ))}
          </ol>
          </div>
        )}

        <div className="my-path__feedback-stack">
          {empty && <p className="my-path__feedback my-path__feedback--error" role="alert">{t('myPath.emptySaveError')}</p>}
          {saveStatus === 'error' && <p className="my-path__feedback my-path__feedback--error" role="alert">{saveError}</p>}
          {saveStatus === 'saved' && <p className="my-path__feedback my-path__feedback--success" role="status">
            {t('myPath.saveSuccess')}{savedRouteId && <> <Link to={`/my-path/${encodeURIComponent(savedRouteId)}`}>{t('myPath.viewSavedRoute')}</Link></>}
          </p>}
        </div>

        <footer className="my-path__completion">
          <div className="my-path__completion-copy">
            <Sparkles size={20} aria-hidden="true" />
            <div>
              <h2>{t('myPath.actionTitle')}</h2>
              <p>{t('myPath.actionDescription')}</p>
            </div>
          </div>
          <div className="my-path__primary-actions">
            <Button variant="secondary" onClick={() => { void generateRoute(true); }}
              isLoading={operation === 'regenerating'} loadingLabel={t('myPath.regenerating')}
              disabled={operation === 'saving'}>
              {t('myPath.regenerate')}
            </Button>
            <Button onClick={() => { void saveCurrentRoute(); }} isLoading={operation === 'saving'}
              loadingLabel={t('myPath.saving')}
              disabled={empty || operation === 'regenerating' || saveStatus === 'saved'}>
              {t(saveStatus === 'error' ? 'myPath.retrySave' : 'myPath.save')}
            </Button>
          </div>
        </footer>
      </section>

      {routeNotice && <p className="my-path__feedback my-path__feedback--success" role="status">{routeNotice}</p>}
        <p className="my-path__sr-only" aria-live="polite" aria-atomic="true">{announcement}</p>
      </div>
    </div>
  );
}
