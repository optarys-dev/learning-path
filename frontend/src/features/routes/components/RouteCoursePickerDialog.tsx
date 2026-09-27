import { useEffect, useMemo, useState } from 'react';
import { BookOpen, Plus, Search, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { getAllCatalogCourses } from '../../catalog/api/getCatalogCourses';
import type { CatalogCourse } from '../../catalog/types';
import { CourseBadges } from '../../catalog/components/CourseBadge';

interface RouteCoursePickerDialogProps {
  excludedCourseIds: string[];
  onAdd: (course: CatalogCourse) => void;
  onClose: () => void;
}

export function RouteCoursePickerDialog({ excludedCourseIds, onAdd, onClose }: RouteCoursePickerDialogProps) {
  const { t } = useTranslation();
  const [courses, setCourses] = useState<CatalogCourse[]>([]);
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const controller = new AbortController();
    getAllCatalogCourses(controller.signal)
      .then(setCourses)
      .finally(() => setLoading(false));
    return () => controller.abort();
  }, []);

  const available = useMemo(() => courses
    .filter(course => !excludedCourseIds.includes(String(course.courseId)))
    .filter(course => !query || course.title.toLocaleLowerCase().includes(query.trim().toLocaleLowerCase())),
  [courses, excludedCourseIds, query]);

  return <div className="route-dialog-backdrop" role="presentation" onMouseDown={event => { if (event.target === event.currentTarget) onClose(); }}>
    <section className="route-dialog route-picker-dialog" role="dialog" aria-modal="true" aria-labelledby="route-picker-title">
      <h2 id="route-picker-title">{t('manualRoute.addCourseTitle')}</h2>
      <button className="route-dialog__close" type="button" onClick={onClose} aria-label={t('myPath.closeDialog')}><X aria-hidden="true" /></button>
      <label className="route-picker-dialog__search"><Search size={17} aria-hidden="true" /><input value={query} onChange={event => setQuery(event.target.value)} placeholder={t('manualRoute.searchPlaceholder')} autoFocus /></label>
      {loading ? <p role="status">{t('manualRoute.loadingCourses')}</p> : available.length === 0 ? <p className="route-picker-dialog__empty">{t('manualRoute.noCourses')}</p> :
        <ul className="route-picker-dialog__list">{available.map(course => <li key={course.courseId}><button type="button" onClick={() => onAdd(course)}>
          {course.imageUrl ? <img src={course.imageUrl} alt="" /> : <span><BookOpen aria-hidden="true" /></span>}
          <div><strong>{course.title}</strong><CourseBadges kinds={course.catalogKinds} />{course.level && <small>{course.level}</small>}</div><Plus aria-hidden="true" />
        </button></li>)}</ul>}
    </section>
  </div>;
}
