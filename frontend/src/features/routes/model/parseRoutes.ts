import { isRecord } from '@/lib/validation';
import { safeExternalUrl } from '@/lib/urls';
import type { RecommendationCourse, RouteRecommendation, SavedRoute, SavedRouteCourse } from './types';

function normalizeNumber(value: unknown): number | null {
  if (typeof value === 'number') return Number.isFinite(value) ? value : null;
  if (typeof value !== 'string' || value.trim() === '') return null;
  const number = Number(value);
  return Number.isFinite(number) ? number : null;
}

function normalizeCourseId(value: unknown): string | null {
  if (typeof value === 'string') return value.trim() === '' ? null : value;
  return typeof value === 'number' && Number.isSafeInteger(value) && value > 0 ? String(value) : null;
}

function nullableString(value: unknown): string | null | undefined {
  if (value === null) return null;
  return typeof value === 'string' ? value : undefined;
}

function optionalUrl(value: unknown): string | null | undefined {
  if (value === null || value === '') return null;
  return typeof value === 'string' ? safeExternalUrl(value) : undefined;
}

function parseRecommendationCourse(value: unknown): RecommendationCourse | null {
  if (!isRecord(value) || typeof value.title !== 'string' || typeof value.reason !== 'string') return null;
  const courseId = normalizeCourseId(value.courseId);
  const position = normalizeNumber(value.position);
  const score = normalizeNumber(value.score);
  const estimatedWeeks = normalizeNumber(value.estimatedWeeks);
  if (courseId === null || position === null || !Number.isSafeInteger(position) || position < 1 || score === null || estimatedWeeks === null || estimatedWeeks < 0) return null;
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
  const reason = value.reason === undefined ? null : nullableString(value.reason);
  const imageUrl = value.imageUrl === undefined ? null : optionalUrl(value.imageUrl);
  const courseUrl = value.courseUrl === undefined ? null : optionalUrl(value.courseUrl);
  const progressPercentage = value.progressPercentage === undefined ? 0 : normalizeNumber(value.progressPercentage);
  if (courseId === null || position === null || !Number.isSafeInteger(position) || position < 1 || reason === undefined || imageUrl === undefined || courseUrl === undefined || progressPercentage === null || progressPercentage < 0 || progressPercentage > 100) return null;
  return { courseId, position, title: value.title, reason, imageUrl, courseUrl, progressPercentage };
}

export function parseSavedRoute(value: unknown): SavedRoute | null {
  if (!isRecord(value) || typeof value.routeId !== 'string' || value.routeId.trim() === '' ||
    typeof value.goal !== 'string' || typeof value.recommendationMethod !== 'string' ||
    typeof value.createdAt !== 'string' || Number.isNaN(Date.parse(value.createdAt)) ||
    !Array.isArray(value.courses)) return null;
  const explanation = value.explanation === undefined ? null : nullableString(value.explanation);
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
