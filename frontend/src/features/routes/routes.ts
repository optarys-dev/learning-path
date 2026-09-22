import { apiUrl } from '../../config/api';
import { mockRouteRecommendation } from './mockRouteRecommendation';
import type { RecommendationCourse, RouteRecommendation, SaveRouteRequest } from './types';
import { RouteRequestError, type RouteRequestErrorKind } from './types';

const MOCK_DELAY_MS = 450;

export const isRouteRecommendationMockEnabled =
  import.meta.env.DEV && import.meta.env.VITE_USE_ROUTE_MOCK?.trim().toLowerCase() === 'true';

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

function parseCourse(value: unknown): RecommendationCourse | null {
  if (!isRecord(value) || typeof value.title !== 'string' || typeof value.reason !== 'string') return null;

  const courseId = normalizeCourseId(value.courseId);
  const position = normalizeNumber(value.position);
  const score = normalizeNumber(value.score);
  const estimatedWeeks = normalizeNumber(value.estimatedWeeks);
  if (courseId === null || position === null || score === null || estimatedWeeks === null) return null;

  return {
    courseId,
    position,
    title: value.title,
    score,
    reason: value.reason,
    estimatedWeeks,
  };
}

export function parseRouteRecommendation(value: unknown): RouteRecommendation | null {
  if (!isRecord(value) || typeof value.method !== 'string' || typeof value.goal !== 'string' ||
    (typeof value.explanation !== 'string' && value.explanation !== null) ||
    typeof value.refinementStatus !== 'string' || !Array.isArray(value.courses)) return null;

  const courses = value.courses.map(parseCourse);
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

async function readApiMessage(response: Response): Promise<string | null> {
  try {
    const body: unknown = await response.json();
    return isRecord(body) && typeof body.message === 'string' ? body.message : null;
  } catch {
    return null;
  }
}

function errorKind(response: Response): RouteRequestErrorKind {
  if (response.status === 400) return 'validation';
  if (response.status === 401 || response.status === 403) return 'unauthorized';
  if (response.status >= 500) return 'server';
  return 'http';
}

export async function getRouteRecommendation(): Promise<RouteRecommendation> {
  let body: unknown;

  if (isRouteRecommendationMockEnabled) {
    await new Promise(resolve => setTimeout(resolve, MOCK_DELAY_MS));
    body = mockRouteRecommendation;
  } else {
    let response: Response;
    try {
      response = await fetch(`${apiUrl}/routes/recommendation/semantic/v2`, { credentials: 'include' });
    } catch {
      throw new RouteRequestError('network');
    }

    if (!response.ok) throw new RouteRequestError(errorKind(response), await readApiMessage(response));

    try {
      body = await response.json();
    } catch {
      throw new RouteRequestError('invalid-response');
    }
  }

  const recommendation = parseRouteRecommendation(body);
  if (recommendation === null) throw new RouteRequestError('invalid-response');
  return recommendation;
}

export async function saveRoute(request: SaveRouteRequest): Promise<void> {
  let response: Response;
  try {
    response = await fetch(`${apiUrl}/routes`, {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(request),
    });
  } catch {
    throw new RouteRequestError('network');
  }

  if (!response.ok) throw new RouteRequestError(errorKind(response), await readApiMessage(response));
}
