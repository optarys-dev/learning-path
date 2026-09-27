import { createContext } from 'react';

export type NotificationTone = 'success' | 'error' | 'info';
export interface NotificationInput { title: string; message?: string; tone?: NotificationTone; }
export interface Notification extends NotificationInput { id: string; tone: NotificationTone; }
export const NotificationContext = createContext<{
  notify: (notification: NotificationInput) => void;
  dismiss: (id: string) => void;
} | null>(null);
