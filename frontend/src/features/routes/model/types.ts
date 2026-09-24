export interface RecommendationCourse {
  courseId: string;
  position: number;
  title: string;
  score: number;
  reason: string;
  estimatedWeeks: number;
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

export interface CreateRouteDto {
  recommendationMethod: string;
  courses: Array<{
    courseId: string;
    reason: string | null;
  }>;
  explanation: string | null;
}

export interface SavedRouteCourse {
  courseId: string;
  position: number;
  title: string;
  reason: string | null;
  imageUrl: string | null;
  courseUrl: string | null;
  progressPercentage: number;
}

export interface SavedRoute {
  routeId: string;
  goal: string;
  recommendationMethod: string;
  explanation: string | null;
  createdAt: string;
  courses: SavedRouteCourse[];
}

export interface DraftSavedRouteCourse extends SavedRouteCourse {
  uiKey: string;
}

export interface DraftSavedRoute extends Omit<SavedRoute, 'courses'> {
  courses: DraftSavedRouteCourse[];
}

export interface UpdateRouteDto {
  goal: string;
  courses: Array<{
    courseId: string;
    reason: string | null;
  }>;
  explanation: string | null;
}

export interface EditableRouteCourse {
  courseId: string;
  uiKey: string;
  title: string;
  reason: string | null;
  estimatedWeeks?: number | null;
  imageUrl?: string | null;
  courseUrl?: string | null;
  progressPercentage?: number;
}

export type CoursePriority = 'high' | 'medium' | 'normal';

export interface CourseNote {
  content: string;
  updatedAt: string;
}

export interface RouteCourseLocalState {
  notes: Record<string, CourseNote>;
  priorities: Record<string, CoursePriority>;
}

export type RouteRequestErrorKind =
  | 'unauthorized'
  | 'validation'
  | 'not-found'
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
