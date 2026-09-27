import { useState } from 'react';
import { ArrowUpRight, BookOpen, Library } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { QuestTab } from '../../../components/ui';
import type { CatalogCourse } from '../types';
import { CourseBadges } from './CourseBadge';
import { isSubscriptionLibrary, subscriptionPortalUrl } from '../model/catalogResource';

interface CatalogCourseCardProps { course: CatalogCourse; }

export function CatalogCourseCard({ course }: CatalogCourseCardProps) {
  const { t } = useTranslation();
  const [imageFailed, setImageFailed] = useState(false);
  const isLibrary = isSubscriptionLibrary(course.courseUrl);
  const linkLabel = t(isLibrary ? 'catalog.openPortal' : 'catalog.openCourse');

  return <article className="catalog-course-card">
    <div className="catalog-course-card__media">
      {!imageFailed ? <img src={course.imageUrl} alt={course.imageAlt} loading="lazy" onError={() => setImageFailed(true)} /> : <BookOpen aria-hidden="true" />}
    </div>
    <div className="catalog-course-card__content">
      <div className="catalog-course-card__meta">
        <CourseBadges kinds={course.catalogKinds} />
        {!isLibrary && course.level && <QuestTab tone="paper">{course.level}</QuestTab>}
      </div>
      <h3>{course.title}</h3>
      {isLibrary && <p className="catalog-course-card__library"><Library size={16} aria-hidden="true" /><span>{t('catalog.subscriptionLibrary')}</span></p>}
      <a className="catalog-course-card__link" href={isLibrary ? subscriptionPortalUrl : course.courseUrl} target="_blank" rel="noreferrer" aria-label={`${linkLabel}: ${course.title}`}>
        <span className="catalog-course-card__link-label">{linkLabel}</span>
        <ArrowUpRight size={17} aria-hidden="true" />
      </a>
    </div>
  </article>;
}
