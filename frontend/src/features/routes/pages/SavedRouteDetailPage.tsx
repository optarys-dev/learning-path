import { useCallback, useEffect, useLayoutEffect, useRef, useState, type DragEvent } from 'react';
import { ArrowLeft, Map as MapIcon, Sparkles } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Link, Navigate, useNavigate, useParams } from 'react-router-dom';
import { Button } from '../../../components/ui/Button/Button';
import { PageState } from '../../../components/ui/PageState/PageState';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import { deleteRoute, getSavedRoute, updateRoute } from '../api/routes';
import { RouteCourseItem } from '../components/RouteCourseItem';
import { buildUpdateRouteRequest, createSavedRouteDraft } from '../model/draftRoute';
import { RouteRequestError, type DraftSavedRoute, type DraftSavedRouteCourse, type RouteRequestErrorKind } from '../model/types';
import './MyPathPage.css';

type Operation = 'idle' | 'saving' | 'deleting';
type LoadState = { status: 'loading' } | { status: 'error'; kind: RouteRequestErrorKind; message: string } | { status: 'ready' };
type DropTarget = { courseKey: string; position: 'before' | 'after' } | null;

export function SavedRouteDetailPage() {
  const { t } = useTranslation();
  const { routeId } = useParams();
  const navigate = useNavigate();
  const { user, isLoading: isSessionLoading, refresh: refreshSession } = useAuthSession();
  const [loadState, setLoadState] = useState<LoadState>({ status: 'loading' });
  const [route, setRoute] = useState<DraftSavedRoute | null>(null);
  const [draft, setDraft] = useState<DraftSavedRoute | null>(null);
  const [editing, setEditing] = useState(false);
  const [modified, setModified] = useState(false);
  const [operation, setOperation] = useState<Operation>('idle');
  const [actionError, setActionError] = useState<string | null>(null);
  const [actionSuccess, setActionSuccess] = useState<string | null>(null);
  const [announcement, setAnnouncement] = useState('');
  const [retryVersion, setRetryVersion] = useState(0);
  const [draggingCourse, setDraggingCourse] = useState<string | null>(null);
  const [dragCourses, setDragCourses] = useState<DraftSavedRouteCourse[] | null>(null);
  const [dropTarget, setDropTarget] = useState<DropTarget>(null);
  const draggedCourse = useRef<string | null>(null);
  const dragCoursesRef = useRef<DraftSavedRouteCourse[] | null>(null);
  const lastDragTarget = useRef<string | null>(null);
  const reorderRects = useRef<Map<string, DOMRect> | null>(null);
  const courseElements = useRef(new Map<string, HTMLElement>());
  const emptyStateRef = useRef<HTMLDivElement>(null);

  const translatedError = useCallback((error: unknown): { kind: RouteRequestErrorKind; message: string } => {
    const kind = error instanceof RouteRequestError ? error.kind : 'http';
    if (kind === 'unauthorized') void refreshSession();
    const key = kind === 'invalid-response' ? 'invalidResponse' : kind === 'not-found' ? 'notFound' : kind;
    return { kind, message: error instanceof RouteRequestError && error.apiMessage ? error.apiMessage : t(`myPath.errors.${key}`) };
  }, [refreshSession, t]);

  useEffect(() => {
    if (isSessionLoading || !user || user.isNewUser || !routeId) return;
    let active = true;
    getSavedRoute(routeId).then(savedRoute => {
      if (!active) return;
      const next = createSavedRouteDraft(savedRoute);
      setRoute(next);
      setDraft(next);
      setLoadState({ status: 'ready' });
      document.title = `${savedRoute.goal} · CODE QUEST 2026`;
    }).catch(error => {
      if (!active) return;
      const translated = translatedError(error);
      setLoadState({ status: 'error', ...translated });
    });
    return () => { active = false; };
  }, [isSessionLoading, retryVersion, routeId, translatedError, user]);

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
      element.animate([{ transform: `translateY(${offsetY}px)` }, { transform: 'translateY(0)' }],
        { duration: 180, easing: 'ease-out' });
    });
  }, [dragCourses]);

  if (isSessionLoading) return <PageState kind="loading" title={t('myPath.sessionLoading')} />;
  if (user === null) return <Navigate to="/login" replace />;
  if (user.isNewUser) return <Navigate to="/learning-profile" replace />;
  if (!routeId) return <Navigate to="/my-path" replace />;

  if (loadState.status === 'loading') {
    return <div className="my-path-page"><div className="my-path"><PageState kind="loading" title={t('myPath.loadingRoute')} /></div></div>;
  }
  if (loadState.status === 'error') {
    return <div className="my-path-page"><div className="my-path">
      {loadState.kind === 'not-found' ? (
        <PageState kind="empty" title={t('myPath.routeNotFound')} description={t('myPath.routeNotFoundDescription')}>
          <Link className="cq-button cq-button--secondary" to="/my-path">{t('myPath.backToRoutes')}</Link>
        </PageState>
      ) : (
        <PageState kind="error" title={t('myPath.routeLoadError')} description={loadState.message}
          onRetry={() => {
            setLoadState({ status: 'loading' });
            setRetryVersion(version => version + 1);
          }} />
      )}
    </div></div>;
  }
  if (!route || !draft) return null;

  const currentRoute = editing ? draft : route;
  const displayedCourses = dragCourses ?? currentRoute.courses;
  const locked = operation !== 'idle';

  function setCourses(courses: DraftSavedRouteCourse[], message: string) {
    setDraft(previous => previous ? {
      ...previous,
      courses: courses.map((course, index) => ({ ...course, position: index + 1 })),
    } : previous);
    setModified(true);
    setActionError(null);
    setActionSuccess(null);
    setAnnouncement(message);
  }

  function moveCourse(sourceKey: string, targetKey: string) {
    if (!editing || !draft || locked) return;
    const sourceIndex = draft.courses.findIndex(course => course.uiKey === sourceKey);
    const targetIndex = draft.courses.findIndex(course => course.uiKey === targetKey);
    if (sourceIndex < 0 || targetIndex < 0 || sourceIndex === targetIndex) return;
    const courses = [...draft.courses];
    const [course] = courses.splice(sourceIndex, 1);
    courses.splice(targetIndex, 0, course);
    setCourses(courses, t('myPath.movedAnnouncement', { title: course.title, position: targetIndex + 1 }));
  }

  function removeCourse(courseKey: string) {
    if (!editing || !draft || locked) return;
    const index = draft.courses.findIndex(course => course.uiKey === courseKey);
    if (index < 0) return;
    const removed = draft.courses[index];
    const focusKey = draft.courses[index + 1]?.uiKey ?? draft.courses[index - 1]?.uiKey;
    setCourses(draft.courses.filter(course => course.uiKey !== courseKey),
      t('myPath.removedSavedAnnouncement', { title: removed.title }));
    requestAnimationFrame(() => focusKey ? courseElements.current.get(focusKey)?.focus() : emptyStateRef.current?.focus());
  }

  async function saveChanges() {
    if (!draft || !modified || draft.courses.length === 0 || locked) return;
    setOperation('saving');
    setActionError(null);
    setActionSuccess(null);
    try {
      const updated = createSavedRouteDraft(await updateRoute(draft.routeId, buildUpdateRouteRequest(draft)));
      setRoute(updated);
      setDraft(updated);
      setModified(false);
      setEditing(false);
      const message = t('myPath.updateSuccess');
      setActionSuccess(message);
      setAnnouncement(message);
    } catch (error) {
      setActionError(translatedError(error).message);
    } finally {
      setOperation('idle');
    }
  }

  async function removeRoute() {
    if (locked || !window.confirm(t('myPath.confirmDeleteRoute', { goal: route!.goal }))) return;
    setOperation('deleting');
    setActionError(null);
    setActionSuccess(null);
    try {
      await deleteRoute(route!.routeId);
      navigate('/my-path', { replace: true, state: { routeDeleted: true } });
    } catch (error) {
      setActionError(translatedError(error).message);
      setOperation('idle');
    }
  }

  function cancelEditing() {
    if (modified && !window.confirm(t('myPath.confirmCancelEdit'))) return;
    setDraft(route!);
    setModified(false);
    setEditing(false);
    setActionError(null);
    setActionSuccess(null);
  }

  return (
    <div className="my-path-page">
      <div className="my-path" aria-busy={locked}>
        <Link className="my-path__back-link" to="/my-path"><ArrowLeft size={17} aria-hidden="true" />{t('myPath.backToRoutes')}</Link>
        <header className="my-path__hero">
          <div className="my-path__hero-copy">
            <p className="my-path__eyebrow"><Sparkles size={16} aria-hidden="true" />{t('myPath.savedRouteEyebrow')}</p>
            <h1>{t('myPath.savedRouteTitle')}</h1>
            <p>{t('myPath.savedRouteDescription')}</p>
          </div>
          <section className="my-path__recommendation" aria-labelledby="saved-route-goal">
            <div className="my-path__recommendation-heading"><p>{t('myPath.goalLabel')}</p>
              <p className="my-path__course-count">{t('myPath.courseCount', { count: currentRoute.courses.length })}</p></div>
            <h2 id="saved-route-goal">{currentRoute.goal}</h2>
            {currentRoute.explanation && <p>{currentRoute.explanation}</p>}
          </section>
        </header>

        <section className="my-path__route-panel" aria-labelledby="saved-route-panel-title">
          <div className="my-path__route-panel-header">
            <div className="my-path__route-panel-title"><span aria-hidden="true"><MapIcon size={20} /></span>
              <h2 id="saved-route-panel-title">{t(editing ? 'myPath.editingRoute' : 'myPath.savedRoute')}</h2>
              {modified && <span className="my-path__modified">{t('myPath.unsavedChanges')}</span>}
            </div>
            <div className="my-path__route-overview"><p>{t('myPath.routeSummary', { count: currentRoute.courses.length })}</p></div>
          </div>

          {displayedCourses.length === 0 ? (
            <div className="my-path__empty" role="alert" tabIndex={-1} ref={emptyStateRef}>
              <h2>{t('myPath.emptySavedTitle')}</h2><p>{t('myPath.emptySavedDescription')}</p>
            </div>
          ) : (
            <ol className="my-path__course-list" aria-label={t('myPath.courseListLabel')}>
              {displayedCourses.map((course, position) => (
                <RouteCourseItem key={course.uiKey} course={course} position={position} courseCount={displayedCourses.length}
                  showControls={editing} locked={locked} dragging={draggingCourse === course.uiKey}
                  dropPosition={dropTarget?.courseKey === course.uiKey ? dropTarget.position : null}
                  elementRef={element => element ? courseElements.current.set(course.uiKey, element) : courseElements.current.delete(course.uiKey)}
                  onMove={offset => {
                    const target = displayedCourses[position + offset];
                    if (target) moveCourse(course.uiKey, target.uiKey);
                  }}
                  onRemove={() => removeCourse(course.uiKey)}
                  onDragStart={(event: DragEvent<HTMLElement>) => {
                    draggedCourse.current = course.uiKey;
                    const initialCourses = [...currentRoute.courses];
                    dragCoursesRef.current = initialCourses;
                    setDragCourses(initialCourses);
                    lastDragTarget.current = null;
                    setDraggingCourse(course.uiKey);
                    event.dataTransfer.effectAllowed = 'move';
                    event.dataTransfer.setData('text/plain', course.uiKey);
                  }}
                  onDragOver={event => {
                    if (draggedCourse.current) { event.preventDefault(); event.dataTransfer.dropEffect = 'move'; }
                    if (!draggedCourse.current || draggedCourse.current === course.uiKey || lastDragTarget.current === course.uiKey) return;
                    const currentCourses = dragCoursesRef.current ?? currentRoute.courses;
                    const sourceIndex = currentCourses.findIndex(item => item.uiKey === draggedCourse.current);
                    const targetIndex = currentCourses.findIndex(item => item.uiKey === course.uiKey);
                    if (sourceIndex < 0 || targetIndex < 0) return;
                    const nextPosition = sourceIndex < targetIndex ? 'after' : 'before';
                    setDropTarget({ courseKey: course.uiKey, position: nextPosition });
                    lastDragTarget.current = course.uiKey;
                    reorderRects.current = new Map([...courseElements.current]
                      .map(([key, element]) => [key, element.getBoundingClientRect()]));
                    const nextCourses = [...currentCourses];
                    const [dragged] = nextCourses.splice(sourceIndex, 1);
                    nextCourses.splice(targetIndex, 0, dragged);
                    dragCoursesRef.current = nextCourses;
                    setDragCourses(nextCourses);
                  }}
                  onDrop={event => {
                    event.preventDefault();
                    const source = draggedCourse.current ?? event.dataTransfer.getData('text/plain');
                    const nextCourses = dragCoursesRef.current;
                    if (source && nextCourses && nextCourses.some((item, index) => item.uiKey !== currentRoute.courses[index]?.uiKey)) {
                      const moved = nextCourses.find(item => item.uiKey === source);
                      const finalPosition = nextCourses.findIndex(item => item.uiKey === source);
                      if (moved) setCourses(nextCourses, t('myPath.movedAnnouncement', { title: moved.title, position: finalPosition + 1 }));
                    }
                    draggedCourse.current = null; dragCoursesRef.current = null; lastDragTarget.current = null;
                    setDraggingCourse(null); setDragCourses(null); setDropTarget(null);
                  }}
                  onDragEnd={() => {
                    draggedCourse.current = null; dragCoursesRef.current = null; lastDragTarget.current = null;
                    setDraggingCourse(null); setDragCourses(null); setDropTarget(null);
                  }} />
              ))}
            </ol>
          )}

          {actionError && <p className="my-path__feedback my-path__feedback--error" role="alert">{actionError}</p>}
          {actionSuccess && <p className="my-path__feedback my-path__feedback--success" role="status">{actionSuccess}</p>}
          <footer className="my-path__completion">
            <div className="my-path__completion-copy"><Sparkles size={20} aria-hidden="true" /><div>
              <h2>{t(editing ? 'myPath.editActionTitle' : 'myPath.savedActionTitle')}</h2>
              <p>{t(editing ? 'myPath.editActionDescription' : 'myPath.savedActionDescription')}</p>
            </div></div>
            <div className="my-path__primary-actions">
              {editing ? <>
                <Button variant="secondary" onClick={cancelEditing} disabled={locked}>{t('myPath.cancel')}</Button>
                <Button onClick={() => { void saveChanges(); }} isLoading={operation === 'saving'}
                  loadingLabel={t('myPath.savingChanges')} disabled={!modified || currentRoute.courses.length === 0 || operation === 'deleting'}>
                  {t('myPath.saveChanges')}
                </Button>
              </> : <>
                <Button variant="secondary" onClick={() => { setActionSuccess(null); setEditing(true); }} disabled={locked}>{t('myPath.editRoute')}</Button>
                <Button className="my-path__delete-route" onClick={() => { void removeRoute(); }} isLoading={operation === 'deleting'}
                  loadingLabel={t('myPath.deletingRoute')} disabled={operation === 'saving'}>{t('myPath.deleteRoute')}</Button>
              </>}
            </div>
          </footer>
        </section>
        <p className="my-path__sr-only" aria-live="polite" aria-atomic="true">{announcement}</p>
      </div>
    </div>
  );
}
