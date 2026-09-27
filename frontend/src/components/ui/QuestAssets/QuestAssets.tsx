import type { ReactNode } from 'react';
import {
  Check,
  CircleDot,
  Flag,
  Lightbulb,
  Sparkles,

  Star,
  type LucideIcon,
} from 'lucide-react';

import './QuestAssets.css';

export type QuestStickerTone = 'completed' | 'progress' | 'recommended' | 'priority';
export type QuestTabTone = 'violet' | 'lime' | 'paper';

interface ClassNameProps {
  className?: string;
}

interface QuestStickerProps extends ClassNameProps {
  children: ReactNode;
  tone: QuestStickerTone;
}

interface QuestTabProps extends ClassNameProps {
  children: ReactNode;
  tone?: QuestTabTone;
}

interface QuestMetricProps extends ClassNameProps {
  label: string;
  value: ReactNode;
}

interface QuestNoteProps extends ClassNameProps {
  children: ReactNode;
  label?: string;
  tone?: 'lavender' | 'lime' | 'paper';
}

interface QuestProgressProps extends ClassNameProps {
  label: string;
  value: number;
}

const stickerIcons: Record<QuestStickerTone, LucideIcon> = {
  completed: Check,
  progress: CircleDot,
  recommended: Star,
  priority: Flag,
};

function joinClassNames(...names: Array<string | undefined>): string {
  return names.filter(Boolean).join(' ');
}

export function QuestSticker({ children, className, tone }: QuestStickerProps) {
  const Icon = stickerIcons[tone];

  return (
    <span className={joinClassNames('cq-quest-sticker', `cq-quest-sticker--${tone}`, className)}>
      <Icon size={14} aria-hidden="true" />
      <span>{children}</span>
    </span>
  );
}

export function QuestTab({ children, className, tone = 'violet' }: QuestTabProps) {
  return <span className={joinClassNames('cq-quest-tab', `cq-quest-tab--${tone}`, className)}>{children}</span>;
}

export function QuestMetric({ className, label, value }: QuestMetricProps) {
  return (
    <span className={joinClassNames('cq-quest-metric', className)}>
      <span className="cq-quest-metric__value">{value}</span>
      <span className="cq-quest-metric__label">{label}</span>
    </span>
  );
}

export function QuestNote({ children, className, label, tone = 'lavender' }: QuestNoteProps) {
  return (
    <aside className={joinClassNames('cq-quest-note', `cq-quest-note--${tone}`, className)}>
      {label && <span className="cq-quest-note__label"><Lightbulb size={14} aria-hidden="true" />{label}</span>}
      <div>{children}</div>
    </aside>
  );
}

export function QuestProgress({ className, label, value }: QuestProgressProps) {
  const normalized = Math.max(0, Math.min(100, value));

  return (
    <div className={joinClassNames('cq-quest-progress', className)} role="progressbar" aria-label={label}
      aria-valuemin={0} aria-valuemax={100} aria-valuenow={normalized}>
      <span className="cq-quest-progress__track"><span style={{ width: `${normalized}%` }} /></span>
      <span className="cq-quest-progress__value">{normalized}%</span>
    </div>
  );
}

export function QuestDoodle({ className, kind = 'route' }: ClassNameProps & {
  kind?: 'arrow' | 'route' | 'underline';
}) {
  if (kind === 'underline') {
    return (
      <svg className={joinClassNames('cq-quest-doodle', 'cq-quest-doodle--underline', className)}
        viewBox="0 0 240 24" aria-hidden="true" focusable="false">
        <path d="M6 15c29-9 47 8 77 0 36-10 61 5 92-2 20-4 38-8 59-2" />
      </svg>
    );
  }

  if (kind === 'arrow') {
    return (
      <svg className={joinClassNames('cq-quest-doodle', 'cq-quest-doodle--arrow', className)}
        viewBox="0 0 140 76" aria-hidden="true" focusable="false">
        <path d="M8 59c30 9 20-44 72-33 20 4 26 20 38 19" />
        <path d="m108 33 12 12-16 7" />
      </svg>
    );
  }

  return (
    <svg className={joinClassNames('cq-quest-doodle', 'cq-quest-doodle--route', className)}
      viewBox="0 0 240 76" aria-hidden="true" focusable="false">
      <path d="M7 56c31 0 24-35 61-35 38 0 32 33 73 33 36 0 42-39 84-34" />
      <circle cx="7" cy="56" r="4" />
      <circle cx="68" cy="21" r="4" />
      <circle cx="141" cy="54" r="4" />
      <path d="m215 14 9 7-11 4" />
      <path d="m228 6 4 4m0-4-4 4" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
    </svg>
  );
}


interface QuestChecklistItem {
  label: ReactNode;
  state?: 'active' | 'done' | 'pending';
}

interface QuestChecklistProps extends ClassNameProps {
  items: QuestChecklistItem[];
  label: string;
}

interface QuestDividerProps extends ClassNameProps {
  label: string;
}

export function QuestChecklist({ className, items, label }: QuestChecklistProps) {
  return (
    <ol className={joinClassNames('cq-quest-checklist', className)} aria-label={label}>
      {items.map((item, index) => {
        const state = item.state ?? 'pending';
        const Icon = state === 'done' ? Check : state === 'active' ? CircleDot : Flag;

        return (
          <li key={index} className={'cq-quest-checklist__item cq-quest-checklist__item--' + state}>
            <Icon size={15} aria-hidden="true" />
            <span>{item.label}</span>
          </li>
        );
      })}
    </ol>
  );
}

export function QuestDivider({ className, label }: QuestDividerProps) {
  return (
    <div className={joinClassNames('cq-quest-divider', className)} role="separator" aria-label={label}>
      <span aria-hidden="true" />
      <Sparkles size={16} aria-hidden="true" />
      <strong>{label}</strong>
      <span aria-hidden="true" />
    </div>
  );
}

