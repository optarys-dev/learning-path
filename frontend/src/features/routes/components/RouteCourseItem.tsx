import { useCourseDragPreview } from '@/features/routes/hooks/useCourseDragPreview';
import { useEffect, useRef, useState, type DragEvent } from 'react';
import { CheckCircle2, Code2, ExternalLink, FileText, GripVertical, MoreHorizontal, Repeat2, RotateCcw, Star, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { QuestMetric, QuestTab } from '@/components/ui';
import type { CoursePriority, EditableRouteCourse } from '@/features/routes/model/types';
import { safeExternalUrl } from '@/lib/urls';
import { CourseBadges } from '@/features/catalog/components/CourseBadge';

interface RouteCourseItemProps {
  course: EditableRouteCourse;
  dropPosition: 'before' | 'after' | null;
  dragging: boolean;
  elementRef: (element: HTMLElement | null) => void;
  locked: boolean;
  onDragEnd: () => void;
  onDragOver: (event: DragEvent<HTMLElement>) => void;
  onDragStart: (event: DragEvent<HTMLElement>) => void;
  onDrop: (event: DragEvent<HTMLElement>) => void;
  onRemove: () => void;
  position: number;
  showControls?: boolean;
  canReorder?: boolean;
  completed?: boolean;
  hasNote?: boolean;
  priority?: CoursePriority;
  onToggleCompleted?: () => void;
  onNote?: () => void;
  onPriorityChange?: (priority: CoursePriority) => void;
  onReplace?: () => void;
}

function positiveWeeks(value: string | number | null | undefined): number | null {
  const weeks = typeof value === 'number' ? value : Number(value);
  return Number.isFinite(weeks) && weeks > 0 ? weeks : null;
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
  dropPosition,
  dragging,
  elementRef,
  locked,
  onDragEnd,
  onDragOver,
  onDragStart,
  onDrop,
  onRemove,
  position,
  showControls = true,
  canReorder = false,
  completed = false,
  hasNote = false,
  priority = 'normal',
  onToggleCompleted,
  onNote,
  onPriorityChange,
  onReplace,
}: RouteCourseItemProps) {
  const { t } = useTranslation();
  const weeks = positiveWeeks(course.estimatedWeeks);
  const mark = courseMark(course.title);
  const courseUrl = safeExternalUrl(course.courseUrl);
  const courseImage = safeExternalUrl(course.imageUrl);
  const [failedImageUrl, setFailedImageUrl] = useState<string | null>(null);
  const dragPreviewBindings = useCourseDragPreview(onDragStart, onDragEnd);
  const menuRef = useRef<HTMLDivElement>(null);
  const menuButtonRef = useRef<HTMLButtonElement>(null);
  const [optionsOpen, setOptionsOpen] = useState(false);

  useEffect(() => {
    if (!optionsOpen) return;
    const closeOnOutsideClick = (event: MouseEvent) => {
      const target = event.target as Node;
      if (!menuRef.current?.contains(target) && !menuButtonRef.current?.contains(target)) setOptionsOpen(false);
    };
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') return;
      setOptionsOpen(false);
      menuButtonRef.current?.focus();
    };
    document.addEventListener('click', closeOnOutsideClick);
    document.addEventListener('keydown', closeOnEscape);
    return () => {
      document.removeEventListener('click', closeOnOutsideClick);
      document.removeEventListener('keydown', closeOnEscape);
    };
  }, [optionsOpen]);

  return (
    <li className={`my-path__course-step${dragging ? ' is-dragging' : ''}${dropPosition ? ` is-drop-${dropPosition}` : ''}${optionsOpen ? ' is-menu-open' : ''}`}
      ref={elementRef} tabIndex={-1} onDragOver={onDragOver} onDrop={onDrop}>
      <div className="my-path__step-marker" aria-hidden="true">{String(position + 1).padStart(2, '0')}</div>
      <article className={`my-path__course-card${canReorder && !locked ? ' is-draggable' : ''}${completed ? ' is-completed' : ''}`}
        draggable={canReorder && !locked} {...dragPreviewBindings}>
        <div className="my-path__course-visual" aria-hidden="true">
          {courseImage && courseImage !== failedImageUrl
            ? <img src={courseImage} alt="" onError={() => setFailedImageUrl(courseImage)} />
            : mark ?? <Code2 size={24} />}
        </div>
        <div className="my-path__course-copy">
          <div className="my-path__course-signals">
            <QuestTab tone="paper">{t('myPath.stepLabel', { position: position + 1 })}</QuestTab>
            <CourseBadges kinds={course.catalogKinds} />
            <span className={`my-path__course-status${completed ? ' is-completed' : ''}`}>
              {completed ? <CheckCircle2 size={15} aria-hidden="true" /> : <span aria-hidden="true">○</span>}
              {t(completed ? 'myPath.completed' : 'myPath.notStarted')}
            </span>
            {priority !== 'normal' && <span className={`my-path__priority my-path__priority--${priority}`}><Star size={14} aria-hidden="true" />{t(`myPath.priority.${priority}`)}</span>}
            {hasNote && <span className="my-path__note-indicator"><FileText size={14} aria-hidden="true" />{t('myPath.hasNote')}</span>}
            {weeks !== null && <QuestMetric value={t(weeks === 1 ? 'myPath.durationWeek' : 'myPath.durationWeeks', { count: weeks })} label={t('myPath.durationLabel')} />}
          </div>
          <h2>{course.title}</h2>
          {course.reason && <p className="my-path__course-reason">{course.reason}</p>}
          {!showControls && courseUrl && (
            <a className="my-path__course-link" href={courseUrl} target="_blank" rel="noreferrer">
              {t('myPath.viewCourse')}<ExternalLink size={15} aria-hidden="true" />
            </a>
          )}
        </div>
        {showControls && <div className="my-path__course-controls" role="group" aria-label={t('myPath.courseActions', { title: course.title })}>
          {canReorder && !locked && (
            <span className="my-path__drag-handle"
              role="img" aria-label={t('myPath.dragCourse', { title: course.title })}
              title={t('myPath.dragCourse', { title: course.title })}>
              <GripVertical size={20} aria-hidden="true" />
            </span>
          )}
          {onToggleCompleted && <button type="button" className="my-path__status-toggle" onClick={onToggleCompleted} disabled={locked}
            aria-label={t(completed ? 'myPath.markNotStarted' : 'myPath.markCompleted')} title={t(completed ? 'myPath.markNotStarted' : 'myPath.markCompleted')}>
            {completed ? <RotateCcw size={18} aria-hidden="true" /> : <CheckCircle2 size={18} aria-hidden="true" />}
          </button>}
          <div className="my-path__course-menu-wrap"><button ref={menuButtonRef} type="button" className="my-path__more-actions" onClick={() => setOptionsOpen(open => !open)} disabled={locked}
            aria-expanded={optionsOpen} aria-label={t('myPath.moreCourseActions')} title={t('myPath.moreCourseActions')}><MoreHorizontal size={19} aria-hidden="true" /></button>
          </div>
        </div>}
        {showControls && optionsOpen && <div className="my-path__course-menu" ref={menuRef}>
              {onNote && <button type="button" disabled={locked} className="my-path__course-menu-action my-path__course-menu-action--note" onClick={() => { setOptionsOpen(false); menuButtonRef.current?.focus(); onNote(); }}><FileText size={17} aria-hidden="true" /><span>{t(hasNote ? 'myPath.editNote' : 'myPath.addNote')}</span></button>}
              {onPriorityChange && <label className="my-path__course-menu-priority"><span className="my-path__priority-control"><Star size={17} aria-hidden="true" /><select aria-label={t('myPath.priority.label')} value={priority} disabled={locked} onChange={event => onPriorityChange(event.target.value as CoursePriority)}><option value="normal">{t('myPath.priority.normal')}</option><option value="medium">{t('myPath.priority.medium')}</option><option value="high">{t('myPath.priority.high')}</option></select></span><span className="my-path__sr-only">{t('myPath.priority.label')}</span></label>}
              {onReplace && <button type="button" disabled={locked} className="my-path__course-menu-action my-path__course-menu-action--replace" onClick={() => { setOptionsOpen(false); menuButtonRef.current?.focus(); onReplace(); }}><Repeat2 size={17} aria-hidden="true" /><span>{t('myPath.replaceCourse')}</span></button>}
              {canReorder && <button type="button" disabled={locked} className="my-path__course-menu-action my-path__course-menu-delete" onClick={() => { setOptionsOpen(false); onRemove(); }}><Trash2 size={17} aria-hidden="true" /><span>{t('myPath.removeCourse', { title: course.title })}</span></button>}
        </div>}
      </article>
    </li>
  );
}
