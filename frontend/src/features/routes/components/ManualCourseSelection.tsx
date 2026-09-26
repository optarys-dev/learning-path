import { ArrowDown, ArrowUp, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui';
import type { CatalogCourse } from '@/features/catalog';

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
    {courses.length === 0 ? <p className="manual-route__selection-empty">{t('manualRoute.emptySelection')}</p>
      : <ol>{courses.map((course, index) => <li key={course.courseId}>
        <span>{index + 1}</span><strong>{course.title}</strong>
        <div>
          <button type="button" onClick={() => onMove(index, -1)} disabled={index === 0} aria-label={t('manualRoute.moveUp', { title: course.title })}><ArrowUp /></button>
          <button type="button" onClick={() => onMove(index, 1)} disabled={index === courses.length - 1} aria-label={t('manualRoute.moveDown', { title: course.title })}><ArrowDown /></button>
          <button type="button" onClick={() => onRemove(course)} aria-label={t('manualRoute.remove', { title: course.title })}><Trash2 /></button>
        </div>
      </li>)}</ol>}
    {error && <p className="manual-route__error" role="alert">{error}</p>}
    <div className="manual-route__selection-action">
      <Button onClick={() => { void onSave(); }} isLoading={saving} loadingLabel={t('manualRoute.saving')} disabled={!canSave}>{t('manualRoute.save')}</Button>
    </div>
  </aside>;
}
