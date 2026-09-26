import { useState } from 'react';
import { ArrowUpRight, BookOpen } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { QuestTab } from '../../../components/ui';
import type { CatalogCourse } from '../types';

interface CatalogCourseCardProps { course: CatalogCourse; }

export function CatalogCourseCard({ course }: CatalogCourseCardProps) {
  const { t } = useTranslation();
  const [imageFailed, setImageFailed] = useState(false);

  return <article className="catalog-course-card">
    <div className="catalog-course-card__media">
      {!imageFailed && course.imageUrl ? <img src={course.imageUrl} alt={course.imageAlt} loading="lazy" onError={() => setImageFailed(true)} /> : <BookOpen aria-hidden="true" />}
    </div>
    <div className="catalog-course-card__content">
      <div className="catalog-course-card__meta">
        <QuestTab tone="violet">DevTalles</QuestTab>
        {course.level && <QuestTab tone="paper">{course.level}</QuestTab>}
      </div>
      <h3>{course.title}</h3>
      {course.courseUrl && <a className="catalog-course-card__link" href={course.courseUrl} target="_blank" rel="noreferrer" aria-label={`${t('catalog.openCourse')}: ${course.title}`}>
        <span className="catalog-course-card__link-label">{t('catalog.openCourse')}</span>
        <ArrowUpRight size={17} aria-hidden="true" />
      </a>}
    </div>
  </article>;
}