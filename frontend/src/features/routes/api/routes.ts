import { routeApiPaths } from './paths';
import { ApiError, requestJson, requestVoid } from '@/lib/api';
import { isAbortError } from '@/lib/api/apiClient';
import { parseRouteRecommendation, parseSavedRoute } from '@/features/routes/model/parseRoutes';
import { RouteRequestError, type CreateRouteDto, type RouteRecommendation, type SavedRoute, type UpdateRouteDto, type RouteRequestErrorKind } from '@/features/routes/model/types';
export { parseRouteRecommendation, parseSavedRoute } from '@/features/routes/model/parseRoutes';

function routeError(error: unknown): never {
  if (isAbortError(error)) throw error;
  if (!(error instanceof ApiError)) throw error;
  let kind: RouteRequestErrorKind = 'http';
  if (error.kind !== 'http') kind = error.kind;
  else if (error.status === 400 || error.status === 409 || error.status === 422) kind = 'validation';
  else if (error.status === 401) kind = 'unauthorized';
  else if (error.status === 403) kind = 'forbidden';
  else if (error.status === 404) kind = 'not-found';
  else if (error.status !== null && error.status >= 500) kind = 'server';
  throw new RouteRequestError(kind, error.kind === 'http' ? error.message : null, error.code);
}

// Preserve the route feature's error contract while sharing transport and 401 handling.
async function requestJsonRoute(response: Promise<unknown>): Promise<unknown> {
  try { return await response; } catch (error) { return routeError(error); }
}
export async function generateRouteRecommendation(excludedCourseIds: string[] = []): Promise<RouteRecommendation> {
  const query = new URLSearchParams();
  excludedCourseIds.forEach(courseId => query.append('excludeCourseIds', courseId));
  const recommendation = parseRouteRecommendation(await requestJsonRoute(requestJson<unknown>(`${routeApiPaths.recommendation}${query.size ? `?${query}` : ''}`)));
  if (!recommendation) throw new RouteRequestError('invalid-response');
  return recommendation;
}

export async function getSavedRoutes(signal?: AbortSignal): Promise<SavedRoute[]> {
  const body = await requestJsonRoute(requestJson<unknown>(routeApiPaths.collection, { signal }));
  if (!Array.isArray(body)) throw new RouteRequestError('invalid-response');
  const routes = body.map(parseSavedRoute);
  if (routes.some(route => route === null)) throw new RouteRequestError('invalid-response');
  return routes.filter((route): route is SavedRoute => route !== null);
}

export async function getSavedRoute(routeId: string, signal?: AbortSignal): Promise<SavedRoute> {
  const route = parseSavedRoute(await requestJsonRoute(requestJson<unknown>(routeApiPaths.detail(routeId), { signal })));
  if (!route) throw new RouteRequestError('invalid-response');
  return route;
}

export async function saveRoute(dto: CreateRouteDto): Promise<SavedRoute> {
  const route = parseSavedRoute(await requestJsonRoute(requestJson<unknown>(routeApiPaths.collection, {
    method: 'POST',
    json: dto,
  })));
  if (!route) throw new RouteRequestError('invalid-response');
  return route;
}

export async function updateRoute(routeId: string, dto: UpdateRouteDto): Promise<SavedRoute> {
  const route = parseSavedRoute(await requestJsonRoute(requestJson<unknown>(routeApiPaths.detail(routeId), {
    method: 'PUT',
    json: dto,
  })));
  if (!route) throw new RouteRequestError('invalid-response');
  return route;
}

export async function updateCourseProgress(routeId: string, courseId: string, completed: boolean): Promise<SavedRoute> {
  const route = parseSavedRoute(await requestJsonRoute(requestJson<unknown>(
    routeApiPaths.progress(routeId, courseId), {
      method: 'PATCH',
      json: { progressPercentage: completed ? 100 : 0 },
    },
  )));
  if (!route) throw new RouteRequestError('invalid-response');
  return route;
}

export async function deleteRoute(routeId: string): Promise<void> {
  try { await requestVoid(routeApiPaths.detail(routeId), { method: 'DELETE' }); }
  catch (error) { routeError(error); }
}
