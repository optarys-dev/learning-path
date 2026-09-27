import { appRoutes } from '@/config/navigation';
import { useEffect, useRef, useState } from 'react';
import { Link } from 'react-router-dom';
import { ArrowRight, BookOpen, Check, CircleDot, Compass, Flag, Lightbulb, RefreshCw, Search, Sparkles, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { QuestDivider, QuestDoodle, QuestMetric, QuestSticker, QuestTab } from '@/components/ui';
import { useAuthSession } from '@/features/auth/hooks/useAuthSession';
import catalogPanel from '@/assets/codequest/scenes/14_panel_informativo_futurista_morado.png';
import { CatalogCourseCard } from '@/features/catalog/components/CatalogCourseCard';
import { CatalogPagination } from '@/features/catalog/components/CatalogPagination';
import { CatalogKindFilter } from '@/features/catalog/components/CatalogKindFilter';
import type { CatalogKind } from '@/features/catalog/model/catalogKind';
import { useCatalogCourses } from '@/features/catalog/hooks/useCatalogCourses';
import './CatalogPage.css';

export function CatalogPage() {
  const { t } = useTranslation();
  const { user } = useAuthSession();
  const [searchQuery, setSearchQuery] = useState('');
  const [debouncedSearchQuery, setDebouncedSearchQuery] = useState('');
  const [catalogKind, setCatalogKind] = useState<CatalogKind>();
  const searchInputRef = useRef<HTMLInputElement>(null);
  const { data, error, isLoading, page, reload, setPage } = useCatalogCourses(debouncedSearchQuery, catalogKind);
  const createPathTarget = user ? appRoutes.learningProfile : appRoutes.login;

  useEffect(() => {
    document.title = `${t('catalog.pageTitle')} · CODE QUEST 2026`;
  }, [t]);

  useEffect(() => {
    const timeout = window.setTimeout(() => setDebouncedSearchQuery(searchQuery.trim()), 300);
    return () => window.clearTimeout(timeout);
  }, [searchQuery]);

  function updateSearchQuery(value: string) {
    setSearchQuery(value);
    setPage(1);
  }

  function clearSearch() {
    updateSearchQuery('');
    searchInputRef.current?.focus();
  }

  return (
    <div className="catalog-page">
      <section className="catalog-hero" aria-labelledby="catalog-title">
        <div className="catalog-hero__copy">
          <p className="catalog-eyebrow"><Sparkles size={15} aria-hidden="true" />{t('catalog.eyebrow')}</p>
          <h1 id="catalog-title">{t('catalog.title')} <span>{t('catalog.titleAccent')}</span></h1>
          <p>{t('catalog.description')}</p>
          {user && <p className="catalog-hero__personalized"><Compass size={17} aria-hidden="true" />{t('catalog.personalized', { name: user.displayName || user.username })}</p>}
          <div className="catalog-hero__assets" aria-label={t('catalog.missionListLabel')}>
            <QuestSticker tone="recommended">{t('catalog.missionRecommended')}</QuestSticker>
            <QuestTab tone="lime">DevTalles</QuestTab>
          </div>
        </div>
        <QuestDoodle kind="route" className="catalog-hero__doodle" />
        <img className="catalog-hero__visual" src={catalogPanel} alt="" aria-hidden="true" />
      </section>

      <section className="catalog-mission-kit" aria-labelledby="catalog-mission-title">
        <div className="catalog-mission-kit__copy">
          <QuestTab tone="lime">{t('catalog.missionLabel')}</QuestTab>
          <h2 id="catalog-mission-title">{t('catalog.missionTitle')}</h2>
          <p>{t('catalog.missionDescription')}</p>
        </div>
        <div className="catalog-mission-kit__journey" aria-label={t('catalog.missionListLabel')}>
          <ol className="catalog-mission-kit__steps">
            <li className="is-done">
              <span className="catalog-mission-kit__step-icon"><Check size={16} aria-hidden="true" /></span>
              <div><span>01</span><strong>{t('catalog.missionSteps.explore')}</strong></div>
              <ArrowRight className="catalog-mission-kit__connector" size={18} aria-hidden="true" />
            </li>
            <li className="is-active" aria-current="step">
              <span className="catalog-mission-kit__step-icon"><CircleDot size={17} aria-hidden="true" /></span>
              <div><span>02</span><strong>{t('catalog.missionSteps.compare')}</strong></div>
              <ArrowRight className="catalog-mission-kit__connector" size={18} aria-hidden="true" />
            </li>
            <li>
              <span className="catalog-mission-kit__step-icon"><Flag size={16} aria-hidden="true" /></span>
              <div><span>03</span><strong>{t('catalog.missionSteps.build')}</strong></div>
            </li>
          </ol>
          <aside className="catalog-mission-kit__devi-note">
            <Lightbulb size={17} aria-hidden="true" />
            <div><strong>{t('catalog.missionNoteLabel')}</strong><p>{t('catalog.missionNote')}</p></div>
          </aside>
        </div>
      </section>

      <QuestDivider className="catalog-mission-divider" label={t('catalog.resultsEyebrow')} />

      <section className="catalog-results" aria-labelledby="catalog-results-title">
        <div className="catalog-toolbar">
          <div className="catalog-search">
            <Search size={20} aria-hidden="true" />
            <input
              ref={searchInputRef}
              type="search"
              value={searchQuery}
              onChange={event => updateSearchQuery(event.target.value)}
              aria-label={t('catalog.searchLabel')}
              placeholder={t('catalog.searchPlaceholder')}
            />
            {searchQuery && (
              <button type="button" onClick={clearSearch} aria-label={t('catalog.clearSearch')}>
                <X size={18} aria-hidden="true" />
              </button>
            )}
          </div>
          <CatalogKindFilter value={catalogKind} onChange={kind => { setCatalogKind(kind); setPage(1); }} />
        </div>

        <div className="catalog-results__header">
          <div>
            <p className="catalog-eyebrow">{t('catalog.resultsEyebrow')}</p>
            <h2 id="catalog-results-title">{t('catalog.resultsTitle')}</h2>
          </div>
          {!isLoading && !error && data && <QuestMetric className="catalog-results__count" value={data.totalCount} label={t('catalog.courseCountLabel')} />}
        </div>

        {isLoading && <CatalogSkeleton label={t('catalog.loading')} />}

        {!isLoading && error && (
          <section className="catalog-state" aria-live="polite">
            <RefreshCw size={30} aria-hidden="true" />
            <h2>{t('catalog.errorTitle')}</h2>
            <p>{t('catalog.errorDescription')}</p>
            <button type="button" className="cq-button cq-button--primary" onClick={() => void reload()}>{t('catalog.retry')}</button>
          </section>
        )}

        {!isLoading && !error && data && (
          data.totalCount === 0 ? (
            <section className={debouncedSearchQuery || catalogKind ? 'catalog-state catalog-state--search' : 'catalog-state'} aria-live="polite">
              <BookOpen size={30} aria-hidden="true" />
              <h2>{debouncedSearchQuery ? t('catalog.noResultsTitle', { query: debouncedSearchQuery }) : t(catalogKind ? 'catalog.noCategoryResultsTitle' : 'catalog.emptyTitle')}</h2>
              <p>{debouncedSearchQuery || catalogKind ? t('catalog.noResultsDescription') : t('catalog.emptyDescription')}</p>
            </section>
          ) : (
            <>
              <ol className="catalog-grid" aria-label={t('catalog.listLabel')}>
                {data.items.map(course => <li key={course.courseId}><CatalogCourseCard course={course} /></li>)}
              </ol>
              <CatalogPagination page={page} pageCount={data.totalPages} hasPreviousPage={data.hasPreviousPage} hasNextPage={data.hasNextPage} onPageChange={setPage} />
            </>
          )
        )}
      </section>

      <section className="catalog-cta" aria-labelledby="catalog-cta-title">
        <div>
          <p className="catalog-eyebrow">{t('catalog.ctaEyebrow')}</p>
          <h2 id="catalog-cta-title">{t('catalog.ctaTitle')}</h2>
          <p>{t('catalog.ctaDescription')}</p>
        </div>
        <Link className="cq-button cq-button--primary" to={createPathTarget}>{t(user ? 'catalog.ctaLoggedIn' : 'catalog.ctaLoggedOut')}</Link>
      </section>
    </div>
  );
}

function CatalogSkeleton({ label }: { label: string }) {
  return <div className="catalog-grid" aria-label={label} aria-busy="true">{Array.from({ length: 12 }, (_, index) => <div className="catalog-skeleton" key={index} />)}</div>;
}
