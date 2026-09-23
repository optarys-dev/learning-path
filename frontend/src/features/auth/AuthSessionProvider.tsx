import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react';
import { endSession, getCurrentSession, type AuthenticatedUser } from './session';
import { AuthSessionContext } from './authSessionContext';
import { ApiError, subscribeToUnauthenticated } from '../../lib/api';

export function AuthSessionProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthenticatedUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [sessionError, setSessionError] = useState<ApiError | null>(null);

  const refresh = useCallback(async () => {
    try {
      setUser(await getCurrentSession());
      setSessionError(null);
    } catch (error) {
      setSessionError(error instanceof ApiError ? error : new ApiError({ message: 'No fue posible recuperar la sesión.' }));
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    void Promise.resolve().then(refresh);
  }, [refresh]);

  useEffect(() => {
    const unsubscribe = subscribeToUnauthenticated(() => {
      setUser(null);
      setSessionError(null);
    });
    return unsubscribe;
  }, []);

  const markPreferencesSaved = useCallback(() => {
    // The successful preferences PUT confirms this change on the server.
    setUser(current => current ? { ...current, isNewUser: false } : current);
  }, []);

  const logout = useCallback(async () => {
    await endSession();
    setUser(null);
    setSessionError(null);
  }, []);

  const value = useMemo(() => ({ user, isLoading, sessionError, refresh, logout, markPreferencesSaved }), [user, isLoading, sessionError, refresh, logout, markPreferencesSaved]);
  return <AuthSessionContext.Provider value={value}>{children}</AuthSessionContext.Provider>;
}
