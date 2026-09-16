import type { ComponentPropsWithRef } from 'react';
import { useTranslation } from 'react-i18next';
import './Button.css';

export type ButtonVariant = 'primary' | 'secondary' | 'ghost';

export interface ButtonProps extends ComponentPropsWithRef<'button'> {
  isLoading?: boolean;
  variant?: ButtonVariant;
}

export function Button({
  children,
  className,
  disabled,
  isLoading = false,
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
      {isLoading ? t('layout.loading') : children}
    </button>
  );
}
