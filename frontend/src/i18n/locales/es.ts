import { landingEs } from './landing.es';
import { loginEs } from './login.es';

export const es = {
  landing: landingEs,
  login: loginEs,
  welcome: {
    pageTitle: 'Tu próxima ruta',
    eyebrow: 'Tu próxima misión de aprendizaje',
    title: 'Tu próxima ruta', titleAccent: 'empieza acá.',
    description: 'Contanos qué querés aprender y te ayudaremos a construir una ruta usando cursos reales de DevTalles.',
    continue: 'Continuar con Discord', connecting: 'Conectando con Discord…', retry: 'Reintentar con Discord',
    purpose: 'Usamos Discord para identificar tu cuenta y guardar tus rutas y progreso.',
    error: 'No pudimos iniciar sesión con Discord. Podés intentarlo nuevamente.',
    cancelled: 'No se completó el inicio de sesión. Podés intentarlo cuando quieras.',
    unavailable: 'El inicio de sesión con Discord estará disponible pronto.',
    session: 'Tu sesión está activa. Preparando tu siguiente paso…',
    signature: 'Cursos reales. Un camino a tu medida.',
    journeyCaption: 'Cada paso cuenta', start: 'Inicio', foundations: 'Fundamentos', specialize: 'Especialización', goal: 'Tu meta',
    deviNote: 'Un buen punto de partida cambia todo.',
  },
  layout: {
    skip: 'Saltar al contenido', navigation: 'Navegación principal',
    openMenu: 'Menú', closeMenu: 'Cerrar menú', home: 'Inicio', catalog: 'Catálogo', myPath: 'Mi ruta',
    footer: 'Aprende a tu ritmo. Construye tu siguiente paso.',
    retry: 'Volver a intentar', loading: 'Cargando…',
    error: 'Algo salió mal', errorDescription: 'No pudimos mostrar esta sección. Inténtalo de nuevo.',
    homeDescription: 'Tu espacio para descubrir qué aprender y avanzar con una dirección clara.',
    catalogDescription: 'Explora las opciones de aprendizaje de DevTalles.',
    myPathDescription: 'Aquí podrás consultar tu ruta de aprendizaje y tus próximos pasos.',
    comingSoon: 'Estamos preparando este espacio',
    comingSoonDescription: 'Esta sección estará disponible próximamente.',
    notFound: 'Página no encontrada', notFoundDescription: 'La dirección que abriste no corresponde a una página disponible.',
    notFoundState: 'Retoma tu camino', notFoundHelp: 'Vuelve al inicio para seguir explorando.', backHome: 'Volver al inicio',
  },
  app: {
    name: 'CODE QUEST 2026',
  },
  auth: {
    profile: 'Mi perfil',
    signedInAs: 'Sesión iniciada como {{name}}',
  },
  language: {
    label: 'Idioma',
    english: 'English',
    spanish: 'Español',
  },
  status: {
    apiAndDatabaseConnected: '🟢 API y PostgreSQL conectados correctamente',
    apiLabel: 'API: {{url}}',
    apiUnavailable: '🔴 No se pudo conectar con la API',
    checking: 'Comprobando conexión con la API y PostgreSQL…',
    databaseUnavailable: '🟡 API conectada, pero PostgreSQL no responde',
    pageTitle: 'Base técnica lista para integrar',
  },
  errors: {
    apiBaseUrlMissing: 'Falta configurar la URL de la API. Revisa frontend/.env.example.',
  },
} as const;

type ToStringValues<T> = {
  [K in keyof T]: T[K] extends Record<string, unknown> ? ToStringValues<T[K]> : string;
};

export type TranslationSchema = ToStringValues<typeof es>;
