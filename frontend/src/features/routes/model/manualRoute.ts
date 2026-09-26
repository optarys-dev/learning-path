import type { CatalogCourse } from '@/features/catalog/types';
import { manualRecommendationMethod, routeLimits } from './constants';
import type { CreateRouteDto } from './types';

export function toggleSelectedCourse(selected: CatalogCourse[], course: CatalogCourse): CatalogCourse[] {
  if (selected.some(item => item.courseId === course.courseId)) {
    return selected.filter(item => item.courseId !== course.courseId);
  }
  return selected.length < routeLimits.courses ? [...selected, course] : selected;
}

export function moveSelectedCourse(selected: CatalogCourse[], index: number, direction: -1 | 1): CatalogCourse[] {
  const target = index + direction;
  if (index < 0 || index >= selected.length || target < 0 || target >= selected.length) return selected;
  const next = [...selected];
  [next[index], next[target]] = [next[target], next[index]];
  return next;
}

export function buildManualRouteRequest(goal: string, explanation: string, selected: CatalogCourse[]): CreateRouteDto {
  return {
    goal: goal.trim(),
    recommendationMethod: manualRecommendationMethod,
    explanation: explanation.trim() || null,
    courses: selected.map(course => ({ courseId: String(course.courseId), reason: null })),
  };
}
