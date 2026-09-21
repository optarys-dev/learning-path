import { createContext } from 'react';
import type { AuthenticatedUser } from './session';

export interface AuthSessionContextValue {
  user: AuthenticatedUser | null;
  isLoading: boolean;
  refresh: () => Promise<void>;
}

export const AuthSessionContext = createContext<AuthSessionContextValue | null>(null);
