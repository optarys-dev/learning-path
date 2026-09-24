import { useEffect, useRef, useState } from 'react';
import { Download, X } from 'lucide-react';
import { toPng } from 'html-to-image';
import { useTranslation } from 'react-i18next';
import { routeStats } from '../model/routeLocalState';
import type { RouteCourseLocalState, SavedRoute } from '../model/types';
import devTallesDark from '../../../assets/brand/logo-b.svg';
import devTallesLight from '../../../assets/brand/logo-n.svg';

interface RouteShareDialogProps { route: SavedRoute; localState: RouteCourseLocalState; onClose: () => void; }

export function RouteShareDialog({ route, localState, onClose }: RouteShareDialogProps) {
  const { t } = useTranslation();
  const nodeRef = useRef<HTMLDivElement>(null);
  const [preview, setPreview] = useState<string | null>(null);
  const [creating, setCreating] = useState(false);
  const stats = routeStats(route, localState);
  async function createPreview() {
    const node = nodeRef.current;
    if (!node) return;
    setCreating(true);
    try {
      await document.fonts.ready;
      await new Promise<void>(resolve => requestAnimationFrame(() => resolve()));
      const images = Array.from(node.querySelectorAll('img'));
      await Promise.all(images.map(image => image.complete ? Promise.resolve() : new Promise<void>(resolve => {
        image.addEventListener('load', () => resolve(), { once: true });
        image.addEventListener('error', () => resolve(), { once: true });
      })));
      setPreview(await toPng(node, { pixelRatio: 2, cacheBust: true, backgroundColor: '#201537' }));
    }
    finally { setCreating(false); }
  }
  useEffect(() => { void createPreview(); }, []);
  function download() { if (!preview) return; const link = document.createElement('a'); link.href = preview; link.download = `${route.goal.toLowerCase().replace(/[^a-z0-9]+/gi, '-') || 'mi-ruta'}.png`; link.click(); }
  return <div className="route-dialog-backdrop" role="presentation" onMouseDown={event => { if (event.target === event.currentTarget) onClose(); }}>
    <section className="route-dialog route-share-dialog" role="dialog" aria-modal="true" aria-labelledby="route-share-title"><h2 id="route-share-title" className="my-path__sr-only">{t('myPath.shareRouteTitle')}</h2><button className="route-dialog__close" type="button" onClick={onClose} aria-label={t('myPath.closeDialog')}><X aria-hidden="true" /></button>
      <div className="route-share-dialog__stage">
        <div className="route-share-card route-share-card--source" ref={nodeRef} aria-hidden="true">
          <div className="route-share-card__copy"><div className="route-share-card__brand"><img className="route-share-card__brand-dark" src={devTallesDark} alt="" /><img className="route-share-card__brand-light" src={devTallesLight} alt="" /></div><h3>{t('myPath.myLearningPath')}</h3><h4>{route.goal}</h4>{route.explanation && <span>{route.explanation}</span>}</div>
          <aside className="route-share-card__overview"><div className="route-share-card__progress"><strong>{Math.round(stats.percentage)}%</strong><div><i style={{ width: `${stats.percentage}%` }} /></div><small>{t('myPath.shareProgress', { completed: stats.completed, total: stats.total })}</small></div></aside>
          <ol className="route-share-card__map">{route.courses.slice(0, 6).map((course, index) => <li key={course.courseId}><span>{String(index + 1).padStart(2, '0')}</span>{course.imageUrl ? <img src={course.imageUrl} alt="" /> : <b>{course.title.slice(0, 2)}</b>}<strong>{course.title}</strong></li>)}</ol>
        </div>
        {creating && <div className="route-share-dialog__creating" role="status">{t('myPath.creatingPreview')}</div>}
        {preview && <img className="route-share-dialog__preview" src={preview} alt={t('myPath.sharePreviewAlt', { goal: route.goal })} />}
      </div>
      <footer><button type="button" className="cq-button cq-button--secondary" onClick={onClose}>{t('myPath.cancel')}</button>{preview && <button type="button" className="cq-button cq-button--primary" onClick={download}><Download size={16} aria-hidden="true" />{t('myPath.downloadPng')}</button>}</footer>
    </section>
  </div>;
}
