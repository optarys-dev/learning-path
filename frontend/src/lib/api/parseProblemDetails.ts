import { ApiError, type ApiValidationErrors } from './ApiError';
import { isRecord } from '@/lib/validation';

function readValidationErrors(value: unknown): ApiValidationErrors {
  if (!isRecord(value)) return {};
  return Object.fromEntries(Object.entries(value).flatMap(([field, messages]) => {
    if (!Array.isArray(messages)) return [];
    const validMessages = messages.filter((message): message is string => typeof message === 'string');
    return validMessages.length ? [[field, validMessages]] : [];
  }));
}

export async function parseApiError(response: Response): Promise<ApiError> {
  let body: unknown = null;
  try { body = await response.json(); } catch (error) {
    if (error instanceof Error && error.name === 'AbortError') throw error;
    // Gateways sometimes return empty or HTML bodies.
  }

  if (isRecord(body)) {
    const detail = typeof body.detail === 'string' ? body.detail : typeof body.message === 'string' ? body.message : null;
    const title = typeof body.title === 'string' ? body.title : null;
    return new ApiError({
      message: detail ?? title ?? `La solicitud falló con estado ${response.status}.`,
      status: response.status,
      code: typeof body.code === 'string' ? body.code : typeof body.error === 'string' ? body.error : null,
      traceId: typeof body.traceId === 'string' ? body.traceId : null,
      validationErrors: readValidationErrors(body.errors),
    });
  }
  return new ApiError({ message: `La solicitud falló con estado ${response.status}.`, status: response.status });
}
