import { useState } from 'react';
import type { DiscordLoginState } from '../features/auth/hooks/useDiscordLogin';
import { LoginView } from '../features/auth/components/LoginView';

const previewStates = ['idle', 'loading', 'error', 'cancelled', 'authenticated', 'unavailable'] as const;

export default function WelcomePreviewPage() {
  const [state, setState] = useState<DiscordLoginState>({ status: 'idle' });
  return (
    <div>
      <label>
        DEV · Vista visual, sin sesión real{' '}
        <select value={state.status} onChange={event => {
          const status = previewStates.find(value => value === event.target.value);
          if (status) setState(status === 'authenticated' ? { status, nextPath: '/' } : { status });
        }}>
          {previewStates.map(status => <option key={status}>{status}</option>)}
        </select>
      </label>
      <LoginView state={state} onLogin={() => setState({ status: 'loading' })} />
    </div>
  );
}
