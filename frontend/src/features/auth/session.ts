import { ApiError, requestJson, requestVoid } from '../../lib/api';
import { apiUrl } from '../../config/api';

export interface AuthenticatedUser {
  id: string;
  userId: string;
  username: string;
  displayName: string;
  avatar: string | null;
  isNewUser: boolean;
}

export async function getCurrentSession(signal?: AbortSignal): Promise<AuthenticatedUser | null> {
  try {
    return await requestJson<AuthenticatedUser>('/auth/me', { signal, notifyOnUnauthenticated: false });
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
