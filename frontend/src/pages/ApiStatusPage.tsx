import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { LanguageSelector } from '../components/LanguageSelector/LanguageSelector';
import { apiUrl } from '../config/api';
import '../App.css';

type HealthStatus = 'checking' | 'healthy' | 'unhealthy';

interface HealthState {
  api: HealthStatus;
  database: HealthStatus;
}

const initialHealthState: HealthState = {
  api: 'checking',
  database: 'checking',
};

export function ApiStatusPage() {
  const [health, setHealth] = useState<HealthState>(initialHealthState);
  const { t } = useTranslation();

  useEffect(() => {
    const abortController = new AbortController();

    async function getHealthStatus(path: string): Promise<HealthStatus> {
      const response = await fetch(`${apiUrl}${path}`, {
        headers: { Accept: 'text/plain' },
        signal: abortController.signal,
      });

      return response.ok ? 'healthy' : 'unhealthy';
    }

    async function checkHealth() {
      try {
        const [api, database] = await Promise.all([
          getHealthStatus('/health/api'),
          getHealthStatus('/health/db'),
        ]);

        if (!abortController.signal.aborted) {
          setHealth({ api, database });
        }
      } catch {
        if (!abortController.signal.aborted) {
          setHealth({ api: 'unhealthy', database: 'unhealthy' });
        }
      }
    }

    void checkHealth();

    return () => abortController.abort();
  }, []);

  let statusMessage: string = t('status.apiAndDatabaseConnected');

  if (health.api === 'checking' || health.database === 'checking') {
    statusMessage = t('status.checking');
  } else if (health.api === 'unhealthy') {
    statusMessage = t('status.apiUnavailable');
  } else if (health.database === 'unhealthy') {
    statusMessage = t('status.databaseUnavailable');
  }

  return (
    <main className="api-status">
      <LanguageSelector />
      <p className="api-status__eyebrow">{t('app.name')}</p>
      <h1>{t('status.pageTitle')}</h1>
      <p aria-live="polite">{statusMessage}</p>
      <small>{t('status.apiLabel', { url: apiUrl })}</small>
    </main>
  );
}
