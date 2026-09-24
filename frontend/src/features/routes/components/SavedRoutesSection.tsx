import { useEffect, useState } from 'react';
import { CalendarDays, FileText, Map, Route as RouteIcon, Share2, Star } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { Button } from '../../../components/ui/Button/Button';
import { QuestDoodle, QuestMetric, QuestSticker } from '../../../components/ui';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import { getSavedRoutes } from '../api/routes';
import { RouteRequestError, type SavedRoute } from '../model/types';
import { readRouteCourseLocalState, routeStats } from '../model/routeLocalState';
import roadmapMascot from '../../../assets/codequest/characters/05_mascota_astronauta_presenta_el_roadmap.png';

interface SavedRoutesSectionProps {
  refreshKey?: number;
}

export function SavedRoutesSection({ refreshKey = 0 }: SavedRoutesSectionProps) {
  const { i18n, t } = useTranslation();
  const { refresh: refreshSession } = useAuthSession();
  const [state, setState] = useState<
    { status: 'loading' } |
    { status: 'ready'; routes: SavedRoute[] } |
    { status: 'error'; message: string }
  >({ status: 'loading' });
  const [retryVersion, setRetryVersion] = useState(0);
  const [, setLocalStateVersion] = useState(0);

  useEffect(() => {
    const refresh = () => setLocalStateVersion(version => version + 1);
    window.addEventListener('learning-path:course-state-change', refresh);
    return () => window.removeEventListener('learning-path:course-state-change', refresh);
  }, []);

  useEffect(() => {
    let active = true;
    getSavedRoutes().then(routes => {
      if (active) setState({ status: 'ready', routes });
    }).catch(error => {
      if (!active) return;
      const kind = error instanceof RouteRequestError ? error.kind : 'http';
      if (kind === 'unauthorized') void refreshSession();
      const key = kind === 'invalid-response' ? 'invalidResponse' : kind === 'not-found' ? 'notFound' : kind;
      setState({ status: 'error', message: t(`myPath.errors.${key}`) });
    });
    return () => { active = false; };
  }, [refreshKey, refreshSession, retryVersion, t]);

  return (
    <section className="my-path__saved my-path__saved--notebook" aria-labelledby="saved-routes-title">
      <div className="my-path__saved-heading">
        <div className="my-path__saved-intro">
          <p className="my-path__eyebrow"><RouteIcon size={16} aria-hidden="true" />{t('myPath.savedEyebrow')}</p>
          <h1 className="cq-journey-title" id="saved-routes-title">{t('myPath.collectionTitle')}</h1>
          <p>{t('myPath.collectionDescription')}</p>
          <Link className="cq-button cq-button--primary my-path__saved-create" to="/create-route/proposal">{t('myPath.createAnotherRoute')}</Link>
        </div>
        <img className="my-path__saved-mascot" src={roadmapMascot} alt="" />
        <QuestDoodle kind="arrow" className="my-path__saved-doodle" />
        {state.status === 'ready' && <QuestMetric value={state.routes.length} label={t('myPath.savedCount', { count: state.routes.length })} />}
      </div>

      {state.status === 'loading' && <p className="my-path__saved-status" role="status">{t('myPath.loadingSaved')}</p>}
      {state.status === 'error' && <div className="my-path__saved-error">
        <p className="my-path__feedback my-path__feedback--error" role="alert">{state.message}</p>
        <Button variant="secondary" onClick={() => {
          setState({ status: 'loading' });
          setRetryVersion(version => version + 1);
        }}>{t('layout.retry')}</Button>
      </div>}
      {state.status === 'ready' && state.routes.length === 0 && (
        <div className="my-path__saved-empty">
          <Map size={24} aria-hidden="true" />
          <div><h3>{t('myPath.noSavedRoutes')}</h3><p>{t('myPath.noSavedRoutesDescription')}</p></div>
        </div>
      )}
      {state.status === 'ready' && state.routes.length > 0 && (
        <ul className="my-path__saved-list">
          {state.routes.map(route => {
            const stats = routeStats(route, readRouteCourseLocalState());
            return (
            <li key={route.routeId}>
              <div className="my-path__saved-card-copy">
                <QuestSticker tone="completed">{t('myPath.savedRoute')}</QuestSticker>
                <h3>{route.goal}</h3>
                <p><CalendarDays size={15} aria-hidden="true" />
                  {new Intl.DateTimeFormat(i18n.language, { dateStyle: 'medium' }).format(new Date(route.createdAt))}
                  <span aria-hidden="true">·</span>{t('myPath.savedCourseCount', { count: stats.total })}
                </p>
                {route.explanation && <p className="my-path__saved-description">{route.explanation}</p>}
                <div className="my-path__saved-progress"><span>{Math.round(stats.percentage)}%</span><div><i style={{ width: `${stats.percentage}%` }} /></div></div>
                <div className="my-path__saved-stats"><span>✓ {stats.completed} {t('myPath.completed')}</span><span>○ {stats.notStarted} {t('myPath.notStarted')}</span><span><FileText size={14} aria-hidden="true" />{t('myPath.notesCount', { count: stats.notes })}</span><span><Star size={14} aria-hidden="true" />{t('myPath.priorityCount', { count: stats.priorities })}</span></div>
                {route.courses.length > 0 && <small>{route.courses.slice(0, 3).map(course => course.title).join(' · ')}</small>}
              </div>
              <div className="my-path__saved-actions"><Link className="cq-button cq-button--secondary" to={`/my-path/${encodeURIComponent(route.routeId)}`}>{t('myPath.viewRoute')}</Link><Link className="my-path__saved-share" aria-label={t('myPath.shareRoute')} to={`/my-path/${encodeURIComponent(route.routeId)}#share`}><Share2 size={17} aria-hidden="true" /></Link></div>
            </li>
          ); })}
        </ul>
      )}
    </section>
  );
}
