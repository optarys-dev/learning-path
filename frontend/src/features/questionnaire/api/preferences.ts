import { requestVoid } from '@/lib/api';

export interface PreferencesDto {
  goal: string;
  interests: string[];
  existingSkills: string[];
  experienceLevel: 'principiante' | 'intermedio' | 'avanzado';
  preferredLanguage: 'es';
  minutesPerWeek: 60;
}

export async function savePreferences(preferences: PreferencesDto): Promise<void> {
  await requestVoid('/users/me/preferences', { method: 'PUT', json: preferences });
}
