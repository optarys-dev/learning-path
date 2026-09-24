import logoB from '../../../assets/brand/logo-b.svg';
import logoN from '../../../assets/brand/logo-n.svg';
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
  const darkAsset = size === 'compact' ? isologoB : logoB;
  const lightAsset = size === 'compact' ? isologoN : logoN;

  if (background !== 'auto') {
    return <img className={className} src={background === 'dark' ? darkAsset : lightAsset} alt={alt} />;
  }

  return (
    <span className={`brand-logo ${className ?? ''}`}>
      <img className="brand-logo__on-dark" src={darkAsset} alt={alt} />
      <img className="brand-logo__on-light" src={lightAsset} alt={alt} />
    </span>
  );
}
