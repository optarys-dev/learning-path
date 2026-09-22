import type { DraftRoute, RouteRecommendation, SaveRouteRequest } from './types';

function numericPosition(value: string | number): number {
  const position = typeof value === 'number' ? value : Number(value);
  return Number.isFinite(position) ? position : Number.MAX_SAFE_INTEGER;
}

export function createDraftRoute(recommendation: RouteRecommendation): DraftRoute {
  const courses = recommendation.courses
    .map((course, sourceIndex) => ({ ...course, uiKey: `${course.courseId}:${sourceIndex}` }))
    .sort((first, second) => numericPosition(first.position) - numericPosition(second.position));

  return { ...recommendation, courses };
}

export function buildSaveRouteRequest(route: DraftRoute): SaveRouteRequest {
  return {
    recommendationMethod: route.method,
    courses: route.courses.map(course => ({ courseId: course.courseId, reason: course.reason })),
    explanation: route.explanation?.trim() || null,
  };
}
