import { appRoutes } from '@/config/navigation';
import { Trans, useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { ArrowLeft, CheckCircle2, ChevronDown, CircleAlert, Compass, FolderOpen, Paperclip, Route, type LucideIcon } from 'lucide-react';
import { motion, useReducedMotion } from 'framer-motion';
import deviReady from '@/assets/portal/10_continuar_aprendiendo.png';
import deviLoading from '@/assets/portal/01_cargando.png';
import deviError from '@/assets/portal/04_error_suave.png';
import { DiscordLoginButton } from '@/features/welcome/components/DiscordLoginButton';
import type { DiscordLoginState } from '@/features/auth/hooks/useDiscordLogin';
import './login.css';
import { Button } from '@/components/ui';
import { GoogleIcon } from './GoogleIcon';

export function LoginView({ state, onLogin, onGoogleLogin, googleLoading = false, googleError = false }: {
  state: DiscordLoginState;
  onLogin: () => void;
  onGoogleLogin?: () => void;
  googleLoading?: boolean;
  googleError?: boolean;
}) {
  const { t } = useTranslation();
  const reduceMotion = useReducedMotion();
  const { status } = state;
  const benefitIcons: LucideIcon[] = [Route, CheckCircle2, Compass];
  const feedback = status === 'error' ? t('welcome.error')
    : status === 'cancelled' ? t('welcome.cancelled')
    : status === 'unavailable' ? t('welcome.unavailable')
    : status === 'authenticated' ? t('welcome.session')
    : status === 'loading' ? t('welcome.connecting') : '';
  const sceneDevi = status === 'loading' || googleLoading ? deviLoading : status === 'error' || status === 'cancelled' || googleError ? deviError : deviReady;

  return (
    <div className="login-page">
      <motion.div className="login-card-wrap"
        initial={reduceMotion ? false : { opacity: 0, x: -14 }}
        animate={reduceMotion ? undefined : { opacity: 1, x: 0 }}
        transition={{ duration: 0.35, ease: 'easeOut' }}>
        <Link className="login-back" to={appRoutes.home}><ArrowLeft size={17} aria-hidden="true" /> {t('login.back')}</Link>
        <section className="login-card" aria-labelledby="login-title">
          <p className="landing-eyebrow">{t('login.eyebrow')}</p>
          <h1 id="login-title">{t('login.title')}</h1>
          <p className="login-card__intro">{t('login.description')}</p>
          {status !== 'authenticated' && <>
            <DiscordLoginButton loading={status === 'loading'} retry={status === 'error' || status === 'cancelled'} onClick={onLogin} disabled={googleLoading} />
            {onGoogleLogin && <Button className="login-google" variant="secondary" isLoading={googleLoading}
              loadingLabel={t('login.googleConnecting')} disabled={status === 'loading'} onClick={onGoogleLogin}>
              <GoogleIcon />{t('login.googleContinue')}
            </Button>}
            {googleError && <p className="login-feedback" data-error="true" role="alert">{t('login.googleError')}</p>}
            <details className="login-account-info">
              <summary>{t('login.accountInfo')}<ChevronDown size={15} aria-hidden="true" /></summary>
              <p id="discord-purpose">{t('login.privacy')}</p>
            </details>
          </>}
          <p id="discord-feedback" className="login-feedback" data-error={status === 'error'} role={status === 'error' ? 'alert' : 'status'}>{status === 'unavailable' && <CircleAlert size={17} aria-hidden="true" />}{feedback}</p>
        </section>
      </motion.div>
      <motion.aside className="login-aside" aria-labelledby="login-aside-title"
        initial={reduceMotion ? false : { opacity: 0, x: 14 }}
        animate={reduceMotion ? undefined : { opacity: 1, x: 0 }}
        transition={{ duration: 0.4, delay: reduceMotion ? 0 : 0.08, ease: 'easeOut' }}>
        <div className="login-aside__copy">
          <span className="login-aside__label"><FolderOpen size={17} aria-hidden="true" />{t('login.sceneLabel')}</span>
          <h2 id="login-aside-title"><Trans i18nKey="login.asideTitle" components={{ accent: <span className="text-accent" /> }} /></h2>
        </div>
        <div className="login-aside__scene" aria-hidden="true">
          <div className="login-scene__sheet"><Paperclip size={30} /><Route size={28} /><span /><span /><CheckCircle2 size={20} /></div>
          <div className="login-scene__note"><Compass size={24} /><span /><span /></div>
          <img src={sceneDevi} alt="" width="248" height="277" />
        </div>
        <ul className="login-aside__benefits">{(['benefitOne', 'benefitTwo', 'benefitThree'] as const).map((key, index) => {
            const Icon = benefitIcons[index];
            return <li key={key}><span aria-hidden="true"><Icon size={16} /></span>{t(`login.${key}`)}</li>;
          })}</ul>
      </motion.aside>
    </div>
  );
}
