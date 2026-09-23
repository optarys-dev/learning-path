import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { BookOpen, Compass, RefreshCw, Sparkles } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import catalogPanel from '../../../assets/codequest/scenes/14_panel_informativo_futurista_morado.png';
import { CatalogCourseCard } from '../components/CatalogCourseCard';
import { CatalogPagination } from '../components/CatalogPagination';
import { useCatalogCourses } from '../hooks/useCatalogCourses';
import './CatalogPage.css';

export function CatalogPage() {
  const { t } = useTranslation();
  const { user } = useAuthSession();
  const { data, error, isLoading, page, reload, setPage } = useCatalogCourses();
  const createPathTarget = user ? '/learning-profile' : '/login';

  useEffect(() => {
    document.title = `${t('catalog.pageTitle')} · CODE QUEST 2026`;
  }, [t]);

  return (
    <div className="catalog-page">
      <section className="catalog-hero" aria-labelledby="catalog-title">
        <div className="catalog-hero__copy">
          <p className="catalog-eyebrow"><Sparkles size={15} aria-hidden="true" />{t('catalog.eyebrow')}</p>
          <h1 id="catalog-title">{t('catalog.title')} <span>{t('catalog.titleAccent')}</span></h1>
          <p>{t('catalog.description')}</p>
          {user && <p className="catalog-hero__personalized"><Compass size={17} aria-hidden="true" />{t('catalog.personalized', { name: user.displayName || user.username })}</p>}
        </div>
        <img className="catalog-hero__visual" src={catalogPanel} alt="" aria-hidden="true" />
      </section>

      <section className="catalog-results" aria-labelledby="catalog-results-title">
        <div className="catalog-results__header">
          <div>
            <p className="catalog-eyebrow">{t('catalog.resultsEyebrow')}</p>
            <h2 id="catalog-results-title">{t('catalog.resultsTitle')}</h2>
          </div>
          {!isLoading && !error && data && <p className="catalog-results__count"><BookOpen size={18} aria-hidden="true" />{t('catalog.totalCourses', { count: data.totalCount })}</p>}
        </div>

        {isLoading && <CatalogSkeleton />}

        {!isLoading && error && (
          <section className="catalog-state" aria-live="polite">
            <RefreshCw size={30} aria-hidden="true" />
            <h2>{t('catalog.errorTitle')}</h2>
            <p>{t('catalog.errorDescription')}</p>
            <button type="button" className="cq-button cq-button--primary" onClick={() => void reload()}>{t('catalog.retry')}</button>
          </section>
        )}

        {!isLoading && !error && data && (
          data.items.length === 0 ? (
            <section className="catalog-state" aria-live="polite">
              <BookOpen size={30} aria-hidden="true" />
              <h2>{t('catalog.emptyTitle')}</h2>
              <p>{t('catalog.emptyDescription')}</p>
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

function CatalogSkeleton() {
  return <div className="catalog-grid" aria-label="Cargando cursos" aria-busy="true">{Array.from({ length: 12 }, (_, index) => <div className="catalog-skeleton" key={index} />)}</div>;
}
