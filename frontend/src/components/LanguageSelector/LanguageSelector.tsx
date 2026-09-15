import { useTranslation } from 'react-i18next';

import { supportedLanguages } from '../../i18n';
import './LanguageSelector.css';

export function LanguageSelector() {
  const { i18n, t } = useTranslation();
  const currentLanguage = i18n.resolvedLanguage === 'en' ? 'en' : 'es';

  function handleLanguageChange(language: string) {
    if (supportedLanguages.includes(language as (typeof supportedLanguages)[number])) {
      void i18n.changeLanguage(language);
    }
  }

  return (
    <label className="language-selector">
      <span>{t('language.label')}</span>
      <select
        value={currentLanguage}
        onChange={event => handleLanguageChange(event.target.value)}
      >
        <option value="es">{t('language.spanish')}</option>
        <option value="en">{t('language.english')}</option>
      </select>
    </label>
  );
}
