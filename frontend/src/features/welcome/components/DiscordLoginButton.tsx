import { useTranslation } from 'react-i18next';
import { Button } from '../../../components/ui/Button/Button';
import { RefreshCw } from 'lucide-react';
import { DiscordIcon } from '../../../components/ui/DiscordIcon/DiscordIcon';

export function DiscordLoginButton({ loading, retry, onClick, disabled = false }: {
  loading: boolean;
  retry: boolean;
  onClick: () => void;
  disabled?: boolean;
}) {
  const { t } = useTranslation();
  return (
    <Button className="welcome__cta" isLoading={loading}
      loadingLabel={t('welcome.connecting')} onClick={onClick} disabled={disabled}
      aria-describedby="discord-purpose discord-feedback">
      {retry ? <RefreshCw size={19} aria-hidden="true" /> : <DiscordIcon size={20} aria-hidden="true" />}
      {t(retry ? 'welcome.retry' : 'welcome.continue')}
    </Button>
  );
}
