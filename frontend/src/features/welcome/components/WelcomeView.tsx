import { Trans, useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { LearningJourney } from './LearningJourney';
import { JourneyExplainer } from './JourneyExplainer';
import { LandingDetails } from './LandingDetails';
import { PageTrail } from './PageTrail';
import { ArrowRight, BookOpen, Compass, Map, type LucideIcon } from 'lucide-react';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import '../styles/welcome.css';
import '../styles/landing.css';

export function WelcomeView() {
  const { t } = useTranslation();
  const { user } = useAuthSession();
  const promiseIcons: LucideIcon[] = [Compass, BookOpen, Map];

  return (
    <div className="landing">
    <PageTrail />
    <section className="welcome welcome--landing" aria-labelledby="welcome-title">
      <div className="welcome__content">
        <p className="welcome__eyebrow">
          <span className="welcome__status-dot" aria-hidden="true" />
          <span>{t('landing.heroMission')}</span>
        </p>
        <h1 id="welcome-title">{t('welcome.title')} <span>{t('welcome.titleAccent')}</span></h1>
        <p className="welcome__description"><Trans i18nKey="landing.heroDescription" components={{ strong: <strong /> }} /></p>
        <div className="welcome__action">
          <Link className="cq-button cq-button--primary welcome__cta" to={user ? '/my-path' : '/login'}>{t('landing.createRoute')} <ArrowRight size={19} aria-hidden="true" /></Link>
        </div>
        <p className="welcome__signature">{t('welcome.signature')}</p>
      </div>
      <LearningJourney />
    </section>
    <section className="landing-promises" aria-labelledby="promise-title">
      <h2 id="promise-title"><Trans i18nKey="landing.promiseTitle" components={{ accent: <span className="text-accent" /> }} /></h2>
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
