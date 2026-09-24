import logoOnDark from '../../../assets/brand/codequest-logo-dark.png';
import logoOnLight from '../../../assets/brand/codequest-logo-light.png';
import isologoB from '../../../assets/brand/isologo-b.svg';
import isologoN from '../../../assets/brand/isologo-n.svg';
import './BrandLogo.css';

export type BrandLogoBackground = 'dark' | 'light';
export type BrandLogoSize = 'full' | 'compact';

interface BrandLogoProps {
  alt?: string;
  background?: BrandLogoBackground | 'auto';
  className?: string;
  size?: BrandLogoSize;
}

export function BrandLogo({
  alt = 'Code Quest 2026',
  background = 'auto',
  className,
  size = 'full',
}: BrandLogoProps) {
  const darkAsset = size === 'compact' ? isologoB : logoOnDark;
  const lightAsset = size === 'compact' ? isologoN : logoOnLight;

  if (background !== 'auto') {
    return <img className={`${className ?? ''}${size === 'full' ? ' brand-logo__image' : ''}`} src={background === 'dark' ? darkAsset : lightAsset} alt={alt} />;
  }

  return (
    <span className={`brand-logo brand-logo--${size} ${className ?? ''}`}>
      <img className="brand-logo__on-dark" src={darkAsset} alt={alt} />
      <img className="brand-logo__on-light" src={lightAsset} alt={alt} />
    </span>
  );
}
