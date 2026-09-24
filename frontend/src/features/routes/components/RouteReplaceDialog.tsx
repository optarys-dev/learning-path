import { useEffect, useMemo, useState } from 'react';
import { ArrowRightLeft, Search, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { getCatalogCourses } from '../../catalog/api/getCatalogCourses';
import type { CatalogCourse } from '../../catalog/types';
import type { DraftSavedRouteCourse } from '../model/types';

interface RouteReplaceDialogProps {
  course: DraftSavedRouteCourse;
  routeCourseIds: string[];
  onClose: () => void;
  onReplace: (course: CatalogCourse) => void;
}

function titleTokens(title: string) { return title.toLocaleLowerCase().split(/[^\p{L}\p{N}#+.]+/u).filter(token => token.length > 2); }

export function RouteReplaceDialog({ course, routeCourseIds, onClose, onReplace }: RouteReplaceDialogProps) {
  const { t } = useTranslation();
  const [courses, setCourses] = useState<CatalogCourse[]>([]);
  const [query, setQuery] = useState('');
  const [selected, setSelected] = useState<CatalogCourse | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    void (async () => {
      try {
        const first = await getCatalogCourses(1);
        const pages = await Promise.all(Array.from({ length: Math.max(0, first.totalPages - 1) }, (_, index) => getCatalogCourses(index + 2)));
        if (active) setCourses([...(first.items), ...pages.flatMap(page => page.items)]);
      } finally { if (active) setLoading(false); }
    })();
    return () => { active = false; };
  }, []);

  const currentTokens = useMemo(() => titleTokens(course.title), [course.title]);
  const candidates = useMemo(() => courses
    .filter(item => String(item.courseId) !== course.courseId && !routeCourseIds.includes(String(item.courseId)))
    .filter(item => !query || item.title.toLowerCase().includes(query.toLowerCase()))
    .map(item => ({ item, score: titleTokens(item.title).filter(token => currentTokens.includes(token)).length + (item.level ? 1 : 0) }))
    .sort((a, b) => b.score - a.score || a.item.title.localeCompare(b.item.title)).map(({ item }) => item), [courses, course.courseId, currentTokens, query, routeCourseIds]);

  return <div className="route-dialog-backdrop" role="presentation" onMouseDown={event => { if (event.target === event.currentTarget) onClose(); }}>
    <section className="route-dialog route-replace-dialog" role="dialog" aria-modal="true" aria-labelledby="route-replace-title">
      <h2 id="route-replace-title" className="my-path__sr-only">{t('myPath.replaceCourseTitle')}</h2>
      <button className="route-dialog__close" type="button" onClick={onClose} aria-label={t('myPath.closeDialog')}><X aria-hidden="true" /></button>
      <div className="route-replace-dialog__comparison"><article><span>{t('myPath.currentCourse')}</span><div>{course.imageUrl ? <img src={course.imageUrl} alt="" /> : <b>{course.title.slice(0, 2)}</b>}<strong>{course.title}</strong></div></article><ArrowRightLeft aria-hidden="true" /><article><span>{t('myPath.alternative')}</span><div>{selected?.imageUrl ? <img src={selected.imageUrl} alt="" /> : <b>?</b>}<strong>{selected?.title ?? t('myPath.chooseAlternative')}</strong></div>{selected?.level && <small>{selected.level}</small>}</article></div>
      <div className="route-replace-dialog__filters"><label><Search size={16} aria-hidden="true" /><input value={query} onChange={event => setQuery(event.target.value)} placeholder={t('myPath.searchCourses')} /></label>
        {query && <button type="button" onClick={() => setQuery('')}>{t('myPath.clearFilters')}</button>}
      </div>
      <div className="route-replace-dialog__list" aria-live="polite">{loading ? <p>{t('myPath.loadingAlternatives')}</p> : candidates.map(item => <button type="button" key={item.courseId} className={selected?.courseId === item.courseId ? 'is-selected' : ''} onClick={() => setSelected(item)}>{item.imageUrl ? <img src={item.imageUrl} alt="" /> : <b>{item.title.slice(0, 2)}</b>}<span><strong>{item.title}</strong>{item.level && <small>{item.level}</small>}</span></button>)}</div>
      <footer><button type="button" className="cq-button cq-button--secondary" onClick={onClose}>{t('myPath.cancel')}</button><button type="button" className="cq-button cq-button--primary" disabled={!selected} onClick={() => selected && onReplace(selected)}>{t('myPath.confirmReplacement')}</button></footer>
    </section>
  </div>;
}
