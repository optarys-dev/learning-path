import { useTranslation } from 'react-i18next';
import { areas, desiredOutcomes, legacyContexts, levels, practicalExperiences } from '@/features/questionnaire/model/config';
import { selectArea } from '@/features/questionnaire/model/state';
import { toggleTechnology } from '@/features/questionnaire/model/validation';
import type { AreaId, QuestionId, QuestionnaireAnswers } from '@/features/questionnaire/model/types';

interface Props {
  questionId: QuestionId;
  answers: QuestionnaireAnswers;
  showError: boolean;
  onChange: (answers: QuestionnaireAnswers) => void;
}

/** Presents the current question; navigation, persistence and submission belong to the page. */
export function QuestionOptions({ questionId, answers, showError, onChange }: Props) {
  const { t } = useTranslation();
  const technologies = answers.goal === null ? [] : areas[answers.goal];
  return <>
          {questionId === 'learningGoal' && (
              <fieldset className="learning-profile__options learning-profile__options--areas" aria-describedby={showError ? 'question-error' : undefined}>
                <legend className="sr-only">{t('questionnaire.questions.learningGoal')}</legend>
                {(Object.keys(areas) as AreaId[]).map(area => (
                  <label className="learning-profile__option learning-profile__area-card" key={area}>
                    <input type="radio" name="learning-area" checked={answers.goal === area}
                      onChange={() => onChange(selectArea(answers, area))} />
                    <span><strong>{t(`questionnaire.areas.${area}`)}</strong><small>{t(`questionnaire.areaDescriptions.${area}`)}</small></span>
                  </label>
                ))}
              </fieldset>
          )}
          {questionId === 'technologyInterests' && (
            <fieldset className="learning-profile__options learning-profile__options--compact"
              aria-describedby={showError ? 'question-error' : undefined}>
              <legend className="sr-only">{t('questionnaire.questions.technologyInterests')}</legend>
              {technologies.map(item => (
                <label className="learning-profile__option learning-profile__chip" key={item}>
                  <input type="checkbox" checked={answers.interests.includes(item)}
                    onChange={() => onChange({ ...answers, interests: toggleTechnology(answers.interests, item) })} />
                  <span>{t(`questionnaire.technologies.${item}`)}</span>
                </label>
              ))}
            </fieldset>
          )}
          {questionId === 'currentExperience' && (
            <fieldset className="learning-profile__options" aria-describedby={showError ? 'question-error' : undefined}>
              <legend className="sr-only">{t('questionnaire.questions.currentExperience')}</legend>
              {levels.map(level => (
                <label className="learning-profile__option" key={level}>
                  <input type="radio" name="current-experience" checked={answers.level === level}
                    onChange={() => onChange({ ...answers, level })} />
                  <span>{t(`questionnaire.levels.${level}`)}</span>
                </label>
              ))}
            </fieldset>
          )}
          {questionId === 'knownSkills' && (
            <fieldset className="learning-profile__options learning-profile__options--compact">
              <legend className="sr-only">{t('questionnaire.questions.knownSkills')}</legend>
              {technologies.map(item => (
                <label className="learning-profile__option learning-profile__chip" key={item}>
                  <input type="checkbox" checked={answers.knownSkills.includes(item)}
                    onChange={() => onChange({ ...answers, knownSkills: toggleTechnology(answers.knownSkills, item) })} />
                  <span>{t(`questionnaire.technologies.${item}`)}</span>
                </label>
              ))}
            </fieldset>
          )}
          {questionId === 'desiredOutcome' && (
            <fieldset className="learning-profile__options" aria-describedby={showError ? 'question-error' : undefined}>
              <legend className="sr-only">{t('questionnaire.questions.desiredOutcome')}</legend>
              {desiredOutcomes.map(desiredOutcome => (
                <label className="learning-profile__option" key={desiredOutcome}>
                  <input type="radio" name="desired-outcome" checked={answers.desiredOutcome === desiredOutcome}
                    onChange={() => onChange({ ...answers, desiredOutcome })} />
                  <span>{t(`questionnaire.outcomes.${desiredOutcome}`)}</span>
                </label>
              ))}
            </fieldset>
          )}
          {questionId === 'practicalExperience' && (
            <div className="learning-profile__final-step">
              <fieldset className="learning-profile__options" aria-describedby={showError ? 'question-error' : undefined}>
                <legend className="sr-only">{t('questionnaire.questions.practicalExperience')}</legend>
                {practicalExperiences.map(experience => (
                  <label className="learning-profile__option" key={experience}>
                    <input type="radio" name="practical-experience" checked={answers.experience === experience}
                      onChange={() => onChange({ ...answers, experience })} />
                    <span>{t(`questionnaire.experiences.${experience}`)}</span>
                  </label>
                ))}
              </fieldset>
              <fieldset className="learning-profile__legacy-context">
                <legend>{t('questionnaire.legacyQuestion')}</legend>
                <p>{t('questionnaire.legacyHint')}</p>
                <div className="learning-profile__legacy-options">
                  {legacyContexts.map(legacyContext => (
                    <label className="learning-profile__legacy-option" key={legacyContext}>
                      <input type="radio" name="legacy-context" checked={answers.legacyContext === legacyContext}
                        onChange={() => onChange({ ...answers, legacyContext })} />
                      <span>{t(`questionnaire.legacyContexts.${legacyContext}`)}</span>
                    </label>
                  ))}
                </div>
              </fieldset>
            </div>
          )}
  </>;
}
