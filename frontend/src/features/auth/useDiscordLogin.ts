import { useEffect, useRef, useState } from 'react';

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

  async function login() {
    if (request.current) return;
    if (!adapter) {
      setState({ status: 'unavailable' });
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
