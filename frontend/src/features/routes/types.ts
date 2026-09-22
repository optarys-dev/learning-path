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

export type RouteRequestErrorKind =
  | 'unauthorized'
  | 'validation'
  | 'server'
  | 'http'
  | 'network'
  | 'invalid-response';

export class RouteRequestError extends Error {
  readonly kind: RouteRequestErrorKind;
  readonly apiMessage: string | null;

  constructor(kind: RouteRequestErrorKind, apiMessage: string | null = null) {
    super(`Route request failed: ${kind}`);
    this.name = 'RouteRequestError';
    this.kind = kind;
    this.apiMessage = apiMessage;
  }
}
