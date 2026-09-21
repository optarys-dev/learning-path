import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react';
import { getCurrentSession, type AuthenticatedUser } from './session';
import { AuthSessionContext } from './authSessionContext';

export function AuthSessionProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthenticatedUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const refresh = useCallback(async () => {
    try {
      setUser(await getCurrentSession());
    } catch {
      setUser(null);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    void Promise.resolve().then(refresh);
  }, [refresh]);

  const markPreferencesSaved = useCallback(() => {
    // The successful preferences PUT confirms this change on the server.
    setUser(current => current ? { ...current, isNewUser: false } : current);
  }, []);

  const value = useMemo(() => ({ user, isLoading, refresh, markPreferencesSaved }), [user, isLoading, refresh, markPreferencesSaved]);
  return <AuthSessionContext.Provider value={value}>{children}</AuthSessionContext.Provider>;
}
