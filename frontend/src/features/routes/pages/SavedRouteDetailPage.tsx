import { useCallback, useEffect, useLayoutEffect, useRef, useState, type DragEvent } from 'react';
import { FileText, Map as MapIcon, Plus, Share2, Sparkles, Star } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Link, Navigate, useLocation, useNavigate, useParams } from 'react-router-dom';
import { Button } from '../../../components/ui/Button/Button';
import { PageState } from '../../../components/ui/PageState/PageState';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import type { CatalogCourse } from '../../catalog/types';
import { deleteRoute, getSavedRoute, updateCourseProgress, updateRoute } from '../api/routes';
import { RouteCourseItem } from '../components/RouteCourseItem';
import { RouteRaceTrack } from '../components/RouteRaceTrack';
import { RouteNoteDialog } from '../components/RouteNoteDialog';
import { RouteReplaceDialog } from '../components/RouteReplaceDialog';
import { RouteShareDialog } from '../components/RouteShareDialog';
import { RouteCoursePickerDialog } from '../components/RouteCoursePickerDialog';
import { buildUpdateRouteRequest, createSavedRouteDraft } from '../model/draftRoute';
import { getCourseNote, getCoursePriority, readRouteCourseLocalState, removeCourseNote, routeStats, saveCourseNote, setCoursePriority } from '../model/routeLocalState';
import { RouteRequestError, type DraftSavedRoute, type DraftSavedRouteCourse, type RouteCourseLocalState, type RouteRequestErrorKind } from '../model/types';
import './MyPathPage.css';

type Operation = 'idle' | 'saving' | 'deleting';
type LoadState = { status: 'loading' } | { status: 'error'; kind: RouteRequestErrorKind; message: string } | { status: 'ready' };
type DropTarget = { courseKey: string; position: 'before' | 'after' } | null;

export function SavedRouteDetailPage() {
  const { t } = useTranslation();
  const { routeId } = useParams();
  const navigate = useNavigate();
  const location = useLocation();
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
  const [localState, setLocalState] = useState<RouteCourseLocalState>(() => readRouteCourseLocalState());
  const [noteCourse, setNoteCourse] = useState<DraftSavedRouteCourse | null>(null);
  const [replacementCourse, setReplacementCourse] = useState<DraftSavedRouteCourse | null>(null);
  const [shareOpen, setShareOpen] = useState(() => window.location.hash === '#share');
  const [coursePickerOpen, setCoursePickerOpen] = useState(false);
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
    if (isSessionLoading || !user || !routeId) return;
    let active = true;
    const savedRouteRequest = getSavedRoute(routeId);
    savedRouteRequest.then(savedRoute => {
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
  const stats = routeStats(currentRoute, localState);

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

  function addCourse(course: CatalogCourse) {
    if (!editing || !draft || draft.courses.length >= 30 || draft.courses.some(item => item.courseId === String(course.courseId))) return;
    setCourses([...draft.courses, {
      courseId: String(course.courseId),
      uiKey: `${course.courseId}:${crypto.randomUUID()}`,
      position: draft.courses.length + 1,
      title: course.title,
      reason: null,
      imageUrl: course.imageUrl,
      courseUrl: course.courseUrl,
      catalogKinds: course.catalogKinds,
      progressPercentage: 0,
    }], t('manualRoute.addedAnnouncement', { title: course.title }));
    setCoursePickerOpen(false);
  }

  async function changeCourseStatus(course: DraftSavedRouteCourse) {
    if (!route || locked) return;
    const completed = course.progressPercentage !== 100;
    const apply = (value: DraftSavedRoute | null) => value ? ({ ...value, courses: value.courses.map(item => item.courseId === course.courseId ? { ...item, progressPercentage: completed ? 100 : 0 } : item) }) : value;
    setRoute(apply); setDraft(apply);
    try {
      const updated = createSavedRouteDraft(await updateCourseProgress(route.routeId, course.courseId, completed));
      setRoute(updated);
      setDraft(previous => previous ? { ...previous, courses: previous.courses.map(item => {
        const persisted = updated.courses.find(next => next.courseId === item.courseId);
        return persisted ? { ...item, progressPercentage: persisted.progressPercentage } : item;
      }) } : updated);
      setAnnouncement(t(completed ? 'myPath.completedAnnouncement' : 'myPath.notStartedAnnouncement', { title: course.title }));
    } catch (error) {
      const restore = (value: DraftSavedRoute | null) => value ? ({ ...value, courses: value.courses.map(item => item.courseId === course.courseId ? { ...item, progressPercentage: course.progressPercentage } : item) }) : value;
      setRoute(restore); setDraft(restore); setActionError(translatedError(error).message);
    }
  }

  function changePriority(course: DraftSavedRouteCourse, priority: 'high' | 'medium' | 'normal') {
    if (route) setLocalState(setCoursePriority(route.routeId, course.courseId, priority));
  }

  async function replaceCourse(course: DraftSavedRouteCourse, alternative: CatalogCourse) {
    if (!route || locked) return;
    const base = editing ? draft! : route;
    const next = { ...base, courses: base.courses.map(item => item.uiKey === course.uiKey ? { ...item, courseId: String(alternative.courseId), title: alternative.title, imageUrl: alternative.imageUrl, courseUrl: alternative.courseUrl, catalogKinds: alternative.catalogKinds } : item) };
    setOperation('saving');
    try {
      const updated = createSavedRouteDraft(await updateRoute(route.routeId, buildUpdateRouteRequest(next)));
      setRoute(updated); setDraft(updated); setModified(false); setReplacementCourse(null);
      setAnnouncement(t('myPath.replacedAnnouncement', { title: alternative.title }));
    } catch (error) { setActionError(translatedError(error).message); }
    finally { setOperation('idle'); }
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
    <div className="my-path-page my-path-page--saved-detail">
      <div className="my-path my-path--saved-detail" aria-busy={locked}>
        {(location.state as { routeCreated?: boolean } | null)?.routeCreated &&
          <p className="my-path__feedback my-path__feedback--success" role="status">{t('myPath.saveSuccess')}</p>}
        <header className="my-path__hero">
          <div className="my-path__hero-copy">
            <p className="my-path__eyebrow"><Sparkles size={16} aria-hidden="true" />{t('myPath.savedRouteEyebrow')}</p>
            <h1>{t('myPath.savedRouteTitle')}</h1>
            <p>{t('myPath.savedRouteDescription')}</p>
          </div>
          <section className="my-path__recommendation" aria-labelledby="saved-route-goal">
            <div className="my-path__recommendation-heading"><p>{t('myPath.goalLabel')}</p>
              <p className="my-path__course-count">{t('myPath.courseCount', { count: currentRoute.courses.length })}</p></div>
            {editing ? <div className="my-path__route-fields"><input aria-label={t('manualRoute.nameLabel')} value={draft.goal} maxLength={1000} onChange={event => { setDraft({ ...draft, goal: event.target.value }); setModified(true); }} /><textarea aria-label={t('manualRoute.descriptionLabel')} value={draft.explanation ?? ''} maxLength={4000} onChange={event => { setDraft({ ...draft, explanation: event.target.value }); setModified(true); }} placeholder={t('manualRoute.descriptionPlaceholder')} /></div> : <><h2 id="saved-route-goal">{currentRoute.goal}</h2>{currentRoute.explanation && <p>{currentRoute.explanation}</p>}</>}
            <div className="my-path__route-summary"><span><strong>{Math.round(stats.percentage)}%</strong>{t('myPath.progressLabel')}</span><span>✓ {stats.completed} {t('myPath.completed')}</span><span>○ {stats.notStarted} {t('myPath.notStarted')}</span><span><FileText size={14} aria-hidden="true" />{t('myPath.notesCount', { count: stats.notes })}</span><span><Star size={14} aria-hidden="true" />{t('myPath.priorityCount', { count: stats.priorities })}</span></div>
            <div className="my-path__route-progress"><i style={{ width: `${stats.percentage}%` }} /></div>
          </section>
        </header>

        <section className="my-path__route-panel" aria-labelledby="saved-route-panel-title">
          <div className="my-path__route-panel-header">
            <div className="my-path__route-panel-title"><span aria-hidden="true"><MapIcon size={20} /></span>
              <h2 id="saved-route-panel-title">{t(editing ? 'myPath.editingRoute' : 'myPath.savedRoute')}</h2>
              {modified && <span className="my-path__modified">{t('myPath.unsavedChanges')}</span>}
              <div className="my-path__route-overview"><p>{t('myPath.routeSummary', { count: currentRoute.courses.length })}</p></div>
            </div>
            {editing && <div className="my-path__route-panel-actions"><Button variant="secondary" onClick={() => setCoursePickerOpen(true)} disabled={locked || currentRoute.courses.length >= 30}><Plus size={16} aria-hidden="true" />{t('manualRoute.addCourse')}</Button></div>}
          </div>

          {displayedCourses.length === 0 ? (
            <div className="my-path__empty" role="alert" tabIndex={-1} ref={emptyStateRef}>
              <h2>{t('myPath.emptySavedTitle')}</h2><p>{t('myPath.emptySavedDescription')}</p>
            </div>
          ) : (
            <div className="my-path__course-track">
              <RouteRaceTrack courseKeys={displayedCourses.map(course => course.uiKey)} />
              <ol className="my-path__course-list" aria-label={t('myPath.courseListLabel')}>
              {displayedCourses.map((course, position) => (
                <RouteCourseItem key={course.uiKey} course={course} position={position}
                  showControls canReorder={editing} locked={locked} completed={course.progressPercentage === 100}
                  hasNote={Boolean(getCourseNote(localState, currentRoute.routeId, course.courseId))}
                  priority={getCoursePriority(localState, currentRoute.routeId, course.courseId)}
                  onToggleCompleted={() => { void changeCourseStatus(course); }} onNote={() => setNoteCourse(course)}
                  onPriorityChange={priority => changePriority(course, priority)} onReplace={() => setReplacementCourse(course)} dragging={draggingCourse === course.uiKey}
                  dropPosition={dropTarget?.courseKey === course.uiKey ? dropTarget.position : null}
                  elementRef={element => element ? courseElements.current.set(course.uiKey, element) : courseElements.current.delete(course.uiKey)}
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
            </div>
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
                  loadingLabel={t('myPath.savingChanges')} disabled={!modified || !currentRoute.goal.trim() || currentRoute.courses.length === 0 || operation === 'deleting'}>
                  {t('myPath.saveChanges')}
                </Button>
              </> : <>
                <Button variant="secondary" onClick={() => setShareOpen(true)} disabled={locked}><Share2 size={16} aria-hidden="true" />{t('myPath.shareRoute')}</Button>
                <Button variant="secondary" onClick={() => { setActionSuccess(null); setEditing(true); }} disabled={locked}>{t('myPath.editRoute')}</Button>
                <Button className="my-path__delete-route" onClick={() => { void removeRoute(); }} isLoading={operation === 'deleting'}
                  loadingLabel={t('myPath.deletingRoute')} disabled={operation === 'saving'}>{t('myPath.deleteRoute')}</Button>
              </>}
            </div>
          </footer>
        </section>
        <p className="my-path__sr-only" aria-live="polite" aria-atomic="true">{announcement}</p>
        {noteCourse && <RouteNoteDialog courseTitle={noteCourse.title} note={getCourseNote(localState, currentRoute.routeId, noteCourse.courseId)} onClose={() => setNoteCourse(null)} onSave={content => setLocalState(saveCourseNote(currentRoute.routeId, noteCourse.courseId, content))} onDelete={() => setLocalState(removeCourseNote(currentRoute.routeId, noteCourse.courseId))} />}
        {replacementCourse && <RouteReplaceDialog course={replacementCourse} routeCourseIds={currentRoute.courses.map(course => course.courseId)} onClose={() => setReplacementCourse(null)} onReplace={alternative => { void replaceCourse(replacementCourse, alternative); }} />}
        {shareOpen && <RouteShareDialog route={currentRoute} localState={localState} onClose={() => setShareOpen(false)} />}
        {coursePickerOpen && <RouteCoursePickerDialog excludedCourseIds={currentRoute.courses.map(course => course.courseId)} onClose={() => setCoursePickerOpen(false)} onAdd={addCourse} />}
      </div>
    </div>
  );
}
