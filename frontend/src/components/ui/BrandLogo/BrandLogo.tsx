import codeQuestLogo from '@/assets/brand/codequest-logo.svg';
import isologoB from '@/assets/brand/isologo-b.svg';
import isologoN from '@/assets/brand/isologo-n.svg';
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
  if (size === 'full') {
    return (
      <span className={`brand-logo brand-logo--full ${className ?? ''}`}>
        <img src={codeQuestLogo} alt={alt} />
      </span>
    );
  }

  const darkAsset = isologoB;
  const lightAsset = isologoN;

  if (background !== 'auto') {
    return <img className={className ?? ''} src={background === 'dark' ? darkAsset : lightAsset} alt={alt} />;
  }

  return (
    <span className={`brand-logo brand-logo--${size} ${className ?? ''}`}>
      <img className="brand-logo__on-dark" src={darkAsset} alt={alt} />
      <img className="brand-logo__on-light" src={lightAsset} alt={alt} />
    </span>
  );
}
