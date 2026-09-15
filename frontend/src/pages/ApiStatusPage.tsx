import { useEffect, useState } from 'react';
import { apiUrl } from '../config/api';
import '../App.css';

type ApiConnectionStatus = 'checking' | 'connected' | 'error';

interface HealthResponse {
  status: string;
}

export function ApiStatusPage() {
  const [connectionStatus, setConnectionStatus] = useState<ApiConnectionStatus>('checking');

  useEffect(() => {
    const abortController = new AbortController();

    async function checkApiHealth() {
      try {
        const response = await fetch(`${apiUrl}/health`, {
          signal: abortController.signal,
        });

        if (!response.ok) {
          throw new Error(`La API respondió con ${response.status}.`);
        }

        const health = (await response.json()) as HealthResponse;
        setConnectionStatus(health.status === 'ok' ? 'connected' : 'error');
      } catch {
        if (!abortController.signal.aborted) {
          setConnectionStatus('error');
        }
      }
    }

    void checkApiHealth();

    return () => abortController.abort();
  }, []);

  const messages: Record<ApiConnectionStatus, string> = {
    checking: 'Comprobando conexión con la API…',
    connected: '🟢 API conectada correctamente',
    error: '🔴 No se pudo conectar con la API',
  };

  return (
    <main className="api-status">
      <p className="api-status__eyebrow">CODE QUEST 2026</p>
      <h1>Base técnica lista para integrar</h1>
      <p>{messages[connectionStatus]}</p>
      <small>API: {apiUrl}</small>
    </main>
  );
}
