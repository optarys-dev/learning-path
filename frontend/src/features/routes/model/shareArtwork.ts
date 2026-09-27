import { es } from '@/i18n/locales/es';
import { en } from '@/i18n/locales/en';

export type ShareFormat = 'landscape' | 'square' | 'portrait';

const formatSpecs = {
  landscape: { width: 1200, minHeight: 630, columns: 2, rowHeight: 155, chromeHeight: 315, gap: 14 },
  square: { width: 1080, minHeight: 1080, columns: 2, rowHeight: 220, chromeHeight: 380, gap: 18 },
  portrait: { width: 1080, minHeight: 1920, columns: 1, rowHeight: 195, chromeHeight: 640, gap: 18 },
} as const;

/** Keep every course legible in a single image, extending its height for long paths. */
export function shareArtworkSize(format: ShareFormat, courseCount: number) {
  const spec = formatSpecs[format];
  const rows = Math.max(1, Math.ceil(courseCount / spec.columns));
  return {
    width: spec.width,
    height: Math.max(spec.minHeight, spec.chromeHeight + rows * spec.rowHeight + (rows - 1) * spec.gap),
    rows,
  };
}

/** Translate recognized questionnaire goals; custom path names remain the user's text. */
export function shareArtworkGoal(goal: string, language: string): string {
  const normalized = goal.trim().toLocaleLowerCase();
  const target = language === 'en' ? en : es;
  for (const key of Object.keys(es.questionnaire.outcomes) as Array<keyof typeof es.questionnaire.outcomes>) {
    if ([es.questionnaire.outcomes[key], en.questionnaire.outcomes[key]]
      .some(value => value.toLocaleLowerCase() === normalized)) return target.questionnaire.outcomes[key];
  }
  return goal;
}
