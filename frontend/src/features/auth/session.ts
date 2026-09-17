import { apiUrl } from '../../config/api';

export interface AuthenticatedUser {
  id: string;
  userId: string;
  username: string;
  displayName: string;
  avatar: string | null;
}

export async function getCurrentSession(signal?: AbortSignal): Promise<AuthenticatedUser | null> {
  const response = await fetch(`${apiUrl}/auth/me`, {
    credentials: 'include',
    signal,
  });

  if (response.status === 401) return null;
  if (!response.ok) throw new Error('Unable to load the current session.');

  return response.json() as Promise<AuthenticatedUser>;
}

export function startDiscordLogin() {
  const loginUrl = new URL(`${apiUrl}/auth/discord`, window.location.origin);
  const returnUrl = import.meta.env.VITE_DISCORD_RETURN_URL?.trim() || '/login/callback';

  loginUrl.searchParams.set('returnUrl', returnUrl);

  window.location.assign(loginUrl.toString());
}
