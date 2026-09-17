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
  questionnaire: {
    title: 'Crea tu perfil de aprendizaje',
    description: 'Cuéntanos qué te interesa y qué quieres construir para preparar una ruta a tu medida.',
    welcomeTitle: '¡Bienvenido!',
    welcomeLead: 'Construyamos tu camino de aprendizaje.',
    welcomeDescription: 'Responde unas preguntas breves para contarnos qué quieres aprender y desde dónde empiezas.',
    getStarted: 'Comenzar',
    stepCount: 'Paso {{current}} de {{total}}', progressLabel: 'Progreso del perfil de aprendizaje',
    stepNames: {
      learningGoal: 'Tus intereses', currentExperience: 'Tu experiencia', knownSkills: 'Lo que ya conoces',
      desiredOutcome: 'Tu objetivo', practicalExperience: 'Tu práctica',
    },
    stepHints: {
      learningGoal: 'Elige el área que más te entusiasma. Luego podrás señalar las tecnologías que te interesan.',
      currentExperience: 'No hay respuestas correctas; usaremos esto para adaptar tu punto de partida.',
      knownSkills: 'Marca solo las que ya conoces. Puedes continuar sin seleccionar ninguna.',
      desiredOutcome: 'Elige el resultado que más te gustaría conseguir primero.',
      practicalExperience: 'Esto nos ayuda a equilibrar contenido, ejercicios y proyectos.',
    },
    interestsPrompt: '¿Qué tecnologías te interesan? Puedes elegir varias o ninguna.',
    knownSkillsHint: 'Selecciona solo las que ya conoces. También puedes continuar sin marcar ninguna.',
    requiredError: 'Selecciona una opción para continuar.',
    back: 'Atrás', continue: 'Continuar', finish: 'Finalizar',
    completeEyebrow: 'Perfil completado',
    completeTitle: 'Tu perfil de aprendizaje está listo',
    completeDescription: 'Ya tenemos lo necesario para preparar tu ruta de aprendizaje.',
    editAnswers: 'Modificar mis respuestas', generatePath: 'Generar mi ruta',
    summaryArea: 'Área', summaryLevel: 'Experiencia actual', summaryOutcome: 'Objetivo',
    summaryExperience: 'Experiencia práctica',
    summaryInterests: 'Intereses', summarySkills: 'Habilidades conocidas', noneSelected: 'Ninguna seleccionada',
    questions: {
      learningGoal: '¿Qué te gustaría aprender o construir?',
      currentExperience: '¿Qué experiencia tienes actualmente?',
      knownSkills: '¿Qué tecnologías o habilidades ya conoces?',
      desiredOutcome: '¿Qué quieres conseguir?',
      practicalExperience: '¿Qué experiencia práctica tienes?',
    },
    areas: {
      frontend: 'Frontend web', backend: 'Backend', ai: 'Inteligencia Artificial', mobile: 'Desarrollo móvil',
      data: 'Datos', automation: 'Automatización', foundations: 'Fundamentos y herramientas',
    },
    areaDescriptions: {
      frontend: 'Interfaces y aplicaciones web', backend: 'APIs, servicios y servidores',
      ai: 'Prompts, agentes, RAG e IA aplicada', mobile: 'Aplicaciones móviles multiplataforma',
      data: 'SQL y PostgreSQL', automation: 'Flujos, herramientas y procesos automatizados',
      foundations: 'Programación y herramientas esenciales',
    },
    technologies: {
      react: 'React', angular: 'Angular', vue: 'Vue', nuxt: 'Nuxt', nextjs: 'Next.js', astro: 'Astro',
      qwik: 'Qwik', tailwind: 'Tailwind', 'shadcn-ui': 'Shadcn/ui', node: 'Node', nestjs: 'NestJS',
      'dotnet-csharp': '.NET / C#', 'java-spring': 'Java / Spring', python: 'Python', django: 'Django',
      fastapi: 'FastAPI', go: 'Go', php: 'PHP', laravel: 'Laravel', prompts: 'Prompts', agents: 'Agentes',
      rag: 'RAG', openai: 'OpenAI', claude: 'Claude', gemini: 'Gemini',
      'ai-assisted-development': 'Desarrollo asistido por IA', flutter: 'Flutter', dart: 'Dart',
      'react-native': 'React Native', expo: 'Expo', bloc: 'BLoC', riverpod: 'Riverpod', sql: 'SQL',
      postgresql: 'PostgreSQL', n8n: 'n8n', mcp: 'MCP', programming: 'Programación', git: 'Git',
      github: 'GitHub', docker: 'Docker', 'vs-code': 'VS Code', solid: 'SOLID',
      'design-patterns': 'Patrones de diseño',
    },
    levels: {
      none: 'Cero experiencia', basics: 'Conozco lo básico', 'small-projects': 'He realizado proyectos pequeños',
      'complete-applications': 'He desarrollado aplicaciones completas',
    },
    outcomes: {
      'build-api': 'Desarrollar una API', 'build-web-app': 'Desarrollar una aplicación web',
      'build-mobile-app': 'Desarrollar una aplicación móvil', 'applied-ai': 'Trabajar con IA aplicada',
      'build-automations': 'Crear automatizaciones', 'work-with-databases': 'Trabajar con bases de datos',
    },
    experiences: {
      none: 'Ninguna', exercises: 'Ejercicios', 'personal-projects': 'Proyectos personales',
      'complete-applications': 'Aplicaciones completas',
    },
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
