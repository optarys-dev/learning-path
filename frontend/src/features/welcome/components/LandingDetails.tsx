import { Link } from 'react-router-dom';
import { useAuthSession } from '../../auth/hooks/useAuthSession';
import { Trans, useTranslation } from 'react-i18next';
import { ArrowRight, Compass, Layers, Route, type LucideIcon } from 'lucide-react';
import { DeviIllustration } from './DeviIllustration';
import { CourseRoutePreview } from './CourseRoutePreview';
import { SectionAccent } from './SectionAccent';
import deviGoal from '../../../assets/codequest/characters/02_mascota_astronauta_cq_en_la_cima.png';
import deviExperience from '../../../assets/codequest/characters/03_mascota_astronauta_cq_en_movimiento.png';

const experienceIcons: LucideIcon[] = [Compass, Route, Layers];

export function LandingDetails() {
  const { t } = useTranslation();
  const { user } = useAuthSession();
  return (
    <>
      <section id="your-experience" className="landing-section experience" aria-labelledby="experience-title">
        <div className="landing-section__heading">
          <p className="landing-eyebrow">{t('landing.experience.eyebrow')}</p>
          <h2 id="experience-title"><Trans i18nKey="landing.experience.title" components={{ accent: <span className="text-accent" /> }} /></h2>
          <p>{t('landing.experience.description')}</p>
        </div>
        <div className="experience__grid">
          {(['direction', 'context', 'continuity'] as const).map((item, index) => {
            const Icon = experienceIcons[index];
            return <article key={item} className="experience__item">
              {index === 0 && <div className="experience__art" aria-hidden="true">
                <DeviIllustration variant="route" src={deviExperience} alt="" width="248" height="277" />
              </div>}
              <div className="experience__content">
                <span className="experience__icon" aria-hidden="true"><Icon size={23} /></span>
                <h3>{t(`landing.experience.${item}.title`)}</h3>
                <p>{t(`landing.experience.${item}.text`)}</p>
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
          <SectionAccent kind="beacon" />
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
          <Link to={user ? '/my-path' : '/login'} className="cq-button cq-button--primary">{t('landing.createRoute')} <ArrowRight size={18} aria-hidden="true" /></Link>
        </div>
        <div className="landing-closing__scene" aria-hidden="true">
          <span className="landing-closing__node landing-closing__node--start" />
          <span className="landing-closing__node landing-closing__node--end" />
          <DeviIllustration variant="closing" src={deviGoal} alt="" width="248" height="277" />
        </div>
      </section>
    </>
  );
}
