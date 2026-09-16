import { useEffect, useRef, useState } from 'react';
import { getCurrentSession, startDiscordLogin } from './session';

export type DiscordLoginState =
  | { status: 'idle' | 'loading' | 'error' | 'cancelled' | 'unavailable' }
  | { status: 'authenticated'; nextPath: string };

export type DiscordLoginAdapter = (signal: AbortSignal) => Promise<
  { status: 'cancelled' } | { status: 'authenticated'; nextPath: string }
>;

export function useDiscordLogin(adapter?: DiscordLoginAdapter) {
  const [state, setState] = useState<DiscordLoginState>({ status: 'idle' });
  const request = useRef<AbortController | null>(null);

  useEffect(() => () => request.current?.abort(), []);
  useEffect(() => {
    const controller = new AbortController();
    void getCurrentSession(controller.signal)
      .then(user => {
        if (user && !controller.signal.aborted) setState({ status: 'authenticated', nextPath: '/my-path' });
      })
      .catch(() => {
        // A failed session check must not block the sign-in screen.
      });
    return () => controller.abort();
  }, []);

  async function login() {
    if (request.current) return;
    if (!adapter) {
      startDiscordLogin();
      return;
    }
    const controller = new AbortController();
    request.current = controller;
    setState({ status: 'loading' });
    try {
      const result = await adapter(controller.signal);
      if (!controller.signal.aborted) setState(result);
    } catch {
      if (!controller.signal.aborted) setState({ status: 'error' });
    } finally {
      if (request.current === controller) request.current = null;
    }
  }

  return { state, login };
}
