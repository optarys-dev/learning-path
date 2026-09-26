import { apiUrl } from '../../../config/api';
import { ApiError, requestJson, requestVoid } from '../../../lib/api';
import { parseSession, type AuthenticatedUser } from '../model/parseSession';
import { isRecord } from '../../../lib/validation';
export type { AuthenticatedUser } from '../model/parseSession';

export async function getCurrentSession(signal?: AbortSignal): Promise<AuthenticatedUser | null> {
  try {
    const session = parseSession(await requestJson<unknown>('/auth/me', { signal, notifyOnUnauthenticated: false }));
    if (!session) throw new ApiError({ message: 'El servicio devolvió una sesión inválida.', kind: 'invalid-response' });
    return session;
  } catch (error) {
    if (error instanceof ApiError && error.isUnauthenticated) return null;
    throw error;
  }
}

export function endSession(): Promise<void> {
  return requestVoid('/auth/logout', { method: 'POST', notifyOnUnauthenticated: false });
}

export function startDiscordLogin() {
  const loginUrl = new URL(`${apiUrl}/auth/discord`, window.location.origin);
  const returnUrl = import.meta.env.VITE_DISCORD_RETURN_URL?.trim() || '/login/callback';

  loginUrl.searchParams.set('returnUrl', returnUrl);

  window.location.assign(loginUrl.toString());
}

export async function getLoginProviders(signal?: AbortSignal): Promise<{ google: boolean }> {
  const providers = await requestJson<unknown>('/auth/providers', { signal, notifyOnUnauthenticated: false });
  if (!isRecord(providers) || typeof providers.google !== 'boolean') {
    throw new ApiError({ message: 'El servicio devolvió proveedores inválidos.', kind: 'invalid-response' });
  }
  return { google: providers.google };
}

export function startGoogleLogin() {
  const loginUrl = new URL(`${apiUrl}/auth/google`, window.location.origin);
  loginUrl.searchParams.set('returnUrl', import.meta.env.VITE_GOOGLE_RETURN_URL?.trim()
    || import.meta.env.VITE_DISCORD_RETURN_URL?.trim() || '/login/callback');
  window.location.assign(loginUrl.toString());
}
