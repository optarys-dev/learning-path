import type { ComponentPropsWithRef } from 'react';
import { useTranslation } from 'react-i18next';
import './Button.css';

export type ButtonVariant = 'primary' | 'secondary' | 'ghost';

export interface ButtonProps extends ComponentPropsWithRef<'button'> {
  isLoading?: boolean;
  loadingLabel?: string;
  variant?: ButtonVariant;
}

export function Button({
  children,
  className,
  disabled,
  isLoading = false,
  loadingLabel,
  type,
  variant = 'primary',
  ...buttonProps
}: ButtonProps) {
  const { t } = useTranslation();
  const buttonClassName = ['cq-button', `cq-button--${variant}`, className]
    .filter(Boolean)
    .join(' ');

  return (
    <button
      {...buttonProps}
      aria-busy={isLoading || undefined}
      className={buttonClassName}
      disabled={disabled || isLoading}
      type={type ?? 'button'}
    >
      {isLoading ? (loadingLabel ?? t('layout.loading')) : children}
    </button>
  );
}
