import type { DragEvent } from 'react';
import { ArrowDown, ArrowUp, Clock3, GripVertical, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import type { DraftRouteCourse } from './types';

interface RouteCourseItemProps {
  course: DraftRouteCourse;
  courseCount: number;
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
}

function positiveWeeks(value: string | number): number | null {
  const weeks = typeof value === 'number' ? value : Number(value);
  return Number.isFinite(weeks) && weeks > 0 ? weeks : null;
}

export function RouteCourseItem({
  course,
  courseCount,
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
}: RouteCourseItemProps) {
  const { t } = useTranslation();
  const weeks = positiveWeeks(course.estimatedWeeks);

  return (
    <li className={`my-path__course-step${dragging ? ' is-dragging' : ''}`}
      ref={elementRef} tabIndex={-1} onDragOver={onDragOver} onDrop={onDrop}>
      <div className="my-path__step-marker" aria-hidden="true">{String(position + 1).padStart(2, '0')}</div>
      <article className="my-path__course-card">
        <div className="my-path__course-copy">
          <p className="my-path__course-position">{t('myPath.stepLabel', { position: position + 1 })}</p>
          <h2>{course.title}</h2>
          <p className="my-path__course-reason">{course.reason}</p>
          {weeks !== null && (
            <p className="my-path__course-duration">
              <Clock3 size={16} aria-hidden="true" />
              {t(weeks === 1 ? 'myPath.estimatedWeek' : 'myPath.estimatedWeeks', { count: weeks })}
            </p>
          )}
        </div>
        <div className="my-path__course-controls" role="group" aria-label={t('myPath.courseActions', { title: course.title })}>
          {!locked && (
            <span className="my-path__drag-handle" draggable onDragStart={onDragStart} onDragEnd={onDragEnd}
              role="img" aria-label={t('myPath.dragCourse', { title: course.title })}>
              <GripVertical size={20} aria-hidden="true" />
            </span>
          )}
          <button type="button" onClick={() => onMove(-1)} disabled={locked || position === 0}
            aria-label={t('myPath.moveUp', { title: course.title })}>
            <ArrowUp size={18} aria-hidden="true" />
          </button>
          <button type="button" onClick={() => onMove(1)} disabled={locked || position === courseCount - 1}
            aria-label={t('myPath.moveDown', { title: course.title })}>
            <ArrowDown size={18} aria-hidden="true" />
          </button>
          <button type="button" className="my-path__remove-course" onClick={onRemove} disabled={locked}
            aria-label={t('myPath.removeCourse', { title: course.title })}>
            <Trash2 size={18} aria-hidden="true" />
          </button>
        </div>
      </article>
    </li>
  );
}
