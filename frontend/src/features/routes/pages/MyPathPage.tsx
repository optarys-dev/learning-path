import { useCourseReorder } from '@/features/routes/hooks/useCourseReorder';
import { appRoutes } from '@/config/navigation';
import { useEffect, useRef, useState } from 'react';
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom';
import { Map as MapIcon, Rocket, Sparkles } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import deviProgress from '@/assets/assessment/07_progreso_de_la_ruta.svg';
import { Button, PageState, QuestSticker } from '@/components/ui';
import { useAuthSession } from '@/features/auth/hooks/useAuthSession';
import { generateRouteRecommendation, saveRoute } from '@/features/routes/api/routes';
import { RouteCourseItem } from '@/features/routes/components/RouteCourseItem';
import { RouteRaceTrack } from '@/features/routes/components/RouteRaceTrack';
import { SavedRoutesSection } from '@/features/routes/components/SavedRoutesSection';
import { buildSaveRouteRequest, clearPendingRoute, createDraftRoute, loadPendingRoute, savePendingRoute } from '@/features/routes/model/draftRoute';
import {
  type DraftRoute,
  type DraftRouteCourse,
} from '@/features/routes/model/types';
import { useNotifications } from '@/components/notifications';
import { clearQuestionnaireDraft } from '@/features/questionnaire/model/draft';
import { useRouteError } from '@/features/routes/hooks/useRouteError';
import './MyPathPage.css';

interface MyPathPageProps {
  mode: 'proposal' | 'collection';
  autoGenerate?: boolean;
  embedded?: boolean;
}

const EMPTY_COURSES: DraftRouteCourse[] = [];

type ProposalOperation = 'idle' | 'regenerating' | 'saving';
type SaveStatus = 'idle' | 'error';

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

export function MyPathPage({ mode, autoGenerate = false, embedded = false }: MyPathPageProps) {
  const { t } = useTranslation();
  const translateError = useRouteError();
  const { notify } = useNotifications();
  const { user, isLoading: isSessionLoading } = useAuthSession();
  const location = useLocation();
  const navigate = useNavigate();
  const [state, setState] = useState<MyPathState>(() => {
    const pending = mode === 'proposal' && user ? loadPendingRoute(user.id) : null;
    return pending ? { status: 'proposal', ...pending, operation: 'idle', generationError: null,
      saveStatus: 'idle', saveError: null } : { status: 'idle' };
  });
  const [announcement, setAnnouncement] = useState('');
  const routeState = location.state as { routeDeleted?: boolean; routeCreated?: boolean; routeId?: string } | null;
  const routeNotice = routeState?.routeDeleted ? t('myPath.routeDeleted')
    : routeState?.routeCreated ? t('myPath.saveSuccess') : null;
  const generationInFlight = useRef(false);
  const saveInFlight = useRef(false);
  const courseElements = useRef(new Map<string, HTMLElement>());
  const emptyStateRef = useRef<HTMLDivElement>(null);
  const { displayedCourses, bindCourse } = useCourseReorder(state.status === 'proposal' ? state.route.courses : EMPTY_COURSES, courseElements,
    (courses, moved, position) => applyCourseEdit(courses, t('myPath.movedAnnouncement', { title: moved.title, position })));

  useEffect(() => {
    document.title = `${t('myPath.pageTitle')} · CODE QUEST 2026`;
  }, [t]);

  useEffect(() => {
    if (mode === 'proposal' && user && state.status === 'proposal') {
      savePendingRoute(user.id, state.route, state.modified);
    }
  }, [mode, user, state]);


  function errorMessage(error: unknown): string { return translateError(error).message; }

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
      const excludedCourseIds = regenerating && currentProposal
        ? currentProposal.route.courses.slice(-1).map(course => course.courseId)
        : [];
      const route = createDraftRoute(await generateRouteRecommendation(excludedCourseIds));
      if (regenerating && currentProposal && (route.courses.length === 0 ||
        route.courses.map(course => course.courseId).sort().join(',') ===
        currentProposal.route.courses.map(course => course.courseId).sort().join(','))) {
        setState({ ...currentProposal, operation: 'idle', generationError: t('myPath.noAlternative') });
        return;
      }
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

  function removeCourse(courseKey: string) {
    if (state.status !== 'proposal' || state.operation !== 'idle') return;
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
      state.operation !== 'idle' || saveInFlight.current) return;
    const currentProposal = state;
    saveInFlight.current = true;
    setState({ ...currentProposal, operation: 'saving', saveStatus: 'idle', saveError: null });

    try {
      const saved = await saveRoute(buildSaveRouteRequest(currentProposal.route));
      clearPendingRoute();
      clearQuestionnaireDraft();
      navigate(appRoutes.savedRoutes, { replace: true, state: { routeCreated: true, routeId: saved.routeId } });
    } catch (error) {
      const message = errorMessage(error);
      setState({ ...currentProposal, operation: 'idle', saveStatus: 'error', saveError: message });
      notify({ tone: 'error', title: t('myPath.errors.http'), message });
    } finally {
      saveInFlight.current = false;
    }
  }

  useEffect(() => {
    if (mode === 'proposal' && autoGenerate && !isSessionLoading && user && !user.isNewUser && state.status === 'idle') {
      const generationTimer = window.setTimeout(() => { void generateRoute(false); }, 0);
      return () => window.clearTimeout(generationTimer);
    }
    return undefined;
    // The route request is deliberately deferred so navigation can render its loading state first.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [autoGenerate, isSessionLoading, mode, state.status, user]);

  if (isSessionLoading) {
    return <PageState kind="loading" title={t('myPath.sessionLoading')} />;
  }
  if (user === null) return <Navigate to={appRoutes.login} replace />;
  if (mode === 'proposal' && user.isNewUser) return embedded
    ? <PageState kind="loading" title={t('myPath.sessionLoading')} />
    : <Navigate to={appRoutes.learningProfile} replace />;

  if (mode === 'collection') {
    return (
      <div className="my-path-page my-path-page--collection">
        <div className="my-path my-path--collection">
          {routeNotice && <p className="my-path__feedback my-path__feedback--success" role="status">{routeNotice}</p>}
          <SavedRoutesSection highlightedRouteId={routeState?.routeCreated ? routeState.routeId : undefined} />
        </div>
      </div>
    );
  }

  if (state.status === 'generation-error') {
    return (
      <div className={`my-path-page my-path-page--proposal${embedded ? ' my-path-page--embedded' : ''}`}>
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
    const generating = state.status === 'generating' || autoGenerate;
    return (
      <div className={`my-path-page my-path-page--proposal${embedded ? ' my-path-page--embedded' : ''}`}>
        <div className="my-path my-path--proposal">
          <section className={`my-path__launch${generating ? ' my-path__launch--generating' : ''}`} aria-busy={generating}>
            <div className="my-path__launch-copy">
              <p className="my-path__eyebrow"><Sparkles size={16} aria-hidden="true" />{t('myPath.eyebrow')}</p>
              <h1 className="cq-journey-title">{t(generating ? 'myPath.generatingTitle' : 'myPath.initialTitle')}</h1>
              <p>{t(generating ? 'myPath.generatingDescription' : 'myPath.initialDescription')}</p>
              {generating ? <ol className="my-path__generation-steps" role="status">
                <li>{t('myPath.generationStepProfile')}</li>
                <li>{t('myPath.generationStepCourses')}</li>
                <li>{t('myPath.generationStepOrder')}</li>
              </ol> : <Button onClick={() => { void generateRoute(false); }}>{t('myPath.generate')}</Button>}
            </div>
            <img src={deviProgress} alt="" className="my-path__launch-mascot" />
          </section>
          {routeNotice && <p className="my-path__feedback my-path__feedback--success" role="status">{routeNotice}</p>}
        </div>
      </div>
    );
  }

  const { route, modified, operation, generationError, saveStatus, saveError } = state;
  const locked = operation !== 'idle';
  const empty = route.courses.length === 0;

  return (
    <div className={`my-path-page my-path-page--proposal${embedded ? ' my-path-page--embedded' : ''}`}>
      <div className="my-path my-path--proposal" aria-busy={operation !== 'idle'}>
      <header className="my-path__hero">
        <div className="my-path__hero-copy">
          <p className="my-path__eyebrow"><Sparkles size={16} aria-hidden="true" />{t('myPath.routeEyebrow')}</p>
          <h1 className="cq-journey-title">{t('myPath.routeTitle')}</h1>
          <p>{t('myPath.routeDescription')}</p>
          {!embedded && <nav className="my-path__creation-options" aria-label={t('manualRoute.methodLabel')}>
            <Link to={appRoutes.createRoute}>{t('manualRoute.manualOption')}</Link>
            <span aria-current="page">{t('manualRoute.recommendedOption')}</span>
          </nav>}
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
                canReorder locked={locked} {...bindCourse(course.uiKey)}
                onRemove={() => removeCourse(course.uiKey)} />
            ))}
          </ol>
          </div>
        )}

        <div className="my-path__feedback-stack">
          {empty && <p className="my-path__feedback my-path__feedback--error" role="alert">{t('myPath.emptySaveError')}</p>}
          {saveStatus === 'error' && <p className="my-path__feedback my-path__feedback--error" role="alert">{saveError}</p>}
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
            <Button variant="ghost" onClick={() => {
              if (!window.confirm(t('myPath.confirmDiscardProposal'))) return;
              clearPendingRoute();
              navigate(appRoutes.savedRoutes);
            }} disabled={operation !== 'idle'}>{t('myPath.cancelProposal')}</Button>
            <Button variant="secondary" onClick={() => { void generateRoute(true); }}
              isLoading={operation === 'regenerating'} loadingLabel={t('myPath.regenerating')}
              disabled={operation === 'saving'}>
              {t('myPath.regenerate')}
            </Button>
            <Button onClick={() => { void saveCurrentRoute(); }} isLoading={operation === 'saving'}
              loadingLabel={t('myPath.saving')}
              disabled={empty || operation === 'regenerating'}>
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
