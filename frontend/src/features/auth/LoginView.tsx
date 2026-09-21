import { Trans, useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { ArrowLeft, CircleAlert, Compass, Route, type LucideIcon } from 'lucide-react';
import { motion, useReducedMotion } from 'framer-motion';
import { DiscordIcon } from '../../components/ui/DiscordIcon/DiscordIcon';
import deviReady from '../../assets/portal/12_editar_perfil.png';
import deviLoading from '../../assets/portal/01_cargando.png';
import deviError from '../../assets/portal/04_error_suave.png';
import { DiscordLoginButton } from '../welcome/DiscordLoginButton';
import type { DiscordLoginState } from './useDiscordLogin';
import './login.css';

export function LoginView({ state, onLogin }: {
  state: DiscordLoginState;
  onLogin: () => void;
}) {
  const { t } = useTranslation();
  const reduceMotion = useReducedMotion();
  const { status } = state;
  const benefitIcons: LucideIcon[] = [Route, Compass];
  const feedback = status === 'error' ? t('welcome.error')
    : status === 'cancelled' ? t('welcome.cancelled')
    : status === 'unavailable' ? t('welcome.unavailable')
    : status === 'authenticated' ? t('welcome.session')
    : status === 'loading' ? t('welcome.connecting') : '';
  const sceneDevi = status === 'loading' ? deviLoading : status === 'error' || status === 'cancelled' ? deviError : deviReady;

  return (
    <div className="login-page">
      <motion.div className="login-card-wrap"
        initial={reduceMotion ? false : { opacity: 0, x: -14 }}
        animate={reduceMotion ? undefined : { opacity: 1, x: 0 }}
        transition={{ duration: 0.35, ease: 'easeOut' }}>
        <Link className="login-back" to="/"><ArrowLeft size={17} aria-hidden="true" /> {t('login.back')}</Link>
        <section className="login-card" aria-labelledby="login-title">
          <p className="landing-eyebrow">{t('login.eyebrow')}</p>
          <h1 id="login-title">{t('login.title')}</h1>
          <p className="login-card__intro">{t('login.description')}</p>
          {status !== 'authenticated' && <>
            <DiscordLoginButton loading={status === 'loading'} retry={status === 'error' || status === 'cancelled'} onClick={onLogin} />
            <p id="discord-purpose" className="login-card__purpose">{t('welcome.purpose')}</p>
          </>}
          <div className="login-card__flow">
            <p>{t('login.flowTitle')}</p>
            <ol>
              <li><span aria-hidden="true">01</span>{t('login.flowOne')}</li>
              <li><span aria-hidden="true">02</span>{t('login.flowTwo')}</li>
            </ol>
          </div>
          <p id="discord-feedback" className="login-feedback" data-error={status === 'error'} role={status === 'error' ? 'alert' : 'status'}>{status === 'unavailable' && <CircleAlert size={17} aria-hidden="true" />}{feedback}</p>
        </section>
      </motion.div>
      <motion.aside className="login-aside" aria-labelledby="login-aside-title"
        initial={reduceMotion ? false : { opacity: 0, x: 14 }}
        animate={reduceMotion ? undefined : { opacity: 1, x: 0 }}
        transition={{ duration: 0.4, delay: reduceMotion ? 0 : 0.08, ease: 'easeOut' }}>
        <div className="login-aside__copy">
          <span className="login-aside__spark" aria-hidden="true">✳</span>
          <h2 id="login-aside-title"><Trans i18nKey="login.asideTitle" components={{ accent: <span className="text-accent" /> }} /></h2>
          <p>{t('login.asideDescription')}</p>
          <ul>{(['benefitOne', 'benefitTwo', 'benefitThree'] as const).map((key, index) => {
            const Icon = index === 0 ? null : benefitIcons[index - 1];
            return <li key={key}><span aria-hidden="true">{Icon ? <Icon size={16} /> : <DiscordIcon size={17} />}</span>{t(`login.${key}`)}</li>;
          })}</ul>
        </div>
        <div className="login-aside__scene" aria-hidden="true">
          <span className="login-aside__tag login-aside__tag--start">{t('login.sceneStart')}</span>
          <span className="login-aside__tag login-aside__tag--goal">{t('login.sceneGoal')}</span>
          <span className="login-aside__node login-aside__node--one" />
          <span className="login-aside__node login-aside__node--two" />
          <img src={sceneDevi} alt="" width="248" height="277" />
        </div>
      </motion.aside>
    </div>
  );
}
