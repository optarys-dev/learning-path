import { motion, useReducedMotion } from 'framer-motion';
import type { ComponentPropsWithoutRef } from 'react';

type DeviIllustrationProps = ComponentPropsWithoutRef<'img'> & {
  variant: 'hero' | 'route' | 'closing';
};

export function DeviIllustration({ variant, className, ...imageProps }: DeviIllustrationProps) {
  const reduceMotion = useReducedMotion();
  return (
    <motion.div
      className={`devi-illustration devi-illustration--${variant} ${className ?? ''}`}
      initial={reduceMotion ? false : { opacity: 0, y: 16 }}
      animate={reduceMotion ? undefined : { opacity: 1, y: 0 }}
      transition={{ duration: 0.45, ease: 'easeOut' }}
      whileHover={reduceMotion ? undefined : { scale: 1.015, rotate: 0.6 }}
    >
      <img {...imageProps} />
    </motion.div>
  );
}
