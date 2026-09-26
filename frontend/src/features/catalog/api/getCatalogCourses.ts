import { ApiError, requestJson } from '../../../lib/api';
import { parseCatalogPage } from '../model/parseCatalogPage';
import type { CatalogCourse, CatalogPageResult } from '../types';

export const catalogPageSize = 12;

export async function getCatalogCourses(page: number, signal?: AbortSignal, pageSize = catalogPageSize): Promise<CatalogPageResult> {
  const parameters = new URLSearchParams({ page: String(page), pageSize: String(pageSize) });
  const pageResult = parseCatalogPage(await requestJson<unknown>(`/courses?${parameters}`, { signal, notifyOnUnauthenticated: false }));
  if (!pageResult) throw new ApiError({ message: 'El catálogo devolvió un formato inesperado.', kind: 'invalid-response' });
  return pageResult;
}

export async function getAllCatalogCourses(signal?: AbortSignal): Promise<CatalogCourse[]> {
  const firstPage = await getCatalogCourses(1, signal, 100);
  if (firstPage.totalPages <= 1) return firstPage.items;
  const remainingPages = await Promise.all(
    Array.from({ length: firstPage.totalPages - 1 }, (_, index) => getCatalogCourses(index + 2, signal, 100)),
  );
  return [...firstPage.items, ...remainingPages.flatMap(page => page.items)];
}
