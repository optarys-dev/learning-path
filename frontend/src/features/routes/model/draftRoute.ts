import { routeStorage } from './constants';
import type { CreateRouteDto, DraftRoute, DraftSavedRoute, RouteRecommendation, SavedRoute, UpdateRouteDto } from './types';

const PENDING_ROUTE_KEY = routeStorage.pendingRecommendation;

export function loadPendingRoute(userId: string): { route: DraftRoute; modified: boolean } | null {
  try {
    const raw = sessionStorage.getItem(PENDING_ROUTE_KEY);
    if (!raw) return null;
    const draft: unknown = JSON.parse(raw);
    if (typeof draft !== 'object' || draft === null || !('userId' in draft) || draft.userId !== userId ||
      !('route' in draft) || typeof draft.route !== 'object' || draft.route === null) return null;
    const route = draft.route as Record<string, unknown>;
    if (typeof route.method !== 'string' || typeof route.goal !== 'string' ||
      (route.explanation !== null && typeof route.explanation !== 'string') ||
      typeof route.refinementStatus !== 'string' || !Array.isArray(route.courses) ||
      !route.courses.every(course => typeof course === 'object' && course !== null &&
        typeof course.courseId === 'string' && course.courseId.length > 0 &&
        typeof course.uiKey === 'string' && course.uiKey.length > 0 &&
        typeof course.title === 'string' && typeof course.reason === 'string' &&
        Number.isInteger(course.position) && Number.isFinite(course.score) &&
        Number.isFinite(course.estimatedWeeks))) return null;
    return { route: route as unknown as DraftRoute, modified: 'modified' in draft && draft.modified === true };
  } catch {
    return null;
  }
}

export function savePendingRoute(userId: string, route: DraftRoute, modified: boolean): void {
  try { sessionStorage.setItem(PENDING_ROUTE_KEY, JSON.stringify({ userId, route, modified })); }
  catch { /* Keep the proposal in memory when storage is unavailable. */ }
}

export function clearPendingRoute(): void {
  try { sessionStorage.removeItem(PENDING_ROUTE_KEY); }
  catch { /* Storage unavailable. */ }
}

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
