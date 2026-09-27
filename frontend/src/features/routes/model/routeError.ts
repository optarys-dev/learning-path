import { RouteRequestError, type RouteRequestErrorKind } from './types';

const errorKeys = {
  unauthorized: 'myPath.errors.unauthorized',
  forbidden: 'myPath.errors.forbidden',
  validation: 'myPath.errors.validation',
  'not-found': 'myPath.errors.notFound',
  server: 'myPath.errors.server',
  network: 'myPath.errors.network',
  'invalid-response': 'myPath.errors.invalidResponse',
  http: 'myPath.errors.http',
} as const satisfies Record<RouteRequestErrorKind, string>;

const codeKeys = {
  preferences_required: 'myPath.errors.preferencesRequired',
  embeddings_unavailable: 'myPath.errors.embeddingsUnavailable',
  embedding_service_unavailable: 'myPath.errors.embeddingUnavailable',
  embedding_service_error: 'myPath.errors.embeddingUnavailable',
  invalid_route: 'myPath.errors.invalidRoute',
  course_unavailable: 'myPath.errors.courseUnavailable',
  invalid_progress: 'myPath.errors.invalidProgress',
  route_course_not_found: 'myPath.errors.notFound',
  route_not_found: 'myPath.errors.notFound',
  forbidden: 'myPath.errors.forbidden',
} as const;

/** Server prose is not a UI translation; retain it on the error for diagnostics. */
export function routeErrorDescriptor(error: unknown) {
  const kind = error instanceof RouteRequestError ? error.kind : 'http';
  const translationKey = error instanceof RouteRequestError && error.code && Object.hasOwn(codeKeys, error.code)
    ? codeKeys[error.code as keyof typeof codeKeys] : errorKeys[kind];
  return { kind, translationKey };
}
