import { appRoutes } from '@/config/navigation';
import { Suspense, useEffect, useRef, useState } from 'react';
import { Link, NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { ChevronDown, LogOut, Menu, X } from 'lucide-react';

import { BrandLogo, Button, PageState } from '@/components/ui';
import { LanguageSelector } from '@/components/ui/LanguageSelector/LanguageSelector';
import { ThemeToggle } from '@/components/ui/ThemeToggle/ThemeToggle';
import { ContentBoundary } from './ContentBoundary';
import { useNotifications } from '@/components/notifications';
import { useAuthSession } from '@/features/auth/hooks/useAuthSession';

import './AppLayout.css';
import '@/features/welcome/styles/landing.css';

export function AppLayout({
  variant = 'application',
}: {
  variant?: 'application' | 'welcome';
}) {
  const { t } = useTranslation();
  const { pathname, hash } = useLocation();
  const navigate = useNavigate();
  const { notify } = useNotifications();

  const [menuOpen, setMenuOpen] = useState(false);
  const [profileMenuOpen, setProfileMenuOpen] = useState(false);
  const [isLoggingOut, setIsLoggingOut] = useState(false);

  const {
    user,
    isLoading: isSessionLoading,
    logout,
  } = useAuthSession();

  const menuButton = useRef<HTMLButtonElement>(null);
  const profileMenu = useRef<HTMLDivElement>(null);
  const profileButton = useRef<HTMLButtonElement>(null);
  const main = useRef<HTMLElement>(null);
  const previousPath = useRef(pathname);

  useEffect(() => {
    if (previousPath.current !== pathname) {
      main.current?.focus();
      window.scrollTo(0, 0);
      previousPath.current = pathname;
      setMenuOpen(false);
      setProfileMenuOpen(false);
    }
  }, [pathname]);

  useEffect(() => {
    if (pathname !== appRoutes.home || !hash) return;
    const frame = window.requestAnimationFrame(() => {
      document.getElementById(hash.slice(1))?.scrollIntoView({ block: 'start' });
      setMenuOpen(false);
    });
    return () => window.cancelAnimationFrame(frame);
  }, [pathname, hash]);

  useEffect(() => {
    if (!profileMenuOpen) return;

    function dismissProfileMenu(event: MouseEvent | KeyboardEvent) {
      if (event instanceof KeyboardEvent && event.key === 'Escape') {
        setProfileMenuOpen(false);
        profileButton.current?.focus();
      }
      if (event instanceof MouseEvent && !profileMenu.current?.contains(event.target as Node)) {
        setProfileMenuOpen(false);
      }
    }

    document.addEventListener('mousedown', dismissProfileMenu);
    document.addEventListener('keydown', dismissProfileMenu);
    return () => {
      document.removeEventListener('mousedown', dismissProfileMenu);
      document.removeEventListener('keydown', dismissProfileMenu);
    };
  }, [profileMenuOpen]);

  const displayName =
    user?.displayName || user?.username;

  const avatarUrl = user?.avatarUrl ?? (user?.avatar && user.provider !== 'Google'
    ? `https://cdn.discordapp.com/avatars/${encodeURIComponent(
        user.id,
      )}/${encodeURIComponent(user.avatar)}.png?size=80`
    : null);

  function scrollToLandingSection(section: string) {
    setMenuOpen(false);
    if (pathname === appRoutes.home) {
      window.requestAnimationFrame(() => document.getElementById(section)?.scrollIntoView({ block: 'start' }));
    }
  }

  async function handleLogout() {
    if (isLoggingOut) return;

    setIsLoggingOut(true);
    try {
      await logout();
      setMenuOpen(false);
      notify({ tone: 'success', title: t('auth.logoutSuccess') });
      setProfileMenuOpen(false);
      navigate(appRoutes.home, { replace: true });
    } catch {
      notify({ tone: 'error', title: t('auth.logoutError') });
    } finally {
      setIsLoggingOut(false);
    }
  }

  const profileMenuContent =
    user && displayName ? (
      <div className="profile-menu" ref={profileMenu}>
        <button
          ref={profileButton}
          className="session-identity"
          type="button"
          aria-label={t('auth.signedInAs', { name: displayName })}
          aria-haspopup="menu"
          aria-expanded={profileMenuOpen}
          aria-controls="profile-menu"
          onClick={() => setProfileMenuOpen(open => !open)}
        >
          <span className="session-identity__avatar" aria-hidden="true">
            <span>{displayName.slice(0, 1).toUpperCase()}</span>

            {avatarUrl && (
              <img
                src={avatarUrl}
                alt=""
                onError={(event) => { event.currentTarget.hidden = true; }}
              />
            )}
          </span>

          <span className="session-identity__name">{displayName}</span>
          <ChevronDown className="session-identity__chevron" size={16} aria-hidden="true" />
        </button>

        {profileMenuOpen && (
          <div className="profile-menu__panel" id="profile-menu" role="menu" aria-label={t('auth.profile')}>
            <p className="profile-menu__heading">{displayName}</p>
            <div className="profile-menu__separator" role="separator" />
            <NavLink to={appRoutes.savedRoutes} role="menuitem" onClick={() => { setProfileMenuOpen(false); setMenuOpen(false); }}>
              {t('layout.myPaths')}
            </NavLink>
            <div className="profile-menu__separator" role="separator" />
            <button type="button" role="menuitem" disabled={isLoggingOut} onClick={() => void handleLogout()}>
              <LogOut size={17} aria-hidden="true" />
              {isLoggingOut ? t('auth.signingOut') : t('auth.logout')}
            </button>
          </div>
        )}
      </div>
    ) : null;

  return (
    <div
      className={`app-shell app-shell--${variant}${pathname === appRoutes.login ? ' app-shell--login' : ''}`}
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
            to={appRoutes.home}
            className="app-brand"
            onClick={() => setMenuOpen(false)}
          >
            <BrandLogo className="app-brand__logo" />
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
                aria-label={t(menuOpen ? 'layout.closeMenu' : 'layout.openMenu')}
                aria-expanded={menuOpen}
                aria-controls="primary-navigation"
                onClick={() => setMenuOpen(!menuOpen)}
              >
                {menuOpen ? <X aria-hidden="true" /> : <Menu aria-hidden="true" />}
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
                    to={appRoutes.home}
                    end
                    onClick={() =>
                      setMenuOpen(false)
                    }
                  >
                    {t('layout.home')}
                  </NavLink>

                  <NavLink
                    to={appRoutes.createRoute}
                    onClick={() =>
                      setMenuOpen(false)
                    }
                  >
                    {t('layout.createPath')}
                  </NavLink>

                  <NavLink
                    to={appRoutes.savedRoutes}
                    onClick={() =>
                      setMenuOpen(false)
                    }
                  >
                    {t('layout.myPaths')}
                  </NavLink>

                  <NavLink
                    to={appRoutes.catalog}
                    onClick={() =>
                      setMenuOpen(false)
                    }
                  >
                    {t('layout.catalog')}
                  </NavLink>
                </nav>

                <ThemeToggle />
                <LanguageSelector />
                {profileMenuContent}
              </div>
            </>
          ) : (
            <>
            <Button ref={menuButton} variant="secondary" className="menu-toggle"
              aria-label={t(menuOpen ? 'layout.closeMenu' : 'layout.openMenu')}
              aria-expanded={menuOpen} aria-controls="public-navigation" onClick={() => setMenuOpen(!menuOpen)}>
              {menuOpen ? <X aria-hidden="true" /> : <Menu aria-hidden="true" />}
            </Button>
            <div className="app-navigation welcome-navigation public-navigation" data-open={menuOpen} id="public-navigation"
              onKeyDown={event => { if (event.key === 'Escape') { setMenuOpen(false); menuButton.current?.focus(); } }}>
              <nav
                aria-label={t(
                  'landing.navigation',
                )}
              >
                <NavLink to={appRoutes.home} end onClick={() => setMenuOpen(false)}>
                  {t('layout.home')}
                </NavLink>
                <Link to="/#how-it-works" onClick={() => scrollToLandingSection('how-it-works')}>{t('landing.howLink')}</Link>
                <Link to="/#your-experience" onClick={() => scrollToLandingSection('your-experience')}>{t('landing.insideLink')}</Link>
                <Link to="/#questions" onClick={() => scrollToLandingSection('questions')}>{t('landing.faqLink')}</Link>
                <NavLink to={appRoutes.catalog} onClick={() => setMenuOpen(false)}>
                  {t('layout.catalog')}
                </NavLink>

              </nav>

              <ThemeToggle />
              <LanguageSelector />

              <NavLink
                className="welcome-navigation__login"
                to={appRoutes.login}
                onClick={() => setMenuOpen(false)}
              >
                {t('login.navigation')}
              </NavLink>
            </div>
            </>
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
