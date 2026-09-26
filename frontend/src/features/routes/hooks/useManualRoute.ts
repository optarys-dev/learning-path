import { useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { useNotifications } from '@/components/notifications';
import { appRoutes } from '@/config/navigation';
import type { CatalogCourse } from '@/features/catalog';
import { saveRoute } from '@/features/routes/api/routes';
import { buildManualRouteRequest, moveSelectedCourse, toggleSelectedCourse } from '@/features/routes/model/manualRoute';
import { useRouteError } from './useRouteError';

/** Owns the manual draft and save lifecycle; catalog loading stays in its own feature. */
export function useManualRoute() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { notify } = useNotifications();
  const translateError = useRouteError();
  const [selected, setSelected] = useState<CatalogCourse[]>([]);
  const [goal, setGoal] = useState('');
  const [explanation, setExplanation] = useState('');
  const [saving, setSaving] = useState(false);
  const [saveError, setSaveError] = useState<string | null>(null);
  const inFlight = useRef(false);

  function toggleCourse(course: CatalogCourse) {
    setSelected(current => toggleSelectedCourse(current, course));
  }

  function moveCourse(index: number, direction: -1 | 1) {
    setSelected(current => moveSelectedCourse(current, index, direction));
  }

  async function submit() {
    if (!goal.trim() || selected.length === 0 || inFlight.current) return;
    inFlight.current = true;
    setSaving(true);
    setSaveError(null);
    try {
      const route = await saveRoute(buildManualRouteRequest(goal, explanation, selected));
      navigate(appRoutes.savedRoutes, { replace: true, state: { routeCreated: true, routeId: route.routeId } });
    } catch (error) {
      const message = translateError(error).message;
      setSaveError(message);
      notify({ tone: 'error', title: t('manualRoute.saveError'), message });
    } finally {
      inFlight.current = false;
      setSaving(false);
    }
  }

  return { selected, goal, setGoal, explanation, setExplanation, saving, saveError, toggleCourse, moveCourse, submit };
}
