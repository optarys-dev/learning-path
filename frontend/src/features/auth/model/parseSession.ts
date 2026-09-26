import { isRecord } from '../../../lib/validation';
import { safeExternalUrl } from '../../../lib/urls';

export interface AuthenticatedUser {
  id: string;
  userId: string;
  username: string;
  displayName: string | null;
  avatar: string | null;
  isNewUser: boolean;
  provider: 'Discord' | 'Google';
  avatarUrl: string | null;
}

export function parseSession(value: unknown): AuthenticatedUser | null {
  if (!isRecord(value) || typeof value.id !== 'string' || !value.id ||
    typeof value.userId !== 'string' || !value.userId || typeof value.username !== 'string' ||
    (value.displayName !== null && typeof value.displayName !== 'string') ||
    (value.avatar !== null && typeof value.avatar !== 'string') || typeof value.isNewUser !== 'boolean' ||
    (value.provider !== 'Discord' && value.provider !== 'Google') ||
    (value.avatarUrl !== null && typeof value.avatarUrl !== 'string')) return null;
  return { id: value.id, userId: value.userId, username: value.username, displayName: value.displayName,
    avatar: value.avatar, isNewUser: value.isNewUser, provider: value.provider, avatarUrl: safeExternalUrl(value.avatarUrl) };
}
