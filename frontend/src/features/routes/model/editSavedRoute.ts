import type { DraftSavedRoute } from './types';

/** A replacement preserves its slot, but never inherits another course's progress or recommendation. */
export function replaceSavedRouteCourse(route: DraftSavedRoute, courseKey: string, alternative: {
  courseId: number; title: string; imageUrl: string; courseUrl: string;
}): DraftSavedRoute {
  const courseId = String(alternative.courseId);
  if (route.courses.some(course => course.uiKey !== courseKey && course.courseId === courseId)) return route;
  return { ...route, courses: route.courses.map(course => course.uiKey === courseKey ? {
    ...course, courseId, title: alternative.title, imageUrl: alternative.imageUrl,
    courseUrl: alternative.courseUrl, progressPercentage: 0, reason: null,
  } : course) };
}
