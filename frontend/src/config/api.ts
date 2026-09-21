const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.trim();

export const apiUrl = apiBaseUrl?.replace(/\/$/, '') ?? '';
