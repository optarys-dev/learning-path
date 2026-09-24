import type { CreateRouteDto, DraftRoute, DraftSavedRoute, RouteRecommendation, SavedRoute, UpdateRouteDto } from './types';

export function createDraftRoute(recommendation: RouteRecommendation): DraftRoute {
  const courses = recommendation.courses
    .map((course, sourceIndex) => ({ ...course, uiKey: `${course.courseId}:${sourceIndex}` }))
    .sort((first, second) => first.position - second.position);

  return { ...recommendation, courses };
}

export function buildSaveRouteRequest(route: DraftRoute): CreateRouteDto {
  return {
    recommendationMethod: route.method,
    courses: route.courses.map(course => ({ courseId: course.courseId, reason: course.reason })),
    explanation: route.explanation?.trim() || null,
  };
}

export function buildUpdateRouteRequest(route: SavedRoute): UpdateRouteDto {
  return {
    goal: route.goal,
    courses: route.courses.map(course => ({ courseId: String(course.courseId), reason: course.reason ?? null })),
    explanation: route.explanation?.trim() || null,
  };
}

export function createSavedRouteDraft(route: SavedRoute): DraftSavedRoute {
  return {
    ...route,
    courses: route.courses
      .map(course => ({ ...course, uiKey: course.courseId }))
      .sort((first, second) => first.position - second.position),
  };
}
