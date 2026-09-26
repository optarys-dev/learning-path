import { Moon, Sun } from 'lucide-react';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import './ThemeToggle.css';

type Theme = 'light' | 'dark';

const themeStorageKey = 'codequest.theme';

function getInitialTheme(): Theme {
  if (typeof document === 'undefined') {
    return 'dark';
  }

  // index.html already resolved storage/system preference before the first paint.
  return document.documentElement.dataset.theme === 'light' ? 'light' : 'dark';
}

export function ThemeToggle() {
  const { t } = useTranslation();
  const [theme, setTheme] = useState<Theme>(getInitialTheme);

  useEffect(() => {
    document.documentElement.dataset.theme = theme;
    try { window.localStorage.setItem(themeStorageKey, theme); }
    catch { /* The active theme still works when browser storage is unavailable. */ }
  }, [theme]);

  const toggleTheme = () => {
    setTheme(current =>
      current === 'dark' ? 'light' : 'dark'
    );
  };

  return (
    <button
      type="button"
      className="theme-toggle"
      onClick={toggleTheme}
      aria-label={
        theme === 'dark'
          ? t('theme.switchToLight')
          : t('theme.switchToDark')
      }
      title={
        theme === 'dark'
          ? t('theme.light')
          : t('theme.dark')
      }
    >
      {theme === 'dark'
        ? <Sun size={18} aria-hidden="true" />
        : <Moon size={18} aria-hidden="true" />
      }
    </button>
  );
}
