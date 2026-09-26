import lunarBeacon from '../../../assets/codequest/scenes/11_baliza_lunar_futurista_brillante.png';
import { Bookmark, Check, Highlighter, NotebookPen, Paperclip, Pencil, type LucideIcon } from 'lucide-react';

type AccentKind = 'beacon' | 'note' | 'bookmark' | 'tools';

const accentAssets = {
  beacon: lunarBeacon,
};

type SectionAccentProps = {
  kind: AccentKind;
};

export function SectionAccent({ kind }: SectionAccentProps) {
  if (kind !== 'beacon') {
    const Icon: LucideIcon = kind === 'bookmark' ? Bookmark : kind === 'note' ? NotebookPen : Pencil;
    return <div className={`study-accent study-accent--${kind}`} aria-hidden="true">
      {kind === 'note' && <Paperclip className="study-accent__clip" size={30} />}
      <Icon size={32} strokeWidth={1.5} />
      {kind === 'note' && <><span /><span /><Check className="study-accent__check" size={20} /></>}
      {kind === 'tools' && <><Highlighter size={30} strokeWidth={1.5} /><Paperclip size={30} strokeWidth={1.5} /></>}
    </div>;
  }
  return (
    <div className={`section-accent section-accent--${kind}`} aria-hidden="true">
      <img src={accentAssets[kind]} alt="" loading="lazy" decoding="async" />
    </div>
  );
}
