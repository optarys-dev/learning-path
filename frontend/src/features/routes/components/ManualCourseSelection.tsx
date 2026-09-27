import { ArrowDown, ArrowUp, BookOpen, Flag, Route, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui';
import type { CatalogCourse } from '@/features/catalog';
import { CourseBadges } from '@/features/catalog/components/CourseBadge';

interface Props {
  courses: CatalogCourse[];
  canSave: boolean;
  saving: boolean;
  error: string | null;
  onMove: (index: number, direction: -1 | 1) => void;
  onRemove: (course: CatalogCourse) => void;
  onSave: () => Promise<void>;
}

export function ManualCourseSelection({ courses, canSave, saving, error, onMove, onRemove, onSave }: Props) {
  const { t } = useTranslation();
  return <aside className="manual-route__selection">
    <div className="manual-route__section-heading">
      <span>{t('manualRoute.orderStep')}</span>
      <div><h2>{t('manualRoute.orderTitle')}</h2><p>{t('manualRoute.orderHint')}</p></div>
    </div>
    <p className="manual-route__count" role="status">{t('manualRoute.selectedCount', { count: courses.length })}</p>
    {courses.length === 0 ? <div className="manual-route__selection-empty">
      <div className="manual-route__journey" aria-hidden="true"><BookOpen /><Route /><Flag /></div>
      <strong>{t('manualRoute.emptyTitle')}</strong><p>{t('manualRoute.emptySelection')}</p>
    </div>
      : <ol>{courses.map((course, index) => <li key={course.courseId}>
        <span>{index + 1}</span><div className="manual-route__selected-course"><strong>{course.title}</strong><CourseBadges kinds={course.catalogKinds} /></div>
        <div>
          <button type="button" onClick={() => onMove(index, -1)} disabled={index === 0} aria-label={t('manualRoute.moveUp', { title: course.title })}><ArrowUp /></button>
          <button type="button" onClick={() => onMove(index, 1)} disabled={index === courses.length - 1} aria-label={t('manualRoute.moveDown', { title: course.title })}><ArrowDown /></button>
          <button type="button" onClick={() => onRemove(course)} aria-label={t('manualRoute.remove', { title: course.title })}><Trash2 /></button>
        </div>
      </li>)}</ol>}
    {error && <p className="manual-route__error" role="alert">{error}</p>}
    <div className="manual-route__selection-action">
      <Button onClick={() => { void onSave(); }} isLoading={saving} loadingLabel={t('manualRoute.saving')} disabled={!canSave}>{t('manualRoute.save')}</Button>
      <p>{t('manualRoute.saveHint')}</p>
    </div>
  </aside>;
}
