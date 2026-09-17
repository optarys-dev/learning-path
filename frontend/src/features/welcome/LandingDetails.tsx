import { Link } from 'react-router-dom';
import { useAuthSession } from '../auth/useAuthSession';
import { Trans, useTranslation } from 'react-i18next';
import { ArrowRight, BookOpen, Compass, ExternalLink, Flag, Layers, Map, Route, Target, type LucideIcon } from 'lucide-react';
import { DeviIllustration } from './DeviIllustration';
import deviRoute from '../../assets/codequest/characters/13_robot_guía_junto_al_letrero_next_stop.png';
import deviGoal from '../../assets/codequest/characters/02_mascota_astronauta_cq_en_la_cima.png';
import deviExperience from '../../assets/codequest/characters/03_mascota_astronauta_cq_en_movimiento.png';

const pathPreview = ['foundations', 'javascript', 'react', 'specialization'] as const;
const experienceIcons: LucideIcon[] = [Compass, Route, Layers];
const routeMarkers: LucideIcon[] = [Compass, BookOpen, Map, Flag];

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
        <div className="route-preview__composition">
          <div className="route-preview__guide">
            <DeviIllustration variant="route" src={deviRoute} alt="" width="248" height="277" />
            <p><Target size={17} aria-hidden="true" />{t('landing.preview.goal')}</p>
            <span>{t('landing.preview.guide')}</span>
          </div>
          <ol className="route-preview__list" aria-label={t('landing.preview.listLabel')}>
            {pathPreview.map((item, index) => {
              const MarkerIcon = routeMarkers[index];
              return <li key={item}>
              <div className="route-preview__marker"><span aria-hidden="true"><MarkerIcon size={15} /></span>{index < pathPreview.length - 1 && <i aria-hidden="true" />}</div>
              <article className={`route-course ${item === 'react' ? 'route-course--featured' : ''}`}>
                <div className="route-course__top"><span className="route-course__example">{t('landing.preview.example')}</span><span className="route-course__level">{t(`landing.preview.${item}.level`)}</span></div>
                <h3>{t(`landing.preview.${item}.title`)}</h3>
                <p>{t(`landing.preview.${item}.reason`)}</p>
                <div className="route-course__footer"><span><BookOpen size={16} aria-hidden="true" />{t(`landing.preview.${item}.state`)}</span><button type="button" disabled aria-label={t('landing.preview.linkUnavailable')}><ExternalLink size={16} aria-hidden="true" />{t('landing.preview.openCourse')}</button></div>
              </article>
            </li>;
            })}
          </ol>
          <div className="route-preview__outcome">
            <span className="route-preview__outcome-icon" aria-hidden="true"><Route size={20} strokeWidth={2.25} /></span>
            <div>
              <strong>{t('landing.preview.outcomeTitle')}</strong>
              <span>{t('landing.preview.outcomeText')}</span>
            </div>
          </div>
        </div>
      </section>
      <section id="questions" className="landing-section landing-faq" aria-labelledby="faq-title">
        <div className="landing-section__heading">
          <p className="landing-eyebrow">{t('landing.faq.eyebrow')}</p>
          <h2 id="faq-title"><Trans i18nKey="landing.faq.title" components={{ accent: <span className="text-accent" /> }} /></h2>
          <p>{t('landing.faq.description')}</p>
          <span className="landing-faq__spark" aria-hidden="true">✳</span>
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
