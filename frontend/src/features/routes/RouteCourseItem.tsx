import { useRef, type DragEvent, type PointerEvent } from 'react';
import { ArrowDown, ArrowUp, Clock3, Code2, ExternalLink, GripVertical, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import type { EditableRouteCourse } from './types';

interface RouteCourseItemProps {
  course: EditableRouteCourse;
  courseCount: number;
  dropPosition: 'before' | 'after' | null;
  dragging: boolean;
  elementRef: (element: HTMLElement | null) => void;
  locked: boolean;
  onDragEnd: () => void;
  onDragOver: (event: DragEvent<HTMLElement>) => void;
  onDragStart: (event: DragEvent<HTMLElement>) => void;
  onDrop: (event: DragEvent<HTMLElement>) => void;
  onMove: (offset: -1 | 1) => void;
  onRemove: () => void;
  position: number;
  showControls?: boolean;
}

function positiveWeeks(value: string | number | null | undefined): number | null {
  const weeks = typeof value === 'number' ? value : Number(value);
  return Number.isFinite(weeks) && weeks > 0 ? weeks : null;
}

function safeCourseUrl(value: string | null | undefined): string | null {
  if (!value) return null;
  try {
    const url = new URL(value);
    return url.protocol === 'https:' || url.protocol === 'http:' ? url.toString() : null;
  } catch {
    return null;
  }
}

function courseMark(title: string): string | null {
  const normalizedTitle = title.toUpperCase();
  if (normalizedTitle.includes('C#')) return 'C#';
  if (normalizedTitle.includes('.NET')) return '.NET';
  if (normalizedTitle.includes('BLAZOR')) return 'B';
  if (normalizedTitle.includes('GOLANG') || normalizedTitle.startsWith('GO')) return 'GO';
  if (normalizedTitle.includes('JAVA')) return 'JAVA';
  return null;
}

export function RouteCourseItem({
  course,
  courseCount,
  dropPosition,
  dragging,
  elementRef,
  locked,
  onDragEnd,
  onDragOver,
  onDragStart,
  onDrop,
  onMove,
  onRemove,
  position,
  showControls = true,
}: RouteCourseItemProps) {
  const { t } = useTranslation();
  const weeks = positiveWeeks(course.estimatedWeeks);
  const mark = courseMark(course.title);
  const courseUrl = safeCourseUrl(course.courseUrl);
  const dragBlocked = useRef(false);
  const dragPreview = useRef<HTMLElement | null>(null);
  const dragGhost = useRef<HTMLCanvasElement | null>(null);
  const dragMoveListener = useRef<((event: globalThis.DragEvent) => void) | null>(null);
  const dragOffset = useRef({ x: 0, y: 0 });
  const dragFrame = useRef<number | null>(null);

  function handlePointerDown(event: PointerEvent<HTMLElement>) {
    const target = event.target;
    dragBlocked.current = target instanceof Element && Boolean(target.closest(
      'button, a, input, select, textarea, [role="button"], [contenteditable="true"]',
    ));
    const bounds = event.currentTarget.getBoundingClientRect();
    dragOffset.current = {
      x: Math.max(0, Math.min(event.clientX - bounds.left, bounds.width)),
      y: Math.max(0, Math.min(event.clientY - bounds.top, bounds.height)),
    };
  }

  function handleDragStart(event: DragEvent<HTMLElement>) {
    if (dragBlocked.current) {
      event.preventDefault();
      dragBlocked.current = false;
      return;
    }

    const source = event.currentTarget;
    const bounds = source.getBoundingClientRect();
    dragPreview.current?.remove();
    const preview = source.cloneNode(true) as HTMLElement;
    preview.removeAttribute('id');
    preview.querySelectorAll('[id]').forEach(element => element.removeAttribute('id'));
    preview.removeAttribute('draggable');
    preview.setAttribute('aria-hidden', 'true');
    preview.classList.add('my-path__drag-preview');
    preview.style.width = `${bounds.width}px`;
    preview.style.minWidth = `${bounds.width}px`;
    preview.style.maxWidth = `${bounds.width}px`;
    preview.style.height = `${bounds.height}px`;
    preview.style.minHeight = `${bounds.height}px`;
    preview.style.maxHeight = `${bounds.height}px`;
    preview.style.setProperty('--my-path-drag-x', `${bounds.left}px`);
    preview.style.setProperty('--my-path-drag-y', `${bounds.top}px`);
    document.body.append(preview);
    dragPreview.current = preview;

    onDragStart(event);
    const transparentDragImage = document.createElement('canvas');
    transparentDragImage.width = 1;
    transparentDragImage.height = 1;
    transparentDragImage.style.cssText = 'position:fixed;inset:0 auto auto 0;pointer-events:none;';
    document.body.append(transparentDragImage);
    dragGhost.current = transparentDragImage;
    event.dataTransfer.setDragImage(transparentDragImage, 0, 0);

    const moveListener = (dragEvent: globalThis.DragEvent) => {
      moveDragPreview(dragEvent.clientX, dragEvent.clientY);
    };
    dragMoveListener.current = moveListener;
    document.addEventListener('dragover', moveListener);
  }

  function moveDragPreview(clientX: number, clientY: number) {
    if (!dragPreview.current || (clientX === 0 && clientY === 0)) return;
    if (dragFrame.current !== null) cancelAnimationFrame(dragFrame.current);
    const x = clientX - dragOffset.current.x;
    const y = clientY - dragOffset.current.y;
    dragFrame.current = requestAnimationFrame(() => {
      dragPreview.current?.style.setProperty('--my-path-drag-x', `${x}px`);
      dragPreview.current?.style.setProperty('--my-path-drag-y', `${y}px`);
      dragFrame.current = null;
    });
  }

  function handleDrag(event: DragEvent<HTMLElement>) {
    moveDragPreview(event.clientX, event.clientY);
  }

  function handleDragEnd() {
    dragBlocked.current = false;
    if (dragFrame.current !== null) cancelAnimationFrame(dragFrame.current);
    dragFrame.current = null;
    if (dragMoveListener.current) document.removeEventListener('dragover', dragMoveListener.current);
    dragMoveListener.current = null;
    dragGhost.current?.remove();
    dragGhost.current = null;
    dragPreview.current?.remove();
    dragPreview.current = null;
    onDragEnd();
  }

  return (
    <li className={`my-path__course-step${dragging ? ' is-dragging' : ''}${dropPosition ? ` is-drop-${dropPosition}` : ''}`}
      ref={elementRef} tabIndex={-1} onDragOver={onDragOver} onDrop={onDrop}>
      <div className="my-path__step-marker" aria-hidden="true">{String(position + 1).padStart(2, '0')}</div>
      <article className={`my-path__course-card${locked || !showControls ? '' : ' is-draggable'}`}
        draggable={showControls && !locked} onPointerDownCapture={handlePointerDown}
        onPointerUpCapture={() => { dragBlocked.current = false; }}
        onDragStart={handleDragStart} onDrag={handleDrag} onDragEnd={handleDragEnd}>
        <div className="my-path__course-visual" aria-hidden="true">
          {mark ?? <Code2 size={24} />}
        </div>
        <div className="my-path__course-copy">
          <p className="my-path__course-position">{t('myPath.stepLabel', { position: position + 1 })}</p>
          <h2>{course.title}</h2>
          {course.reason && <p className="my-path__course-reason">{course.reason}</p>}
          {weeks !== null && (
            <p className="my-path__course-duration">
              <Clock3 size={16} aria-hidden="true" />
              {t(weeks === 1 ? 'myPath.durationWeek' : 'myPath.durationWeeks', { count: weeks })}
            </p>
          )}
          {!showControls && courseUrl && (
            <a className="my-path__course-link" href={courseUrl} target="_blank" rel="noreferrer">
              {t('myPath.viewCourse')}<ExternalLink size={15} aria-hidden="true" />
            </a>
          )}
        </div>
        {showControls && <div className="my-path__course-controls" role="group" aria-label={t('myPath.courseActions', { title: course.title })}>
          {!locked && (
            <span className="my-path__drag-handle"
              role="img" aria-label={t('myPath.dragCourse', { title: course.title })}
              title={t('myPath.dragCourse', { title: course.title })}>
              <GripVertical size={20} aria-hidden="true" />
            </span>
          )}
          <button type="button" onClick={() => onMove(-1)} disabled={locked || position === 0}
            aria-label={t('myPath.moveUp', { title: course.title })}
            title={t('myPath.moveUp', { title: course.title })}>
            <ArrowUp size={18} aria-hidden="true" />
          </button>
          <button type="button" onClick={() => onMove(1)} disabled={locked || position === courseCount - 1}
            aria-label={t('myPath.moveDown', { title: course.title })}
            title={t('myPath.moveDown', { title: course.title })}>
            <ArrowDown size={18} aria-hidden="true" />
          </button>
          <button type="button" className="my-path__remove-course" onClick={onRemove} disabled={locked}
            aria-label={t('myPath.removeCourse', { title: course.title })}
            title={t('myPath.removeCourse', { title: course.title })}>
            <Trash2 size={18} aria-hidden="true" />
          </button>
        </div>}
      </article>
    </li>
  );
}
