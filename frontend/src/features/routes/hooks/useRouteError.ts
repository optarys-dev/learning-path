import { useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { useAuthSession } from '@/features/auth/hooks/useAuthSession';
import { routeErrorDescriptor } from '@/features/routes/model/routeError';

export function useRouteError() {
  const { t } = useTranslation();
  const { refresh } = useAuthSession();
  return useCallback((error: unknown) => {
    const { kind, translationKey } = routeErrorDescriptor(error);
    if (kind === 'unauthorized') void refresh();
    return { kind, message: t(translationKey) };
  }, [refresh, t]);
}
