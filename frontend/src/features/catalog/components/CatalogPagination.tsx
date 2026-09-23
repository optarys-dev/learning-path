import { ChevronLeft, ChevronRight } from 'lucide-react';
import { useTranslation } from 'react-i18next';

interface CatalogPaginationProps {
  page: number;
  pageCount: number;
  hasPreviousPage: boolean;
  hasNextPage: boolean;
  onPageChange: (page: number) => void;
}

export function CatalogPagination({ page, pageCount, hasPreviousPage, hasNextPage, onPageChange }: CatalogPaginationProps) {
  const { t } = useTranslation();
  if (pageCount < 2) return null;

  return <nav className="catalog-pagination" aria-label={t('catalog.paginationLabel')}>
    <button type="button" className="cq-button cq-button--secondary" disabled={!hasPreviousPage} onClick={() => onPageChange(page - 1)}><ChevronLeft size={18} aria-hidden="true" />{t('catalog.previousPage')}</button>
    <span aria-live="polite">{t('catalog.pageStatus', { page, total: pageCount })}</span>
    <button type="button" className="cq-button cq-button--secondary" disabled={!hasNextPage} onClick={() => onPageChange(page + 1)}>{t('catalog.nextPage')}<ChevronRight size={18} aria-hidden="true" /></button>
  </nav>;
}
