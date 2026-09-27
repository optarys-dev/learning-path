import { useId, useRef, useState, type KeyboardEvent } from 'react';
import { Trans, useTranslation } from 'react-i18next';
import { motion, useReducedMotion } from 'framer-motion';
import { SectionAccent } from './SectionAccent';
import { ArrowLeft, ArrowRight, BookOpenCheck, Check, Compass, Flag, GitBranch, ListOrdered, Map, NotebookPen, Route, Search, ShieldCheck, Sparkles, Bookmark, type LucideIcon } from 'lucide-react';

const steps = ['personalize', 'discover', 'route', 'progress'] as const;
const stepIcons: LucideIcon[] = [Compass, Map, Route, BookOpenCheck];
const benefitIcons: LucideIcon[][] = [
  [Search, ListOrdered, Sparkles],
  [BookOpenCheck, Route, GitBranch],
  [Flag, GitBranch, ShieldCheck],
  [Bookmark, Check, NotebookPen],
];

export function JourneyExplainer() {
  const { t } = useTranslation();
  const id = useId();
  const [active, setActive] = useState(0);
  const reduceMotion = useReducedMotion();
  const tabs = useRef<(HTMLButtonElement | null)[]>([]);

  function selectStep(next: number) {
    if (next === active) return;
    setActive(next);
  }

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
    selectStep(next);
    tabs.current[next]?.focus();
  }

  return (
    <section id="how-it-works" className="landing-section journey-story journey-workbench" aria-labelledby={`${id}-title`}>
      <div className="landing-section__heading journey-story__heading">
        <p className="landing-eyebrow">{t('landing.how.eyebrow')}</p>
        <h2 id={`${id}-title`}><Trans i18nKey="landing.how.title" components={{ accent: <span className="text-accent" /> }} /></h2>
        <p>{t('landing.how.description')}</p>
        <SectionAccent kind="note" />
      </div>
      <div className="journey-workbench__layout">
      <div className="journey-tabs" role="tablist" aria-label={t('landing.how.label')}>
        {steps.map((value, index) => {
          const Icon = stepIcons[index];
          return <button key={value} type="button" role="tab" id={`${id}-tab-${index}`}
            aria-selected={active === index} aria-controls={`${id}-panel-${index}`}
            tabIndex={active === index ? 0 : -1}
            ref={element => { tabs.current[index] = element; }}
            onKeyDown={event => onKeyDown(event, index)} onClick={() => selectStep(index)}>
            <span aria-hidden="true"><Icon size={20} /></span><span>{t(`landing.how.${value}.tab`)}</span><small aria-hidden="true">0{index + 1}</small>
          </button>;
        })}
      </div>
      <div className="journey-panel">
              <div className="journey-blueprint" aria-hidden="true">
                {steps.map((node, nodeIndex) => {
                  const NodeIcon = stepIcons[nodeIndex];
                  return <span key={node} data-reached={nodeIndex <= active} data-current={nodeIndex === active}><NodeIcon size={26} /><small>0{nodeIndex + 1}</small></span>;
                })}
              </div>
        <div className="journey-step-stage">
        {steps.map((step, index) => (
          <motion.div key={step} id={`${id}-panel-${index}`} role="tabpanel"
            className="journey-step-content" tabIndex={active === index ? 0 : -1}
            aria-labelledby={`${id}-tab-${index}`} aria-hidden={active !== index}
            inert={active !== index} data-active={active === index}
            initial={false} animate={{ opacity: active === index ? 1 : 0 }}
            transition={{ duration: reduceMotion ? 0 : .24, ease: 'easeInOut' }}>
            <div className="journey-panel__copy">
              <h3>{t(`landing.how.${step}.title`)}</h3>
              <p>{t(`landing.how.${step}.description`)}</p>
            </div>
            <div className="journey-benefits">
              <ul className="journey-benefits__grid">
                {(['itemOne', 'itemTwo', 'itemThree'] as const).map((item, itemIndex) => {
                  const Icon = benefitIcons[index][itemIndex];
                  return <li key={item}>
                    <span className="journey-benefits__icon" aria-hidden="true"><Icon size={24} strokeWidth={1.7} /></span>
                    <strong>{t(`landing.how.${step}.${item}`)}</strong>
                  </li>;
                })}
              </ul>
              <div className="journey-benefits__result"><span aria-hidden="true"><Sparkles size={19} /></span><p>{t('landing.how.resultLabel')}<strong>{t(`landing.how.${step}.outcome`)}</strong></p></div>
            </div>
          </motion.div>
        ))}
        </div>
      </div>
      </div>
      <div className="journey-controls">
        <span className="journey-controls__count" aria-live="polite"><strong>{String(active + 1).padStart(2, '0')}</strong> / 04</span>
        <div>
          <button type="button" disabled={active === 0} onClick={() => selectStep(active - 1)}><ArrowLeft size={17} aria-hidden="true" />{t('landing.how.previous')}</button>
          <button type="button" disabled={active === steps.length - 1} onClick={() => selectStep(active + 1)}>{t('landing.how.next')}<ArrowRight size={17} aria-hidden="true" /></button>
        </div>
      </div>
    </section>
  );
}
