import { appRoutes } from '@/config/navigation';
import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { PageState } from '@/components/ui';

export function SectionPage({ section }: { section: 'home' | 'catalog' | 'myPath' | 'notFound' }) {
  const { t } = useTranslation();
  const title = t(`layout.${section}`);
  useEffect(() => { document.title = `${title} · CODE QUEST 2026`; }, [title]);
  return (
    <>
      <div className="section-heading">
        <h1>{title}</h1>
        <p>{t(`layout.${section}Description`)}</p>
      </div>
      <PageState kind="empty" title={t(section === 'notFound' ? 'layout.notFoundState' : 'layout.comingSoon')}
        description={t(section === 'notFound' ? 'layout.notFoundHelp' : 'layout.comingSoonDescription')}>
        {section === 'notFound' && <Link className="cq-button cq-button--primary" to={appRoutes.home}>{t('layout.backHome')}</Link>}
      </PageState>
    </>
  );
}
