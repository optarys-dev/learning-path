import type { DraftRoute, RouteRecommendation, SaveRouteRequest } from './types';

export function createDraftRoute(recommendation: RouteRecommendation): DraftRoute {
  const courses = recommendation.courses
    .map((course, sourceIndex) => ({ ...course, uiKey: `${course.courseId}:${sourceIndex}` }))
    .sort((first, second) => first.position - second.position);

  return { ...recommendation, courses };
}

export function buildSaveRouteRequest(route: DraftRoute): SaveRouteRequest {
  return {
    recommendationMethod: route.method,
    courses: route.courses.map(course => ({ courseId: course.courseId, reason: course.reason })),
    explanation: route.explanation?.trim() || null,
  };
}
