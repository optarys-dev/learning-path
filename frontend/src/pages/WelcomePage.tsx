import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { WelcomeView } from '../features/welcome/components/WelcomeView';

export function WelcomePage() {
  const { t } = useTranslation();
  useEffect(() => { document.title = `${t('welcome.pageTitle')} · CODE QUEST 2026`; }, [t]);
  return <WelcomeView />;
}
