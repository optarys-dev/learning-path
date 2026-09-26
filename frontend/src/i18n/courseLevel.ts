type CourseLevelKey = 'course.levels.beginner' | 'course.levels.intermediate' | 'course.levels.advanced';
const levelKeys: Record<string, CourseLevelKey> = {
  beginner: 'course.levels.beginner', básico: 'course.levels.beginner', basico: 'course.levels.beginner', principiante: 'course.levels.beginner',
  intermediate: 'course.levels.intermediate', intermedio: 'course.levels.intermediate',
  advanced: 'course.levels.advanced', avanzado: 'course.levels.advanced',
};

/** Unknown catalog values remain visible rather than being assigned an invented level. */
export function courseLevelTranslationKey(level: string): CourseLevelKey | null {
  return levelKeys[level.trim().toLocaleLowerCase()] ?? null;
}
