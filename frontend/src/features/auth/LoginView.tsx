import { Trans, useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { ArrowLeft, CircleAlert, Compass, Route, type LucideIcon } from 'lucide-react';
import { DiscordIcon } from '../../components/ui/DiscordIcon/DiscordIcon';
import devi from '../../assets/brand/devi-laptop.svg';
import { DiscordLoginButton } from '../welcome/DiscordLoginButton';
import type { DiscordLoginState } from './useDiscordLogin';
import './login.css';

export function LoginView({ state, onLogin }: {
  state: DiscordLoginState;
  onLogin: () => void;
}) {
  const { t } = useTranslation();
  const { status } = state;
  const benefitIcons: LucideIcon[] = [Route, Compass];
  const feedback = status === 'error' ? t('welcome.error')
    : status === 'cancelled' ? t('welcome.cancelled')
    : status === 'unavailable' ? t('welcome.unavailable')
    : status === 'authenticated' ? t('welcome.session')
    : status === 'loading' ? t('welcome.connecting') : '';

  return (
    <div className="login-page">
      <section className="login-card" aria-labelledby="login-title">
        <Link className="login-back" to="/"><ArrowLeft size={17} aria-hidden="true" /> {t('login.back')}</Link>
        <p className="landing-eyebrow">{t('login.eyebrow')}</p>
        <h1 id="login-title">{t('login.title')}</h1>
        <p className="login-card__intro">{t('login.description')}</p>
        {status !== 'authenticated' && <>
          <DiscordLoginButton loading={status === 'loading'} retry={status === 'error' || status === 'cancelled'} onClick={onLogin} />
          <p id="discord-purpose" className="login-card__purpose">{t('welcome.purpose')}</p>
        </>}
        <p id="discord-feedback" className="login-feedback" data-error={status === 'error'} role={status === 'error' ? 'alert' : 'status'}>{status === 'unavailable' && <CircleAlert size={17} aria-hidden="true" />}{feedback}</p>
        {status !== 'authenticated' && <p className="login-availability">{t('login.developmentNote')}</p>}
      </section>
      <aside className="login-aside" aria-labelledby="login-aside-title">
        <span className="login-aside__spark" aria-hidden="true">✳</span>
        <h2 id="login-aside-title"><Trans i18nKey="login.asideTitle" components={{ accent: <span className="text-accent" /> }} /></h2>
        <p>{t('login.asideDescription')}</p>
        <ul>{(['benefitOne', 'benefitTwo', 'benefitThree'] as const).map((key, index) => {
          const Icon = index === 0 ? null : benefitIcons[index - 1];
          return <li key={key}><span aria-hidden="true">{Icon ? <Icon size={16} /> : <DiscordIcon size={17} />}</span>{t(`login.${key}`)}</li>;
        })}</ul>
        <img src={devi} alt="" width="248" height="277" />
      </aside>
    </div>
  );
}
