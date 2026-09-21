import { apiUrl } from '../../config/api';

export interface PreferencesDto {
  goal: string;
  interests: string[];
  existingSkills: string[];
  experienceLevel: 'principiante' | 'intermedio' | 'avanzado';
  preferredLanguage: 'es';
  minutesPerWeek: 60;
}

export type PreferencesErrorKind = 'validation' | 'unauthorized' | 'server' | 'http' | 'network';

export class PreferencesError extends Error {
  readonly kind: PreferencesErrorKind;

  constructor(kind: PreferencesErrorKind) {
    super(`Unable to save preferences: ${kind}`);
    this.name = 'PreferencesError';
    this.kind = kind;
  }
}

export async function savePreferences(preferences: PreferencesDto): Promise<void> {
  let response: Response;
  try {
    response = await fetch(`${apiUrl}/users/me/preferences`, {
      method: 'PUT',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(preferences),
    });
  } catch {
    throw new PreferencesError('network');
  }

  if (response.status === 400) throw new PreferencesError('validation');
  if (response.status === 401) throw new PreferencesError('unauthorized');
  if (response.status >= 500) throw new PreferencesError('server');
  if (!response.ok) throw new PreferencesError('http');
  // Saving does not depend on the API returning a JSON body.
}
