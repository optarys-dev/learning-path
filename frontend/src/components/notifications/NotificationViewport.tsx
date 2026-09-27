import { CircleAlert, CircleCheck, Info, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import type { Notification } from './NotificationContext';

const icons = { success: CircleCheck, error: CircleAlert, info: Info };

export function NotificationViewport({ notifications, onDismiss }: { notifications: Notification[]; onDismiss: (id: string) => void; }) {
  const { t } = useTranslation();
  return <aside className="cq-notifications" aria-live="polite" aria-label={t('notifications.label')}>
    {notifications.map(notification => {
      const Icon = icons[notification.tone];
      return <section className={`cq-notification cq-notification--${notification.tone}`} key={notification.id} role={notification.tone === 'error' ? 'alert' : 'status'}>
        <Icon size={20} aria-hidden="true" />
        <div><strong>{notification.title}</strong>{notification.message && <p>{notification.message}</p>}</div>
        <button type="button" onClick={() => onDismiss(notification.id)} aria-label={t('notifications.dismiss')}><X size={17} aria-hidden="true" /></button>
      </section>;
    })}
  </aside>;
}
