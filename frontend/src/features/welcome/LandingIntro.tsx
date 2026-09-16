import { useEffect, useState } from 'react';
import missionLogo from '../../assets/brand/codequest-2026-mission.png';

const introSessionKey = 'codequest.landing-intro.seen';
const introDuration = 4200;

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

  useEffect(() => {
    if (!isVisible) return;

    const timeoutId = window.setTimeout(() => {
      try {
        window.sessionStorage.setItem(introSessionKey, 'true');
      } catch {
        // The landing remains usable when browser storage is unavailable.
      }

      setIsVisible(false);
    }, introDuration);

    return () => window.clearTimeout(timeoutId);
  }, [isVisible]);

  if (!isVisible) return null;

  return (
    <div className="landing-intro" aria-hidden="true">
      <div className="landing-intro__mission-mark">
        <img src={missionLogo} alt="" />

        <div className="landing-intro__meta">
          <div className="landing-intro__team">
            <span className="landing-intro__team-label">
              TEAM // OPTARYS
            </span>

            <div className="landing-intro__members">
              <span>@saturogosho</span>
              <span>@mynameisjohan</span>
              <span>@kevinorjg</span>
            </div>
          </div>

          <div className="landing-intro__status">
            <span className="landing-intro__status-dot" />
            <span>MISSION START</span>
          </div>
        </div>
      </div>
    </div>
  );
}
