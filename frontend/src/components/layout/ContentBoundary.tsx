import { Component, type ReactNode } from 'react';
import { useTranslation } from 'react-i18next';
import { PageState } from '../ui/PageState/PageState';

class ErrorBoundary extends Component<{ children: ReactNode; fallback: (reset: () => void) => ReactNode }, { failed: boolean }> {
  state = { failed: false };
  static getDerivedStateFromError() { return { failed: true }; }
  render() {
    return this.state.failed
      ? this.props.fallback(() => this.setState({ failed: false }))
      : this.props.children;
  }
}

export function ContentBoundary({ children }: { children: ReactNode }) {
  const { t } = useTranslation();
  return <ErrorBoundary fallback={reset => (
    <PageState kind="error" title={t('layout.error')} description={t('layout.errorDescription')} onRetry={reset} />
  )}>{children}</ErrorBoundary>;
}
