import { Compass, Flag, MapPinned, Sparkles, type LucideIcon } from 'lucide-react';

type Milestone = {
  id: 'start' | 'explore' | 'route' | 'checkpoint' | 'goal';
  icon: LucideIcon;
};

const milestones: Milestone[] = [
  { id: 'start', icon: Compass },
  { id: 'explore', icon: MapPinned },
  { id: 'route', icon: Sparkles },
  { id: 'checkpoint', icon: Compass },
  { id: 'goal', icon: Flag },
];

export function PageTrail() {
  return (
    <div className="landing-trail" aria-hidden="true">
      <svg className="landing-trail__line" viewBox="0 0 1200 6000" preserveAspectRatio="none">
        <defs>
          <linearGradient id="landing-trail-gradient" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0" stopColor="currentColor" stopOpacity=".2" />
            <stop offset=".5" stopColor="currentColor" stopOpacity=".88" />
            <stop offset="1" stopColor="currentColor" stopOpacity=".22" />
          </linearGradient>
        </defs>
        <path d="M 1010 430 C 1130 720, 1040 980, 860 1160 S 160 1430, 170 1810 S 1010 2150, 1030 2590 S 190 2960, 190 3400 S 1030 3800, 1010 4280 S 190 4700, 210 5170 S 920 5560, 1000 5860" />
      </svg>
      {milestones.map(({ id, icon: Icon }) => (
        <span className={`landing-trail__marker landing-trail__marker--${id}`} key={id}>
          <Icon size={15} strokeWidth={2} />
        </span>
      ))}
    </div>
  );
}
