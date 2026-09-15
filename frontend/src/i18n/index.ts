import i18n from 'i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import { initReactI18next } from 'react-i18next';

import { en } from './locales/en';
import { es } from './locales/es';

export const supportedLanguages = ['es', 'en'] as const;
export type SupportedLanguage = (typeof supportedLanguages)[number];

void i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: en },
      es: { translation: es },
    },
    fallbackLng: 'es',
    supportedLngs: supportedLanguages,
    load: 'languageOnly',
    returnEmptyString: false,
    saveMissing: false,
    interpolation: {
      escapeValue: false,
    },
    detection: {
      caches: ['localStorage'],
      lookupLocalStorage: 'codequest-language',
      order: ['localStorage'],
    },
  });

i18n.on('languageChanged', language => {
  document.documentElement.lang = language;
});

export default i18n;

document.documentElement.lang = i18n.resolvedLanguage ?? "es";
