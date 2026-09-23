import { apiUrl } from '../../../config/api';
import type { NumericApiValue, RecommendationCourse, RouteRecommendation, SaveRouteRequest } from '../model/types';
import { RouteRequestError, type RouteRequestErrorKind } from '../model/types';

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isNumericApiValue(value: unknown): value is NumericApiValue {
  return typeof value === 'string' || (typeof value === 'number' && Number.isFinite(value));
}

function parseCourse(value: unknown): RecommendationCourse | null {
  if (!isRecord(value) || typeof value.courseId !== 'string' || typeof value.title !== 'string' ||
    typeof value.reason !== 'string' || !isNumericApiValue(value.position) ||
    !isNumericApiValue(value.score) || !isNumericApiValue(value.estimatedWeeks)) return null;

  return {
    courseId: value.courseId,
    position: value.position,
    title: value.title,
    score: value.score,
    reason: value.reason,
    estimatedWeeks: value.estimatedWeeks,
  };
}

function parseRecommendation(value: unknown): RouteRecommendation | null {
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
  let response: Response;
  try {
    response = await fetch(`${apiUrl}/routes/recommendation/semantic/v2`, { credentials: 'include' });
  } catch {
    throw new RouteRequestError('network');
  }

  if (!response.ok) throw new RouteRequestError(errorKind(response), await readApiMessage(response));

  let body: unknown;
  try {
    body = await response.json();
  } catch {
    throw new RouteRequestError('invalid-response');
  }
  const recommendation = parseRecommendation(body);
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
