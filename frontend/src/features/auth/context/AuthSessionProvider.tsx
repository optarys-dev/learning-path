import { useCallback, useEffect, useMemo, useRef, useState, type ReactNode } from 'react';
import { endSession, getCurrentSession, type AuthenticatedUser } from '../api/session';
import { AuthSessionContext } from './authSessionContext';
import { ApiError, subscribeToUnauthenticated } from '../../../lib/api';
import { createLatestRequest } from '../../../lib/api/latestRequest';

export function AuthSessionProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthenticatedUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [sessionError, setSessionError] = useState<ApiError | null>(null);
  const requests = useRef(createLatestRequest());

  const refresh = useCallback(async () => {
    const request = requests.current.start();
    try {
      const currentUser = await getCurrentSession(request.signal);
      if (!request.isCurrent()) return;
      setUser(currentUser);
      setSessionError(null);
    } catch (error) {
      if (!request.isCurrent()) return;
      setSessionError(error instanceof ApiError ? error : new ApiError({ message: 'No fue posible recuperar la sesión.' }));
    } finally {
      if (request.isCurrent()) setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    let active = true;
    const pending = requests.current;
    void Promise.resolve().then(() => { if (active) void refresh(); });
    return () => { active = false; pending.cancel(); };
  }, [refresh]);

  useEffect(() => {
    const unsubscribe = subscribeToUnauthenticated(() => {
      requests.current.cancel();
      setUser(null);
      setSessionError(null);
      setIsLoading(false);
    });
    return unsubscribe;
  }, []);

  const markPreferencesSaved = useCallback(() => {
    // The successful preferences PUT confirms this change on the server.
    setUser(current => current ? { ...current, isNewUser: false } : current);
  }, []);

  const logout = useCallback(async () => {
    await endSession();
    requests.current.cancel();
    setUser(null);
    setSessionError(null);
    setIsLoading(false);
  }, []);

  const value = useMemo(() => ({ user, isLoading, sessionError, refresh, logout, markPreferencesSaved }), [user, isLoading, sessionError, refresh, logout, markPreferencesSaved]);
  return <AuthSessionContext.Provider value={value}>{children}</AuthSessionContext.Provider>;
}
