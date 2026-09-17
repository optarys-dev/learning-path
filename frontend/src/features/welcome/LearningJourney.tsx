import { useTranslation } from 'react-i18next';
import { CircleDot, Compass, Flag, Map, MapPin } from 'lucide-react';
import { DeviIllustration } from './DeviIllustration';
import devi from '../../assets/codequest/characters/04_mascota_astronauta_con_mapa_del_tesoro.png';

export function LearningJourney() {
  const { t } = useTranslation();
  return (
    <div className="journey" aria-hidden="true">
      <div className="journey__orbit" />
      <svg className="journey__line" viewBox="0 0 440 460" fill="none">
        <path d="M75 365 C75 265 320 330 330 225 S115 180 150 110 S300 85 340 50" />
      </svg>
      <span className="journey__prop journey__prop--compass"><Compass size={18} /></span>
      <span className="journey__prop journey__prop--map"><Map size={17} /></span>
      <div className="journey__station journey__station--start"><CircleDot aria-hidden="true" size={15} />{t('welcome.start')}</div>
      <div className="journey__station journey__station--foundations"><MapPin aria-hidden="true" size={15} />{t('welcome.foundations')}</div>
      <div className="journey__station journey__station--goal"><Flag aria-hidden="true" size={15} />{t('welcome.goal')}</div>
      <DeviIllustration variant="hero" className="journey__devi" src={devi} alt="" width="300" height="300" />
    </div>
  );
}
