import { useEffect, useMemo, useState } from 'react';
import { ArrowDown, ArrowUp, BookOpen, Check, Map, Plus, Search, Sparkles, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Link, Navigate, useNavigate } from 'react-router-dom';
import { Button } from '../../../components/ui/Button/Button';
import { PageState } from '../../../components/ui/PageState/PageState';
import { useNotifications } from '../../../components/notifications';
import { getAllCatalogCourses } from '../../catalog/api/getCatalogCourses';
import type { CatalogCourse } from '../../catalog/types';
import { CourseBadges } from '../../catalog/components/CourseBadge';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import { saveRoute } from '../api/routes';
import { loadPendingRoute } from '../model/draftRoute';
import { RouteRequestError } from '../model/types';
import './ManualRoutePage.css';

export function ManualRoutePage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { notify } = useNotifications();
  const { user, isLoading: sessionLoading } = useAuthSession();
  const [courses, setCourses] = useState<CatalogCourse[]>([]);
  const [selected, setSelected] = useState<CatalogCourse[]>([]);
  const [goal, setGoal] = useState('');
  const [explanation, setExplanation] = useState('');
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [catalogError, setCatalogError] = useState<string | null>(null);
  const [saveError, setSaveError] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();
    getAllCatalogCourses(controller.signal)
      .then(items => { if (!controller.signal.aborted) { setCourses(items); setCatalogError(null); } })
      .catch(() => { if (!controller.signal.aborted) setCatalogError(t('manualRoute.loadError')); })
      .finally(() => { if (!controller.signal.aborted) setLoading(false); });
    return () => controller.abort();
  }, [t]);

  useEffect(() => { document.title = `${t('manualRoute.title')} · CODE QUEST 2026`; }, [t]);

  const visibleCourses = useMemo(() => courses.filter(course =>
    !query || course.title.toLocaleLowerCase().includes(query.trim().toLocaleLowerCase())), [courses, query]);
  const selectedIds = new Set(selected.map(course => course.courseId));

  function toggleCourse(course: CatalogCourse) {
    setSelected(current => current.some(item => item.courseId === course.courseId)
      ? current.filter(item => item.courseId !== course.courseId)
      : current.length < 30 ? [...current, course] : current);
  }

  function moveCourse(index: number, direction: -1 | 1) {
    const target = index + direction;
    if (target < 0 || target >= selected.length) return;
    setSelected(current => {
      const next = [...current];
      [next[index], next[target]] = [next[target], next[index]];
      return next;
    });
  }

  async function submit() {
    if (!goal.trim() || selected.length === 0 || saving) return;
    setSaving(true);
    setSaveError(null);
    try {
      const route = await saveRoute({ goal: goal.trim(), recommendationMethod: 'manual-v1', explanation: explanation.trim() || null,
        courses: selected.map(course => ({ courseId: String(course.courseId), reason: null })) });
      navigate('/my-path', { replace: true, state: { routeCreated: true, routeId: route.routeId } });
    } catch (caught) {
      const message = caught instanceof RouteRequestError && caught.apiMessage ? caught.apiMessage : t('manualRoute.saveError');
      setSaveError(message);
      notify({ tone: 'error', title: t('manualRoute.saveError'), message });
    } finally { setSaving(false); }
  }

  if (sessionLoading) return <PageState kind="loading" title={t('myPath.sessionLoading')} />;
  if (!user) return <Navigate to="/login" replace />;

  const hasPendingRecommendation = loadPendingRoute(user.id) !== null;

  return <div className="manual-route-page"><div className="manual-route">
    <header className="manual-route__hero"><div><p>{t('manualRoute.eyebrow')}</p><h1>{t('manualRoute.title')}</h1><span>{t('manualRoute.description')}</span></div>
      <div className="manual-route__hero-actions"><nav className="manual-route__creation-options" aria-label={t('manualRoute.methodLabel')}><span aria-current="page"><Map size={16} aria-hidden="true" />{t('manualRoute.manualOption')}</span><Link to={hasPendingRecommendation ? '/create-route/proposal' : '/learning-profile'}><Sparkles size={16} aria-hidden="true" />{t(hasPendingRecommendation ? 'manualRoute.resumeRecommended' : 'manualRoute.recommendedOption')}</Link></nav><strong><Map size={18} aria-hidden="true" />{t('manualRoute.selectedCount', { count: selected.length })}</strong></div>
    </header>
    <section className="manual-route__details" aria-label={t('manualRoute.detailsTitle')}>
      <div className="manual-route__details-heading"><span>{t('manualRoute.detailsStep')}</span><div><h2>{t('manualRoute.detailsTitle')}</h2><p>{t('manualRoute.detailsHint')}</p></div></div>
      <div className="manual-route__fields"><label htmlFor="manual-route-name">{t('manualRoute.nameLabel')}<input id="manual-route-name" value={goal} maxLength={1000} onChange={event => setGoal(event.target.value)} placeholder={t('manualRoute.namePlaceholder')} /></label>
        <label htmlFor="manual-route-description">{t('manualRoute.descriptionLabel')}<textarea id="manual-route-description" value={explanation} maxLength={4000} onChange={event => setExplanation(event.target.value)} placeholder={t('manualRoute.descriptionPlaceholder')} /></label></div>
    </section>
    <section className="manual-route__workspace">
      <section className="manual-route__catalog" aria-labelledby="manual-route-catalog-title">
        <div className="manual-route__section-heading"><span>{t('manualRoute.catalogStep')}</span><div><h2 id="manual-route-catalog-title">{t('manualRoute.catalogTitle')}</h2><p>{t('manualRoute.catalogHint')}</p></div></div>
        <label className="manual-route__search"><Search size={17} aria-hidden="true" /><input aria-label={t('manualRoute.searchPlaceholder')} value={query} onChange={event => setQuery(event.target.value)} placeholder={t('manualRoute.searchPlaceholder')} /></label>
        {loading ? <p className="manual-route__state" role="status">{t('manualRoute.loadingCourses')}</p> : catalogError ? <p className="manual-route__state manual-route__error" role="alert">{catalogError}</p> : visibleCourses.length === 0 ? <p className="manual-route__state">{t('manualRoute.noCourses')}</p> :
          <ul className="manual-route__course-grid">{visibleCourses.map(course => { const active = selectedIds.has(course.courseId); return <li key={course.courseId}><button type="button" className={active ? 'is-selected' : ''} onClick={() => toggleCourse(course)} aria-pressed={active} disabled={!active && selected.length >= 30}>
            <span className="manual-route__course-image">{course.imageUrl ? <img src={course.imageUrl} alt="" /> : <BookOpen aria-hidden="true" />}</span><span><strong>{course.title}</strong><CourseBadges kinds={course.catalogKinds} />{course.level && <small>{course.level}</small>}</span><i>{active ? <Check aria-hidden="true" /> : <Plus aria-hidden="true" />}</i>
          </button></li>; })}</ul>}
      </section>
      <aside className="manual-route__selection"><div className="manual-route__section-heading"><span>{t('manualRoute.orderStep')}</span><div><h2>{t('manualRoute.orderTitle')}</h2><p>{t('manualRoute.orderHint')}</p></div></div>
        {selected.length === 0 ? <p className="manual-route__selection-empty">{t('manualRoute.emptySelection')}</p> : <ol>{selected.map((course, index) => <li key={course.courseId}><span>{index + 1}</span><div className="manual-route__selected-course"><strong>{course.title}</strong><CourseBadges kinds={course.catalogKinds} /></div><div><button type="button" onClick={() => moveCourse(index, -1)} disabled={index === 0} aria-label={t('manualRoute.moveUp', { title: course.title })}><ArrowUp /></button><button type="button" onClick={() => moveCourse(index, 1)} disabled={index === selected.length - 1} aria-label={t('manualRoute.moveDown', { title: course.title })}><ArrowDown /></button><button type="button" onClick={() => toggleCourse(course)} aria-label={t('manualRoute.remove', { title: course.title })}><Trash2 /></button></div></li>)}</ol>}
        {saveError && <p className="manual-route__error" role="alert">{saveError}</p>}
        <div className="manual-route__selection-action"><Button onClick={() => { void submit(); }} isLoading={saving} loadingLabel={t('manualRoute.saving')} disabled={!goal.trim() || selected.length === 0}>{t('manualRoute.save')}</Button></div>
      </aside>
    </section>
  </div></div>;
}
