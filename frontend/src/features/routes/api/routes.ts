import { apiUrl } from '../../../config/api';
import type {
  CreateRouteDto,
  RecommendationCourse,
  RouteRecommendation,
  SavedRoute,
  SavedRouteCourse,
  UpdateRouteDto,
} from '../model/types';
import { RouteRequestError, type RouteRequestErrorKind } from '../model/types';

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function normalizeNumber(value: unknown): number | null {
  if (typeof value === 'number') return Number.isFinite(value) ? value : null;
  if (typeof value !== 'string' || value.trim() === '') return null;
  const number = Number(value);
  return Number.isFinite(number) ? number : null;
}

function normalizeCourseId(value: unknown): string | null {
  if (typeof value === 'string') return value.trim() === '' ? null : value;
  return typeof value === 'number' && Number.isFinite(value) ? String(value) : null;
}

function nullableString(value: unknown): string | null | undefined {
  if (value === null) return null;
  return typeof value === 'string' ? value : undefined;
}

function optionalUrl(value: unknown): string | null | undefined {
  if (value === null || value === '') return null;
  return typeof value === 'string' ? value : undefined;
}

function parseRecommendationCourse(value: unknown): RecommendationCourse | null {
  if (!isRecord(value) || typeof value.title !== 'string' || typeof value.reason !== 'string') return null;
  const courseId = normalizeCourseId(value.courseId);
  const position = normalizeNumber(value.position);
  const score = normalizeNumber(value.score);
  const estimatedWeeks = normalizeNumber(value.estimatedWeeks);
  if (courseId === null || position === null || score === null || estimatedWeeks === null) return null;
  return { courseId, position, title: value.title, score, reason: value.reason, estimatedWeeks };
}

export function parseRouteRecommendation(value: unknown): RouteRecommendation | null {
  if (!isRecord(value) || typeof value.method !== 'string' || typeof value.goal !== 'string' ||
    (typeof value.explanation !== 'string' && value.explanation !== null) ||
    typeof value.refinementStatus !== 'string' || !Array.isArray(value.courses)) return null;
  const courses = value.courses.map(parseRecommendationCourse);
  if (courses.some(course => course === null)) return null;
  return {
    method: value.method,
    goal: value.goal,
    explanation: value.explanation,
    courses: courses.filter((course): course is RecommendationCourse => course !== null),
    refinementStatus: value.refinementStatus,
    model: value.model ?? null,
  };
}

function parseSavedRouteCourse(value: unknown): SavedRouteCourse | null {
  if (!isRecord(value) || typeof value.title !== 'string') return null;
  const courseId = normalizeCourseId(value.courseId);
  const position = normalizeNumber(value.position);
  const reason = nullableString(value.reason);
  const imageUrl = optionalUrl(value.imageUrl);
  const courseUrl = optionalUrl(value.courseUrl);
  if (courseId === null || position === null || reason === undefined || imageUrl === undefined || courseUrl === undefined) return null;
  return { courseId, position, title: value.title, reason, imageUrl, courseUrl };
}

export function parseSavedRoute(value: unknown): SavedRoute | null {
  if (!isRecord(value) || typeof value.routeId !== 'string' || value.routeId.trim() === '' ||
    typeof value.goal !== 'string' || typeof value.recommendationMethod !== 'string' ||
    typeof value.createdAt !== 'string' || Number.isNaN(Date.parse(value.createdAt)) ||
    !Array.isArray(value.courses)) return null;
  const explanation = nullableString(value.explanation);
  const courses = value.courses.map(parseSavedRouteCourse);
  if (explanation === undefined || courses.some(course => course === null)) return null;
  return {
    routeId: value.routeId,
    goal: value.goal,
    recommendationMethod: value.recommendationMethod,
    explanation,
    createdAt: value.createdAt,
    courses: courses.filter((course): course is SavedRouteCourse => course !== null)
      .sort((first, second) => first.position - second.position),
  };
}

async function readApiMessage(response: Response): Promise<string | null> {
  try {
    const body: unknown = await response.json();
    return isRecord(body) && typeof body.message === 'string' ? body.message : null;
  } catch {
    return null;
  }
}

function errorKind(response: Response): RouteRequestErrorKind {
  if (response.status === 400 || response.status === 409 || response.status === 422) return 'validation';
  if (response.status === 401 || response.status === 403) return 'unauthorized';
  if (response.status === 404) return 'not-found';
  if (response.status >= 500) return 'server';
  return 'http';
}

async function request(path: string, init?: RequestInit): Promise<Response> {
  try {
    const response = await fetch(`${apiUrl}${path}`, { ...init, credentials: 'include' });
    if (!response.ok) throw new RouteRequestError(errorKind(response), await readApiMessage(response));
    return response;
  } catch (error) {
    if (error instanceof RouteRequestError) throw error;
    throw new RouteRequestError('network');
  }
}

async function readJson(response: Response): Promise<unknown> {
  try {
    return await response.json();
  } catch {
    throw new RouteRequestError('invalid-response');
  }
}

export async function generateRouteRecommendation(): Promise<RouteRecommendation> {
  const recommendation = parseRouteRecommendation(await readJson(
    await request('/routes/recommendation/semantic/v2'),
  ));
  if (!recommendation) throw new RouteRequestError('invalid-response');
  return recommendation;
}

export async function getSavedRoutes(): Promise<SavedRoute[]> {
  const body = await readJson(await request('/routes'));
  if (!Array.isArray(body)) throw new RouteRequestError('invalid-response');
  const routes = body.map(parseSavedRoute);
  if (routes.some(route => route === null)) throw new RouteRequestError('invalid-response');
  return routes.filter((route): route is SavedRoute => route !== null);
}

export async function getSavedRoute(routeId: string): Promise<SavedRoute> {
  const route = parseSavedRoute(await readJson(await request(`/routes/${encodeURIComponent(routeId)}`)));
  if (!route) throw new RouteRequestError('invalid-response');
  return route;
}

export async function saveRoute(dto: CreateRouteDto): Promise<SavedRoute> {
  const route = parseSavedRoute(await readJson(await request('/routes', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(dto),
  })));
  if (!route) throw new RouteRequestError('invalid-response');
  return route;
}

export async function updateRoute(routeId: string, dto: UpdateRouteDto): Promise<SavedRoute> {
  const route = parseSavedRoute(await readJson(await request(`/routes/${encodeURIComponent(routeId)}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(dto),
  })));
  if (!route) throw new RouteRequestError('invalid-response');
  return route;
}

export async function deleteRoute(routeId: string): Promise<void> {
  await request(`/routes/${encodeURIComponent(routeId)}`, { method: 'DELETE' });
}
