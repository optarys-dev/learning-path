import { Suspense, useEffect, useRef, useState } from 'react';
import { Link, NavLink, Outlet, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { BrandLogo } from '../ui/BrandLogo/BrandLogo';
import { Button } from '../ui/Button/Button';
import { LanguageSelector } from '../LanguageSelector/LanguageSelector';
import './AppLayout.css';
import { ContentBoundary } from './ContentBoundary';
import { PageState } from '../ui/PageState/PageState';

export function AppLayout() {
  const { t } = useTranslation();
  const { pathname } = useLocation();
  const [menuOpen, setMenuOpen] = useState(false);
  const menuButton = useRef<HTMLButtonElement>(null);
  const main = useRef<HTMLElement>(null);
  const previousPath = useRef(pathname);

  useEffect(() => {
    if (previousPath.current !== pathname) {
      main.current?.focus();
      window.scrollTo(0, 0);
      previousPath.current = pathname;
    }
  }, [pathname]);

  return (
    <div className="app-shell">
      <a className="skip-link" href="#main-content">{t('layout.skip')}</a>
      <header className="app-header">
        <div className="app-header__inner">
          <Link to="/" className="app-brand" onClick={() => setMenuOpen(false)}>
            <BrandLogo className="app-brand__logo" />
            <span>{t('app.name')}</span>
          </Link>
          <Button ref={menuButton} variant="secondary" className="menu-toggle"
            aria-expanded={menuOpen} aria-controls="primary-navigation"
            onClick={() => setMenuOpen(!menuOpen)}>
            {t(menuOpen ? 'layout.closeMenu' : 'layout.openMenu')}
          </Button>
          <div className="app-navigation" data-open={menuOpen} id="primary-navigation"
            onKeyDown={event => {
              if (event.key === 'Escape' && menuOpen) {
                setMenuOpen(false);
                menuButton.current?.focus();
              }
            }}>
            <nav aria-label={t('layout.navigation')}>
              <NavLink to="/" end onClick={() => setMenuOpen(false)}>{t('layout.home')}</NavLink>
              <NavLink to="/catalog" onClick={() => setMenuOpen(false)}>{t('layout.catalog')}</NavLink>
              <NavLink to="/my-path" onClick={() => setMenuOpen(false)}>{t('layout.myPath')}</NavLink>
            </nav>
            <LanguageSelector />
          </div>
        </div>
      </header>
      <main id="main-content" className="app-main" ref={main} tabIndex={-1}>
        <ContentBoundary key={pathname}>
          <Suspense fallback={<PageState kind="loading" title={t('layout.loading')} />}>
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
