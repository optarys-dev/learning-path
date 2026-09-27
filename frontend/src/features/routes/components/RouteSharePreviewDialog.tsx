import { Dialog } from '@/components/ui';
import { useEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { Check, Download, Share2, X } from 'lucide-react';
import { toPng } from 'html-to-image';
import { useTranslation } from 'react-i18next';
import { routeStats } from '@/features/routes/model/routeLocalState';
import type { RouteCourseLocalState, SavedRoute } from '@/features/routes/model/types';
import { shareArtworkGoal, shareArtworkSize, type ShareFormat } from '@/features/routes/model/shareArtwork';
import devTallesDark from '@/assets/brand/logo-b.svg';
import devTallesLight from '@/assets/brand/logo-n.svg';
import './RouteShareDialog.css';

interface RouteShareDialogProps { route: SavedRoute; localState: RouteCourseLocalState; onClose: () => void; }
type ShareTheme = 'light' | 'dark';

const formatLabels = {
  landscape: 'myPath.shareFormatLandscape',
  square: 'myPath.shareFormatSquare',
  portrait: 'myPath.shareFormatPortrait',
} as const;
const imageFallback = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=';

async function captureArtwork(node: HTMLDivElement, width: number, height: number): Promise<string> {
  let timeout: ReturnType<typeof setTimeout> | undefined;
  try {
    return await Promise.race([
      (async () => {
        await document.fonts.ready;
        await new Promise<void>(resolve => requestAnimationFrame(() => resolve()));
        const images = Array.from(node.querySelectorAll('img'));
        await Promise.race([
          Promise.all(images.map(image => image.complete ? Promise.resolve() : new Promise<void>(resolve => {
            image.addEventListener('load', () => resolve(), { once: true });
            image.addEventListener('error', () => resolve(), { once: true });
          }))),
          new Promise<void>(resolve => setTimeout(resolve, 5000)),
        ]);
        return toPng(node, {
          width,
          height,
          pixelRatio: 1.5,
          cacheBust: true,
          imagePlaceholder: imageFallback,
          style: { position: 'relative', top: '0', left: '0', zIndex: '0', opacity: '1' },
        });
      })(),
      new Promise<string>((_, reject) => { timeout = setTimeout(() => reject(new Error('Share image timed out')), 20000); }),
    ]);
  } finally {
    clearTimeout(timeout);
  }
}

function currentTheme(): ShareTheme {
  return document.documentElement.dataset.theme === 'light' ? 'light' : 'dark';
}

export function RouteShareDialog({ route, localState, onClose }: RouteShareDialogProps) {
  const { t, i18n } = useTranslation();
  const artwork = useRef<HTMLDivElement>(null);
  const [format, setFormat] = useState<ShareFormat>('landscape');
  const [theme, setTheme] = useState<ShareTheme>(currentTheme);
  const [preview, setPreview] = useState<string | null>(null);
  const [creating, setCreating] = useState(false);
  const [sharing, setSharing] = useState(false);
  const [error, setError] = useState(false);
  const stats = routeStats(route, localState);
  const language = i18n.resolvedLanguage === 'en' ? 'en' : 'es';
  const spec = shareArtworkSize(format, route.courses.length);
  const goal = shareArtworkGoal(route.goal, language);
  const fileName = route.goal.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/gi, '-').replace(/^-|-$/g, '') || 'mi-ruta';

  useEffect(() => {
    const observer = new MutationObserver(() => setTheme(currentTheme()));
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    let cancelled = false;
    const createPreview = async () => {
      const node = artwork.current;
      if (!node) return;
      setPreview(null);
      setCreating(true);
      setError(false);
      try {
        const image = await captureArtwork(node, spec.width, spec.height);
        if (!cancelled) setPreview(image);
      } catch {
        if (!cancelled) setError(true);
      } finally {
        if (!cancelled) setCreating(false);
      }
    };
    void createPreview();
    return () => { cancelled = true; };
  }, [format, theme, language, t, route, localState, spec.width, spec.height]);

  function changeFormat(next: ShareFormat) { setFormat(next); setPreview(null); }
  function download() {
    if (!preview || creating) return;
    const link = document.createElement('a');
    link.href = preview;
    link.download = `${fileName}-${format}-${language}.png`;
    link.click();
  }
  async function share() {
    if (!preview || creating || sharing || !navigator.share || !navigator.canShare) return;
    setSharing(true);
    try {
      const response = await fetch(preview);
      const file = new File([await response.blob()], `${fileName}-${format}-${language}.png`, { type: 'image/png' });
      if (navigator.canShare({ files: [file] })) await navigator.share({ files: [file], title: goal });
      else download();
    } catch (cause) {
      // Dismissing the native sheet is a user decision, not a failed export.
      if (!(cause instanceof DOMException && cause.name === 'AbortError')) setError(true);
    } finally {
      setSharing(false);
    }
  }
  const canShare = typeof navigator !== 'undefined' && typeof navigator.share === 'function' && typeof navigator.canShare === 'function';

  return <Dialog labelledBy="learning-share-title" onClose={onClose}>
    <section className="route-dialog learning-share-dialog">
      <div className="learning-share-dialog__top">
        <div><span className="learning-share-dialog__eyebrow">{t('myPath.shareRoute')}</span><h2 id="learning-share-title">{t('myPath.shareRouteTitle')}</h2></div>
        <button className="learning-share-dialog__close" type="button" onClick={onClose} aria-label={t('myPath.closeDialog')}><X aria-hidden="true" /></button>
      </div>
      <div className="learning-share-dialog__formats" role="group" aria-label={t('myPath.shareFormat')}>
        {(['landscape', 'square', 'portrait'] as const).map(option => <button key={option} type="button" className={format === option ? 'is-selected' : ''} aria-pressed={format === option} onClick={() => changeFormat(option)} disabled={sharing}>
          <span className={`learning-share-dialog__format-icon learning-share-dialog__format-icon--${option}`} aria-hidden="true" /><span>{t(formatLabels[option])}<small>{shareArtworkSize(option, route.courses.length).width} × {shareArtworkSize(option, route.courses.length).height}</small></span>
        </button>)}
      </div>
      <div className="learning-share-dialog__canvas" aria-live="polite">
        {creating && <div className="learning-share-dialog__loading" role="status">{t('myPath.creatingPreview')}</div>}
        {error && <p className="learning-share-dialog__error" role="alert">{t('myPath.sharePreviewError')}</p>}
        {preview && !creating && <img src={preview} alt={t('myPath.sharePreviewAlt', { goal })} />}
      </div>
      <div className="learning-share-dialog__bottom">
        <p className="learning-share-dialog__hint">{t('myPath.shareSingleImage')}</p>
        <div className="learning-share-dialog__actions">
          {canShare && <button type="button" className="cq-button cq-button--secondary" onClick={() => void share()} disabled={!preview || creating || sharing}><Share2 size={16} aria-hidden="true" />{t('myPath.shareImage')}</button>}
          <button type="button" className="cq-button cq-button--primary" onClick={download} disabled={!preview || creating || sharing}><Download size={16} aria-hidden="true" />{t('myPath.downloadPng')}</button>
        </div>
      </div>
      {createPortal(<div className={`learning-share-art learning-share-art--${format} learning-share-art--${theme}`} style={{ width: spec.width, height: spec.height }} ref={artwork} aria-hidden="true" lang={language}>
        <div className="learning-share-art__header">
          <div className="learning-share-art__intro">
            <img className="learning-share-art__logo" src={theme === 'dark' ? devTallesDark : devTallesLight} alt="" />
            <span className="learning-share-art__eyebrow">{t('myPath.myLearningPath')}</span>
            <h3>{goal}</h3>
            <p>{t('myPath.shareDescription', { count: stats.total })}</p>
          </div>
          <div className="learning-share-art__progress">
            <strong>{Math.round(stats.percentage)}%</strong>
            <span>{t('myPath.shareProgress', { completed: stats.completed, total: stats.total })}</span>
            <div><i style={{ width: `${stats.percentage}%` }} /></div>
          </div>
        </div>
        <div className="learning-share-art__map-heading"><span>{t('myPath.shareJourney')}</span></div>
        <ol className={`learning-share-art__map${route.courses.length <= 2 ? ' is-short' : ''}`} style={{ gridTemplateRows: `repeat(${spec.rows}, minmax(0, 1fr))` }}>
          {route.courses.map((course, index) => <li key={`${course.courseId}-${course.position}`}>
            <div className="learning-share-art__step"><span>{String(index + 1).padStart(2, '0')}</span><i /></div>
            {course.imageUrl ? <img src={course.imageUrl} alt="" /> : <b className="learning-share-art__fallback">{course.title.slice(0, 2)}</b>}
            <div className="learning-share-art__course-copy"><strong>{course.title}</strong><small className={course.progressPercentage === 100 ? 'is-completed' : ''}>{course.progressPercentage === 100 && <Check size={15} aria-hidden="true" />}{t(course.progressPercentage === 100 ? 'myPath.completed' : 'myPath.notStarted')}</small></div>
          </li>)}
        </ol>
        <div className="learning-share-art__footer"><span>{t('myPath.shareCourseCount', { total: stats.total })}</span><span>CODE QUEST 2026</span></div>
      </div>, document.body)}
    </section>
  </Dialog>;
}
