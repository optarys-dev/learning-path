import { apiUrl } from '../../../config/api';
import type { CatalogPageResult } from '../types';

export const catalogPageSize = 12;

export async function getCatalogCourses(page: number, signal?: AbortSignal): Promise<CatalogPageResult> {
  const parameters = new URLSearchParams({ page: String(page), pageSize: String(catalogPageSize) });
  const response = await fetch(`${apiUrl}/courses?${parameters}`, { headers: { Accept: 'application/json' }, signal });

  if (!response.ok) throw new Error(`Unable to load catalog: ${response.status}`);

  return response.json() as Promise<CatalogPageResult>;
}
