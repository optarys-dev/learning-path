import { apiUrl } from '../../../config/api';
import type { CatalogCourse, CatalogPageResult } from '../types';
import { parseCatalogKinds, type CatalogKind } from '../model/catalogKind';

export const catalogPageSize = 12;

export async function getCatalogCourses(page: number, signal?: AbortSignal, pageSize = catalogPageSize, search?: string, catalogKind?: CatalogKind): Promise<CatalogPageResult> {
  const parameters = new URLSearchParams({ page: String(page), pageSize: String(pageSize) });
  
  const normalizedSearch = search?.trim();
  if (normalizedSearch) parameters.set('search', normalizedSearch);
  if (catalogKind) parameters.set('catalogKind', catalogKind);
  
  const response = await fetch(`${apiUrl}/courses?${parameters}`, { headers: { Accept: 'application/json' }, signal });

  if (!response.ok) throw new Error(`Unable to load catalog: ${response.status}`);

  const result: CatalogPageResult = await response.json();
  return { ...result, items: result.items.map(course => ({ ...course, catalogKinds: parseCatalogKinds(course.catalogKinds) })) };
}

export async function getAllCatalogCourses(signal?: AbortSignal): Promise<CatalogCourse[]> {
  const firstPage = await getCatalogCourses(1, signal, 100);
  if (firstPage.totalPages <= 1) return firstPage.items;
  const remainingPages = await Promise.all(
    Array.from({ length: firstPage.totalPages - 1 }, (_, index) => getCatalogCourses(index + 2, signal, 100)),
  );
  return [...firstPage.items, ...remainingPages.flatMap(page => page.items)];
}
