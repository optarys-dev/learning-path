import { Suspense, useEffect, useRef, useState } from 'react';
import { Link, NavLink, Outlet, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

import { BrandLogo } from '../ui/BrandLogo/BrandLogo';
import { Button } from '../ui/Button/Button';
import { LanguageSelector } from '../LanguageSelector/LanguageSelector';
import { ThemeToggle } from '../ui/ThemeToggle/ThemeToggle';
import { ContentBoundary } from './ContentBoundary';
import { PageState } from '../ui/PageState/PageState';
import { useAuthSession } from '../../features/auth/useAuthSession';

import './AppLayout.css';
import '../../features/welcome/landing.css';

export function AppLayout({
  variant = 'application',
}: {
  variant?: 'application' | 'welcome';
}) {
  const { t } = useTranslation();
  const { pathname } = useLocation();

  const [menuOpen, setMenuOpen] = useState(false);

  const {
    user,
    isLoading: isSessionLoading,
  } = useAuthSession();

  const menuButton = useRef<HTMLButtonElement>(null);
  const main = useRef<HTMLElement>(null);
  const previousPath = useRef(pathname);

  useEffect(() => {
    if (previousPath.current !== pathname) {
      main.current?.focus();
      window.scrollTo(0, 0);
      previousPath.current = pathname;
      setMenuOpen(false);
    }
  }, [pathname]);

  const displayName =
    user?.displayName || user?.username;

  const avatarUrl = user?.avatar
    ? `https://cdn.discordapp.com/avatars/${encodeURIComponent(
        user.id,
      )}/${encodeURIComponent(user.avatar)}.png?size=80`
    : null;

  const profileLink =
    user && displayName ? (
      <NavLink
        className="session-identity"
        to="/my-path"
        aria-label={t('auth.signedInAs', {
          name: displayName,
        })}
      >
        <span
          className="session-identity__avatar"
          aria-hidden="true"
        >
          <span>
            {displayName
              .slice(0, 1)
              .toUpperCase()}
          </span>

          {avatarUrl && (
            <img
              src={avatarUrl}
              alt=""
              onError={(event) => {
                event.currentTarget.hidden = true;
              }}
            />
          )}
        </span>

        <span className="session-identity__name">
          {displayName}
        </span>
      </NavLink>
    ) : null;

  return (
    <div
      className={`app-shell app-shell--${variant}`}
    >
      <a
        className="skip-link"
        href="#main-content"
      >
        {t('layout.skip')}
      </a>

      <header className="app-header">
        <div className="app-header__inner">
          <Link
            to="/"
            className="app-brand"
            onClick={() => setMenuOpen(false)}
          >
            <BrandLogo className="app-brand__logo" />
            <span>{t('app.name')}</span>
          </Link>

          {isSessionLoading ? (
            <div className="welcome-navigation">
              <ThemeToggle />
              <LanguageSelector />

              <span
                className="session-identity session-identity--loading"
                aria-label={t('layout.loading')}
              />
            </div>
          ) : user ? (
            <>
              <Button
                ref={menuButton}
                variant="secondary"
                className="menu-toggle"
                aria-expanded={menuOpen}
                aria-controls="primary-navigation"
                onClick={() =>
                  setMenuOpen(!menuOpen)
                }
              >
                {t(
                  menuOpen
                    ? 'layout.closeMenu'
                    : 'layout.openMenu',
                )}
              </Button>

              <div
                className="app-navigation"
                data-open={menuOpen}
                id="primary-navigation"
                onKeyDown={(event) => {
                  if (
                    event.key === 'Escape' &&
                    menuOpen
                  ) {
                    setMenuOpen(false);
                    menuButton.current?.focus();
                  }
                }}
              >
                <nav
                  aria-label={t(
                    'layout.navigation',
                  )}
                >
                  <NavLink
                    to="/"
                    end
                    onClick={() =>
                      setMenuOpen(false)
                    }
                  >
                    {t('layout.home')}
                  </NavLink>

                  <NavLink
                    to="/learning-profile"
                    onClick={() =>
                      setMenuOpen(false)
                    }
                  >
                    Crear ruta
                  </NavLink>

                  <NavLink
                    to="/my-path"
                    onClick={() =>
                      setMenuOpen(false)
                    }
                  >
                    Mis rutas
                  </NavLink>

                  <NavLink
                    to="/catalog"
                    onClick={() =>
                      setMenuOpen(false)
                    }
                  >
                    {t('layout.catalog')}
                  </NavLink>
                </nav>

                <ThemeToggle />
                <LanguageSelector />
                {profileLink}
              </div>
            </>
          ) : (
            <div className="welcome-navigation">
              <nav
                aria-label={t(
                  'landing.navigation',
                )}
              >
                <NavLink to="/">
                  Inicio
                </NavLink>

                <NavLink to="/catalog">
                  Catálogo
                </NavLink>

                <a href="/#how-it-works">
                  {t('landing.howLink')}
                </a>

                <a href="/#questions">
                  {t('landing.faqLink')}
                </a>
              </nav>

              <ThemeToggle />
              <LanguageSelector />

              <NavLink
                className="welcome-navigation__login"
                to="/login"
              >
                {t('login.navigation')}
              </NavLink>
            </div>
          )}
        </div>
      </header>

      <main
        id="main-content"
        className="app-main"
        ref={main}
        tabIndex={-1}
      >
        <ContentBoundary key={pathname}>
          <Suspense
            fallback={
              <PageState
                kind="loading"
                title={t('layout.loading')}
              />
            }
          >
            <Outlet />
          </Suspense>
        </ContentBoundary>
      </main>

      <footer className="app-footer">
        <span>{t('app.name')}</span>
        <p>{t('layout.footer')}</p>
      </footer>
    </div>
  );
}
