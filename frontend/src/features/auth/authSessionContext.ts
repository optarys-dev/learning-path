import { createContext } from 'react';
import type { AuthenticatedUser } from './session';
import type { ApiError } from '../../lib/api';

export interface AuthSessionContextValue {
  user: AuthenticatedUser | null;
  isLoading: boolean;
  sessionError: ApiError | null;
  refresh: () => Promise<void>;
  logout: () => Promise<void>;
  markPreferencesSaved: () => void;
}

export const AuthSessionContext = createContext<AuthSessionContextValue | null>(null);
