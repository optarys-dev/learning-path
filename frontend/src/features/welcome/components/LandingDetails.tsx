import { appRoutes } from '@/config/navigation';
import { Link } from 'react-router-dom';
import { useAuthSession } from '@/features/auth/hooks/useAuthSession';
import { Trans, useTranslation } from 'react-i18next';
import { ArrowRight, Check, Compass, Layers, Paperclip, Route, Sparkles, type LucideIcon } from 'lucide-react';
import { DeviIllustration } from './DeviIllustration';
import { CourseRoutePreview } from './CourseRoutePreview';
import { SectionAccent } from './SectionAccent';
import deviGoal from '@/assets/codequest/characters/02_mascota_astronauta_cq_en_la_cima.png';
import reactIcon from '@/assets/technologies/react.svg';
import typescriptIcon from '@/assets/technologies/typescript.svg';
import nodeIcon from '@/assets/technologies/nodejs.svg';
import javascriptIcon from '@/assets/technologies/javascript.svg';
import gitIcon from '@/assets/technologies/git.svg';
import cssIcon from '@/assets/technologies/css3.svg';

const experienceIcons: LucideIcon[] = [Compass, Route, Layers];
const routeStepKeys = ['routeStep1', 'routeStep2', 'routeStep3'] as const;
const technologyIcons = [
  { name: 'React', src: reactIcon },
  { name: 'TypeScript', src: typescriptIcon },
  { name: 'Node.js', src: nodeIcon },
  { name: 'JavaScript', src: javascriptIcon },
  { name: 'Git', src: gitIcon },
  { name: 'CSS', src: cssIcon },
];

export function LandingDetails() {
  const { t } = useTranslation();
  const { user } = useAuthSession();
  return (
    <>
      <section id="your-experience" className="landing-section experience experience-studio" aria-labelledby="experience-title">
        <div className="landing-section__heading">
          <p className="landing-eyebrow">{t('landing.experience.eyebrow')}</p>
          <h2 id="experience-title"><Trans i18nKey="landing.experience.title" components={{ accent: <span className="text-accent" /> }} /></h2>
          <p>{t('landing.experience.description')}</p>
        </div>
        <div className="plan-transformation">
          <div className="plan-transformation__source">
            <span className="plan-transformation__label"><Layers size={16} />{t('landing.experience.before')}</span>
            <div className="plan-transformation__pile">
              {technologyIcons.map(technology => <span key={technology.name} title={technology.name}><img src={technology.src} alt={technology.name} width="44" height="44" loading="lazy" decoding="async" /></span>)}
              <span className="plan-transformation__question" aria-hidden="true">?</span>
            </div>
            <p>{t('landing.experience.beforeText')}</p>
          </div>
          <span className="plan-transformation__bridge" aria-hidden="true"><Sparkles size={24} /><ArrowRight size={22} /></span>
          <div className="plan-transformation__result">
            <Paperclip className="plan-transformation__clip" size={28} aria-hidden="true" />
            <span className="plan-transformation__label"><Route size={16} />{t('landing.experience.after')}</span>
            <ol>
              {['JavaScript', 'TypeScript', 'React'].map((course, index) => <li key={course}><span>{index === 0 ? <Check size={16} /> : `0${index + 1}`}</span><strong>{course}</strong><small>{t(`landing.experience.${routeStepKeys[index]}`)}</small></li>)}
            </ol>
            <p>{t('landing.experience.afterText')}</p>
          </div>
        </div>
        <div className="experience__grid">
          {(['direction', 'context', 'continuity'] as const).map((item, index) => {
            const Icon = experienceIcons[index];
            return <article key={item} className="experience__item">
              <div className="experience__content">
                <span className="experience__icon" aria-hidden="true"><Icon size={23} /></span>
                <h3>{t(`landing.experience.${item}.title`)}</h3>
                <p>{t(`landing.experience.${item}.text`)}</p>
                <Link className="experience__link" to={user ? [appRoutes.learningProfile, appRoutes.manualRoute, appRoutes.savedRoutes][index] : appRoutes.login}>
                  {t(`landing.experience.${item}.action`)}<ArrowRight size={17} aria-hidden="true" />
                </Link>
              </div>
            </article>;
          })}
        </div>
      </section>
      <section id="route-preview" className="landing-section route-preview" aria-labelledby="route-preview-title">
        <div className="landing-section__heading">
          <p className="landing-eyebrow">{t('landing.preview.eyebrow')}</p>
          <h2 id="route-preview-title"><Trans i18nKey="landing.preview.title" components={{ accent: <span className="text-accent" /> }} /></h2>
          <p>{t('landing.preview.description')}</p>
        </div>
        <CourseRoutePreview />
      </section>
      <section id="questions" className="landing-section landing-faq" aria-labelledby="faq-title">
        <div className="landing-section__heading">
          <p className="landing-eyebrow">{t('landing.faq.eyebrow')}</p>
          <h2 id="faq-title"><Trans i18nKey="landing.faq.title" components={{ accent: <span className="text-accent" /> }} /></h2>
          <p>{t('landing.faq.description')}</p>
          <SectionAccent kind="bookmark" />
        </div>
        <div className="landing-faq__list">
          {(['login', 'courses', 'beginner', 'areas', 'progress'] as const).map(item => (
            <details key={item}>
              <summary>{t(`landing.faq.${item}.question`)}<span className="landing-faq__toggle" aria-hidden="true">+</span></summary>
              <p>{t(`landing.faq.${item}.answer`)}</p>
            </details>
          ))}
        </div>
      </section>
      <section className="landing-closing" aria-labelledby="closing-title">
        <div>
          <p className="landing-eyebrow">{t('landing.closing.eyebrow')}</p>
          <h2 id="closing-title"><Trans i18nKey="landing.closing.title" components={{ accent: <span className="text-accent" /> }} /></h2>
          <p>{t('landing.closing.note')}</p>
          <Link to={user ? appRoutes.createRoute : appRoutes.login} className="cq-button cq-button--primary">{t('landing.createRoute')} <ArrowRight size={18} aria-hidden="true" /></Link>
          <Link to={appRoutes.catalog} className="landing-text-link">{t('landing.exploreCatalog')} <ArrowRight size={16} aria-hidden="true" /></Link>
        </div>
        <div className="landing-closing__scene" aria-hidden="true">
          <SectionAccent kind="tools" />
          <span className="landing-closing__node landing-closing__node--start" />
          <span className="landing-closing__node landing-closing__node--end" />
          <DeviIllustration variant="closing" src={deviGoal} alt="" width="248" height="277" />
        </div>
      </section>
    </>
  );
}
