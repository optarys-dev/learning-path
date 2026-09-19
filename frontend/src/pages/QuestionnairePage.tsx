import { useEffect, useLayoutEffect, useRef, useState, type TransitionEvent } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import deviLaptop from '../assets/assessment/04_aprendiendo_con_laptop.svg';
import deviSelection from '../assets/assessment/05_seleccion_correcta.svg';
import deviNeedsAnswer from '../assets/assessment/06_necesita_una_respuesta.svg';
import deviProgress from '../assets/assessment/07_progreso_de_la_ruta.svg';
import deviReady from '../assets/assessment/08_perfil_completado.svg';
import { Button } from '../components/ui/Button/Button';
import { areas, desiredOutcomes, levels, practicalExperiences, questions } from '../questionnaire/config';
import { clearQuestionnaireDraft, loadQuestionnaireDraft, saveQuestionnaireDraft } from '../questionnaire/draft';
import { selectArea } from '../questionnaire/state';
import type { AreaId, QuestionnaireAnswers, QuestionnaireState, TechnologyId } from '../questionnaire/types';
import './QuestionnairePage.css';

function isStepComplete(step: number, answers: QuestionnaireAnswers): boolean {
  switch (questions[step].id) {
    case 'learningGoal': return answers.goal !== null;
    case 'currentExperience': return answers.level !== null;
    case 'knownSkills': return true;
    case 'desiredOutcome': return answers.desiredOutcome !== null;
    case 'practicalExperience': return answers.experience !== null;
  }
}

function toggle(items: TechnologyId[], item: TechnologyId): TechnologyId[] {
  return items.includes(item) ? items.filter(value => value !== item) : [...items, item];
}

const COMPLETE_TOP_GAP = 12;

export function QuestionnairePage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [state, setState] = useState<QuestionnaireState>(loadQuestionnaireDraft);
  const [welcome, setWelcome] = useState(() => state.currentStep === 0 &&
    state.answers.goal === null && state.answers.level === null && state.answers.desiredOutcome === null &&
    state.answers.experience === null && state.answers.interests.length === 0 && state.answers.knownSkills.length === 0);
  const [entryPhase, setEntryPhase] = useState<'idle' | 'preparing' | 'sliding'>('idle');
  const [started, setStarted] = useState(false);
  const entryFrame = useRef<number | null>(null);
  const startScrollFrame = useRef<number | null>(null);
  const flowResizeObserver = useRef<ResizeObserver | null>(null);
  const profileRef = useRef<HTMLDivElement>(null);
  const viewportRef = useRef<HTMLDivElement>(null);
  const stackRef = useRef<HTMLDivElement>(null);
  const welcomeRef = useRef<HTMLElement>(null);
  const flowRef = useRef<HTMLDivElement>(null);
  const welcomeHeadingRef = useRef<HTMLHeadingElement>(null);
  const [showError, setShowError] = useState(false);
  const [hasNavigated, setHasNavigated] = useState(false);
  const [result, setResult] = useState<QuestionnaireAnswers | null>(null);
  const headingRef = useRef<HTMLHeadingElement>(null);
  const completeRef = useRef<HTMLElement>(null);
  const areasRef = useRef<HTMLFieldSetElement>(null);
  const technologySectionRef = useRef<HTMLDivElement>(null);
  const manualAreaSelection = useRef(false);
  const pendingProfileScroll = useRef<'start' | 'step' | 'complete' | null>(null);
  const { answers, currentStep } = state;
  const question = questions[currentStep];
  const stepMascot = {
    learningGoal: deviSelection,
    currentExperience: deviSelection,
    knownSkills: deviLaptop,
    desiredOutcome: deviSelection,
    practicalExperience: deviProgress,
  }[question.id];
  const technologies = answers.goal === null ? [] : areas[answers.goal];
  const progressPercent = questions.length > 1 ? (currentStep / (questions.length - 1)) * 100 : 100;
  const interestsPrompt = t('questionnaire.interestsPrompt');
  const interestsQuestionEnd = interestsPrompt.indexOf('?') + 1;

  useLayoutEffect(() => {
    // Only the area radio handler requests this; restored answers never do.
    if (!manualAreaSelection.current) return;
    const profile = profileRef.current;
    const areaOptions = areasRef.current?.querySelectorAll<HTMLElement>('.learning-profile__area-card');
    const technologySection = technologySectionRef.current;
    const header = profile?.closest('.app-shell')?.querySelector<HTMLElement>('.app-header');
    if (!profile || !areaOptions?.length || !technologySection || !header) return;
    const areaCards = [...areaOptions];
    const lastAreaBounds = areaCards.at(-1)?.getBoundingClientRect();
    if (!lastAreaBounds) return;
    const hasTwoColumns = areaCards.length > 1 &&
      Math.abs(areaCards[0].getBoundingClientRect().top - areaCards[1].getBoundingClientRect().top) < 1;
    const contextArea = hasTwoColumns
      ? [...areaCards].reverse().find(area => area.getBoundingClientRect().top < lastAreaBounds.top - 1) ?? areaCards.at(-1)
      : areaCards.at(-1);
    const contextBounds = contextArea?.getBoundingClientRect();
    if (!contextBounds) return;
    const sectionStyle = getComputedStyle(technologySection);
    const visualGap = parseFloat(sectionStyle.paddingTop);
    const topInset = header.getBoundingClientRect().height + visualGap;
    manualAreaSelection.current = false;
    window.scrollTo({
      top: Math.max(0, window.scrollY + contextBounds.top - topInset),
      behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth',
    });
  }, [answers.goal]);

  useEffect(() => { if (result === null) saveQuestionnaireDraft(state); }, [state, result]);
  useEffect(() => { document.title = `${t('questionnaire.title')} · CODE QUEST 2026`; }, [t]);
  useEffect(() => {
    if (welcome) welcomeHeadingRef.current?.focus();
    else headingRef.current?.focus({ preventScroll: true });
  }, [welcome, currentStep, result]);
  useEffect(() => {
    if (pendingProfileScroll.current !== 'complete' || result === null) return;
    const complete = completeRef.current;
    if (!complete) return;
    const mascot = complete.querySelector<HTMLImageElement>('.learning-profile__mascot--ready');
    let cancelled = false;
    const scrollToComplete = () => {
      if (cancelled) return;
      pendingProfileScroll.current = null;
      const completeTop = complete.getBoundingClientRect().top + window.scrollY;
      window.scrollTo({
        top: Math.max(0, completeTop - COMPLETE_TOP_GAP),
        behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth',
      });
    };
    if (!mascot || mascot.complete) {
      scrollToComplete();
      return;
    }
    mascot.addEventListener('load', scrollToComplete, { once: true });
    mascot.addEventListener('error', scrollToComplete, { once: true });
    return () => {
      cancelled = true;
      mascot.removeEventListener('load', scrollToComplete);
      mascot.removeEventListener('error', scrollToComplete);
    };
  }, [result]);
  useLayoutEffect(() => {
    const scrollIntent = pendingProfileScroll.current;
    if (!scrollIntent) return;
    if (scrollIntent === 'complete') return;
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (scrollIntent === 'start' && !prefersReducedMotion) {
      if (!welcome || entryPhase !== 'sliding') return;
      const profile = profileRef.current;
      if (!profile) return;
      const finalProfileTop = profile.getBoundingClientRect().top + window.scrollY -
        parseFloat(getComputedStyle(profile).marginTop);
      pendingProfileScroll.current = null;
      const scrollWhenReachable = () => {
        const maxScroll = Math.max(0, document.documentElement.scrollHeight - window.innerHeight);
        const revealFinished = ![profile, viewportRef.current, stackRef.current].some(element =>
          element?.getAnimations().some(animation => animation instanceof CSSTransition && animation.playState !== 'finished'));
        if (maxScroll + 0.5 >= finalProfileTop || revealFinished) {
          startScrollFrame.current = null;
          window.scrollTo({ top: finalProfileTop, behavior: 'smooth' });
          return;
        }
        startScrollFrame.current = requestAnimationFrame(scrollWhenReachable);
      };
      startScrollFrame.current = requestAnimationFrame(scrollWhenReachable);
      return;
    }
    if (welcome || entryPhase !== 'idle') return;
    const target = profileRef.current;
    if (!target) return;
    pendingProfileScroll.current = null;
    const targetTop = target.getBoundingClientRect().top + window.scrollY;
    window.scrollTo({
      top: targetTop,
      behavior: prefersReducedMotion ? 'auto' : 'smooth',
    });
  }, [welcome, entryPhase, currentStep, result]);
  useLayoutEffect(() => {
    if (!welcome && viewportRef.current) {
      viewportRef.current.style.height = '';
      stackRef.current?.style.removeProperty('--slide-distance');
    }
  }, [welcome]);
  useEffect(() => () => {
    if (entryFrame.current !== null) cancelAnimationFrame(entryFrame.current);
    if (startScrollFrame.current !== null) cancelAnimationFrame(startScrollFrame.current);
    flowResizeObserver.current?.disconnect();
  }, []);

  function getStarted() {
    if (entryPhase !== 'idle') return;
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      pendingProfileScroll.current = 'start';
      setStarted(true);
      setWelcome(false);
      return;
    }
    const viewport = viewportRef.current;
    const stack = stackRef.current;
    const intro = welcomeRef.current;
    const flow = flowRef.current;
    if (!viewport || !stack || !intro || !flow) return;
    const introHeight = intro.getBoundingClientRect().height;
    viewport.style.height = `${introHeight}px`;
    stack.style.setProperty('--slide-distance', `${introHeight}px`);
    pendingProfileScroll.current = 'start';
    setEntryPhase('preparing');
    entryFrame.current = requestAnimationFrame(() => {
      // The prepared flow already has the questionnaire's final responsive width.
      viewport.style.height = `${flow.getBoundingClientRect().height}px`;
      setEntryPhase('sliding');
      flowResizeObserver.current = new ResizeObserver(() => {
        viewport.style.height = `${flow.getBoundingClientRect().height}px`;
      });
      flowResizeObserver.current.observe(flow, { box: 'border-box' });
      entryFrame.current = null;
    });
  }

  function finishEntry(event: TransitionEvent<HTMLDivElement>) {
    if (entryPhase !== 'sliding') return;
    const profile = profileRef.current;
    const viewport = viewportRef.current;
    const stack = stackRef.current;
    const flow = flowRef.current;
    if (!profile || !viewport || !stack || !flow ||
      ![profile, viewport, stack].includes(event.target as HTMLDivElement)) return;
    // Width/margin may finish before a resize-triggered height transition.
    // Wait for every actual geometry transition, including unchanged-height cases.
    if ([profile, viewport, stack].some(element => element.getAnimations().some(animation =>
      animation instanceof CSSTransition && animation.playState !== 'finished'))) return;
    const viewportBounds = viewport.getBoundingClientRect();
    const flowBounds = flow.getBoundingClientRect();
    if (Math.abs(viewportBounds.height - flowBounds.height) > 0.5 ||
      Math.abs(viewportBounds.top - flowBounds.top) > 0.5 ||
      Math.abs(viewportBounds.width - flowBounds.width) > 0.5 ||
      Math.abs(viewportBounds.left - flowBounds.left) > 0.5 ||
      Math.abs(parseFloat(getComputedStyle(profile).marginTop)) > 0.5) return;
    flowResizeObserver.current?.disconnect();
    flowResizeObserver.current = null;
    setStarted(true);
    setWelcome(false);
    setEntryPhase('idle');
  }

  function setAnswers(next: QuestionnaireAnswers) {
    setState(previous => ({ ...previous, answers: next }));
    setShowError(false);
  }

  function continueFlow() {
    if (!isStepComplete(currentStep, answers)) { setShowError(true); return; }
    if (currentStep < questions.length - 1) {
      pendingProfileScroll.current = 'step';
      setHasNavigated(true);
      setState(previous => ({ ...previous, currentStep: previous.currentStep + 1 }));
      setShowError(false);
      return;
    }
    const incomplete = questions.findIndex((_, index) => !isStepComplete(index, answers));
    if (incomplete >= 0) {
      pendingProfileScroll.current = 'step';
      setHasNavigated(true);
      setState(previous => ({ ...previous, currentStep: incomplete }));
      setShowError(true);
      return;
    }
    pendingProfileScroll.current = 'complete';
    setResult({ ...answers, interests: [...answers.interests], knownSkills: [...answers.knownSkills] });
    clearQuestionnaireDraft();
  }

  function editAnswers() {
    setState(previous => ({ ...previous, currentStep: 0 }));
    setResult(null);
    setWelcome(false);
    setShowError(false);
  }

  return (
    <div ref={profileRef} onTransitionEnd={finishEntry} className={`learning-profile${welcome ? ' learning-profile--welcome' : ''}${entryPhase !== 'idle' ? ' learning-profile--entering' : ''}${entryPhase === 'sliding' ? ' learning-profile--sliding' : ''}${started ? ' learning-profile--started' : ''}`}>
      <div className="learning-profile__reveal-viewport" ref={viewportRef}>
        <div className="learning-profile__reveal-stack" ref={stackRef}>
      {welcome && (
        <section className="learning-profile__welcome" aria-labelledby="welcome-title" ref={welcomeRef}>
          <img className="learning-profile__mascot learning-profile__mascot--welcome" src={deviProgress} alt="" />
          <div className="learning-profile__welcome-content">
            <span className="learning-profile__eyebrow">{t('app.name')}</span>
            <h1 id="welcome-title" ref={welcomeHeadingRef} tabIndex={-1}>{t('questionnaire.welcomeTitle')}</h1>
            <p className="learning-profile__welcome-lead">{t('questionnaire.welcomeLead')}</p>
            <p>{t('questionnaire.welcomeDescription')}</p>
            <Button onClick={getStarted} disabled={entryPhase !== 'idle'}>{t('questionnaire.getStarted')}</Button>
          </div>
        </section>
      )}
        <div className="learning-profile__flow" ref={flowRef} inert={welcome}>
          <header className="learning-profile__intro">
            <h1>{t('questionnaire.title')}</h1>
            <p>{t('questionnaire.description')}</p>
          </header>
          {result === null ? (
        <section className="learning-profile__step" data-question={question.id} aria-labelledby="question-title">
          <p className="learning-profile__step-count">{t('questionnaire.stepCount', { current: currentStep + 1, total: questions.length })}</p>
          <p className="learning-profile__step-name">{t(`questionnaire.stepNames.${question.id}`)}</p>
          <div className="learning-profile__progress-geometry">
            <div className="learning-profile__progress" role="progressbar" aria-label={t('questionnaire.progressLabel')}
              aria-valuemin={1} aria-valuemax={questions.length} aria-valuenow={currentStep + 1}>
              <span style={{ width: `${progressPercent}%` }} />
            </div>
            <div className="learning-profile__milestones" aria-hidden="true">
              {questions.map((item, index) => (
                <span key={item.id} className={index === currentStep ? 'is-current' : index < currentStep ? 'is-complete' : 'is-pending'}
                  style={{ left: `${questions.length > 1 ? (index / (questions.length - 1)) * 100 : 100}%` }} />
              ))}
            </div>
          </div>
          <div className={`learning-profile__question-content${hasNavigated ? ' learning-profile__question-content--animated' : ''}`} key={currentStep}>
          <img className="learning-profile__mascot learning-profile__mascot--explore" src={showError ? deviNeedsAnswer : stepMascot} alt="" />
          <h2 id="question-title" ref={headingRef} tabIndex={-1}>{t(`questionnaire.questions.${question.id}`)}</h2>
          <p className="learning-profile__question-hint"><span aria-hidden="true">✦</span>{t(`questionnaire.stepHints.${question.id}`)}</p>
          {question.id === 'learningGoal' && (
            <>
              <fieldset ref={areasRef} className="learning-profile__options learning-profile__options--areas" aria-describedby={showError ? 'question-error' : undefined}>
                <legend className="sr-only">{t('questionnaire.questions.learningGoal')}</legend>
                {(Object.keys(areas) as AreaId[]).map(area => (
                  <label className="learning-profile__option learning-profile__area-card" key={area}>
                    <input type="radio" name="learning-area" checked={answers.goal === area}
                      onChange={() => {
                        manualAreaSelection.current = true;
                        setAnswers(selectArea(answers, area));
                      }} />
                    <span><strong>{t(`questionnaire.areas.${area}`)}</strong><small>{t(`questionnaire.areaDescriptions.${area}`)}</small></span>
                  </label>
                ))}
              </fieldset>
              {answers.goal !== null && (
                <div className="learning-profile__technology-section" ref={technologySectionRef}>
                <fieldset className="learning-profile__options learning-profile__options--compact learning-profile__interests">
                  <legend>
                    <span className="learning-profile__technology-title">{interestsQuestionEnd ? interestsPrompt.slice(0, interestsQuestionEnd) : interestsPrompt}</span>
                    {interestsQuestionEnd > 0 && <span className="learning-profile__technology-hint">{interestsPrompt.slice(interestsQuestionEnd).trim()}</span>}
                  </legend>
                  {technologies.map(item => (
                    <label className="learning-profile__option learning-profile__chip" key={item}>
                      <input type="checkbox" checked={answers.interests.includes(item)}
                        onChange={() => setAnswers({ ...answers, interests: toggle(answers.interests, item) })} />
                      <span>{t(`questionnaire.technologies.${item}`)}</span>
                    </label>
                  ))}
                </fieldset>
                </div>
              )}
            </>
          )}
          {question.id === 'currentExperience' && (
            <fieldset className="learning-profile__options" aria-describedby={showError ? 'question-error' : undefined}>
              <legend className="sr-only">{t('questionnaire.questions.currentExperience')}</legend>
              {levels.map(level => (
                <label className="learning-profile__option" key={level}>
                  <input type="radio" name="current-experience" checked={answers.level === level}
                    onChange={() => setAnswers({ ...answers, level })} />
                  <span>{t(`questionnaire.levels.${level}`)}</span>
                </label>
              ))}
            </fieldset>
          )}
          {question.id === 'knownSkills' && (
            <fieldset className="learning-profile__options learning-profile__options--compact">
              <legend className="sr-only">{t('questionnaire.questions.knownSkills')}</legend>
              <p className="learning-profile__hint">{t('questionnaire.knownSkillsHint')}</p>
              {technologies.map(item => (
                <label className="learning-profile__option learning-profile__chip" key={item}>
                  <input type="checkbox" checked={answers.knownSkills.includes(item)}
                    onChange={() => setAnswers({ ...answers, knownSkills: toggle(answers.knownSkills, item) })} />
                  <span>{t(`questionnaire.technologies.${item}`)}</span>
                </label>
              ))}
            </fieldset>
          )}
          {question.id === 'desiredOutcome' && (
            <fieldset className="learning-profile__options" aria-describedby={showError ? 'question-error' : undefined}>
              <legend className="sr-only">{t('questionnaire.questions.desiredOutcome')}</legend>
              {desiredOutcomes.map(desiredOutcome => (
                <label className="learning-profile__option" key={desiredOutcome}>
                  <input type="radio" name="desired-outcome" checked={answers.desiredOutcome === desiredOutcome}
                    onChange={() => setAnswers({ ...answers, desiredOutcome })} />
                  <span>{t(`questionnaire.outcomes.${desiredOutcome}`)}</span>
                </label>
              ))}
            </fieldset>
          )}
          {question.id === 'practicalExperience' && (
            <fieldset className="learning-profile__options" aria-describedby={showError ? 'question-error' : undefined}>
              <legend className="sr-only">{t('questionnaire.questions.practicalExperience')}</legend>
              {practicalExperiences.map(experience => (
                <label className="learning-profile__option" key={experience}>
                  <input type="radio" name="practical-experience" checked={answers.experience === experience}
                    onChange={() => setAnswers({ ...answers, experience })} />
                  <span>{t(`questionnaire.experiences.${experience}`)}</span>
                </label>
              ))}
            </fieldset>
          )}
          {showError && <p id="question-error" className="learning-profile__error" role="alert">{t('questionnaire.requiredError')}</p>}
          </div>
          <div className="learning-profile__actions">
            {currentStep > 0 && <Button variant="secondary" onClick={() => {
              pendingProfileScroll.current = 'step';
              setHasNavigated(true);
              setState(previous => ({ ...previous, currentStep: previous.currentStep - 1 })); setShowError(false);
            }}>{t('questionnaire.back')}</Button>}
            <Button onClick={continueFlow}>{t(currentStep === questions.length - 1 ? 'questionnaire.finish' : 'questionnaire.continue')}</Button>
          </div>
        </section>
      ) : (
        <section ref={completeRef} className="learning-profile__step learning-profile__complete" role="status">
          <header className="learning-profile__complete-hero">
            <img className="learning-profile__mascot learning-profile__mascot--ready" src={deviReady} alt="" />
            <div>
              <p className="learning-profile__complete-eyebrow">{t('questionnaire.completeEyebrow')}</p>
              <h2 ref={headingRef} tabIndex={-1}>{t('questionnaire.completeTitle')}</h2>
              <p>{t('questionnaire.completeDescription')}</p>
            </div>
          </header>
          <dl className="learning-profile__summary">
            <div><dt>{t('questionnaire.summaryArea')}</dt><dd>{result.goal && t(`questionnaire.areas.${result.goal}`)}</dd></div>
            <div><dt>{t('questionnaire.summaryLevel')}</dt><dd>{result.level && t(`questionnaire.levels.${result.level}`)}</dd></div>
            <div><dt>{t('questionnaire.summaryOutcome')}</dt><dd>{result.desiredOutcome && t(`questionnaire.outcomes.${result.desiredOutcome}`)}</dd></div>
            <div><dt>{t('questionnaire.summaryExperience')}</dt><dd>{result.experience && t(`questionnaire.experiences.${result.experience}`)}</dd></div>
            <div><dt>{t('questionnaire.summaryInterests')}</dt><dd>{result.interests.length ? result.interests.map(item => t(`questionnaire.technologies.${item}`)).join(', ') : t('questionnaire.noneSelected')}</dd></div>
            <div><dt>{t('questionnaire.summarySkills')}</dt><dd>{result.knownSkills.length ? result.knownSkills.map(item => t(`questionnaire.technologies.${item}`)).join(', ') : t('questionnaire.noneSelected')}</dd></div>
          </dl>
          <div className="learning-profile__complete-actions">
            <Button variant="secondary" onClick={editAnswers}>{t('questionnaire.editAnswers')}</Button>
            <Button onClick={() => navigate('/my-path')}>{t('questionnaire.generatePath')}</Button>
          </div>
        </section>
          )}
        </div>
        </div>
      </div>
    </div>
  );
}
