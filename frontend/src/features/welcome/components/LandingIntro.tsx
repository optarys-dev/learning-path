import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import codeQuestLogo from '../../../assets/brand/codequest-logo.svg';

const introSessionKey = 'codequest.landing-intro.seen';
const introDuration = 2800;

function shouldPlayIntro() {
  if (typeof window === 'undefined') return false;

  try {
    const reduceMotion = window.matchMedia(
      '(prefers-reduced-motion: reduce)'
    ).matches;

    return (
      !reduceMotion &&
      window.sessionStorage.getItem(introSessionKey) !== 'true'
    );
  } catch {
    return false;
  }
}

/**
 * Brand reveal shown once per browser session.
 */
export function LandingIntro() {
  const [isVisible, setIsVisible] = useState(shouldPlayIntro);
  const { t } = useTranslation();

  useEffect(() => {
    if (!isVisible) return;

    try {
      window.sessionStorage.setItem(introSessionKey, 'true');
    } catch {
      // The landing remains usable when browser storage is unavailable.
    }

    const timeoutId = window.setTimeout(() => {
      setIsVisible(false);
    }, introDuration);

    return () => window.clearTimeout(timeoutId);
  }, [isVisible]);

  if (!isVisible) return null;

  return (
    <div className="landing-intro" aria-hidden="true">
      <svg className="landing-intro__orbit" viewBox="0 0 900 560" preserveAspectRatio="xMidYMid meet">
        <path d="M55 430 C180 450 170 320 300 345 S440 460 535 330 S700 110 845 130" />
      </svg>
      <span className="landing-intro__star landing-intro__star--one" />
      <span className="landing-intro__star landing-intro__star--two" />
      <span className="landing-intro__star landing-intro__star--three" />
      <div className="landing-intro__mission-mark">
        <img src={codeQuestLogo} alt="" />
        <span className="landing-intro__caption">{t('landing.heroMission')}</span>
        <span className="landing-intro__progress" />
      </div>
    </div>
  );
}
