import { courseLevelTranslationKey } from '@/i18n/courseLevel';
import { Dialog } from '@/components/ui';
import { useMemo, useState } from 'react';
import { BookOpen, Plus, Search, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { useAllCatalogCourses, type CatalogCourse } from '@/features/catalog';
import { CourseBadges } from '@/features/catalog/components/CourseBadge';

interface RouteCoursePickerDialogProps {
  excludedCourseIds: string[];
  onAdd: (course: CatalogCourse) => void;
  onClose: () => void;
}

export function RouteCoursePickerDialog({ excludedCourseIds, onAdd, onClose }: RouteCoursePickerDialogProps) {
  const { t } = useTranslation();
  function levelLabel(level: string) { const key = courseLevelTranslationKey(level); return key ? t(key) : level; }
  const { state, courses, retry } = useAllCatalogCourses();
  const [query, setQuery] = useState('');
  const available = useMemo(() => courses
    .filter(course => !excludedCourseIds.includes(String(course.courseId)))
    .filter(course => !query || course.title.toLocaleLowerCase().includes(query.trim().toLocaleLowerCase())),
  [courses, excludedCourseIds, query]);

  return <Dialog labelledBy="route-picker-title" onClose={onClose}>
    <section className="route-dialog route-picker-dialog">
      <h2 id="route-picker-title">{t('manualRoute.addCourseTitle')}</h2>
      <button className="route-dialog__close" type="button" onClick={onClose} aria-label={t('myPath.closeDialog')}><X aria-hidden="true" /></button>
      <label className="route-picker-dialog__search"><Search size={17} aria-hidden="true" /><input value={query} onChange={event => setQuery(event.target.value)} aria-label={t('manualRoute.searchPlaceholder')} placeholder={t('manualRoute.searchPlaceholder')} autoFocus data-dialog-initial-focus /></label>
      {state.status === 'loading' ? <p role="status">{t('manualRoute.loadingCourses')}</p> : state.status === 'error' ? <div><p role="alert">{t('manualRoute.loadError')}</p><button type="button" onClick={retry}>{t('layout.retry')}</button></div> : available.length === 0 ? <p className="route-picker-dialog__empty">{t('manualRoute.noCourses')}</p> :
        <ul className="route-picker-dialog__list">{available.map(course => <li key={course.courseId}><button type="button" onClick={() => onAdd(course)}>
          {course.imageUrl ? <img src={course.imageUrl} alt="" /> : <span><BookOpen aria-hidden="true" /></span>}
          <div><strong>{course.title}</strong><CourseBadges kinds={course.catalogKinds} />{course.level && <small>{levelLabel(course.level)}</small>}</div><Plus aria-hidden="true" />
        </button></li>)}</ul>}
    </section>
  </Dialog>;
}
