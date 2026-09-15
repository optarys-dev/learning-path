import logoB from '../../../assets/brand/logo-b.svg';
import logoN from '../../../assets/brand/logo-n.svg';
import isologoB from '../../../assets/brand/isologo-b.svg';
import isologoN from '../../../assets/brand/isologo-n.svg';

export type BrandLogoBackground = 'dark' | 'light';
export type BrandLogoSize = 'full' | 'compact';

interface BrandLogoProps {
  alt?: string;
  background?: BrandLogoBackground;
  className?: string;
  size?: BrandLogoSize;
}

export function BrandLogo({
  alt = 'DevTalles',
  background = 'dark',
  className,
  size = 'full',
}: BrandLogoProps) {
  const src = size === 'compact'
    ? background === 'dark' ? isologoB : isologoN
    : background === 'dark' ? logoB : logoN;

  return <img className={className} src={src} alt={alt} />;
}
