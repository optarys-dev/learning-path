import { areas } from './config';
import type { AreaId, QuestionnaireAnswers, QuestionnaireState } from './types';

export const initialQuestionnaireState: QuestionnaireState = {
  currentStep: 0,
  answers: { goal: null, interests: [], level: null, knownSkills: [], desiredOutcome: null, experience: null, legacyContext: null },
};

export function selectArea(answers: QuestionnaireAnswers, goal: AreaId): QuestionnaireAnswers {
  const validOptions: readonly string[] = areas[goal];
  return {
    ...answers,
    goal,
    interests: answers.interests.filter(item => validOptions.includes(item)),
    knownSkills: answers.knownSkills.filter(item => validOptions.includes(item)),
  };
}
