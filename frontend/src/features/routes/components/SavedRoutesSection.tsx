import { useEffect, useState } from 'react';
import { CalendarDays, Map, Route as RouteIcon } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { Button } from '../../../components/ui/Button/Button';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import { getSavedRoutes } from '../api/routes';
import { RouteRequestError, type SavedRoute } from '../model/types';

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
    <section className="my-path__saved" aria-labelledby="saved-routes-title">
      <div className="my-path__saved-heading">
        <div>
          <p className="my-path__eyebrow"><RouteIcon size={16} aria-hidden="true" />{t('myPath.savedEyebrow')}</p>
          <h2 id="saved-routes-title">{t('myPath.savedRoutes')}</h2>
        </div>
        {state.status === 'ready' && <span>{t('myPath.savedCount', { count: state.routes.length })}</span>}
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
          {state.routes.map(route => (
            <li key={route.routeId}>
              <div className="my-path__saved-card-copy">
                <h3>{route.goal}</h3>
                <p><CalendarDays size={15} aria-hidden="true" />
                  {new Intl.DateTimeFormat(i18n.language, { dateStyle: 'medium' }).format(new Date(route.createdAt))}
                  <span aria-hidden="true">·</span>{t('myPath.savedCourseCount', { count: route.courses.length })}
                </p>
                {route.courses.length > 0 && <small>{route.courses.slice(0, 3).map(course => course.title).join(' · ')}</small>}
              </div>
              <Link className="cq-button cq-button--secondary" to={`/my-path/${encodeURIComponent(route.routeId)}`}>
                {t('myPath.viewRoute')}
              </Link>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
