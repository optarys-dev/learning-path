import { ListFilter } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { catalogKinds, parseCatalogKind, type CatalogKind } from '@/features/catalog/model/catalogKind';

export function CatalogKindFilter({ value, onChange }: { value?: CatalogKind; onChange: (kind?: CatalogKind) => void }) {
  const { t } = useTranslation();
  return <label className="catalog-kind-filter">
    <ListFilter size={18} aria-hidden="true" />
    <select aria-label={t('catalog.categoryFilterLabel')} value={value ?? ''} onChange={event => onChange(parseCatalogKind(event.target.value) ?? undefined)}>
      <option value="">{t('catalog.allCategories')}</option>
      {catalogKinds.map(kind => <option key={kind} value={kind}>{t(`courseBadges.${kind}`)}</option>)}
    </select>
  </label>;
}
