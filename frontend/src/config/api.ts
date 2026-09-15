const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.trim();

if (!apiBaseUrl) {
  throw new Error('Falta configurar VITE_API_BASE_URL. Revisa frontend/.env.example.');
}

export const apiUrl = apiBaseUrl.replace(/\/$/, '');
