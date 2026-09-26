export function moveCourseTo<T extends { uiKey: string }>(courses: T[], sourceKey: string, targetKey: string): T[] {
  const source = courses.findIndex(course => course.uiKey === sourceKey);
  const target = courses.findIndex(course => course.uiKey === targetKey);
  if (source < 0 || target < 0 || source === target) return courses;
  const next = [...courses];
  const [moved] = next.splice(source, 1);
  next.splice(target, 0, moved);
  return next;
}
