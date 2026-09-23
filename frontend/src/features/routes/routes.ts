import type { NumericApiValue, RecommendationCourse, RouteRecommendation, SaveRouteRequest } from './types';
import { ApiError, requestJson, requestVoid } from '../../lib/api';

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

export async function getRouteRecommendation(): Promise<RouteRecommendation> {
  const body = await requestJson<unknown>('/routes/recommendation/semantic/v2');
  const recommendation = parseRecommendation(body);
  if (recommendation === null) throw new ApiError({ message: 'El servicio devolvió una respuesta inválida.', kind: 'invalid-response' });
  return recommendation;
}

export async function saveRoute(request: SaveRouteRequest): Promise<void> {
  await requestVoid('/routes', { method: 'POST', json: request });
}
