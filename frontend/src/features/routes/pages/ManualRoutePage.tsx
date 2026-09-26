import { routeLimits } from '@/features/routes/model/constants';
import { appRoutes } from '@/config/navigation';
import { useEffect } from 'react';
import { Map, Sparkles } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Link, Navigate } from 'react-router-dom';
import { PageState } from '@/components/ui';
import { useAuthSession } from '@/features/auth/hooks/useAuthSession';
import { loadPendingRoute } from '@/features/routes/model/draftRoute';
import { useManualRoute } from '@/features/routes/hooks/useManualRoute';
import { ManualCourseCatalog } from '@/features/routes/components/ManualCourseCatalog';
import { ManualCourseSelection } from '@/features/routes/components/ManualCourseSelection';
import './ManualRoutePage.css';

export function ManualRoutePage() {
  const { t } = useTranslation();
  const { user, isLoading: sessionLoading } = useAuthSession();
  const { selected, goal, setGoal, explanation, setExplanation, saving, saveError, toggleCourse, moveCourse, submit } = useManualRoute();

  useEffect(() => { document.title = `${t('manualRoute.title')} · CODE QUEST 2026`; }, [t]);

  if (sessionLoading) return <PageState kind="loading" title={t('myPath.sessionLoading')} />;
  if (!user) return <Navigate to={appRoutes.login} replace />;

  const hasPendingRecommendation = loadPendingRoute(user.id) !== null;

  return (
    <div className="manual-route-page"><div className="manual-route">
      <header className="manual-route__hero">
        <div>
          <p>{t('manualRoute.eyebrow')}</p>
          <h1>{t('manualRoute.title')}</h1>
          <span>{t('manualRoute.description')}</span>
        </div>
        <div className="manual-route__hero-actions">
          <nav className="manual-route__creation-options" aria-label={t('manualRoute.methodLabel')}>
            <span aria-current="page"><Map size={16} aria-hidden="true" />{t('manualRoute.manualOption')}</span>
            <Link to={hasPendingRecommendation ? appRoutes.proposal : appRoutes.learningProfile}>
              <Sparkles size={16} aria-hidden="true" />
              {t(hasPendingRecommendation ? 'manualRoute.resumeRecommended' : 'manualRoute.recommendedOption')}
            </Link>
          </nav>
          <strong><Map size={18} aria-hidden="true" />{t('manualRoute.selectedCount', { count: selected.length })}</strong>
        </div>
      </header>
      <section className="manual-route__details" aria-label={t('manualRoute.detailsTitle')}>
        <div className="manual-route__details-heading">
          <span>{t('manualRoute.detailsStep')}</span>
          <div><h2>{t('manualRoute.detailsTitle')}</h2><p>{t('manualRoute.detailsHint')}</p></div>
        </div>
        <div className="manual-route__fields">
          <label htmlFor="manual-route-name">
            {t('manualRoute.nameLabel')}
            <input id="manual-route-name" value={goal} maxLength={routeLimits.goalLength}
              onChange={event => setGoal(event.target.value)} placeholder={t('manualRoute.namePlaceholder')} />
          </label>
          <label htmlFor="manual-route-description">
            {t('manualRoute.descriptionLabel')}
            <textarea id="manual-route-description" value={explanation} maxLength={routeLimits.explanationLength}
              onChange={event => setExplanation(event.target.value)} placeholder={t('manualRoute.descriptionPlaceholder')} />
          </label>
        </div>
      </section>
      <section className="manual-route__workspace">
        <ManualCourseCatalog selected={selected} onToggle={toggleCourse} />
        <ManualCourseSelection courses={selected} canSave={Boolean(goal.trim()) && selected.length > 0}
          saving={saving} error={saveError} onMove={moveCourse} onRemove={toggleCourse} onSave={submit} />
      </section>
    </div></div>
  );
}
