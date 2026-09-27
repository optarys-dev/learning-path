export const catalogKinds = ['course', 'free', 'mini-course', 'pro-exclusive', 'legacy', 'in-development'] as const;

export type CatalogKind = typeof catalogKinds[number];

/** Unknown or absent classifications must never imply a paid or Pro entitlement. */
export function parseCatalogKind(value: unknown): CatalogKind | null {
  return catalogKinds.find(kind => kind === value) ?? null;
}

export function parseCatalogKinds(value: unknown): CatalogKind[] {
  return Array.isArray(value) ? catalogKinds.filter(kind => value.includes(kind)) : [];
}

// The generic course category adds no information when a more specific category is known.
// Order describes visual prominence only; it never affects recommendation ranking.
const badgeOrder: CatalogKind[] = ['pro-exclusive', 'in-development', 'legacy', 'free', 'mini-course', 'course'];

export function visibleCatalogKinds(value: unknown): CatalogKind[] {
  const kinds = parseCatalogKinds(value);
  return badgeOrder.filter(kind => kinds.includes(kind) && (kind !== 'course' || kinds.length === 1));
}
