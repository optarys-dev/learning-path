import lunarBeacon from '../../../assets/codequest/scenes/11_baliza_lunar_futurista_brillante.png';

type AccentKind = 'beacon';

const accentAssets: Record<AccentKind, string> = {
  beacon: lunarBeacon,
};

type SectionAccentProps = {
  kind: AccentKind;
};

export function SectionAccent({ kind }: SectionAccentProps) {
  return (
    <div className={`section-accent section-accent--${kind}`} aria-hidden="true">
      <img src={accentAssets[kind]} alt="" loading="lazy" decoding="async" />
    </div>
  );
}
