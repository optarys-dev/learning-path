import type { CourseNote, CoursePriority, RouteCourseLocalState, SavedRoute } from './types';
import { isRecord } from '../../../lib/validation';

const storageKey = 'learning-path:course-state';
const emptyState = (): RouteCourseLocalState => ({ notes: {}, priorities: {} });
const courseKey = (routeId: string, courseId: string) => `${routeId}:${courseId}`;

export function readRouteCourseLocalState(): RouteCourseLocalState {
  if (typeof window === 'undefined') return emptyState();
  try {
    const raw = window.localStorage.getItem(storageKey);
    if (!raw) return emptyState();
    const parsed: unknown = JSON.parse(raw);
    if (!isRecord(parsed)) return emptyState();
    const notes: Record<string, CourseNote> = {};
    const priorities: Record<string, CoursePriority> = {};
    if (isRecord(parsed.notes)) for (const [key, note] of Object.entries(parsed.notes)) {
      if (isRecord(note) && typeof note.content === 'string' && typeof note.updatedAt === 'string' &&
        Number.isFinite(Date.parse(note.updatedAt))) notes[key] = { content: note.content, updatedAt: note.updatedAt };
    }
    if (isRecord(parsed.priorities)) for (const [key, priority] of Object.entries(parsed.priorities)) {
      if (priority === 'normal' || priority === 'medium' || priority === 'high') priorities[key] = priority;
    }
    return {
      notes,
      priorities,
    };
  } catch { return emptyState(); }
}

function write(state: RouteCourseLocalState) {
  if (typeof window !== 'undefined') {
    // Callers display the failure and keep the editor open; never claim a failed write succeeded.
    window.localStorage.setItem(storageKey, JSON.stringify(state));
    window.dispatchEvent(new Event('learning-path:course-state-change'));
  }
}

export function saveCourseNote(routeId: string, courseId: string, content: string): RouteCourseLocalState {
  const state = readRouteCourseLocalState();
  const key = courseKey(routeId, courseId);
  const trimmed = content.trim();
  if (trimmed) state.notes[key] = { content: trimmed, updatedAt: new Date().toISOString() };
  else delete state.notes[key];
  write(state);
  return state;
}

export function removeCourseNote(routeId: string, courseId: string): RouteCourseLocalState {
  const state = readRouteCourseLocalState();
  delete state.notes[courseKey(routeId, courseId)];
  write(state);
  return state;
}

export function setCoursePriority(routeId: string, courseId: string, priority: CoursePriority): RouteCourseLocalState {
  const state = readRouteCourseLocalState();
  state.priorities[courseKey(routeId, courseId)] = priority;
  write(state);
  return state;
}

export function getCourseNote(state: RouteCourseLocalState, routeId: string, courseId: string): CourseNote | undefined {
  return state.notes[courseKey(routeId, courseId)];
}

export function getCoursePriority(state: RouteCourseLocalState, routeId: string, courseId: string): CoursePriority {
  return state.priorities[courseKey(routeId, courseId)] ?? 'normal';
}

export function routeStats(route: SavedRoute, localState: RouteCourseLocalState) {
  const total = route.courses.length;
  const completed = route.courses.filter(course => course.progressPercentage === 100).length;
  const notStarted = total - completed;
  const notes = route.courses.filter(course => getCourseNote(localState, route.routeId, course.courseId)).length;
  const priorities = route.courses.filter(course => getCoursePriority(localState, route.routeId, course.courseId) !== 'normal').length;
  return { total, completed, notStarted, notes, priorities, percentage: total ? (completed / total) * 100 : 0 };
}
