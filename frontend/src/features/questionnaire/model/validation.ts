import { questions } from './config';
import type { QuestionnaireAnswers, TechnologyId } from './types';

export function isStepComplete(step: number, answers: QuestionnaireAnswers): boolean {
  const question = questions[step];
  if (!question) return false;
  switch (question.id) {
    case 'learningGoal': return answers.goal !== null;
    case 'technologyInterests': return true;
    case 'currentExperience': return answers.level !== null;
    case 'knownSkills': return true;
    case 'desiredOutcome': return answers.desiredOutcome !== null;
    case 'practicalExperience': return answers.experience !== null;
  }
}

export function toggleTechnology(items: TechnologyId[], item: TechnologyId): TechnologyId[] {
  return items.includes(item) ? items.filter(value => value !== item) : [...items, item];
}

