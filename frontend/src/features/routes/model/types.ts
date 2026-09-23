export type NumericApiValue = string | number;

export interface RecommendationCourse {
  courseId: string;
  position: NumericApiValue;
  title: string;
  score: NumericApiValue;
  reason: string;
  estimatedWeeks: NumericApiValue;
}

export interface RouteRecommendation {
  method: string;
  goal: string;
  explanation: string | null;
  courses: RecommendationCourse[];
  refinementStatus: string;
  model: unknown;
}

export interface DraftRouteCourse extends RecommendationCourse {
  uiKey: string;
}

export interface DraftRoute extends Omit<RouteRecommendation, 'courses'> {
  courses: DraftRouteCourse[];
}

export interface SaveRouteRequest {
  recommendationMethod: string;
  courses: Array<{
    courseId: string;
    reason: string;
  }>;
  explanation: string | null;
}
