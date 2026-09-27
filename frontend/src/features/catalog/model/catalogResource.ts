// +DevTalles is a subscription library, rather than a standalone course.
// Identify the verified resource URL; never infer access from a course title.
const subscriptionLibraryUrl = 'https://cursos.devtalles.com/courses/mas-DevTalles';
export const subscriptionPortalUrl = 'https://cursos.devtalles.com/enrollments?q=%2Bdevtalles&status=all';

export function isSubscriptionLibrary(courseUrl: string): boolean {
  try {
    const url = new URL(courseUrl);
    return `${url.origin}${url.pathname.replace(/\/$/, '')}` === subscriptionLibraryUrl;
  } catch {
    return false;
  }
}
