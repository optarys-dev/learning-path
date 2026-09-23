import { createContext } from 'react';
import type { AuthenticatedUser } from '../api/session';

export interface AuthSessionContextValue {
  user: AuthenticatedUser | null;
  isLoading: boolean;
  refresh: () => Promise<void>;
  logout: () => Promise<void>;
  markPreferencesSaved: () => void;
}

export const AuthSessionContext = createContext<AuthSessionContextValue | null>(null);
