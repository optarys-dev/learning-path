import type { Course } from './course.types';

export async function getCourses(): Promise<Course[]> {
  const response = await fetch('/courses');

  if (!response.ok) {
    throw new Error(`Error al obtener cursos: ${response.status}`);
  }

  return response.json();
}
