import { Link } from 'react-router-dom';
import { useAuthSession } from '../auth/useAuthSession';
import { Trans, useTranslation } from 'react-i18next';
import { ArrowRight, BookOpen, Compass, ExternalLink, Flag, Layers, Map, Route, type LucideIcon } from 'lucide-react';
import { DeviIllustration } from './DeviIllustration';
import deviRoute from '../../assets/codequest/characters/04_mascota_astronauta_con_mapa_del_tesoro.png';
import deviGoal from '../../assets/codequest/characters/02_mascota_astronauta_cq_en_la_cima.png';
import deviExperience from '../../assets/codequest/characters/03_mascota_astronauta_cq_en_movimiento.png';

const pathPreview = ['foundations', 'javascript', 'react', 'specialization'] as const;
const experienceIcons: LucideIcon[] = [Compass, Route, Layers];
const routeMarkers: LucideIcon[] = [Compass, BookOpen, Map, Flag];
const previewCourseUrls = {
  foundations: 'https://cursos.devtalles.com/courses/programacion-para-principiantes',
  javascript: 'https://cursos.devtalles.com/courses/javascript-moderno',
  react: 'https://cursos.devtalles.com/courses/react-de-cero',
  specialization: 'https://cursos.devtalles.com/courses/react-pro',
} as const;

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
        <div className="route-preview__composition route-map">
          <svg className="route-map__trail" viewBox="0 0 1200 520" fill="none" aria-hidden="true" preserveAspectRatio="none">
            <path d="M104 315 C202 85 322 420 452 228 S691 71 795 314 S1015 414 1100 126" />
          </svg>
          <div className="route-preview__guide route-map__guide">
            <DeviIllustration variant="route" src={deviRoute} alt="" width="248" height="277" />
          </div>
          <ol className="route-preview__list route-map__stops" aria-label={t('landing.preview.listLabel')}>
            {pathPreview.map((item, index) => {
              const MarkerIcon = routeMarkers[index];
              return <li key={item} className={`route-map__stop route-map__stop--${item}`}>
              <span className="route-map__marker" aria-hidden="true"><MarkerIcon size={16} /></span>
              <a className={`route-course ${item === 'react' ? 'route-course--featured' : ''}`} href={previewCourseUrls[item]} target="_blank" rel="noreferrer" aria-label={`${t(`landing.preview.${item}.title`)} · ${t('landing.preview.openCourse')}`}>
                <h3>{t(`landing.preview.${item}.title`)}</h3>
                <ExternalLink size={15} aria-hidden="true" />
              </a>
            </li>;
            })}
          </ol>
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
