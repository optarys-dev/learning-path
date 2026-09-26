import { appRoutes } from '@/config/navigation';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import type { DiscordLoginState } from '@/features/auth/hooks/useDiscordLogin';
import { LoginView } from '@/features/auth/components/LoginView';

const previewStates = ['idle', 'loading', 'error', 'cancelled', 'authenticated', 'unavailable'] as const;

export default function WelcomePreviewPage() {
  const { t } = useTranslation();
  const [state, setState] = useState<DiscordLoginState>({ status: 'idle' });
  return (
    <div>
      <label>
        {t('devPreview.label')}{' '}
        <select value={state.status} onChange={event => {
          const status = previewStates.find(value => value === event.target.value);
          if (status) setState(status === 'authenticated' ? { status, nextPath: appRoutes.home } : { status });
        }}>
          {previewStates.map(status => <option key={status} value={status}>{t(`devPreview.${status}`)}</option>)}
        </select>
      </label>
      <LoginView state={state} onLogin={() => setState({ status: 'loading' })} />
    </div>
  );
}
