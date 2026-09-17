import { useTranslation } from 'react-i18next';
import { CircleDot, Flag, MapPin } from 'lucide-react';
import { DeviIllustration } from './DeviIllustration';
import devi from '../../assets/portal/10_continuar_aprendiendo.png';

export function LearningJourney() {
  const { t } = useTranslation();
  return (
    <div className="journey" aria-hidden="true">
      <div className="journey__orbit" />
      <svg className="journey__line" viewBox="0 0 440 460" fill="none">
        <path d="M75 365 C75 265 320 330 330 225 S115 180 150 110 S300 85 340 50" />
      </svg>
      <div className="journey__station journey__station--start"><CircleDot aria-hidden="true" size={15} />{t('welcome.start')}</div>
      <div className="journey__station journey__station--foundations"><MapPin aria-hidden="true" size={15} />{t('welcome.foundations')}</div>
      <div className="journey__station journey__station--goal"><Flag aria-hidden="true" size={15} />{t('welcome.goal')}</div>
      <DeviIllustration variant="hero" className="journey__devi" src={devi} alt="" width="300" height="300" />
    </div>
  );
}
