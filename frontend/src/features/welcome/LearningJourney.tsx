import { useTranslation } from 'react-i18next';
import { CircleDot, Flag, MapPin, Route } from 'lucide-react';
import { DeviIllustration } from './DeviIllustration';
import devi from '../../assets/brand/devi-hello.svg';

export function LearningJourney() {
  const { t } = useTranslation();
  return (
    <div className="journey" aria-hidden="true">
      <div className="journey__orbit" />
      <p className="journey__caption"><Route size={15} aria-hidden="true" />{t('welcome.journeyCaption')}</p>
      <svg className="journey__line" viewBox="0 0 440 460" fill="none">
        <path d="M75 365 C75 265 320 330 330 225 S115 180 150 110 S300 85 340 50" />
      </svg>
      <div className="journey__station journey__station--start"><CircleDot aria-hidden="true" size={15} />{t('welcome.start')}</div>
      <div className="journey__station journey__station--foundations"><MapPin aria-hidden="true" size={15} />{t('welcome.foundations')}</div>
      <div className="journey__station journey__station--specialize"><Route aria-hidden="true" size={15} />{t('welcome.specialize')}</div>
      <div className="journey__station journey__station--goal"><Flag aria-hidden="true" size={15} />{t('welcome.goal')}</div>
      <DeviIllustration variant="hero" className="journey__devi" src={devi} alt="" width="273" height="291" />
      <p className="journey__note">{t('welcome.deviNote')}</p>
    </div>
  );
}
