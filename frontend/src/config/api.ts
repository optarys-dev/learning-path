import i18n from '../i18n';

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.trim();

if (!apiBaseUrl) {
  throw new Error(i18n.t('errors.apiBaseUrlMissing'));
}

export const apiUrl = apiBaseUrl.replace(/\/$/, '');
