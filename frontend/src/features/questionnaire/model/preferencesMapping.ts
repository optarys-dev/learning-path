import { PreferencesError, type PreferencesDto } from '../api/preferences';
import { es } from '../../../i18n/locales/es';
import { areas, desiredOutcomes, levels, practicalExperiences } from './config';
import type { LevelId, QuestionnaireAnswers, TechnologyId } from './types';

const experienceLevels = {
  none: 'principiante',
  basics: 'principiante',
  'small-projects': 'intermedio',
  'complete-applications': 'avanzado',
} as const satisfies Record<LevelId, PreferencesDto['experienceLevel']>;

export function mapPreferences(answers: QuestionnaireAnswers): PreferencesDto {
  if (answers.goal === null || !Object.hasOwn(areas, answers.goal) ||
    answers.desiredOutcome === null || !desiredOutcomes.includes(answers.desiredOutcome) ||
    answers.level === null || !levels.includes(answers.level) ||
    answers.experience === null || !practicalExperiences.includes(answers.experience)) {
    throw new PreferencesError('validation');
  }

  const technologies: readonly string[] = areas[answers.goal];
  function canonicalTechnologies(ids: TechnologyId[]): string[] {
    if (!Array.isArray(ids) || ids.length > 30 || ids.some(id => !technologies.includes(id))) {
      throw new PreferencesError('validation');
    }
    const names = ids.map(id => es.questionnaire.technologies[id]);
    if (names.some(name => !name || name.length > 100)) throw new PreferencesError('validation');
    return names;
  }

  // Persist the project's Spanish names regardless of the active UI language.
  // The current API contract has no legacyContext field. It remains in the
  // questionnaire state and summary so a future recommender can deliberately
  // use it instead of inferring legacy relevance from a technology alone.
  // Area and practical experience also remain questionnaire answers, not DTO fields.
  return {
    goal: es.questionnaire.outcomes[answers.desiredOutcome],
    interests: canonicalTechnologies(answers.interests),
    existingSkills: canonicalTechnologies(answers.knownSkills),
    experienceLevel: experienceLevels[answers.level],
    preferredLanguage: 'es',
    minutesPerWeek: 60,
  };
}
