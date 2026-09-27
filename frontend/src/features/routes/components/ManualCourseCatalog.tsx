import { useState } from 'react';
import { BookOpen, Check, Plus, Search } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui';
import { useAllCatalogCourses, courseLevelTranslationKey, type CatalogCourse } from '@/features/catalog';
import { routeLimits } from '@/features/routes/model/constants';

interface Props { selected: CatalogCourse[]; onToggle: (course: CatalogCourse) => void; }

export function ManualCourseCatalog({ selected, onToggle }: Props) {
  const { t } = useTranslation();
  const { state, courses, retry } = useAllCatalogCourses();
  const [query, setQuery] = useState('');
  const normalizedQuery = query.trim().toLocaleLowerCase();
  const visibleCourses = courses.filter(course => course.title.toLocaleLowerCase().includes(normalizedQuery));
  const selectedIds = new Set(selected.map(course => course.courseId));

  return <section className="manual-route__catalog" aria-labelledby="manual-route-catalog-title">
    <div className="manual-route__section-heading">
      <span>{t('manualRoute.catalogStep')}</span>
      <div><h2 id="manual-route-catalog-title">{t('manualRoute.catalogTitle')}</h2><p>{t('manualRoute.catalogHint')}</p></div>
    </div>
    <label className="manual-route__search">
      <Search size={17} aria-hidden="true" />
      <input aria-label={t('manualRoute.searchPlaceholder')} value={query} onChange={event => setQuery(event.target.value)} placeholder={t('manualRoute.searchPlaceholder')} />
    </label>
    {state.status === 'loading' ? <p className="manual-route__state" role="status">{t('manualRoute.loadingCourses')}</p>
      : state.status === 'error' ? <div><p className="manual-route__state manual-route__error" role="alert">{t('manualRoute.loadError')}</p><Button variant="secondary" onClick={retry}>{t('layout.retry')}</Button></div>
      : visibleCourses.length === 0 ? <p className="manual-route__state">{t('manualRoute.noCourses')}</p>
      : <ul className="manual-route__course-grid">{visibleCourses.map(course => {
        const active = selectedIds.has(course.courseId);
        const levelKey = course.level ? courseLevelTranslationKey(course.level) : null;
        return <li key={course.courseId}>
          <button type="button" className={active ? 'is-selected' : ''} onClick={() => onToggle(course)} aria-pressed={active} disabled={!active && selected.length >= routeLimits.courses}>
            <span className="manual-route__course-image">{course.imageUrl ? <img src={course.imageUrl} alt="" /> : <BookOpen aria-hidden="true" />}</span>
            <span><strong>{course.title}</strong>{course.level && <small>{levelKey ? t(levelKey) : course.level}</small>}</span>
            <i>{active ? <Check aria-hidden="true" /> : <Plus aria-hidden="true" />}</i>
          </button>
        </li>;
      })}</ul>}
  </section>;
}
