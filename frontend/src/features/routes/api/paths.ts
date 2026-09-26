const collection = '/routes';
const detail = (routeId: string) => collection + '/' + encodeURIComponent(routeId);

export const routeApiPaths = {
  collection,
  detail,
  recommendation: collection + '/recommendation/semantic/v2',
  progress: (routeId: string, courseId: string) => detail(routeId) + '/courses/' + encodeURIComponent(courseId) + '/progress',
} as const;
