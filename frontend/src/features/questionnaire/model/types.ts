import type { areas, desiredOutcomes, levels, practicalExperiences, questions } from './config';

export type AreaId = keyof typeof areas;
export type TechnologyId = (typeof areas)[AreaId][number];
export type LevelId = (typeof levels)[number];
export type DesiredOutcomeId = (typeof desiredOutcomes)[number];
export type PracticalExperienceId = (typeof practicalExperiences)[number];
export type QuestionId = (typeof questions)[number]['id'];

export interface QuestionnaireAnswers {
  goal: AreaId | null;
  interests: TechnologyId[];
  level: LevelId | null;
  knownSkills: TechnologyId[];
  desiredOutcome: DesiredOutcomeId | null;
  experience: PracticalExperienceId | null;
}

export interface QuestionnaireState {
  currentStep: number;
  answers: QuestionnaireAnswers;
}
