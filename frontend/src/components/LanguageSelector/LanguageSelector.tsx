import { useState } from 'react';
import { useTranslation } from 'react-i18next';

import { supportedLanguages } from '../../i18n';
import spanishFlag from '../../assets/flags/es.svg';
import englishFlag from '../../assets/flags/us.svg';
import './LanguageSelector.css';

export function LanguageSelector() {
  const { i18n, t } = useTranslation();
  const currentLanguage = i18n.resolvedLanguage === 'en' ? 'en' : 'es';
  const [isOpen, setIsOpen] = useState(false);
  const currentFlag = currentLanguage === 'es' ? spanishFlag : englishFlag;

  function handleLanguageChange(language: string) {
    if (supportedLanguages.includes(language as (typeof supportedLanguages)[number])) {
      void i18n.changeLanguage(language);
      setIsOpen(false);
    }
  }

  return (
    <div className="language-selector">
      <button className="language-selector__trigger" type="button" aria-label={t('language.label')}
        aria-expanded={isOpen} aria-haspopup="listbox" onClick={() => setIsOpen(open => !open)}>
        <img src={currentFlag} alt="" /> {currentLanguage.toUpperCase()} <span aria-hidden="true">▾</span>
      </button>
      {isOpen && <div className="language-selector__menu" role="listbox" aria-label={t('language.label')}>
        <button type="button" role="option" aria-selected={currentLanguage === 'es'} onClick={() => handleLanguageChange('es')}><img src={spanishFlag} alt="" />{t('language.spanish')}</button>
        <button type="button" role="option" aria-selected={currentLanguage === 'en'} onClick={() => handleLanguageChange('en')}><img src={englishFlag} alt="" />{t('language.english')}</button>
      </div>}
    </div>
  );
}
