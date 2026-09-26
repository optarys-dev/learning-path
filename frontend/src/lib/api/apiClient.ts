import { apiUrl } from '../../config/api';
import { ApiError } from './ApiError';
import { parseApiError } from './parseProblemDetails';

type ApiRequestOptions = Omit<RequestInit, 'body'> & { json?: unknown; notifyOnUnauthenticated?: boolean; };
type UnauthenticatedListener = (error: ApiError) => void;
const unauthenticatedListeners = new Set<UnauthenticatedListener>();

export function subscribeToUnauthenticated(listener: UnauthenticatedListener) {
  unauthenticatedListeners.add(listener);
  return () => { unauthenticatedListeners.delete(listener); };
}

export function isAbortError(error: unknown) { return error instanceof Error && error.name === 'AbortError'; }

async function request(path: string, options: ApiRequestOptions = {}): Promise<Response> {
  const { json, notifyOnUnauthenticated = true, headers, ...requestOptions } = options;
  const requestHeaders = new Headers(headers);
  requestHeaders.set('Accept', 'application/json, application/problem+json');
  if (json !== undefined) requestHeaders.set('Content-Type', 'application/json');

  let response: Response;
  try {
    response = await fetch(`${apiUrl}${path}`, {
      credentials: 'include', ...requestOptions, headers: requestHeaders,
      body: json === undefined ? undefined : JSON.stringify(json),
    });
  } catch (error) {
    if (isAbortError(error)) throw error;
    throw new ApiError({ message: 'No fue posible conectar con el servicio.', kind: 'network' });
  }
  if (response.ok) return response;

  const error = await parseApiError(response);
  if (notifyOnUnauthenticated && error.isUnauthenticated) unauthenticatedListeners.forEach(listener => listener(error));
  throw error;
}

export async function requestJson<T>(path: string, options?: ApiRequestOptions): Promise<T> {
  const response = await request(path, options);
  try { return await response.json() as T; }
  catch (error) {
    if (isAbortError(error)) throw error;
    throw new ApiError({ message: 'El servicio devolvió una respuesta inválida.', kind: 'invalid-response' });
  }
}

export async function requestVoid(path: string, options?: ApiRequestOptions): Promise<void> { await request(path, options); }
