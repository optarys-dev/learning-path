import { useEffect, useState } from 'react';

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

function getStatusMessage({ api, database }: HealthState) {
  if (api === 'checking' || database === 'checking') {
    return 'Comprobando conexión con la API y PostgreSQL…';
  }

  if (api === 'unhealthy') {
    return '🔴 No se pudo conectar con la API';
  }

  if (database === 'unhealthy') {
    return '🟡 API conectada, pero PostgreSQL no responde';
  }

  return '🟢 API y PostgreSQL conectados correctamente';
}

export function ApiStatusPage() {
  const [health, setHealth] = useState<HealthState>(initialHealthState);

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

  return (
    <main className="api-status">
      <p className="api-status__eyebrow">CODE QUEST 2026</p>
      <h1>Base técnica lista para integrar</h1>
      <p aria-live="polite">{getStatusMessage(health)}</p>
      <small>API: {apiUrl}</small>
    </main>
  );
}
