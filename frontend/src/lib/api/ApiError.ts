export type ApiValidationErrors = Record<string, string[]>;

export class ApiError extends Error {
  readonly status: number | null;
  readonly code: string | null;
  readonly traceId: string | null;
  readonly validationErrors: ApiValidationErrors;
  readonly kind: 'http' | 'network' | 'invalid-response';

  constructor({ message, status = null, code = null, traceId = null, validationErrors = {}, kind = 'http' }: {
    message: string; status?: number | null; code?: string | null; traceId?: string | null;
    validationErrors?: ApiValidationErrors; kind?: ApiError['kind'];
  }) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code;
    this.traceId = traceId;
    this.validationErrors = validationErrors;
    this.kind = kind;
  }

  get isUnauthenticated() { return this.status === 401 || this.code === 'unauthenticated'; }
  get isForbidden() { return this.status === 403 || this.code === 'forbidden'; }
}

export function isApiError(error: unknown): error is ApiError { return error instanceof ApiError; }
