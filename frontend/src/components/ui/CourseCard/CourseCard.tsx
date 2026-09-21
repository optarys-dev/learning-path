import type { ReactNode } from 'react';

import './CourseCard.css';

export type CourseCardState = 'default' | 'in-progress' | 'completed';

interface CourseCardProps {
  action?: ReactNode;
  area: string;
  imageAlt?: string;
  imageSrc?: string;
  level: string;
  progress?: number;
  state?: CourseCardState;
  title: string;
}

const stateLabels: Record<Exclude<CourseCardState, 'default'>, string> = {
  'in-progress': 'En progreso',
  completed: 'Completado',
};

export function CourseCard({
  action,
  area,
  imageAlt = '',
  imageSrc,
  level,
  progress = 0,
  state = 'default',
  title,
}: CourseCardProps) {
  const normalizedProgress = Math.max(0, Math.min(100, progress));
  const stateLabel = state === 'default' ? undefined : stateLabels[state];

  return (
    <article className="cq-course-card">
      {imageSrc ? (
        <img className="cq-course-card__image" src={imageSrc} alt={imageAlt} />
      ) : (
        <div className="cq-course-card__image-placeholder" aria-hidden="true" />
      )}

      <div className="cq-course-card__content">
        <p className="cq-course-card__metadata">{area} · {level}</p>
        <h3 className="cq-course-card__title">{title}</h3>

        {stateLabel && (
          <p className={`cq-course-card__status cq-course-card__status--${state}`}>
            {stateLabel}
          </p>
        )}

        {state !== 'default' && (
          <div
            className="cq-course-card__progress"
            role="progressbar"
            aria-label={`Progreso de ${title}`}
            aria-valuemin={0}
            aria-valuemax={100}
            aria-valuenow={normalizedProgress}
          >
            <span style={{ width: `${normalizedProgress}%` }} />
          </div>
        )}

        {action && <div className="cq-course-card__action">{action}</div>}
      </div>
    </article>
  );
}
