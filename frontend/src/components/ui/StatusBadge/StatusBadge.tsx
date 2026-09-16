import type { ReactNode } from 'react';

import './StatusBadge.css';

export type StatusTone = 'success' | 'warning' | 'error' | 'info';

interface StatusBadgeProps {
  children: ReactNode;
  tone: StatusTone;
}

export function StatusBadge({ children, tone }: StatusBadgeProps) {
  return <span className={`cq-status-badge cq-status-badge--${tone}`}>{children}</span>;
}
