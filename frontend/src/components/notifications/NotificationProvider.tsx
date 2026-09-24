import { useCallback, useMemo, useState, type ReactNode } from 'react';
import { NotificationContext, type Notification, type NotificationInput } from './NotificationContext';
import { NotificationViewport } from './NotificationViewport';

const NOTIFICATION_DURATION = 5000;

export function NotificationProvider({ children }: { children: ReactNode }) {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const dismiss = useCallback((id: string) => setNotifications(current => current.filter(notification => notification.id !== id)), []);
  const notify = useCallback((input: NotificationInput) => {
    const id = crypto.randomUUID();
    setNotifications(current => [...current, { ...input, id, tone: input.tone ?? 'info' }]);
    window.setTimeout(() => dismiss(id), NOTIFICATION_DURATION);
  }, [dismiss]);
  const value = useMemo(() => ({ notify, dismiss }), [notify, dismiss]);
  return <NotificationContext.Provider value={value}>
    {children}<NotificationViewport notifications={notifications} onDismiss={dismiss} />
  </NotificationContext.Provider>;
}
