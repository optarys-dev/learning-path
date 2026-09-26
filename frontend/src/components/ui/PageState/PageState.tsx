import type { ReactNode } from 'react';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui/Button/Button';
import './PageState.css';

type PageStateProps = {
  title: string;
  description?: string;
  children?: ReactNode;
} & ({ kind: 'error'; onRetry: () => void } | { kind: 'loading' | 'empty'; onRetry?: never });

export function PageState({ kind, title, description, children, onRetry }: PageStateProps) {
  const { t } = useTranslation();
  return (
    <section className="page-state" data-state={kind} aria-busy={kind === 'loading'}>
      <div role={kind === 'error' ? 'alert' : 'status'}>
        <span className="page-state__symbol" aria-hidden="true">{kind === 'error' ? '!' : kind === 'loading' ? '…' : '◇'}</span>
        <h2>{title}</h2>
        {description && <p>{description}</p>}
      </div>
      {kind === 'error' && <Button onClick={onRetry}>{t('layout.retry')}</Button>}
      {children}
    </section>
  );
}
