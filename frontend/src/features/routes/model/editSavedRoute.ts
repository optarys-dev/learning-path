import type { DraftSavedRoute } from './types';
import type { CatalogCourse } from '@/features/catalog/types';

/** A replacement preserves its slot, but never inherits another course's progress or recommendation. */
export function replaceSavedRouteCourse(route: DraftSavedRoute, courseKey: string, alternative: Pick<CatalogCourse, 'courseId' | 'title' | 'imageUrl' | 'courseUrl' | 'catalogKinds'>): DraftSavedRoute {
  const courseId = String(alternative.courseId);
  if (route.courses.some(course => course.uiKey !== courseKey && course.courseId === courseId)) return route;
  return { ...route, courses: route.courses.map(course => course.uiKey === courseKey ? {
    ...course, courseId, title: alternative.title, imageUrl: alternative.imageUrl,
    courseUrl: alternative.courseUrl, catalogKinds: alternative.catalogKinds, progressPercentage: 0, reason: null,
  } : course) };
}
