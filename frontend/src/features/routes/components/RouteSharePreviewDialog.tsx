import { useEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { Check, ChevronLeft, ChevronRight, Download, Share2, X } from 'lucide-react';
import { toPng } from 'html-to-image';
import { useTranslation } from 'react-i18next';
import { routeStats } from '../model/routeLocalState';
import type { RouteCourseLocalState, SavedRoute } from '../model/types';
import devTallesDark from '../../../assets/brand/logo-b.svg';
import devTallesLight from '../../../assets/brand/logo-n.svg';
import './RouteShareDialog.css';

interface RouteShareDialogProps { route: SavedRoute; localState: RouteCourseLocalState; onClose: () => void; }
type ShareFormat = 'landscape' | 'square' | 'portrait';
type ShareTheme = 'light' | 'dark';

const formats: Record<ShareFormat, { width: number; height: number; coursesPerPage: number }> = {
  landscape: { width: 1200, height: 630, coursesPerPage: 4 },
  square: { width: 1080, height: 1080, coursesPerPage: 4 },
  portrait: { width: 1080, height: 1920, coursesPerPage: 6 },
};
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
  const { t } = useTranslation();
  const nodeRefs = useRef<Array<HTMLDivElement | null>>([]);
  const [format, setFormat] = useState<ShareFormat>('landscape');
  const [page, setPage] = useState(0);
  const [theme, setTheme] = useState<ShareTheme>(currentTheme);
  const [preview, setPreview] = useState<string | null>(null);
  const [creating, setCreating] = useState(false);
  const [downloadingAll, setDownloadingAll] = useState(false);
  const [error, setError] = useState(false);
  const stats = routeStats(route, localState);
  const spec = formats[format];
  const pageCount = Math.max(1, Math.ceil(route.courses.length / spec.coursesPerPage));
  const fileName = route.goal.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/gi, '-').replace(/^-|-$/g, '') || 'mi-ruta';

  useEffect(() => {
    const observer = new MutationObserver(() => setTheme(currentTheme()));
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    let cancelled = false;
    const createPreview = async () => {
      const node = nodeRefs.current[page];
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
  }, [format, page, theme, route, localState, spec.width, spec.height]);

  function changeFormat(next: ShareFormat) { setFormat(next); setPage(0); setPreview(null); }
  function changePage(next: number) { setPage(next); setPreview(null); }
  function downloadImage(image: string, index: number) {
    const link = document.createElement('a');
    link.href = image;
    link.download = `${fileName}-${format}${pageCount > 1 ? `-${index + 1}` : ''}.png`;
    link.click();
  }
  function download() { if (preview) downloadImage(preview, page); }
  async function downloadAll() {
    setDownloadingAll(true);
    setError(false);
    try {
      for (let index = 0; index < pageCount; index += 1) {
        const node = nodeRefs.current[index];
        if (!node) throw new Error('Missing share artwork');
        const image = index === page && preview ? preview : await captureArtwork(node, spec.width, spec.height);
        downloadImage(image, index);
      }
    } catch {
      setError(true);
    } finally {
      setDownloadingAll(false);
    }
  }
  async function share() {
    if (!preview || !navigator.share || !navigator.canShare) return;
    const response = await fetch(preview);
    const file = new File([await response.blob()], `${fileName}-${format}.png`, { type: 'image/png' });
    if (navigator.canShare({ files: [file] })) {
      try { await navigator.share({ files: [file], title: route.goal }); }
      catch { /* The user can dismiss the native share sheet. */ }
    }
  }
  const canShare = typeof navigator !== 'undefined' && typeof navigator.share === 'function' && typeof navigator.canShare === 'function';

  return <div className="route-dialog-backdrop" role="presentation" onMouseDown={event => { if (event.target === event.currentTarget) onClose(); }}>
    <section className="route-dialog learning-share-dialog" role="dialog" aria-modal="true" aria-labelledby="learning-share-title">
      <div className="learning-share-dialog__top">
        <div><span className="learning-share-dialog__eyebrow">{t('myPath.shareRoute')}</span><h2 id="learning-share-title">{t('myPath.shareRouteTitle')}</h2></div>
        <button className="learning-share-dialog__close" type="button" onClick={onClose} aria-label={t('myPath.closeDialog')}><X aria-hidden="true" /></button>
      </div>
      <div className="learning-share-dialog__formats" role="group" aria-label={t('myPath.shareFormat')}>
        {(['landscape', 'square', 'portrait'] as const).map(option => <button key={option} type="button" className={format === option ? 'is-selected' : ''} aria-pressed={format === option} onClick={() => changeFormat(option)} disabled={downloadingAll}>
          <span className={`learning-share-dialog__format-icon learning-share-dialog__format-icon--${option}`} aria-hidden="true" /><span>{t(formatLabels[option])}<small>{formats[option].width} × {formats[option].height}</small></span>
        </button>)}
      </div>
      <div className="learning-share-dialog__canvas" aria-live="polite">
        {creating && <div className="learning-share-dialog__loading" role="status">{t('myPath.creatingPreview')}</div>}
        {error && <p className="learning-share-dialog__error" role="alert">{t('myPath.sharePreviewError')}</p>}
        {preview && !creating && <img src={preview} alt={t('myPath.sharePreviewAlt', { goal: route.goal })} />}
      </div>
      <div className="learning-share-dialog__bottom">
        <div className="learning-share-dialog__pages">
          <button type="button" onClick={() => changePage(page - 1)} disabled={page === 0 || downloadingAll} aria-label={t('myPath.sharePreviousPage')}><ChevronLeft aria-hidden="true" /></button>
          <span>{t('myPath.sharePageCount', { current: page + 1, total: pageCount })}</span>
          <button type="button" onClick={() => changePage(page + 1)} disabled={page === pageCount - 1 || downloadingAll} aria-label={t('myPath.shareNextPage')}><ChevronRight aria-hidden="true" /></button>
        </div>
        <div className="learning-share-dialog__actions">
          {canShare && <button type="button" className="cq-button cq-button--secondary" onClick={() => void share()} disabled={!preview || creating || downloadingAll}><Share2 size={16} aria-hidden="true" />{t('myPath.shareImage')}</button>}
          {pageCount > 1 && <button type="button" className="cq-button cq-button--secondary" onClick={() => void downloadAll()} disabled={creating || downloadingAll}><Download size={16} aria-hidden="true" />{t(downloadingAll ? 'myPath.downloadingAllImages' : 'myPath.downloadAllImages')}</button>}
          <button type="button" className="cq-button cq-button--primary" onClick={download} disabled={!preview || creating || downloadingAll}><Download size={16} aria-hidden="true" />{t('myPath.downloadPng')}</button>
        </div>
      </div>
      {createPortal(Array.from({ length: pageCount }, (_, pageIndex) => {
        const pageCourses = route.courses.slice(pageIndex * spec.coursesPerPage, (pageIndex + 1) * spec.coursesPerPage);
        return <div key={`${format}-${pageIndex}`} className={`learning-share-art learning-share-art--${format} learning-share-art--${theme}`} style={{ width: spec.width, height: spec.height }} ref={node => { nodeRefs.current[pageIndex] = node; }} aria-hidden="true">
        <div className="learning-share-art__header">
          <div className="learning-share-art__intro">
            <img className="learning-share-art__logo" src={theme === 'dark' ? devTallesDark : devTallesLight} alt="" />
            <span className="learning-share-art__eyebrow">{t('myPath.myLearningPath')}</span>
            <h3>{route.goal}</h3>
            {route.explanation && <p>{route.explanation}</p>}
          </div>
          <div className="learning-share-art__progress">
            <strong>{Math.round(stats.percentage)}%</strong>
            <span>{t('myPath.shareProgress', { completed: stats.completed, total: stats.total })}</span>
            <div><i style={{ width: `${stats.percentage}%` }} /></div>
          </div>
        </div>
        <div className="learning-share-art__map-heading"><span>{t('myPath.shareJourney')}</span><span>{t('myPath.sharePageCount', { current: pageIndex + 1, total: pageCount })}</span></div>
        <ol className={`learning-share-art__map${pageCourses.length <= 2 ? ' is-short' : ''}`}>
          {pageCourses.map((course, index) => <li key={`${course.courseId}-${course.position}`}>
            <div className="learning-share-art__step"><span>{String(pageIndex * spec.coursesPerPage + index + 1).padStart(2, '0')}</span><i /></div>
            {course.imageUrl ? <img src={course.imageUrl} alt="" /> : <b className="learning-share-art__fallback">{course.title.slice(0, 2)}</b>}
            <div className="learning-share-art__course-copy"><strong>{course.title}</strong><small className={course.progressPercentage === 100 ? 'is-completed' : ''}>{course.progressPercentage === 100 && <Check size={15} aria-hidden="true" />}{t(course.progressPercentage === 100 ? 'myPath.completed' : 'myPath.notStarted')}</small></div>
          </li>)}
        </ol>
        <div className="learning-share-art__footer"><span>{t('myPath.shareCourseCount', { total: stats.total })}</span><span>CODE QUEST 2026</span></div>
      </div>}), document.body)}
    </section>
  </div>;
}
