import { areas, desiredOutcomes, levels, practicalExperiences, questions } from './config';
import type { AreaId, QuestionnaireAnswers, QuestionnaireState, TechnologyId } from './types';
import { initialQuestionnaireState } from './state';

export const DRAFT_KEY = 'codequest-questionnaire-draft';
const DRAFT_VERSION = 2;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isOption<T extends string>(value: unknown, options: readonly T[]): value is T {
  return typeof value === 'string' && options.some(option => option === value);
}

function isArea(value: unknown): value is AreaId {
  return typeof value === 'string' && Object.hasOwn(areas, value);
}

function isTechnologyList(value: unknown, goal: AreaId | null): value is TechnologyId[] {
  return Array.isArray(value) && value.every(item => goal !== null && isOption(item, areas[goal]));
}

function parseAnswers(value: unknown): QuestionnaireAnswers | null {
  if (!isRecord(value)) return null;

  const goal = value.goal === null ? null : isArea(value.goal) ? value.goal : undefined;

  if (goal === undefined || !isTechnologyList(value.interests, goal) || !isTechnologyList(value.knownSkills, goal)) return null;
  
  const level = value.level === null ? null : isOption(value.level, levels) ? value.level : undefined;
  const desiredOutcome = value.desiredOutcome === null ? null : isOption(value.desiredOutcome, desiredOutcomes) ? value.desiredOutcome : undefined;
  const experience = value.experience === null ? null : isOption(value.experience, practicalExperiences) ? value.experience : undefined;
  
  if (level === undefined || desiredOutcome === undefined || experience === undefined) return null;
  
  return { goal, interests: value.interests, level, knownSkills: value.knownSkills, desiredOutcome, experience };
}

function canResumeAt(step: number, answers: QuestionnaireAnswers): boolean {
  return (step < 1 || answers.goal !== null) &&
    (step < 3 || answers.level !== null) &&
    (step < 5 || answers.desiredOutcome !== null);
}

export function loadQuestionnaireDraft(): QuestionnaireState {
  try {
    const raw = localStorage.getItem(DRAFT_KEY);

    if (raw === null) return initialQuestionnaireState;

    const draft: unknown = JSON.parse(raw);

    if (isRecord(draft) && draft.draftVersion === DRAFT_VERSION &&
      Number.isInteger(draft.currentStep) && typeof draft.currentStep === 'number' &&
      draft.currentStep >= 0 && draft.currentStep < questions.length) {

      const answers = parseAnswers(draft.answers);

      if (answers !== null && canResumeAt(draft.currentStep, answers)) return { currentStep: draft.currentStep, answers };
    }
    localStorage.removeItem(DRAFT_KEY);
  } catch {
    // Storage may be unavailable or contain malformed JSON.
    try { localStorage.removeItem(DRAFT_KEY); } catch { /* Storage unavailable. */ }
  }
  return initialQuestionnaireState;
}

export function saveQuestionnaireDraft(state: QuestionnaireState): void {
  try {
    localStorage.setItem(DRAFT_KEY, JSON.stringify({ draftVersion: DRAFT_VERSION, currentStep: state.currentStep, answers: state.answers }));
  } catch { /* Continue in memory when storage is unavailable. */ }
}

export function clearQuestionnaireDraft(): void {
  try { localStorage.removeItem(DRAFT_KEY); } catch { /* Storage unavailable. */ }
}
