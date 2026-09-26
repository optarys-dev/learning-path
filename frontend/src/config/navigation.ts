/** Public application URLs. Keep API endpoints in their owning features. */
export const appRoutes = {
  home: '/', login: '/login', loginCallback: '/login/callback', catalog: '/catalog',
  createRoute: '/create-route', manualRoute: '/create-route/manual',
  proposal: '/create-route/proposal', learningProfile: '/learning-profile', savedRoutes: '/my-path',
  savedRoutePattern: '/my-path/:routeId',
  savedRoute: (routeId: string) => '/my-path/' + encodeURIComponent(routeId),
} as const;
