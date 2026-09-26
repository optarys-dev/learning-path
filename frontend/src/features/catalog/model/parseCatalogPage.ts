import { isRecord } from '@/lib/validation';
import { safeExternalUrl } from '@/lib/urls';
import type { CatalogCourse, CatalogPageResult } from '@/features/catalog/types';

function parseCourse(value: unknown): CatalogCourse | null {
  if (!isRecord(value) || typeof value.courseId !== 'number' || !Number.isSafeInteger(value.courseId) || value.courseId <= 0 ||
    typeof value.slug !== 'string' || typeof value.title !== 'string' ||
    (value.level !== null && typeof value.level !== 'string') || typeof value.imageUrl !== 'string' ||
    typeof value.imageAlt !== 'string' || typeof value.courseUrl !== 'string') return null;
  return { courseId: value.courseId, slug: value.slug, title: value.title, level: value.level,
    imageUrl: safeExternalUrl(value.imageUrl) ?? '', imageAlt: value.imageAlt, courseUrl: safeExternalUrl(value.courseUrl) ?? '' };
}

export function parseCatalogPage(value: unknown): CatalogPageResult | null {
  if (!isRecord(value) || !Array.isArray(value.items) ||
    typeof value.page !== 'number' || !Number.isSafeInteger(value.page) || value.page < 1 ||
    typeof value.pageSize !== 'number' || !Number.isSafeInteger(value.pageSize) || value.pageSize < 1 ||
    typeof value.totalCount !== 'number' || !Number.isSafeInteger(value.totalCount) || value.totalCount < 0 ||
    typeof value.totalPages !== 'number' || !Number.isSafeInteger(value.totalPages) || value.totalPages < 0 ||
    typeof value.hasPreviousPage !== 'boolean' || typeof value.hasNextPage !== 'boolean') return null;
  const items = value.items.map(parseCourse);
  if (items.some(item => item === null)) return null;
  return { items: items.filter((item): item is CatalogCourse => item !== null), page: value.page,
    pageSize: value.pageSize, totalCount: value.totalCount, totalPages: value.totalPages,
    hasPreviousPage: value.hasPreviousPage, hasNextPage: value.hasNextPage };
}
