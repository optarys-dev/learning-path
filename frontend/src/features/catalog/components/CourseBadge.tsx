import { BookOpen, Crown, Gift, Hammer, History, Zap } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { parseCatalogKind, visibleCatalogKinds, type CatalogKind } from '../model/catalogKind';
import './CourseBadge.css';

const icons = {
  course: BookOpen,
  free: Gift,
  'mini-course': Zap,
  'pro-exclusive': Crown,
  legacy: History,
  'in-development': Hammer,
} satisfies Record<CatalogKind, typeof BookOpen>;

export function CourseBadge({ kind }: { kind?: CatalogKind | null }) {
  const { t } = useTranslation();
  const classification = parseCatalogKind(kind);
  const Icon = classification ? icons[classification] : BookOpen;

  return <span className={`course-badge course-badge--${classification ?? 'unknown'}`}>
    <Icon size={13} aria-hidden="true" />
    <span>{classification ? t(`courseBadges.${classification}`) : 'DevTalles'}</span>
  </span>;
}

export function CourseBadges({ kinds }: { kinds?: CatalogKind[] }) {
  const visible = visibleCatalogKinds(kinds);
  return <span className="course-badges">
    {visible.length ? visible.map(kind => <CourseBadge key={kind} kind={kind} />) : <CourseBadge />}
  </span>;
}
