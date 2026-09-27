import { BookOpen, ExternalLink, Flag, Map, Sparkles } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { DeviIllustration } from './DeviIllustration';
import deviRoute from '@/assets/codequest/characters/04_mascota_astronauta_con_mapa_del_tesoro.png';
import lunarTerrain from '@/assets/codequest/scenes/10_divisor_lunar_neón_con_ruta_estelar.png';
import { featuredCourses } from '@/features/welcome/model/featuredCourses';

const routeMarkers = [BookOpen, Map, Sparkles, Flag];
const routeStepKeys = ['start', 'build', 'practice', 'next'] as const;

export function CourseRoutePreview() {
  const { t } = useTranslation();

  return (
    <div className="route-preview__composition route-map">
      <img className="route-map__terrain" src={lunarTerrain} alt="" loading="lazy" decoding="async" aria-hidden="true" />
      <div className="route-preview__guide route-map__guide" aria-hidden="true">
        <DeviIllustration variant="route" src={deviRoute} alt="" width="248" height="277" />
      </div>
      <ol className="route-preview__list route-map__stops" aria-label={t('landing.preview.listLabel')}>
        {featuredCourses.map((course, index) => {
              const MarkerIcon = routeMarkers[index];
              const stepKey = routeStepKeys[index];
              return (
                <li key={course.courseId} className="route-map__stop">
                  <span className="route-map__marker" aria-hidden="true"><span className="route-map__marker-label">{t(`landing.preview.steps.${stepKey}`)}</span><MarkerIcon size={16} /></span>
                  <a className="route-course" href={course.courseUrl} target="_blank" rel="noreferrer" aria-label={`${course.title} · ${t('landing.preview.openCourse')}`}>
                    <img src={course.imageUrl} alt="" loading="lazy" />
                    <span className="route-course__copy"><small>DevTalles</small><strong>{course.title}</strong></span>
                    <ExternalLink size={15} aria-hidden="true" />
                  </a>
                </li>
              );
            })}
      </ol>
    </div>
  );
}
