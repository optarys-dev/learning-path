import { appRoutes } from '@/config/navigation';
import { Trans, useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { LearningJourney } from './LearningJourney';
import { JourneyExplainer } from './JourneyExplainer';
import { LandingDetails } from './LandingDetails';
import { PageTrail } from './PageTrail';
import { SectionAccent } from './SectionAccent';
import { ArrowRight, BookOpen, Compass, Map, FolderOpen, Paperclip, FileText, type LucideIcon } from 'lucide-react';
import { useAuthSession } from '@/features/auth/hooks/useAuthSession';
import '@/features/welcome/styles/welcome.css';
import '@/features/welcome/styles/landing.css';
import '@/features/welcome/styles/landing-refinements.css';

export function WelcomeView() {
  const { t } = useTranslation();
  const { user } = useAuthSession();
  const promiseIcons: LucideIcon[] = [Compass, BookOpen, Map];

  return (
    <div className="landing">
      <PageTrail />
      <section id="start" className="welcome welcome--landing" aria-labelledby="welcome-title">
      <div className="welcome__content">
        <p className="welcome__eyebrow">
          <span className="welcome__status-dot" aria-hidden="true" />
          <span>{t('landing.heroMission')}</span>
        </p>
        <h1 id="welcome-title">{t('welcome.title')} <span>{t('welcome.titleAccent')}</span></h1>
        <p className="welcome__description"><Trans i18nKey="landing.heroDescription" components={{ strong: <strong /> }} /></p>
        <div className="welcome__action">
          <Link className="cq-button cq-button--primary welcome__cta" to={user ? appRoutes.createRoute : appRoutes.login}>{t('landing.createRoute')} <ArrowRight size={19} aria-hidden="true" /></Link>
          <Link className="landing-text-link" to={appRoutes.catalog}><BookOpen size={18} aria-hidden="true" />{t('landing.exploreCatalog')}</Link>
        </div>
        <p className="welcome__choice">{t('landing.heroChoice')}</p>
        <p className="welcome__signature">{t('welcome.signature')}</p>
      </div>
      <div className="learning-folder">
        <span className="learning-folder__tab"><FolderOpen size={17} aria-hidden="true" />{t('landing.folderLabel')}</span>
        <span className="learning-folder__clip" aria-hidden="true"><Paperclip /></span>
        <LearningJourney />
        <div className="learning-folder__caption"><FileText size={16} aria-hidden="true" /><span>{t('landing.heroDetail')}</span><span aria-hidden="true">01 / 03</span></div>
      </div>
      </section>
      <section className="landing-promises" aria-labelledby="promise-title">
      <h2 id="promise-title"><Trans i18nKey="landing.promiseTitle" components={{ accent: <span className="text-accent" /> }} /></h2>
      <SectionAccent kind="tools" />
      <div className="landing-promises__grid">
        {(['goal', 'catalog', 'pace'] as const).map((value, index) => {
          const Icon = promiseIcons[index];
          return <div key={value}><span aria-hidden="true"><Icon size={18} /></span><div><h3>{t(`landing.promises.${value}.title`)}</h3><p>{t(`landing.promises.${value}.text`)}</p></div></div>;
        })}
      </div>
      </section>
      <JourneyExplainer />
      <LandingDetails />
    </div>
  );
}
