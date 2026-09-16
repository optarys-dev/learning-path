import { useId, useRef, useState, type KeyboardEvent } from 'react';
import { Trans, useTranslation } from 'react-i18next';
import { BookOpenCheck, Compass, Map, Route, type LucideIcon } from 'lucide-react';

const steps = ['personalize', 'discover', 'route', 'progress'] as const;
const stepIcons: LucideIcon[] = [Compass, Map, Route, BookOpenCheck];

export function JourneyExplainer() {
  const { t } = useTranslation();
  const id = useId();
  const [active, setActive] = useState(0);
  const tabs = useRef<(HTMLButtonElement | null)[]>([]);
  const step = steps[active];

  function onKeyDown(event: KeyboardEvent<HTMLButtonElement>, index: number) {
    let next: number;
    switch (event.key) {
      case 'ArrowRight': next = (index + 1) % steps.length; break;
      case 'ArrowLeft': next = (index + steps.length - 1) % steps.length; break;
      case 'Home': next = 0; break;
      case 'End': next = steps.length - 1; break;
      default: return;
    }
    event.preventDefault();
    setActive(next);
    tabs.current[next]?.focus();
  }

  return (
    <section id="how-it-works" className="landing-section" aria-labelledby={`${id}-title`}>
      <div className="landing-section__heading">
        <p className="landing-eyebrow"><span aria-hidden="true">01</span>{t('landing.how.eyebrow')}</p>
        <h2 id={`${id}-title`}><Trans i18nKey="landing.how.title" components={{ accent: <span className="text-accent" /> }} /></h2>
        <p>{t('landing.how.description')}</p>
      </div>
      <div className="journey-tabs" role="tablist" aria-label={t('landing.how.label')}>
        {steps.map((value, index) => {
          const Icon = stepIcons[index];
          return <button key={value} type="button" role="tab" id={`${id}-tab-${index}`}
            aria-selected={active === index} aria-controls={`${id}-panel-${index}`}
            tabIndex={active === index ? 0 : -1}
            ref={element => { tabs.current[index] = element; }}
            onKeyDown={event => onKeyDown(event, index)} onClick={() => setActive(index)}>
            <span aria-hidden="true"><Icon size={18} /></span>{t(`landing.how.${value}.tab`)}
          </button>;
        })}
      </div>
      {steps.map((value, index) => (
        <div key={value} id={`${id}-panel-${index}`} role="tabpanel" tabIndex={0}
          aria-labelledby={`${id}-tab-${index}`} hidden={active !== index}>
          {active === index && <div className="journey-panel">
            <div className="journey-panel__copy">
              <span className="journey-panel__number" aria-hidden="true">0{index + 1}<span> / 04</span></span>
              <h3>{t(`landing.how.${step}.title`)}</h3>
              <p>{t(`landing.how.${step}.description`)}</p>
            </div>
            <div className="journey-panel__preview">
              <p className="journey-panel__eyebrow"><span aria-hidden="true">◇</span>{t('landing.how.preview')}</p>
              <ul>
                {(['itemOne', 'itemTwo', 'itemThree'] as const).map((item, itemIndex) => (
                  <li key={item}><span aria-hidden="true">{itemIndex + 1}</span>{t(`landing.how.${step}.${item}`)}</li>
                ))}
              </ul>
              <div className="journey-panel__outcome"><span>{t('landing.how.resultLabel')}</span><strong>{t(`landing.how.${step}.outcome`)}</strong></div>
            </div>
          </div>}
        </div>
      ))}
    </section>
  );
}
