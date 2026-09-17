-- Review this generated script before applying it to PostgreSQL.
-- Only untouched inferred seed rows are updated; manually revised rows are skipped.
BEGIN;
CREATE TEMP TABLE imported_course_metadata_ids (course_id bigint PRIMARY KEY) ON COMMIT DROP;
-- git-github-control-versiones-desde-cero
WITH changed AS (
  UPDATE courses SET
    description = 'Domina GIT y GitHub para gestionar y colaborar en proyectos de forma eficiente. Aprende desde lo básico hasta flujos de trabajo avanzados.',
    syllabus = 'Sección 1: Introducción a GIT y GitHub
Sección 2: Git - Fundamentos
Sección 3: Un poco más allá de los fundamentos de GIT
Sección 4: Ramas, uniones, conflictos y tags
Sección 5: Git stash y rebase
Sección 6: Inicios en GitHub, Git remote, push & pull
Sección 7 - GitHub Básico
Sección 8 - GitHub real en el día a día
Sección 9 - Issues, Milestones y colaboradores
Sección 10 - Wikis, Proyectos y GitHub Pages
Sección 11: GitHub Actions y Workflows
Sección 12 - Organizaciones y equipos
Sección 13 - Gists
Fin del curso',
    learning_outcomes = ARRAY['Dominarás Git para controlar el historial y la evolución de tus proyectos.', 'Aprenderás a trabajar con GitHub utilizando flujos de trabajo profesionales.', 'Podrás colaborar con otros desarrolladores de forma segura y organizada.', 'Contarás con una habilidad indispensable para cualquier desarrollador o profesional del área tecnológica.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['No es necesario conocimiento alguno de Git', 'No es necesario conocimiento sobre GitHub', 'Navegación básica en el powershell o terminal es recomendada pero no necesaria', 'Se puede seguir el curso en Windows, OSX o Linux sin problemas']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 690,
    metadata_source_url = 'https://cursos.devtalles.com/courses/git-github-control-versiones-desde-cero',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'git-github-control-versiones-desde-cero'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- golang-backend-profesional
WITH changed AS (
  UPDATE courses SET
    description = 'Construye APIs REST profesionales en Go desde cero con un proyecto real desplegado en producción con criterio profesional.',
    syllabus = 'Sección 1: Bienvenida al curso
Sección 2: Setup entorno profesional
Sección 3: HTTP en Go
Sección 4: Middlewares para logs en Go
Sección 5: JSON y validadores
Sección 6: Errores y contratos de API
Sección 7: Patrones de diseño aplicados a Go Backend
Sección 8: Arquitectura limpia aplicada a Go
Sección 9: Arquitectura limpia aplicada a Go - Task module
Sección 10: Base de datos - Configuraciones y migraciones
Sección 11: Base de datos - Repositorios Postgres
Sección 12: Autenticación y autorización - Redis, Argon2id y JWT
Sección 13: Autenticación y autorización - Use case y Handler
Sección 14: Autenticación y autorización - Middlewares, auth, CORS y security headers
Sección 15: Devboard - Modelado de datos
Sección 16: Devboard - Repository y Use case
Sección 17: Devboard - Handler y rutas
Sección 18: Despedida del curso',
    learning_outcomes = ARRAY['Construirás APIs y aplicaciones Backend profesionales utilizando Go de forma nativa.', 'Comprenderás cómo diseñar aplicaciones escalables aplicando arquitectura limpia y buenas prácticas.', 'Estarás preparado para trabajar en proyectos profesionales o migrar fácilmente a cualquier framework del ecosistema Go.', 'Contarás con las habilidades necesarias para postularte a posiciones como Backend Developer, Go Developer o Software Engineer.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Fundamentos de Golang, si aun no tienes esta base, te invitamos a que tomes el curso Golang: fundamentos del leguaje', 'Bases de datos estructuradas', 'Conocimiento en SQL', 'Git y Github', 'PostgreSQL (deseable)']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1530,
    metadata_source_url = 'https://cursos.devtalles.com/courses/golang-backend-profesional',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'golang-backend-profesional'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- laravel-ai
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a construir una API REST profesional con Laravel desarrollando una Movie API completa desde cero. Dominarás CRUD, JWT, el Repository Pattern, la caché, el versionado y mucho más, aplicando las buenas prácticas utilizadas en proyectos reales.',
    syllabus = 'Sección 1: Introducción
Sección 2: Creación de proyecto y estructura
Sección 3: Creación de género
Sección 4: Patrón repositorio y pruebas
Sección 5: API género: búsqueda, filtrado y restauración
Sección 6: API Película
Sección 7: API usuario, autenticación y JWT
Sección 8: CORS
Sección 9: Autorización y protección de rutas
Sección 10: Caché
Sección 11: Versionamiento de la API
Sección 12: Subida de imágenes
Sección 13: Paginación y manejo de excepciones
Sección 14: IA en Laravel
Sección 15: Despliegue en Railway
Sección 16: Fin de curso',
    learning_outcomes = ARRAY['Desarrollarás una API REST profesional utilizando Laravel y las mejores prácticas del ecosistema.', 'Aprenderás a estructurar proyectos escalables con una arquitectura limpia y mantenible.', 'Integrarás autenticación, documentación, testing e Inteligencia Artificial dentro de una misma aplicación.', 'Desplegarás tu API en producción y contarás con un proyecto sólido para tu portafolio profesional.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de programación o lógica de programación serán útiles.', 'Experiencia previa en PHP; aprenderás el uso de Laravel no acerca del lenguaje PHP.', 'Tener instalado un editor de código, preferiblemente Visual Studio Code.', 'Ganas de aprender y practicar escribiendo código durante el curso.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 810,
    metadata_source_url = 'https://cursos.devtalles.com/courses/laravel-ai',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'laravel-ai'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- spring-ai
WITH changed AS (
  UPDATE courses SET
    description = 'Integra inteligencia artificial en Java con Spring AI 2.x. Construye un asistente médico educativo completo: Tool Calling, RAG, memoria persistente y agentes inteligentes. Del chatbot básico al deploy en AWS. Stack: Java 21, Spring Boot 4, Gemini.',
    syllabus = 'Sección 1: Introducción
Sección 2: Fundamentos de LLMs y Spring AI
Sección 3: Proyecto, configuración y primera llamada
Sección 4: Portabilidad de Modelos
Sección 5: Context Engineering: Prompts, Templates y System Prompt
Sección 6: Structured Outputs
Sección 7: Tools: Funciones, Keycloak y APIs Externas
Sección 8: Memoria, RAG y Advisors
Sección 9: Agentes: de Workflows y Autonomía
Sección 10: MCP: Cliente y Servidor
Sección 11: AWS: de Localhost a Producción
Sección 12: Fin de curso',
    learning_outcomes = ARRAY['Comprenderás cómo integrar modelos de IA dentro del ecosistema Spring utilizando Spring AI.', 'Desarrollarás agentes inteligentes con memoria, Tool Calling, RAG y MCP.', 'Aprenderás a construir aplicaciones listas para producción utilizando Docker y AWS.', 'Tendrás un proyecto completo desplegado que podrás utilizar como parte de tu portafolio profesional.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Haber completado un curso de Java y Java Avanzado o dominar la programación funcional en Java.', 'Tener conocimientos previos de Spring Boot.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1110,
    metadata_source_url = 'https://cursos.devtalles.com/courses/spring-AI',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'spring-ai'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- open-code-guia-completa
WITH changed AS (
  UPDATE courses SET
    description = 'OpenCode, el agente de IA open source para programar desde la terminal: instalación, CLI, configuración, agentes personalizados, MCP y flujos de trabajo. Un curso práctico y orientado a proyectos reales.',
    syllabus = 'Sección 1: Introducción
Sección 2: OpenCode - Instalación y configuraciones
Sección 3: OpenCode 101 - Primeros pasos
Sección 4: Aplicación de consola
Sección 5: Worktrees y comandos personalizados
Sección 6: Spec Driven Development / Design
Sección 7: MCPs y Agentes personalizados
Sección 8: Maquetación de OpenDayCare
Sección 9: Referencias, esquemas y Supabase
Sección 10: Automatizaciones y agentes en paralelo
Sección 11: Metodologías Grill Me y OpenSpec
Sección 12: Producción
Sección 13: Fin del curso',
    learning_outcomes = ARRAY['Integrarás OpenCode de forma profesional dentro de tu flujo de trabajo diario.', 'Aprenderás a utilizar agentes, MCPs y automatizaciones para aumentar tu productividad.', 'Desarrollarás aplicaciones reales utilizando IA durante todo el ciclo de desarrollo.', 'Comprenderás cómo diseñar procesos modernos con Specs verificables, automatizaciones y despliegues listos para producción.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Poder realizar instalaciones en el equipo (Node, Bun, entre otras por ejemplo)', 'Cuenta gratuita en GitHub para seguir los ejercicios prácticos con repositorios reales.', 'Opcional - Conocimientos básicos de JavaScript/TypeScript y desarrollo web (no se requiere experiencia previa con IA).', 'Opcional - Manejo básico de la terminal y comandos de Git.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 840,
    metadata_source_url = 'https://cursos.devtalles.com/courses/open-code-guia-completa',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'open-code-guia-completa'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- claude-code-guia-completa
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a usar Claude Code sin importar si ya lo has usado antes. Desde la instalación y flujos de trabajo diarios, hasta personalización con CLAUDE.md, conexión a servicios externos vía MCP, automatización con hooks y mucho más.',
    syllabus = 'Sección 1: Introducción
Sección 2: Instalación y consumo de tokens
Sección 3: ClaudeCode con modelos de Ollama
Sección 4: Fundamentos - ClaudeCode 101
Sección 5: Fundamentos - Flujo de trabajo
Sección 6: Avanzado - Batch - Worktrees
Sección 7: Intermedio - Spec Driven Design
Sección 8: Intermedio - Skills y Playwright MCP
Sección 9: Intermedio - Hooks y MCPs
Sección 10: Intermedio - Skills y comandos basados en Specs
Sección 11: Avanzado - Agentes - Patrón Orquestador/Trabajador
Sección 12: Avanzado - Skill con agentes + rutinas
Sección 13: Intermedio - Autenticación y seguridad
Sección 14: Intermedio - Skills, Plugins y utilidades
Sección 15: Avanzado - Producción
Sección 16: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Experiencia básica de programación (no hace falta ser experto).', 'Una suscripción a Claude Code para seguir las prácticas paso a paso. (Se enseña Ollama para seguir el curso gratis en su mayoría)', 'Conocimientos básicos de Git y línea de comandos son recomendables pero no obligatorios.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1050,
    metadata_source_url = 'https://cursos.devtalles.com/courses/claude-code-guia-completa',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'claude-code-guia-completa'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- ia-para-developers
WITH changed AS (
  UPDATE courses SET
    description = 'Construye un agente de IA desde cero con Claude API, RAG y function calling en Node.js. Sin frameworks, sin magia: solo Anthropic SDK, OpenAI para embedding y SQLite. Pasa de tu primera llamada a la API a un asistente desplegable en producción.',
    syllabus = 'Sección 1: Introducción
Sección 2: Setup y fundamentos
Sección 3: Tu primera integración con Claude API
Sección 4: Function Calling: cuando Claude necesita hacer cosas
Sección 5: RAG: dale conocimiento a tu aplicación (OpenAI)
Sección 6: Construyendo un agente: todo junto
Sección 7: De demo a producción: lo que nadie te enseña
Sección 8: Despliegue en GitHub Codespaces
Sección 9: Fin de curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Programación para principiantes - Primeros pasos.', 'TypeScript: Tu completa guía y manual de mano.', 'Ingeniería de prompts: Para la vida real (Opcional).']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 480,
    metadata_source_url = 'https://cursos.devtalles.com/courses/ia-para-developers',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'ia-para-developers'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- python-ia-aplicada
WITH changed AS (
  UPDATE courses SET
    description = 'Curso práctico de Python aplicado a IA: crea agentes, domina prompts, usa OpenAI, implementa RAG, orquesta con LangChain y despliega con FastAPI. Aprende a llevar IA real a producción con proyectos útiles.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Fundamentos
Sección 3: Prompts para desarrolladores
Sección 4: Técnicas de Prompts avanzados (JSON, Function calling)
Sección 5: Memoria y Contexto - RAG (Retrieval Augmented Generation)
Sección 6: Proyecto - RAG - Chatea con PDFs
Sección 7: Introducción a LangChain
Sección 8: LangChain memoria persistente
Sección 9: LangChain + RAG
Sección 10: LangGraph
Sección 11: Despedida del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Python Fundamentos (Básico-Intermedio o intermedio)', 'Fundamentos de bases de datos.', 'Ingeniería de prompts (Deseable, no obligatorio)']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1110,
    metadata_source_url = 'https://cursos.devtalles.com/courses/python-ia-aplicada',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'python-ia-aplicada'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- spring-boot-patrones-arquitectura
WITH changed AS (
  UPDATE courses SET
    description = 'Lleva tu nivel de Spring Boot de CRUD a arquitectura profesional. Construye Atlas-Bank: un proyecto que aplica SOLID, patrones GoF, DDD, arquitectura hexagonal, Keycloak, ArchUnit y AI como cliente. Clases cortas y con código real.',
    syllabus = 'Sección 1: Introducción
Sección 2: Los cimientos: por qué la arquitectura importa
Sección 3: Arquitectura en capas con criterio
Sección 4: Seguridad con Keycloak
Sección 5: Patrones que organizan la lógica
Sección 6: Patrones que Conectan las Piezas
Sección 7: Domain-Driven Design Táctico
Sección 8: Arquitectura Hexagonal: Migración
Sección 9: Arquitectura Hexagonal: Desde cero
Sección 10: CQRS Liviano
Sección 11: ArchUnit y Testing de Dominio Puro
Sección 12: AI y Arquitectura
Sección 13: Fin de curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento en Java y Spring Boot']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1230,
    metadata_source_url = 'https://cursos.devtalles.com/courses/spring-boot-patrones-arquitectura',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'spring-boot-patrones-arquitectura'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- ingenieria-de-prompts
WITH changed AS (
  UPDATE courses SET
    description = 'Este es un curso donde aprenderás Prompt Engineering de forma simple, práctica y sin tecnicismos, para que puedas escribir mejores prompts y obtener excelentes resultados con herramientas de inteligencia artificial como ChatGPT, Claude, Gemini y más.',
    syllabus = 'Sección 1: Introducción
Sección 2: Prompts y estrategias iniciales
Sección 3: Contexto y persona
Sección 4: Técnicas avanzadas - ACHIEVE Framework
Sección 5: Técnicas avanzadas de pensamiento
Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['No se necesita experiencia previa. Solo necesitas curiosidad y ganas de aprender a trabajar mejor con la IA.', 'No se requiere experiencia en programación ni conocimientos técnicos.', 'Este curso fue diseñado desde cero para que cualquier persona.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 150,
    metadata_source_url = 'https://cursos.devtalles.com/courses/Ingenier%C3%ADa-de-prompts',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'ingenieria-de-prompts'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- vibe-coding
WITH changed AS (
  UPDATE courses SET
    description = 'Crearás aplicaciones reales usando IA como desarrollador, pero con criterio profesional. Aprenderás autenticación, carga de archivos, integración con Supabase y buenas prácticas y seguridad para llevar tus proyectos a producción con confianza.',
    syllabus = 'Sección 1: Introducción
Sección 2: Iniciando en Vibe Coding
Sección 3: Funcionalidades, investigaciones y multi-idioma
Sección 4: Autenticación y autorización
Sección 5: Crear propiedades y carga de archivos
Sección 6: Cierre del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Opcional - Tener conocimientos básicos de programación y comprensión general de cómo funciona una aplicación web.', 'Poder realizar instalaciones en el equipo']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 270,
    metadata_source_url = 'https://cursos.devtalles.com/courses/vibe-coding',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'vibe-coding'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- golang-fundamentos-lenguaje
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende Golang desde cero, profesional y con buenas prácticas. Tipado estático, paquetes, funciones, structs, interfaces, errores y concurrencia. Ejemplos reales para código limpio y listo para desplegar, ideal si vienes de JS/Python/PHP y más.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Introducción a Go
Sección 3: Fundamentos de Go
Seccion 4: Tipos compuestos de datos
Sección 5: Estructuras de control
Sección 6: Funciones
Sección 7: Funciones - continuación
Sección 8: Punteros
Sección 9: Tipos, métodos e interfaces
Sección 10: Generics
Sección 11: Manejo de errores
Sección 12: Módulos, paquetes e imports
Sección 13: Goroutines y Go Channels
Sección 14: Despedida del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Tener conocimientos de programación básica', 'Conocer al menos un lenguaje de programación aunque no se domine el lenguaje (opcional pero útil)', 'Git y GitHub']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1380,
    metadata_source_url = 'https://cursos.devtalles.com/courses/golang-fundamentos-lenguaje',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'golang-fundamentos-lenguaje'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- php-moderno
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende PHP moderno desde cero y con buenas prácticas. Domina fundamentos, control de flujo, funciones, POO, Composer, APIs y base de datos, hasta desplegar tu primer backend real y listo para producción. Ideal para iniciar tu camino profesional.',
    syllabus = 'Sección 1: Introduction
Sección 2: Fundamentos de PHP moderno
Sección 3: Control de flujo
Sección 4: Arrays y funciones útiles
Sección 5: Manejo básico de errores
Sección 6: Funciones e incluir archivos
Sección 7: Programación Orientada a Objetos (POO)
Sección 8: Composer
Sección 9: Backend práctico: API simple
Sección 10: API productos
Sección 11: Base de datos con MariaDB
Sección 12: Introducción a Laravel
Sección 13: Despliegue en producción
Sección 14: Fin de curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Programación para principiantes primeros pasos (opcional)', 'No se requiere experiencia previa en PHP; aprenderás el lenguaje paso a paso desde los fundamentos.', 'Conocimientos básicos de programación o lógica de programación serán útiles, pero no obligatorios.', 'Tener instalado un editor de código, preferiblemente Visual Studio Code.', 'Ganas de aprender y practicar escribiendo código durante el curso.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 600,
    metadata_source_url = 'https://cursos.devtalles.com/courses/PHP-moderno',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'php-moderno'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- spring-boot-microservicios
WITH changed AS (
  UPDATE courses SET
    description = 'Domina microservicios con Spring Boot 4: arquitectura de capas, MongoDB, Docker, Kubernetes, comunicación entre servicios, resiliencia, seguridad OAuth2, observabilidad y patrones enterprise. Proyecto e-commerce con buenas prácticas de producción.',
    syllabus = 'Sección 1: Introducción
Sección 2: Fundamentos de Arquitectura y Ecosistema
Sección 3: Product Service - Construcción del Núcleo
Sección 4: Comunicación Síncrona entre Microservicios: Order & Inventory
Sección 5: Config Server (Centralización)
Sección 6: Service Discovery & API Gateway
Sección 7: Seguridad con Keycloak
Sección 8: Resiliencia y Límites de la Sincronía en Arquitecturas Distribuidas
Sección 9: Arquitectura Orientada a Eventos & Sagas (RabbitMQ)
Sección 10: Resiliencia de Datos y Alto Rendimiento
Sección 11: Observabilidad Total en Microservicios con LGTM Stack y OpenTelemetry
Sección 12: De Docker Compose a Kubernetes: Deploy Completo en Producción
Sección 13: Fin de curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos sólidos de Java y POO: manejo fluido de clases, interfaces, herencia y excepciones.', 'Experiencia previa con Spring Boot: familiaridad con controladores REST, JPA, validaciones y conceptos básicos de Spring Security.', 'Docker (no excluyente): comprensión general de qué es un contenedor, cómo ejecutar una imagen y cómo interpretar un archivo docker-compose.yml.', 'SQL y bases de datos relacionales: conocimiento de tablas, relaciones y consultas básicas.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1260,
    metadata_source_url = 'https://cursos.devtalles.com/courses/spring-boot-microservicios',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'spring-boot-microservicios'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- angular-sockets-bun
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a crear y configurar aplicaciones en tiempo real usando la implementación nativa de websockets junto a un backend en Bun.',
    syllabus = 'Sección 1: Introducción
Sección 2: Primeros pasos en los WebsSockets
Sección 3: Backend - Partidos políticos
Sección 4: Angular - Partidos políticos
Sección 5: Backend - Mapas y movimientos
Sección 6: Angular - Mapas en tiempo real
Sección 7: Backend - Sistema de colas
Sección 8: Angular - Sistema de colas
Sección 9: Backend - Chat - Seguridad
Sección 10: Backend - Chat con mensajes privados - Websockets
Sección 11: Mensajes privados y usuarios conectados
Sección 12: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de JavaScript o TypeScript (variables, funciones, async/await).', 'Conocimientos básicos de Angular.', 'Poder realizar instalaciones en el equipo (editor de código, extensiones y Bun)', 'Ganas de practicar: vamos a construir varios proyectos y probar con múltiples navegadores.', 'No necesitas experiencia previa con WebSockets ni con Bun.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 870,
    metadata_source_url = 'https://cursos.devtalles.com/courses/Angular_socket_bun',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'angular-sockets-bun'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- react-sockets
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a crear y configurar aplicaciones en tiempo real usando la implementación nativa de websockets junto a un backend en Bun.',
    syllabus = 'Sección 1: Introducción
Sección 2: Primeros pasos en los WebsSockets
Sección 3: Backend - Partidos políticos
Sección 4: React - Partidos políticos
Sección 5: Backend - Mapas y movimientos
Sección 6: Mapas en tiempo real
Sección 7: Backend - Sistema de colas
Sección 8: React - Sistema de colas
Sección 9: Backend - Chat - Seguridad
Sección 10: Backend - Chat con mensajes privados - Websockets
Sección 11: Mensajes privados y usuarios conectados
Sección 12: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de JavaScript o TypeScript (variables, funciones, async/await).', 'Conocimientos básicos de React (componentes, props, estado y hooks).', 'Poder realizar instalaciones en el equipo (editor de código, extensiones y Bun)', 'Ganas de practicar: vamos a construir varios proyectos y probar con múltiples navegadores.', 'No necesitas experiencia previa con WebSockets ni con Bun.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 900,
    metadata_source_url = 'https://cursos.devtalles.com/courses/react-sockets',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'react-sockets'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- tailwindcss-para-desarrolladores
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a usar Tailwind CSS orientado a desarrolladores, para crear diseños responsivos y modernos, evitando usar JavaScript para esto.',
    syllabus = 'Sección 1: Introducción
Sección 2: TailwindCSS - Primeros pasos
Sección 3: TailwindCSS localmente + Recomendaciones oficiales
Sección 4: Pseudo-classes
Sección 5: Tema y configuraciones
Sección 6: Despedida',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico sobre CSS, si se conoce sobre MediaQueries mucho mejor.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 240,
    metadata_source_url = 'https://cursos.devtalles.com/courses/tailwindcss-para-desarrolladores',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'tailwindcss-para-desarrolladores'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- python-n8n-automatiza-rutinas
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a utilizar Python para tus proyectos de automatización cotidiana o para tus proyectos personales. Aprende conceptos n8n, crea scripts de automatización, servicios simples con FastAPI, manipulación de datos, Scraping y mucho más.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Fundamentos de N8N
Sección 3: n8n y Python
Sección 4: n8n y Python usando nodo HTTPRequest
Sección 5: Proyecto - Convertidor de imagen a Webp
Sección 6: Proyecto - Email Detox
Sección 7: Proyecto - Eliminar duplicados de carpeta local
Sección 8: Despedida del curso',
    learning_outcomes = ARRAY['Capacidad para automatizar cualquier tarea repetitiva de tu trabajo o vida diaria.', 'Habilidad para ofrecer servicios de automatización como freelancer o aportar alto valor en tu empresa.', 'Estar preparado para dar el siguiente paso lógico: la integración de flujos avanzados de automatización con Inteligencia Artificial (Agentes y LLMs) .']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos de Python a nivel básico o intermedio (requerido)', 'Fundamentos de n8n (deseable)', 'Conocimientos básicos de FastAPI (opcional)']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 540,
    metadata_source_url = 'https://cursos.devtalles.com/courses/python-n8n-automatiza-rutinas',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'python-n8n-automatiza-rutinas'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- springboot-mvc-hexagonal
WITH changed AS (
  UPDATE courses SET
    description = 'Programa intensivo de Diseño de Software con Spring Boot. Aprenderás a crear apps modulares y resilientes con Arquitectura Hexagonal. Usaremos una migración de JPA a MongoDB para mostrar el acoplamiento y aplicar Inversión de Dependencias.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: El Modelo MVC Backend
Sección 3: Migrando a MongoDB - El problema del acoplamiento
Sección 4: La arquitectura hexagonal - Construyendo la resiliencia
Sección 5: Introducción a los Microservicios
Sección 6: Fin de curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Este no es un curso introductorio a Java ni a Spring Boot. Está pensado para desarrolladores que ya cuentan con experiencia previa en desarrollo backend y desean profundizar en arquitectura de software y diseño de proyectos.', 'Para aprovechar el curso, es importante que tengas:', 'Conocimientos básicos de Java', 'Bases sólidas de Programación Orientada a Objetos', 'Uso básico de programación funcional (lambdas, streams, Optional)', 'Experiencia previa construyendo APIs REST', 'Familiaridad con controladores, servicios, DTOs y persistencia', 'No es obligatorio que sea con Spring Boot; puede ser con Node.js, NestJS u otro framework backend', 'Conocimientos generales de bases de datos', 'No es necesario ser experto, pero sí entender qué significa persistir información', '¿Aún no dominas Java?', 'Te recomendamos seguir nuestra Ruta de Aprendizaje de Java antes de avanzar a este curso.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 510,
    metadata_source_url = 'https://cursos.devtalles.com/courses/springboot-mvc-hexagonal',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'springboot-mvc-hexagonal'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- net-pruebascompletas
WITH changed AS (
  UPDATE courses SET
    description = 'Este curso te enseña a crear pruebas automatizadas para Minimal APIs en .NET de forma práctica y directa. Aprenderás a validar comportamientos, estructurar servicios y asegurar la calidad de tus aplicaciones desde el inicio.',
    syllabus = 'Sección 1: Introducción
Sección 2: Introducción a pruebas - Parte 1
Sección 3: Introducción a pruebas - Parte 2
Sección 4: Creación de proyecto Minimal API
Sección 5: Pruebas unitarias a la minimal API
Sección 6: Pruebas de Integración con WebApplicationFactory
Sección 7: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de C# y .NET, no es necesario ser experto.', 'Nociones básicas de programación, como variables, condicionales y bucles.', 'Tener instalado Visual Studio Code y .NET 8, el curso guía paso a paso todo el proceso de configuración.', 'Interés en aprender pruebas automatizadas y buenas prácticas, con disposición para practicar y aplicar los conceptos en ejemplos reales.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 360,
    metadata_source_url = 'https://cursos.devtalles.com/courses/net-pruebascompletas',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'net-pruebascompletas'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- nuxt
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende Nuxt.js, el framework basado en Vue.js para crear aplicaciones web rápidas, modernas y optimizadas para SEO, desde los fundamentos hasta el despliegue con SSR, SSG y API Routes.',
    syllabus = 'Sección 1: Introducción
Sección 2: Reforzamiento sobre Vue.js
Sección 3: Nuxt - Primeros pasos
Sección 4: NuxtUI - Estructuras y componentes
Sección 5: Nuxt - Server API - PostgreSQL
Sección 6: Server Endpoints y paginación
Sección 7: Autenticación y autorización
Sección 8: Administración de productos y carga de archivos
Sección 9: Carga de archivos
Sección 10: Maestro detalle - Reseñas de productos
Sección 11: Despliegues a producción
Sección 12: Despedida',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de JavaScript y/o TypeScript.', 'Idealmente haber usado alguna vez Vue.js, aunque el curso incluye un reforzamiento completo.', 'Tener instalado Node.js y un editor de código como VSCode.', 'No se necesita experiencia previa con Nuxt; el curso cubre conceptos desde cero y avanza hasta nivel profesional.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 810,
    metadata_source_url = 'https://cursos.devtalles.com/courses/nuxt',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'nuxt'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- netfullstack
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende desarrollo web Fullstack con C# y .NET Core. Domina Clean Architecture, Blazor Server y WebAssembly, CQRS con MediatR, EF Core, ASP.NET Core Identity, autenticación, autorización por roles, SQL Server, Tailwind CSS y QuickGrid en un proyecto.',
    syllabus = 'Sección 1: Introducción
Sección 2: Breve introducción a C# y fundamentos esenciales para .NET (Opcional)
Sección 3: Creación del Proyecto
Sección 4: Arquitectura limpia
Sección 5: Capa de infraestructura: Base de datos y entity framework
Sección 6: Introducción a CQRS y al patrón mediador
Sección 7: CRUD con CQRS y Blazor SSR
Sección 8: Mejoras experiencia de usuario y desarrollador
Sección 9: Incluyendo Tailwind y mejorando el estilo en la capa de presentación
Sección 10: Autenticación con ASP.NET Core Identity y Google
Sección 11: Autorización mediante roles con ASP.NET Core Identity
Sección 12: Gestión de usuarios con interactividad con blazor server
Sección 13: Gestión de notas Interactividad con Blazor WebAssembly
Sección 14: Reemplazar MediatR
Sección 15: Desplegar en AWS
Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Necesitas dominio de los fundamentos de C#', 'Haber completado nuestros cursos introductorios de C# y .NET Backend te dará la base ideal para avanzar de forma más cómoda y aprovechar al máximo este curso.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 840,
    metadata_source_url = 'https://cursos.devtalles.com/courses/netfullstack',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'netfullstack'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- fastapi
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a crear APIss modernas, seguras y rápidas con Python, Pydantic, JWT, WebSockets, Webhooks Bases de datos, subida de archivos, tests, despliegue, tareas asíncronas, seguridad, proyectos reales y mucho más.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Fundamentos de Python
Sección 3: Introducción a FastAPI y primeros pasos
Sección 4: Tipado, validaciones y Pydantic
Sección 5: Validación de parámetros y queries
Sección 6: Bases de datos relacionales con FastAPI (SQLAlchemy)
Sección 7: Arquitectura y modularización del proyecto
Sección 8: Dependencias, seguridad y JWT
Sección 9: Funciones síncronas y asíncronas
Sección 10: Manejo de archivos
Sección 11: Proyecto - Tags
Sección 12: Proyecto - Users
Sección 13: Proyecto - Categorías
Sección 14: Proyecto - Seeds y slug para Post
Sección 15: Middlewares
Sección 16: SQLModel - Modelos y Schemas - Devinote
Sección 17: SQLModel - Servicios y rutas - Devinote
Sección 18: Migraciones con Alembic y PostgreSQL
Sección 19: Desplegando aplicación con Render
Sección 20: Despedida del curso
Bonus - WebSockets
Bonus - Webhooks',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Python básico', 'SQL Básico', 'Control de versiones con Git']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2160,
    metadata_source_url = 'https://cursos.devtalles.com/courses/fastapi',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'fastapi'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- spring-boot
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende Spring Boot desde cero: inicia con Spring MVC y Thymeleaf creando un sitio web dinámico con JdbcTemplate y controladores básicos. Luego desarrolla un API REST con seguridad, JPA, relaciones en BD y buenas prácticas MVC.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Introducción a Spring boot
Sección 3: Introducción a HTML
Sección 4: Introducción a CSS
Sección 5: Spring Boot y Persistencia con JdbcTemplate: La Base del Portfolio
Sección 6: Validator, Excepciones globales y Transacciones
Sección 7: Pruebas unitarias y de integración
Sección 8: Portfolio dinámico con Thymeleaf
Sección 9: Project, DTO, MultipartFile y validaciones
Sección 10: Adaptando el modelo con el pátron DTO - Completando los CRUD
Sección 11: Spring Security: Autenticación, Autorización y Protección con CSRF
Sección 12: API - Arquitectura y CRUD de Eventos
Sección 13: Implementación de la seguridad con JWT
Sección 14: Optimización de Consultas y Gestión Avanzada de Relaciones JPA
Sección 15: CORS y el problema N + 1
Sección 16: Introducción a los test unitarios y de integración
Sección 17: Camino a Producción: Postgres - OpenAPI - Logger - Docker y render.com
Sección 18: Despedida del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Idealmente: conocimientos en Java (nivel inicial y avanzado).', 'Mínimo indispensable: Java inicial y fundamentos de programación funcional.', 'De lo contrario, el curso podría resultar muy desafiante.', '¿Aún no dominas Java?', 'Te recomendamos seguir nuestra Ruta de Aprendizaje de Java antes de avanzar a este curso.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2130,
    metadata_source_url = 'https://cursos.devtalles.com/courses/spring-boot',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'spring-boot'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- n8n-mcp
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a crear automatizaciones poderosas con n8n: desde flujos simples con Google Sheets y correos, hasta proyectos avanzados con lógica, manejo de errores y agentes de IA usando MCPs, tanto localmente como en la nube.',
    syllabus = 'Sección 1: Introducción
Sección 2: Fundamentos e instalación de n8n
Sección 3: Introducción a n8n - Mi primer flujo de trabajo
Sección 4: Opcional (Usuario técnico) - Google Cloud - Cargar Flujos
Sección 5: Formularios y decisiones
Sección 6: Opcional (Usuario técnico) - PostgreSQL y ciclos (Loops)
Sección 7: Solicitud de vacaciones y días de enfermedad
Sección 8: Opcional (Usuario técnico) - WebHooks
Sección 9: Extraer información de sitios web - Scraping
Sección 10: Workflows - Scraping - Google Maps e información de contacto
Sección 11: Introducción a los agentes de AI, Chatbots y modelos locales
Sección 12: Agentes con herramientas - Tools y MCP Servers
Sección 13: Usuario Técnico - Agentes de AI contra backends personalizados
Sección 14: Tipos de autenticación en n8n
Sección 15: Sistemas RAG - Consultas a bases de conocimiento
Sección 16: Agentes de voz con herramientas
Sección 17: Telegram Bots
Sección 18: Whatsapp Bots
Sección 19: Despliegues alternativos y consideraciones
Sección 20: Manejo de errores y logs
Sección 21: Despedida',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['No se necesita experiencia previa en automatización o IA, el curso comienza desde lo básico y avanza paso a paso.', 'Conocimientos básicos de informática y manejo de aplicaciones en la web son recomendables, pero no obligatorios.', 'Contar con un ordenador e internet estable para instalar n8n localmente o trabajar en su versión web.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1050,
    metadata_source_url = 'https://cursos.devtalles.com/courses/n8n-mcp',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'n8n-mcp'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- react-de-cero
WITH changed AS (
  UPDATE courses SET
    description = 'En este curso de React aprenderás desde los fundamentos de la librería hasta aspectos técnicos avanzados y despliegues, incorporando librerías adicionales ampliamente utilizadas en la industria. Todo el contenido está basado en TypeScript.',
    syllabus = 'Sección 1 - Introducción
Sección 2 - Introducción a React y conceptos generales
Sección 3 - Reforzamiento JavaScript / TypeScript
Sección 4 - Primeros pasos en React
Sección 5 - Pruebas automáticas - Unit testing
Sección 6 - GifExpertApp - Aplicación
Sección 7 - Optimización y despliegue
Sección 8 - Testing - Pruebas sobre GifsApp
Sección 9 - Profundizando Hooks y React
Sección 10 - Profundizando Hooks - useReducer
Sección 11 - Memorización y optimizaciones
Sección 12 - Use Context
Sección 13 - Single Page Application - SPA
Sección 14 - Funcionalidad, caché y optimizaciones
Sección 15 - Context API - Búsquedas y favoritos
Sección 16 - Testing HeroesApp
Sección 17 - Desplegar aplicación
Sección 18 - Panel administrativo de productos
Sección 19 - Productos y Backend
Sección 20 - Auth
Sección 21 - Formularios y productos
Sección 22 - Carga de archivos
Sección 23 - Punto de control
Sección 24: MERN Calendar - Estructura y Diseño
Sección 25: CalendarApp - Backend - Node, Express, Mongo
Sección 26: Backend - Eventos del calendario - CRUD
Sección 27: Despliegue del backend a la nube
Sección 28: MERN - Calendario + Backend
Sección 29: MERN CRUD - Eventos del calendario
Sección 30: Fin el MERN - Desplegarlo a producción',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de JavaScript es necesario', 'Conocimiento básico de programación es necesario', 'Poder realizar instalaciones en el equipo como administrador', 'Pueden seguir el curso en OSX (Mac), Windows o Linux', 'Estar dispuesto a realizar las tareas y ejercicios adicionales']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2760,
    metadata_source_url = 'https://cursos.devtalles.com/courses/react-de-cero',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'react-de-cero'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- expo-gemini
WITH changed AS (
  UPDATE courses SET
    description = 'En este curso aprenderás a integrar la inteligencia artificial de Gemini usando la librería oficial y conectándola, a través de un backend personalizado, con nuestra aplicación de Expo.',
    syllabus = 'Sección 1: Introducción
Sección 2: Creación y explicación del UI - Opcional
Sección 3: Backend - NestJS
Sección 4: Consulta básica - React Native
Sección 5: Backend - Stream Response
Sección 6: Frontend - Stream Response
Sección 7: Backend - Recibir archivos y retornar stream
Sección 8: Frontend - Enviar archivos
Sección 9: Backend - Contexto conversacional
Sección 10: Frontend - Contexto conversacional
Sección 11: Backend - Generación y edición de imágenes
Sección 12: Frontend - Generación y edición de imágenes
Sección 13: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de JavaScript o TypeScript.', 'Experiencia previa con React Native o React.', 'Tener los simuladores un un dispositivo físico para probar la aplicación.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 420,
    metadata_source_url = 'https://cursos.devtalles.com/courses/expo-gemini',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'expo-gemini'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- java-avanzado
WITH changed AS (
  UPDATE courses SET
    description = 'Lleva tu conocimiento de Java al siguiente nivel: código limpio, funcional y concurrente. Streams, RxJava, bases de datos, patrones, excepciones y más. Incluye proyectos prácticos y bonus de Spring MVC. Ideal para desarrolladores exigentes.',
    syllabus = 'Sección 1: Introducción
Sección 2: Genéricos: Tipos flexibles y reutilizables
Sección 3: Repaso del patrón MVC y Lombok
Sección 4: Programación funcional
Sección 5: La clase Optional
Sección 6: Hilos y concurrencia
Sección 7: Programación Reactiva
Sección 8: Introducción a SQL
Sección 9: Persistencia en base de datos con JDBC
Sección 10: Integración: JDBC, DAO y Transacciones en una App MVC
Sección 11: Patrones de diseño y UML
Sección 12: Manejo de Fechas - API java.time
Sección 13: Introducción a Spring boot
Sección 14: Despedida del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Haber completado un curso inicial de Java o dominar sus fundamentos (POO, colecciones, excepciones)', 'Conocimientos básicos de desarrollo con IntelliJ IDEA.', 'Diseñado para quienes desean explorar nuevas formas de programar y estructurar sus proyectos', 'Acceso a internet para descargar recursos y librerías externas.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1500,
    metadata_source_url = 'https://cursos.devtalles.com/courses/java-avanzado',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'java-avanzado'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- net-backend
WITH changed AS (
  UPDATE courses SET
    description = 'Construye desde cero una API RESTful profesional en .NET para un e-commerce real. Aprende sobre JWT, Entity Framework, control de acceso, subida de imágenes, cache, versionado y despliegue en la nube.',
    syllabus = 'Sección 1: Introduction
Sección 2: Breve introducción a C# y fundamentos esenciales para .NET
Sección 3: Creación de proyecto
Sección 4: Creación de categoría
Sección 5: Repositorio categoría
Sección 6: API Categoría
Sección 7: API Producto
Sección 8: API Usuario, autenticación y JWT
Sección 9: CORS
Sección 10: Autorización
Sección 11: Caché
Sección 12: Versionando API
Sección 13: Autenticación y autorización con Identity
Sección 14: Implementar subida de imagen
Sección 15: Seed, paginación y uso de agente
Sección 16: Publicando API en Azure
Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Tener conocimientos básicos de programación (estructuras de control, variables, métodos, clases).', 'Haber trabajado previamente con C# o completado un curso introductorio.', 'Conocimientos básicos sobre HTTP y JSON.', 'Visual Studio Code instalado y configurado con .NET 8.', 'Acceso a internet para instalar paquetes NuGet y realizar pruebas con herramientas externas como Postman.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 660,
    metadata_source_url = 'https://cursos.devtalles.com/courses/NET-Backend',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'net-backend'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- django
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende Django desde cero con este curso práctico. Crea sitios web, conecta bases de datos, desarrolla APIs REST y publica tu proyecto. Ideal para convertirte en desarrollador web backend con Django.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Fundamentos necesarios de Python
Sección 3: Introducción a Django
Sección 4: URLs y Vistas
Sección 5: Templates
Sección 6: Proyecto - URLs, Views y Templates
Sección 7: Modelos y bases de datos
Sección 8: Manipulación de datos con el ORM
Sección 9: Relaciones entre modelos
Sección 10: Django Admin
Sección 11: Filtros, búsquedas y paginación en listas
Sección 12: Proyecto - Modelos y Django admin
Sección 13: Proyecto - Renderizado, paginación y búsquedas
Sección 14: Formularios y validaciones
Sección 15: Function-Based Views (FBV) vs. Class-Based Views (CBV)
Sección 16: Middlewares
Sección 17: Sesiones de usuario
Sección 18: Autenticación y permisos de usuarios
Sección 19: Subir archivos
Section 20: Proyecto - CBV, Autenticación, permisos, forms, etc
Section 21: Proyecto - Complementos (Reseñas, cambiar contraseña, emails, dashboard)
Section 22: Fin del curso
Bonus: Django y PostgreSQL
Bonus: Introducción a Django Rest Framework
Bonus: Deploy en Render',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de Python', 'Conocimientos básicos de HTML, CSS y JS', 'Conocimientos básicos de SQL (No obligatorio pero deseable)', 'Poder realizar instalaciones en el equipo como administrador', 'Usar sistema operativo Mac (OSx), Windows o Linux', 'Ganas de aprender una tecnología desde cero', 'Compromiso para mejorar carrera profesional y hacer los ejercicios, proyectos realizados en el curso.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2640,
    metadata_source_url = 'https://cursos.devtalles.com/courses/django',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'django'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- flutter-gemini
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a trabajar con la inteligencia artificial de Google Gemini y su SDK nativo, siguiendo buenas prácticas y recomendaciones de la documentación oficial.',
    syllabus = 'Sección 1: Introducción
Sección 2: Creación del UI - Opcional
Sección 3: Backend - NestJS
Sección 4: Consulta básica - Flutter
Sección 5: Backend - Stream Response
Sección 6: Frontend - Stream Response
Sección 7: Backend - Recibir archivos y retornar stream
Sección 8: Frontend - Enviar archivos
Sección 9: Backend - Contexto conversacional
Sección 10: Frontend - Contexto conversacional
Sección 11: Backend - Generación y edición de imágenes
Sección 12: Frontend - Generación y edición de imágenes
Sección 13: Bonus: Respuestas de Gemini en formato JSON
Sección 14: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de Flutter (widgets, navegación, estado).', 'Conocimientos básicos de node o APIs es recomendado.', 'Tener Flutter instalado y un entorno de desarrollo como VS Code.', 'Conocimientos básicos de HTTP y consumo de APIs REST.', 'Se recomienda, pero no es obligatorio, experiencia previa trabajando con algún gestor de estado de Flutter.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 510,
    metadata_source_url = 'https://cursos.devtalles.com/courses/Flutter-Gemini',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'flutter-gemini'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- react-router
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende a trabajar con React Router tanto como librería para proyectos tipo SPA o trabajarlo cómo Framework y obtener el máximo provecho de server actions, route modules, pre-rendering y mucho más!',
    syllabus = 'Sección 1 - Introducción
Sección 2 - React Router - Librería vs Framework
Sección 3 - Declarativa - Preparación de proyecto
Sección 4 - Declarativa - React Router
Sección 5 - Declarativa - Protección y estados
Sección 6 - Framework - Preparación de proyecto
Sección 7 - Framework - Server side - Route Module
Sección 8 - Framework - Autenticación y sesiones
Sección 9 - Framework - Chat y despliegues
Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de React:', 'Saber usar useState, useEffect, props y componentes funcionales.', 'Experiencia previa con JavaScript (al menos las bases):', 'Entender conceptos como funciones flecha, async/await y módulos ES6.', 'Familiaridad con HTML, CSS y herramientas como Vite o npm:', 'Poder iniciar proyectos, instalar paquetes y aplicar estilos básicos']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 450,
    metadata_source_url = 'https://cursos.devtalles.com/courses/react-router',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'react-router'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- python
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende las bases de Python: variables, estructuras de control, ciclos, funciones, POO, errores, módulos y entornos virtuales. Ideal para principiantes o quienes desean reforzar conceptos con ejemplos prácticos y aplicar Python en distintas áreas.',
    syllabus = 'Sección 1: Introducción
Sección 2: Primeros pasos
Sección 3: Condicionales
Sección 4: Listas
Sección 5: Diccionarios
Sección 6: Tuplas y Sets
Sección 7: Loops (Ciclos, Bucles)
Sección 8: Funciones
Sección 9: Programación Orientada a Objetos (Parte 1)
Sección 10: Programación Orientada a Objetos (Parte 2)
Sección 11: Manejo de errores
Sección 12: Librerías, módulo y paquetes
Sección 13: Entornos Virtuales
Sección 14: Manejo de Archivos
Sección 15: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['No se necesita experiencia previa en programación.', 'Tener una computadora con Windows, macOS o Linux.', 'Acceso a internet para instalar Python y un editor de código como VSCode.', 'Curiosidad y disposición para resolver problemas prácticos con código.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 930,
    metadata_source_url = 'https://cursos.devtalles.com/courses/python',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'python'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- csharp
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende C# desde cero, domina desde la sintaxis básica, estructuras de control y POO, manejo de excepciones, LINQ y manejo de archivos JSON, arquitectura MVC e introducción a desarrollo api web con ASP.NET Core.',
    syllabus = 'Sección 1: Introducción
Sección 2: Sintaxis básica de C#, variables y tipos de datos
Sección 3: Estructuras de control, casteo y funciones
Sección 4: Clases,objetos, herencia y polimorfismo, propiedades
Sección 5: Manejo de excepciones, colecciones e introducción a LINQ
Sección 6: Manejo de archivos
Sección 7: TaskMaster - Gestor de tareas
Sección 8: Introducción a ASP.NET Core
Sección 9: TaskMasterAPI
Sección 10: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['No se necesita experiencia previa en C#', 'Se recomienda una noción básica de programación (variables, condicionales, bucles)', 'Tener instalado Visual Studio Code y .NET 8 (el curso guía este proceso)', 'Ganas de aprender con ejercicios prácticos y construir proyectos reales']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 690,
    metadata_source_url = 'https://cursos.devtalles.com/courses/csharp',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'csharp'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- java
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende Java desde cero, dominando la sintaxis, POO, estructuras de datos y manejo de excepciones. Explora la jerarquía de clases, colecciones, archivos y el uso de patrones como MVC.',
    syllabus = 'Sección 1: Introducción
Sección 2: Primeros pasos en Java
Sección 3: Fundamentos del lenguaje
Sección 4: Clases y Objetos
Sección 5: Programación Orientada a Objetos (POO)
Sección 6: Estructuras de Datos y Colecciones
Sección 7: Manejo de Excepciones
Sección 8: Manejo de JSON
Sección 9: Aplicación práctica con el patrón MVC
Sección 10: Bonus: Lombok
Sección 11: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Solo necesitas una computadora con Windows, macOS o Linux', 'Ganas de aprender y de practicar con ejemplos reales', 'Acceso a internet para descargar IntelliJ IDEA y el JDK de Java', 'Nociones básicas de programación estructurada']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 900,
    metadata_source_url = 'https://cursos.devtalles.com/courses/Java',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'java'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- nestjs-testing
WITH changed AS (
  UPDATE courses SET
    description = 'Aquí aprenderán a realizar pruebas unitarias, integración y de extremo a extremo (E2E) de sus aplicaciones hechas en NestJS utilizando Jest, siguiendo estándares recomendados.',
    syllabus = 'Sección 1: Introducción
Sección 2: Introducción a las pruebas
Sección 3: Nuestras primeras pruebas
Sección 4: Pruebas sobre módulos, controladores y servicios
Sección 5: Tarea - Cobertura al 100%
Sección 6: E2E - End to end testing
Sección 7: Unit Testing - Aplicación real
Sección 8: Unit Testing - Autenticación, controladores y strategies
Sección 9: Unit Testing - Productos y carga de archivos
Sección 10: E2E - Pruebas de extremo a extremo
Sección 11: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de NestJS previo es necesario', 'No es un curso para aprender NestJS', 'Conocer qué es un Restful API sería útil', 'No es necesario saber sobre pruebas automáticas o Jest', 'Conocimiento de TypeScript sería ideal']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 750,
    metadata_source_url = 'https://cursos.devtalles.com/courses/NestJS-Testing',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'nestjs-testing'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- angular-moderno
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende Angular en profundidad con el nuevo paradigma Zoneless basado en señales. Comienza desde cero y realiza ejercicios prácticos para dominar lo necesario y crear aplicaciones con este framework.',
    syllabus = 'Sección 1 - Introducción
Sección 2: Conceptos generales - TypeScript y Angular
Sección 3: Bases de TypeScript - Recomendado
Sección 4: Angular
Sección 5 - Expandir bases
Sección 6 - GifsApp - Pensemos en componentes
Sección 7 - Aplicación de Gifs
Sección 8 - Gifs Intermedio/Avanzado
Sección 9 - Country SPA
Sección 10 - Country SPA - Funcionalidad
Sección 11 - CountryApp - Intermedio/Avanzado
Sección 12 - Pipes
Sección 13 - Pipes personalizados
Sección 14 - Formularios Reactivos
Sección 15 - Formularios Reactivos
Sección 16 - LifeCycle Hooks
Sección 17 - Mapas
Sección 18 - TesloShop Aplicación administrativa
Sección 19 - Paginación (Opcional)
Sección 20 - Autenticación y autorización
Sección 21 - Panel administrativo
Sección 22 - Carga de archivos y despliegues
Sección 23 - Angular 19+ - Nuevas características
Sección 24: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Saber JavaScript básico', 'Conocimiento básico de programación', 'No es necesario saber TypeScript pero ayudaría', 'No es necesario conocimiento alguno de Angular u otras versiones']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2010,
    metadata_source_url = 'https://cursos.devtalles.com/courses/angular-moderno',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'angular-moderno'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- patrones-diseno
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende 24 patrones de diseño clave para resolver problemas comunes y escribir código más limpio y escalable.',
    syllabus = 'Sección 1: Introducción
Sección 2: Introducción a los patrones
Sección 3: Patrones creacionales
Sección 4: Builder
Sección 5: Factory Method
Sección 6: Abstract Factory
Sección 7: Prototype
Sección 8: Inmutabilidad con copia
Sección 9: Singleton
Sección 10: Factory Function
Sección 11: Código fuente
Sección 12: Patrones estructurales
Sección 13: Adapter
Sección 14: Bridge
Sección 15: Composite
Sección 16: Decorator
Sección 17: Facade
Sección 18: Flyweight
Sección 19: Proxy
Sección 20: Código fuente
Sección 21: Patrones de comportamiento
Sección 22: Chain of Responsibility
Sección 23: Command
Sección 24: iterator
Sección 25: Mediator
Sección 26: Memento
Sección 27: Observer
Sección 28: State
Sección 29: Strategy
Sección 30: Template Method
Sección 31: Visitor
Sección 32: Código fuente
Sección 33: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de TypeScript es recomendado', 'Conocimiento de Programación orientada a objetos es recomendado', 'Poder realizar instalaciones en el equipo es necesario']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 600,
    metadata_source_url = 'https://cursos.devtalles.com/courses/patrones-diseno',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'patrones-diseno'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- react-native-expo
WITH changed AS (
  UPDATE courses SET
    description = 'Curso completo de React Native con Expo que te dará las bases sólidas sobre este framework, con más de 42 horas de contenido en video y despliegues en la Google PlayStore y Apple AppStore incluído en el curso.',
    syllabus = 'Sección 1: Introducción
Sección 2: Reforzamiento sobre React y TypeScript
Sección 3: Configuración de equipo - React Native - Expo
Sección 4: Mi primera aplicación en React Native
Sección 5: Calculator App
Sección 6: Tipos de navegación y estilos
Sección 7: Tabs y Drawer
Sección 8: MoviesApp - Peticiones HTTP - TanStack
Sección 9: MoviesApp - InfiniteScroll y Detalles
Sección 10: Components App - Temas y estructura
Sección 11: Componentes de React Native
Sección 12: Lists, Infinite scrolls, Slides, Theme Changer, modals
Sección 13: Push Notifications
Sección 14: MapsApp - Permisos
Sección 15: MapsApp - Mapas y controles
Sección 16: Backend personalizado
Sección 17: Productos App - Autenticación
Sección 18: Products App - Listado y mantenimiento
Sección 19: Cámara, galería y carga de imágenes
Sección 20: PlayStore y AppStore
Sección 21: Cierre del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de React es necesario', 'No es necesario saber TypeScript (pero es recomendado)', 'No necesitas saber nada de React Native o React Native CLI', 'Es necesario poder realizar instalaciones como administrador', 'No es necesario Mac o un equipo especial']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2520,
    metadata_source_url = 'https://cursos.devtalles.com/courses/react-native-expo',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'react-native-expo'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- angular-pro
WITH changed AS (
  UPDATE courses SET
    description = 'Angular PRO, es un curso que llevará tu conocimiento de Angular al siguiente nivel con SSR, SSG, Testing, Zoneless, TanStack, optimizaciones y mucho más.',
    syllabus = 'Sección 1: Introducción
Sección 2: Zoneless Calculator
Sección 3: Señales, comportamiento y lógica
Sección 4: Testing - Zoneless Calculator
Sección 5: Angular - SSR - SSG - Hydration
Sección 6: Angular SSR - SSG - Con peticiones HTTP
Sección 7: Static Site Generation - Pre-Rendering SSG + Hybrid
Sección 8: Testing - PokemonSSR
Sección 9: TanStack Query - Angular
Sección 10: TanStack - Filtros y optimizaciones
Sección 11: GitHub Issues App Testing
Sección 12: Crear paquetes personalizados de Angular a NPM
Sección 13: Angular internationalization - i18n
Sección 14: Cierre del curso
Archivado: Jasmine Karma - Zoneless Calculator
Archivado: Jasmine Karma - PokemonSSR
Archivado: Jasmine Karma - GitHub Issues App Testing',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de Angular es necesario', 'Poder realizar instalaciones como administrador', 'Poder subir repositorios a GitHub']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1290,
    metadata_source_url = 'https://cursos.devtalles.com/courses/angular-pro',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'angular-pro'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- astro
WITH changed AS (
  UPDATE courses SET
    description = 'Framework de desarrollo web diseñado para construir sitios web rápidos y eficientes con las tecnologías que ya conoces.',
    syllabus = 'Sección 1: Introducción
Sección 2: Introducción a Astro
Sección 3: Rutas dinámicas y paginación estática
Sección 4: Añadir dinamismo a nuestro sitio estático
Sección 5: Colecciones e imágenes
Sección 6: Relaciones de colecciones
Sección 7: Astro Themes
Sección 8: RSS Feed
Sección 9: Server Side Rendering y Endpoints
Sección 10: Astro DB
Sección 11: Server Actions - Funciones de Blog - Likes Counter
Sección 12: Autenticación y protección de rutas
Sección 13: Autenticación y autorización - Auth.js
Sección 14: Productos, paginación y SEO
Sección 15: Carrito - Cookies y Nanostores
Sección 16: Mantenimiento de productos
Sección 17: Server Islands - Prisma
Opcional: Astro con PostgreSQL
Opcional: Astro con PosgreSQL + Actions continuación
Cierre del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de JavaScript es necesario', 'Conocimiento básico de maquetación HTML y CSS (recomendado)', 'Saber TypeScript no es necesario (pero es de utilidad)']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1530,
    metadata_source_url = 'https://cursos.devtalles.com/courses/Astro',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'astro'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- nestjs-reportes
WITH changed AS (
  UPDATE courses SET
    description = 'Crea reportes en PDF utilizando NestJS. Aprenderás a integrar y utilizar Pdfmake y ChartJS para generar reportes profesionales y personalizados.',
    syllabus = 'Sección 1: Introducción
Sección 2: Preparación de proyecto
Sección 3: Constancia de empleo
Sección 4: Tablas - Listado de países
Sección 5: Recibo de compra - Maestro detalle relacionado
Sección 6: Gráficos y SVGs
Sección 7: Utilidades y diseño complejo
Sección 8: Despedida del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de Nest es necesario', 'Conocimiento básico de JavaScript y TypeScript es recomendado']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 390,
    metadata_source_url = 'https://cursos.devtalles.com/courses/nestjs-reportes',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'nestjs-reportes'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- shadcn-ui
WITH changed AS (
  UPDATE courses SET
    description = 'Una librería de componentes diferente, que te da control absoluto sobre cada pieza que importes en tu proyecto, aprende a usarla y configurarla en este curso.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Preparación del proyecto
Sección 3: Shadcn/ui - Componentes
Sección 4: Data table
Sección 5: Formularios
Sección 6: Temas
Sección 7: Cierre del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de React y TypeScript:', 'Saber crear componentes, usar props y hooks como useState.', 'Familiaridad con Tailwind CSS:', 'Haber trabajado con clases utilitarias para estilos.', 'Entorno de desarrollo configurado (Node.js + npm/yarn):', 'Poder instalar paquetes y ejecutar proyectos locales.', 'Experiencia básica con formularios y tablas en React:', 'Saber manejar inputs, validaciones o manipular listas de datos.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 360,
    metadata_source_url = 'https://cursos.devtalles.com/courses/shadcn-ui',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'shadcn-ui'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- vue-cero-a-experto
WITH changed AS (
  UPDATE courses SET
    description = 'Nueva entrega renovada del curso que se enfoca plenamente en el Composition Api, TypeScript y Vitest para crear aplicaciones modernas.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Reforzamiento de JavaScript / TypeScript
Sección 3: Introducción a Vue.js
Sección 4: Vue + Vite - Single-File Components
Sección 5: Indecision App - Continuación
Sección 6: Introducción a las pruebas unitarias y de integración
Sección 7: Pokemon Game
Sección 8: Testing - Pokemon Game
Sección 9: Vue Router - SPA - Single Page Applications
Sección 10: Vue Router - Testing
Sección 11: Pinia - Slots y DaisyUI
Sección 12: Pinia - Gestor de estado
Sección 13: Slots y Pinia Testing
Sección 14: Administración de productos - Estructura inicial y Backend
Sección 15: Autenticación y Autorización
Sección 16: Formularios y Mantenimiento de Productos
Sección 17: Carga de archivos y posteos
Sección 18: Desplegar aplicación final
Sección 19: Testing - Admin Shop
Sección 20: Bonus: Quasar
Sección 21: MapasApp - Mapbox + Rutas
Sección 22: Cierre del curso',
    learning_outcomes = ARRAY['Serás capaz de desarrollar aplicaciones profesionales utilizando Vue.js con confianza.', 'Dominarás las herramientas y patrones modernos que utilizan equipos de desarrollo en proyectos reales.', 'Aprenderás a implementar pruebas automáticas que aumentan la calidad y mantenibilidad de tus aplicaciones.', 'Tendrás la experiencia necesaria para estructurar proyectos de cualquier tamaño siguiendo buenas prácticas.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de programación básica', 'Conocimiento de JavaScript básico', 'Poder realizar instalaciones en el equipo', 'El curso se puede seguir en Window, Linux o Mac OSx', 'Conocimiento de TypeScript es opcional pero recomendado']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2250,
    metadata_source_url = 'https://cursos.devtalles.com/courses/vue-cero-a-experto',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'vue-cero-a-experto'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- nestjs-microservicios
WITH changed AS (
  UPDATE courses SET
    description = 'Es momento de crear un sistema distribuido utilizando múltiples bases de datos, transportadores y técnicas para escalar de forma independiente cada microservicio.',
    syllabus = 'Sección 1: Introducción
Sección 2: Reforzamiento de NestJS
Sección 3: Introducción - Microservicios
Sección 4: Products Microservice
Sección 5: Gateway
Sección 6: Orders Microservice
Sección 7: Order Details - Maestro detalle
Sección 8: Nats Server
Sección 9: Docker - Crear docker compose
Sección 10: Pagos - Payments Microservice
Sección 11: Integrar Orders MS y Payments MS
Sección 12: Autenticación - Auth Microservice
Sección 13: Containerization - Construcción de imágenes - PROD
Sección 14: Google Cloud - CI/CD
Sección 15: Kubernetes - Configuración local
Sección 16: GCloud - Kubernetes Engine
Sección 17: Cierre del curso',
    learning_outcomes = ARRAY['Comprenderás cuándo utilizar una arquitectura monolítica y cuándo implementar microservicios.', 'Serás capaz de construir, configurar y comunicar múltiples microservicios utilizando NestJS.', 'Aprenderás a desplegar aplicaciones en la nube utilizando Docker, Kubernetes y Google Cloud.', 'Estarás preparado para integrarte rápidamente a proyectos profesionales que utilicen arquitecturas de microservicios o implementar esta arquitectura en tus propios desarrollos.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de TypeScript es necesario', 'Conocimiento básico de NestJS es requerido', 'Es un curso para personas que han creado API Rest anteriormente']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1260,
    metadata_source_url = 'https://cursos.devtalles.com/courses/nestjs-microservicios',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'nestjs-microservicios'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- openai-angular-nestjs
WITH changed AS (
  UPDATE courses SET
    description = 'En este curso práctico de OpenAI, aprenderás la librería de OpenAI en Node, para consumir desde un frontend en Angular, y así consultar información, generar imágenes, editar, generar audio basado en texto, texto a audio, configurar tu asistente y más.',
    syllabus = 'Sección 1: Introducción
Sección 2: Frontend - Diseño y creación de la aplicación
Sección 3: Backend - Caso de uso - Ortografía
Sección 4: Frontend - Ortografía
Sección 5: Backend - ProsCons Discusser - Streams
Sección 6: Frontend - ProsCons - Discusser Streams
Sección 7: Backend - Traducciones
Sección 8: Frontend - Traducciones
Sección 9: Backend - Texto a audio
Sección 10: Frontend - Texto a audio
Sección 11: Backend - Audio a texto
Sección 12: Frontend - Audio a texto
Sección 13: Backend - Generación de imágenes
Sección 14: Frontend - Generación y edición de imágenes
Sección 15: Backend - Asistentes de OpenAI
Sección 16: Frontend - Asistentes
Sección 17: Tareas adicionales
Sección 18: Fin del curso',
    learning_outcomes = ARRAY['Serás capaz de integrar la API de OpenAI dentro de aplicaciones desarrolladas con Node.js, NestJS y Angular.', 'Aprenderás a construir asistentes personalizados capaces de responder utilizando información específica de tus proyectos.', 'Podrás desarrollar aplicaciones que generen texto, audio, imágenes y contenido inteligente mediante inteligencia artificial.', 'Comprenderás cómo estructurar aplicaciones Full Stack donde el backend administra toda la lógica relacionada con OpenAI y el frontend consume las respuestas de forma eficiente.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de JavaScript', 'Saber TypeScript es opcional, pero recomendado', 'Conocimiento básico de Node', 'Conocimiento de Nest es recomendado pero no obligatorio', 'Conocer sobre la sintaxis de Angular']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 660,
    metadata_source_url = 'https://cursos.devtalles.com/courses/openai-angular-nestjs',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'openai-angular-nestjs'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- openai-react-nestjs
WITH changed AS (
  UPDATE courses SET
    description = 'En este curso práctico de OpenAI, aprenderás la librería de OpenAI en Node, para consumir desde un frontend en React, y así consultar información, generar imágenes, editar, generar audio basado en texto, texto a audio, configurar tu asistente y más.',
    syllabus = 'Sección 1: Introducción
Sección 2: Frontend - Diseño y creación de la aplicación
Sección 3: Backend - Caso de uso - Ortografía
Sección 4: Frontend - Ortografía
Sección 5: Backend - ProsCons Discusser - Streams
Sección 6: Frontend - ProsCons Discusser - Streams
Sección 7: Backend - Traducciones
Sección 8: Frontend - Traducciones
Sección 9: Backend - Texto a audio
Sección 10: Frontend - Texto a audio
Sección 11: Backend - Audio a texto
Sección 12: Frontend - Audio a texto
Sección 13: Backend - Generación de imágenes
Sección 14: Frontend - Generación y edición de imágenes
Sección 15: Backend - Asistentes de OpenAI
Sección 16: Frontend - Asistentes
Sección 17: Tareas adicionales
Sección 18: Fin del curso',
    learning_outcomes = ARRAY['Serás capaz de integrar la API de OpenAI dentro de aplicaciones desarrolladas con Node.js, NestJS y React.', 'Aprenderás a construir asistentes personalizados capaces de responder utilizando información específica de tus proyectos.', 'Podrás desarrollar aplicaciones que generen texto, audio, imágenes y contenido inteligente mediante inteligencia artificial.', 'Comprenderás cómo estructurar aplicaciones Full Stack donde el backend administra toda la lógica relacionada con OpenAI y el frontend consume las respuestas de forma eficiente.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de JavaScript', 'Saber TypeScript es opcional, pero recomendado', 'Conocimiento básico de Node', 'Conocimiento de Nest es recomendado pero no obligatorio', 'Haber trabajado con React con Hooks']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 600,
    metadata_source_url = 'https://cursos.devtalles.com/courses/openai',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'openai-react-nestjs'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- zustand-react
WITH changed AS (
  UPDATE courses SET
    description = 'Este gestor de estado a punta a ser un reemplazo directo a Redux, Redux Toolkit y el mismo Context API de React, ofreciendo funcionalidades similares a Redux sin tener que construir tanto código base para hacerlo funcionar.',
    syllabus = 'Sección 1: Introducción
Sección 2: Bases de Zustand
Sección 3: Middlewares de Zustand
Sección 4: Tareas - Drag & Drop - Inmutabilidad con Immer
Sección 5: Zustand Slices
Sección 6: Peticiones HTTP - Zustand fuera de React
Sección 7: Fin del curso',
    learning_outcomes = ARRAY['Serás capaz de implementar Zustand en aplicaciones React de cualquier tamaño utilizando las mejores prácticas.', 'Aprenderás a reemplazar Redux o Context API cuando sea conveniente, reduciendo significativamente la cantidad de código necesario.', 'Dominarás la persistencia de datos, la autenticación y la organización profesional del estado utilizando TypeScript.', 'Contarás con una base sólida para desarrollar aplicaciones escalables con un gestor de estado moderno y altamente eficiente.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de React con Hooks es necesario', 'Saber realizar peticiones HTTP con Fetch API o Axios', 'Saber TypeScript es opcional pero recomendado', 'No es necesario saber Tailwind, React Router, Dom o Docker']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 360,
    metadata_source_url = 'https://cursos.devtalles.com/courses/zustand-gestor-de-estado-para-react',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'zustand-react'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- node-clean-architecture
WITH changed AS (
  UPDATE courses SET
    description = 'El objetivo del curso es crear una autenticación y registro de usuarios mediante un Restful API utilizando Clean Architecture y diferentes patrones de desarrollo. Pasando por la configuración de Node con TypeScript hasta la verificación de nuestro Json Web Token.',
    syllabus = 'Sección 1: Requisitos de instalación y materiales
Sección 2: Repository Pattern
Sección 3: Base de datos
Sección 4: Generacion de Json Web Tokens
Sección 5: Casos de uso
Sección 6: Cierre del curso',
    learning_outcomes = ARRAY['Serás capaz de construir APIs modernas utilizando Node.js y TypeScript siguiendo buenas prácticas de arquitectura.', 'Aprenderás a estructurar proyectos escalables mediante Repository Pattern e inyección de dependencias.', 'Implementarás autenticación segura con JWT y desarrollarás funcionalidades reales como registro e inicio de sesión de usuarios.', 'Tendrás una base sólida para desarrollar APIs profesionales utilizando MongoDB, Mongoose y Docker.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de JavaScript o TypeScript:', 'Entender funciones, clases, módulos y tipado básico.', 'Familiaridad con Node.js y Express:', 'Haber creado rutas y manejado peticiones HTTP.', 'Experiencia básica con bases de datos:', 'Conocer conceptos de modelos, esquemas y consultas simples.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 240,
    metadata_source_url = 'https://cursos.devtalles.com/courses/node-clean-architecture',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'node-clean-architecture'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- flutter-bloc
WITH changed AS (
  UPDATE courses SET
    description = 'Este mini-curso sobre Flutter Bloc te enseñará a utilizar este gestor de estado de una forma organizada, pasando desde cubits, blocs simples y compuestos, pero también aprenderás a como comunicarlos entre sí.',
    syllabus = 'Flutter BLoC',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de Flutter y Dart:', 'Saber crear widgets, usar estados, y manejar estructuras comunes.', 'Familiaridad con el concepto de manejo de estado:', 'Haber usado alguna solución como Provider, Riverpod, o setState de los stateful widgets.', 'Instalación funcional de Flutter en tu entorno local:', 'Tener acceso al emulador o dispositivo físico para pruebas.', 'Conocimientos básicos de programación orientada a objetos:', 'Entender clases, constructores y métodos en Dart.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 210,
    metadata_source_url = 'https://cursos.devtalles.com/courses/flutter-bloc',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'flutter-bloc'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- nodejs-de-cero-a-experto
WITH changed AS (
  UPDATE courses SET
    description = 'Aprende Node.js desde los fundamentos, usos comunes y no tan comunes, despliegues, construcción de imágenes, testing y muchas más habilidades que son necesarias hoy en día con este runtime-environment de JavaScript.',
    syllabus = 'Sección 1: Introducción
Sección 2: Fundamentos de Node - Primeros pasos
Sección 3: Desarrollando en Node
Sección 4: Bases de Node + TypeScript - Continuación
Sección 5: Introducción al testing
Sección 6: Aplicación de consola - Clean Architecture - Primeros Pasos
Sección 7: Aplicación de consola - Testing
Sección 8: Aplicación de Monitoreo - NOC
Sección 9: Clean Architecture - Repository Pattern
Sección 10: Correos electrónicos
Sección 11: MongoDB y PostgreSQL
Sección 12: NOC - Testing - Clean Architecture
Sección 13: WebServer - Http/Http2
Sección 14: RestServer
Sección 15: RestServer + PostgreSQL
Sección 16: Rest - Clean Architecture
Sección 17: Rest Testing
Sección 18: Autenticación y Autorización
Sección 19: Enviar correo + Validación de Tokens
Sección 20: Protección de rutas, relaciones, middlewares y paginación
Sección 21: Relaciones y semilla
Sección 22: Carga de archivos - Simple y Múltiple
Sección 23: WebHooks
Sección 24: Seguridad de Webhooks
Sección 25: Edge Functions con Netlify
Sección 26: Websockets
Sección 27: RESTApi + WebSockets - Aplicación de colas
Sección 28: Cierre del curso',
    learning_outcomes = ARRAY['Serás capaz de desarrollar aplicaciones backend profesionales utilizando Node.js y TypeScript.', 'Comprenderás cómo estructurar proyectos escalables aplicando patrones de diseño y principios de Clean Code.', 'Podrás construir APIs, automatizaciones, WebSockets e integraciones con múltiples servicios y bases de datos.', 'Contarás con una base sólida para desarrollar aplicaciones modernas preparadas para entornos de producción.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de JavaScript es altamente recomendado', 'No es necesario saber TypeScript pero es útil', 'Poder realizar instalaciones en tu equipo', 'Es necesario tener bases de programación estructurada']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2250,
    metadata_source_url = 'https://cursos.devtalles.com/courses/nodejs-de-cero-a-experto',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'nodejs-de-cero-a-experto'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- riverpod-con-anotaciones
WITH changed AS (
  UPDATE courses SET
    description = 'Curso de Flutter Riverpod para aprender este gestor de estado con anotaciones y generación de código automático.',
    syllabus = 'Providers de Riverpod con generador de código',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de Flutter y Dart:', 'Saber construir interfaces, usar widgets y manejar el estado con setState.', 'Experiencia inicial con el concepto de providers o manejo de estado:', 'Haber trabajado con Provider, Bloc, o alguna solución similar.', 'Entorno de desarrollo Flutter funcional:', 'Poder correr proyectos localmente y tener acceso a simuladores o dispositivos.', 'Conocimientos básicos de programación asíncrona en Dart:', 'Uso de Future, async/await, y Stream.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 120,
    metadata_source_url = 'https://cursos.devtalles.com/courses/riverpod-con-anotaciones',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'riverpod-con-anotaciones'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- sql-con-postgres
WITH changed AS (
  UPDATE courses SET
    description = 'El objetivo es aprender sobre bases de datos relacionales partiendo desde cero, pasando por queries, triggers, procedimientos almacenados hasta optimizaciones.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Preparar ambiente de pruebas
Sección 3: Generalidades y primeros pasos
Sección 4: Funciones agregadas - agrupaciones y ordenamiento
Sección 5: Intermedio - Relaciones, Llaves y Constraints
Sección 6: Intermedio - Separación de data en otras tablas
Sección 7: Joins - Uniones
Sección 8: Queries - Fechas, intervalos y funciones sobre fechas
Sección 9: Generación de llaves primarias
Sección 10: Diseño de bases de datos - Medium
Sección 11: Ejercicios con base de datos de medium - Intro Funciones
Sección 12: Diseño de bases de datos - Más ejercicios
Sección 13: Vistas, Vistas materializadas y Common Table Expression
Sección 14: Funciones personalizadas
Sección 15: Stored Procedures
Sección 16: Triggers + Funciones + Procedimientos
Sección 17: Cierre del curso',
    learning_outcomes = ARRAY['Serás capaz de diseñar y desarrollar bases de datos relacionales utilizando PostgreSQL.', 'Dominarás SQL desde los conceptos básicos hasta funcionalidades avanzadas.', 'Aprenderás a modelar información, optimizar consultas y automatizar procesos dentro de la base de datos.', 'Obtendrás conocimientos aplicables a la mayoría de motores de bases de datos relacionales que utilizan SQL.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Tener conocimiento de programación estructurada será útil en la parte de PL/pgSQL.', 'Conocimiento de Docker será útil, pero no es necesario.', 'Poder realizar instalaciones en el equipo es necesario.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 960,
    metadata_source_url = 'https://cursos.devtalles.com/courses/sql-con-postgres',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'sql-con-postgres'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- nextjs
WITH changed AS (
  UPDATE courses SET
    description = 'Este curso tiene por objetivo enseñarte Next.js de forma completa con muchas tareas y ejercicios. Al final del curso no solo aprenderás Next.js, también habrás desarrollado una tienda electrónica con cobros, mantenimientos, carga, optimizaciones para SEO, desplegarla y tenerla en tu portafolio de proyectos.',
    syllabus = 'Sección 1: Introducción
Sección 2: Introducción a Next.js
Sección 3: Despliegues a Vercel y Docker Images
Sección 4: Server Side + Cliente Side Rendering
Sección 5: Generación dinámica - SSR
Sección 6: Incremental & Static Generation
Sección 7: Global State - Redux y LocalStorage
Sección 8: Estado Global - Favoritos
Sección 9: Next API Routes - RESTful Api Handlers
Sección 10: Next + RestAPI - AdminTodos
Sección 11: Server Actions - Optimistic Updates - Next 14+
Sección 12: Cookies - Server y Client Side
Sección 13: Better Auth - Manejo de autenticación
Sección 14 - E-Commerce - Diseño - TesloShop
Sección 15 - E-Commerce - Diseño parte 2
Sección 16 - Preparación de base de datos
Sección 17 - Paginación del lado del servidor
Sección 18 - Pantalla de Producto
Sección 19 - Carrito de compras
Sección 20 - NextAuth
Sección 21 - Dirección de entrega
Sección 22 - Creación de Ordenes
Sección 23 - Pagos - PayPal
Sección 24 - Mantenimientos administrativos
Sección 25 - Desplegar Tienda
Sección 26 - Cierre del curso
Archivado - Sección 13: Auth.js - Autenticación de protección de rutas',
    learning_outcomes = ARRAY['Dominarás Next.js para desarrollar aplicaciones modernas listas para producción.', 'Comprenderás cuándo utilizar ISR, SSR, SSG y CSR para optimizar el rendimiento de tus aplicaciones.', 'Construirás una tienda en línea completa con autenticación, pagos, bases de datos y despliegue.', 'Tendrás proyectos reales que podrás incorporar a tu portafolio profesional.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de React con Hooks es necesario', 'NO es necesario saber TypeScript (pero será útil)', 'NO es necesario saber Node (pero será útil)', 'NO es necesario saber Next para empezar este curso']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2340,
    metadata_source_url = 'https://cursos.devtalles.com/courses/nextjs',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'nextjs'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- qwik-introduccion
WITH changed AS (
  UPDATE courses SET
    description = 'El objetivo del curso es brindar una entrada robusta al nuevo framework qwik, que es muy interesante y completo; cubre muchos aspectos desde creación hasta despliegue, rutas, estados, peticiones http, SSR, reanudabilidad, integraciones ChatGPT y más',
    syllabus = 'Sección 1: Introducción
Sección 2: Primeros pasos en Qwik
Sección 3: Server Side y Client Side Rendering
Sección 4: Context API - Estado global
Sección 5: Custom Hooks
Sección 6: Slots
Sección 7: Formularios, Validaciones, autenticación, Layouts y Rutas
Sección 8 - Despliegues
Sección 9 - Despedida del curso',
    learning_outcomes = ARRAY['Comprenderás cómo funciona Qwik y qué lo diferencia de otros frameworks modernos.', 'Serás capaz de desarrollar aplicaciones completas utilizando Qwik, Qwik City y TypeScript.', 'Aprenderás a implementar manejo de estado, formularios, autenticación e integraciones modernas.', 'Tendrás una base sólida para comenzar a desarrollar proyectos profesionales utilizando esta nueva tecnología.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de JavaScript y TypeScript:', 'Saber trabajar con funciones, objetos, arreglos y tipos básicos.', 'Experiencia previa con React, Vue o algún framework web:', 'Entender conceptos como componentes, props y manejo de estado.', 'Conocimientos básicos de HTML y CSS:', 'Saber estructurar páginas y aplicar estilos con Tailwind (opcional).', 'Entorno de desarrollo configurado (Node.js + npm):', 'Poder instalar dependencias, ejecutar scripts y trabajar en local.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 480,
    metadata_source_url = 'https://cursos.devtalles.com/courses/qwik-introduccion',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'qwik-introduccion'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- flutter-movil-intermedio
WITH changed AS (
  UPDATE courses SET
    description = 'Este curso se enfoca en la utilización de recursos nativos del dispositivo móvil, que van desde el giroscopio, cámara, sensores, contactos, conexión a internet, etc. Pero también emplearemos ese conocimiento para poder crear aplicación que van más allá de peticiones HTTP y mostrar información.',
    syllabus = 'Sección 1: Introducción
Sección 2: Reforzamiento sobre Flutter
Sección 3: Permisos y estado de la aplicación
Sección 4: Sensores
Sección 5: Actualizaciones de Flutter
Sección 6: Deep Links - Preparación de proyecto
Sección 7: Deep-Link - Configuraciones
Sección 8: Biométricos - FaceID - FingerPrint Reader
Sección 9: Ubicación de usuario y seguimiento
Sección 10: Mapas, controllers y marcadores
Sección 11: Quick Actions e indicador de notificaciones
Sección 12: adMob - Ads- Banner, FullScreen y Reward
Sección 13: Base de datos local - Drift
Sección 14 - Despedida del curso
Archivado - Sección 13: Background tasks y Periodic Tasks',
    learning_outcomes = ARRAY['Serás capaz de desarrollar aplicaciones Flutter que aprovechen los recursos físicos del dispositivo.', 'Aprenderás a integrar sensores, biometría, mapas, Deep Linking y procesos en segundo plano.', 'Comprenderás cómo estructurar aplicaciones móviles modernas utilizando Riverpod y buenas prácticas de arquitectura.', 'Tendrás los conocimientos necesarios para desarrollar aplicaciones móviles mucho más completas y profesionales.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento previo de Flutter es necesario', 'Conocimiento previo de Dart es requerido', 'Este curso no es ideal para aprender Flutter']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 960,
    metadata_source_url = 'https://cursos.devtalles.com/courses/flutter-movil-intermedio',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'flutter-movil-intermedio'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- flutter-movil-cero-a-experto
WITH changed AS (
  UPDATE courses SET
    description = 'El curso cubre todo lo necesario de Flutter para crear aplicaciones móviles para iOS y Android hasta su despliegue en las tiendas. Cuando termines el curso, habrás creado diferentes aplicaciones móviles y comprender el proceso de publicación de las mismas.',
    syllabus = 'Sección 1: Introducción
Sección 2: Introducción a Dart
Sección 3: Instalación de Flutter y Virtuales - Mac y Windows
Sección 4: Flutter - Primeros pasos
Sección 5: Yes No - Maybe App
Sección 6: Yes No - Maybe App - Funcionalidad
Sección 7: TokTik - Videos verticales
Sección 8: Conceptos de Clean Architecture -Datasources - Repositories
Sección 9: Widgets App
Sección 10: Widgets App - Continuación
Sección 11: Riverpod - Menú y Temas
Sección 12: Full App - Cinemapedia
Sección 13: Cinemapedia - Continuación
Sección 14: Películas individuales y actores
Sección 15: SearchDelegate - Búsquedas
Sección 16: ShellRoutes - Go Router - Tabs
Sección 17: Local Databases
Sección 18: Estudios adicionales
Sección 19: BLoC (Business Logic Component) - FlutterBloc y Cubits
Sección 20: Manejo de formularios
Sección 21: Push Notifications + Local Notifications
Sección 22: Enviar notificaciones desde una Rest API
Sección 23: Local Notifications
Sección 24: IOS - Push + Local Notifications
Sección 25: Preparación de Backend con Autenticación JWT
Sección 26: Autenticación - Jwt - Riverpod
Sección 27: Go Router - Protección de Rutas
Sección 28: Obtener productos - Datasources y Repositories
Sección 29: Crear y Actualizar Productos
Sección 30: Cámara, Galería y carga de archivos
Sección 31: Despliegues a Play Store y Apple App Store
Sección 32: Cierre del curso',
    learning_outcomes = ARRAY['Dominarás Dart y Flutter para desarrollar aplicaciones móviles profesionales.', 'Aprenderás a estructurar proyectos utilizando Domain Driven Design y patrones de arquitectura modernos.', 'Serás capaz de crear aplicaciones escalables, consumir APIs, trabajar con bases de datos y utilizar recursos del dispositivo.', 'Tendrás el conocimiento necesario para desarrollar, desplegar y publicar aplicaciones listas para producción.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Es necesario tener conceptos de programación estructurada y orientada a objetos', 'Si no tienes conocimiento en el requisito anterior, es recomendado mi curso de programación para principiantes', 'Puedes seguir el curso en Windows, Mac o Linux (Instalaciones y configuraciones en Mac y Windows incluídas)', 'Revisar los requisitos mínimos de Flutter dependiendo de tu sistema operativo en Flutter-dev']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 3000,
    metadata_source_url = 'https://cursos.devtalles.com/courses/flutter-movil-cero-a-experto',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'flutter-movil-cero-a-experto'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- angular-clasico
WITH changed AS (
  UPDATE courses SET
    description = 'Este curso te ayudará a aprender Angular v2023 a profundidad mediante ejercicios y tareas que tú mismo harás. Partiendo de cero conocimiento de TypeScript hasta crear un sistema robusto de autenticación, uso de mapas, consumo de servicios y mucho más.',
    syllabus = 'Sección 1: Introducción
Sección 2: Conceptos generales antes de empezar
Sección 3: Bases de TypeScript - Recomendado
Sección 4: Angular
Sección 5: Expandir Bases de Angular
Sección 6: Despliegues a producción
Sección 7 - GifsApp
Sección 8 - Image Loader
Sección 9 - Country SPA
Sección 10 - Mejoras y funcionalidades extra
Sección 11 - PipesApp - PrimeNG
Sección 12 - Pipes Personalizados
Sección 13 - Rutas hijas y LazyLoading
Sección 14 - Angular Material
Sección 15 - CRUD Heroes
Sección 16 - Protección de Rutas
Sección 17 - Formularios Reactivos
Sección 18 - Validaciones
Sección 19 - Formularios Reactivos - Multiples selectores anidados
Sección 20 - LifeCycle Hooks
Sección 21 - Mapas en Angular
Sección 22 - Standalone Components
Sección 23 - Directivas personalizadas
Sección 24 - Signals en Angular - Angular 16+
Sección 25 - Auth MEAN - Nest Backend
Sección 26 - AuthApp - Backend + Angular App
Sección 27 - Despliegues a producción - Backend y Frontend
Sección 28: Angular 18+ - Nuevas características
Sección 29: Nuevos Inputs, Outputs y Angular Material 3
Sección 30: Fin del curso
Sección 31: Bonus: Mapas - Marcadores y Direcciones con Mapbox',
    learning_outcomes = ARRAY['Dominarás Angular para desarrollar aplicaciones modernas y escalables.', 'Aprenderás las mejores prácticas utilizadas en proyectos profesionales.', 'Contarás con los conocimientos necesarios para desarrollar aplicaciones listas para producción.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de programación en JavaScript o TypeScript:', 'No necesitas ser experto, pero debes entender funciones, objetos y estructuras básicas.', 'Conocimientos iniciales de HTML y CSS:', 'Saber estructurar páginas web y aplicar estilos básicos.', 'Entorno de desarrollo listo (Node.js, Angular CLI, VSCode):', 'Debes poder ejecutar proyectos localmente y manejar la terminal.', 'El curso es extenso, por lo que es ideal para personas comprometidas con su aprendizaje.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2730,
    metadata_source_url = 'https://cursos.devtalles.com/courses/angular',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'angular-clasico'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- docker-guia-practica
WITH changed AS (
  UPDATE courses SET
    description = 'En este curso aprenderás qué es Docker, porqué es tan popular y para qué te puede servir. Realizaremos ejercicios prácticos que te ayudarán a conocer las características que Docker ofrece y te permitirá agregar esta nueva herramienta a tu repertorio de software para convertirte en un mejor desarrollador.',
    syllabus = 'Sección 1: Introducción
Sección 2: Bases de Docker
Sección 3: Volúmenes y Redes
Sección 4: Multi-container Apps - Docker Compose
Sección 5: Dockerfile - Crear imágenes
Sección 6: Multi-State Build
Sección 7: Deployments y Registros
Sección 8: Construcciones automáticas - Github Actions
Sección 9: nginx
Sección 10: Introducción a Kubernetes - K8s
Sección 11: Fin del curso',
    learning_outcomes = ARRAY['Serás capaz de crear, administrar y desplegar contenedores utilizando Docker.', 'Aprenderás a construir imágenes personalizadas y automatizar tus despliegues.', 'Obtendrás una base sólida para comenzar a trabajar con Kubernetes y tecnologías de contenedores.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Poder realizar instalaciones como administrador', 'Una computadora PC, Mac o Linux con los requisitos mínimos para correr Docker (revisar sitio web para confirmar)', 'Saber comandos básicos de consola o terminal es recomendado (no obligatorio)']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 840,
    metadata_source_url = 'https://cursos.devtalles.com/courses/docker-guia-practica',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'docker-guia-practica'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- nest-graphql
WITH changed AS (
  UPDATE courses SET
    description = 'Nest + GraphQL: Aprende a integrar ambas tecnologías para lograr crear endpoints que le permitan auto servir la información exacta que necesita el FrontEnd.',
    syllabus = 'Sección 1: Introducción
Sección 2: Breve reforzamiento sobre Nest
Sección 3: Nest + GraphQL - Introducción
Sección 4: GraphQL TODO - Continuación
Sección 5: Anylist - GraphQL + Postgres
Sección 6: Autenticación y autorización
Sección 7: Usuarios y enumeraciones - Admin Roles
Sección 8: Items + Usuarios - Peticiones autenticadas
Sección 9: Seed Data - Cargar y purgar base de datos
Sección 10: Paginaciones, paginaciones anidadas y filtros
Sección 11: Entidad para el manejo de listas Maestro Detalle
Sección 12: Despliegues
Sección 13: Despedida del curso',
    learning_outcomes = ARRAY['Serás capaz de desarrollar APIs GraphQL completas utilizando NestJS.', 'Comprenderás cuándo utilizar GraphQL y las ventajas que ofrece frente a una API REST tradicional.', 'Implementarás autenticación, autorización, relaciones, paginación y despliegues siguiendo buenas prácticas.', 'Podrás crear endpoints que permitan a los equipos Frontend consumir exactamente la información que necesitan.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Estar familiarizado con Nest (decoradores, clases, módulos)', 'No es necesario saber nada sobre GraphQL (esto es cubierto en el curso)', 'Conocimiento de JavaScript y TypeScript es recomendado', 'Este NO es un curso para aprender Nest puro, es para aprender Nest con GraphQL']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1080,
    metadata_source_url = 'https://cursos.devtalles.com/courses/nest-graphql',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'nest-graphql'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- programacion-para-principiantes
WITH changed AS (
  UPDATE courses SET
    description = 'Este curso de programación para principiantes, tiene por objetivo brindarte una base para comenzar tu camino en el desarrollo de aplicaciones de cualquier tipo.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Primeros pasos en lógica y corriendo nuestro primer programa
Sección 3: Tipos de datos y flujo de control
Sección 4: Funciones y arreglos
Sección 5: Objetos y Clases
Sección 6: Ejercicios de programación - lógica
Sección 7: Creación de un juego de ahorcado - React
Sección 8: Fin del curso',
    learning_outcomes = ARRAY['Comprenderás los fundamentos de la programación desde cero.', 'Desarrollarás la lógica necesaria para aprender cualquier lenguaje o tecnología en el futuro.', 'Crearás tu primera aplicación y adquirirás una base sólida para continuar especializándote.', 'Estarás preparado para iniciar tu camino en el desarrollo de software con confianza.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Debes poder realizar instalaciones en el equipo', 'Para seguir el curso, pueden hacerlo en Windows, OSX o Linux', 'Ganas de aprender a programar']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 480,
    metadata_source_url = 'https://cursos.devtalles.com/courses/programacion-para-principiantes',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'programacion-para-principiantes'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- nest
WITH changed AS (
  UPDATE courses SET
    description = 'El curso está pensado para ayudarlos a empezar en Nest como para mejorar sus habilidades en este framework tan poderoso, adicionalmente cuenta con un cheat-sheet personalizado por mi para ayudarlos en el aprendizaje que pueden imprimir y compartir.',
    syllabus = 'Sección 1: Introducción al curso
Sección 2: Breve introducción a TypeScript y conocimientos generales necesarios
Sección 3: Primeros pasos en Nest
Sección 4: DTOs y Validación de información
Sección 5: Nest CLI Resource - Brands CRUD
Sección 6: Generar build de producción básico
Sección 7: MongoDB Pokedex
Sección 8: Seed y Paginación
Sección 9: Variables de entorno - Deployment y Dockerizar la aplicación
Sección 10: TypeORM - Postgres
Sección 11: Relaciones en TypeORM
Sección 12: Carga de archivos
Sección 13: Autenticación de autorización
Sección 14: Documentación - OpenAPI
Sección 15: Websockets
Sección 16: Desplegar toda la aplicación a producción
Sección 17: Despedida del curso',
    learning_outcomes = ARRAY['Serás capaz de desarrollar aplicaciones backend profesionales utilizando NestJS y TypeScript.', 'Aprenderás a construir APIs escalables con autenticación, bases de datos y despliegues en producción.', 'Dominarás la arquitectura y las herramientas más utilizadas dentro del ecosistema NestJS.', 'Tendrás una base sólida para participar en proyectos profesionales desarrollados con este framework.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de JavaScript es necesario', 'Bases de TypeScript son recomendadas', 'Tener una idea general de Node es recomendado', 'Tener una idea de programación orientada a objetos es recomendada pero no necesaria']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1470,
    metadata_source_url = 'https://cursos.devtalles.com/courses/nest',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'nest'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- legacy-vue-options-api
WITH changed AS (
  UPDATE courses SET
    description = 'Curso completo sobre Vue.js que parte de cero conocimiento sobre este framework hasta llevarte a un nivel profesional competitivo.',
    syllabus = 'Sección 1: Introducción
Sección 2: Reforzamiento de JavaScript
Sección 3: Introducción a Vue.js
Sección 4: Vue CLI - Primera aplicación real
Sección 5: IndecisionApp - Continuación
Sección 6: Introducción a las pruebas unitarias y de integración
Sección 7: Pokemon Game
Sección 8: Pokemon Game - Unit Test
Sección 9: Vue Router y Ciclo de vida de los componentes - Options Api
Sección 10: Introducción a Vuex
Sección 11: Journal App - Options Api + Vuex
Sección 12: CRUD - Vuex
Sección 13: Testing Vuex
Sección 14: Composition API - Bases
Sección 15: Vuex con el composition API
Sección 16: Autenticación - Vuex - Composition API
Sección 17: Composition API Testing
Sección 18: Bonus: Quasar
Sección 19: MapasApp - Mapbox + Rutas + TypeScript + Composition API
Sección 20: Cierre del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de HTML, CSS y JavaScript:', 'Ideal para quienes ya han trabajado con la web, aunque sea a nivel básico.', 'Muchas ganas de aprender Vue.js de manera estructurada:', 'El curso empieza desde cero, pero avanza a un nivel profesional.', 'Tener Node.js y un editor de código (como VSCode) instalado:', 'Necesario para trabajar con Vue CLI y herramientas modernas de desarrollo.', 'Conexión a internet para descargar dependencias y probar APIs externas:', 'Parte del contenido depende de peticiones HTTP, Firebase, y servicios como Mapbox.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 2580,
    metadata_source_url = 'https://cursos.devtalles.com/courses/vue-js',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'legacy-vue-options-api'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- tanstack-query
WITH changed AS (
  UPDATE courses SET
    description = 'TanStack Query es una librería indispensable para mejorar la experiencia de usuario en nuestras aplicaciones de React. Este curso te enseñará a utilizarlo y sacarle provecho a muchas de sus funcionalidades principales.',
    syllabus = 'Sección 1 - Introducción al curso
Sección 2 - ¿Por qué TanStack Query?
Seccion 3 - TanStack Query - IssuesApp
Seccion 4 - Issues
Sección 5 - Optimizaciones
Sección 6 - Objetos complejos como cache name
Sección 7 - Paginaciones
Sección 8 - Preparación y reforzamiento
Sección 9 - Mutaciones
Sección 10: Despedida del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimientos básicos de React y TypeScript']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 360,
    metadata_source_url = 'https://cursos.devtalles.com/courses/tanstack-query',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'tanstack-query'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- legacy-flutter-web
WITH changed AS (
  UPDATE courses SET
    description = 'En este curso nos enfocamos en expandir tu conocimiento existente sobre Flutter para crear aplicaciones nativas para IOS, Android y ahora también Web y Desktop. El curso esta construido totalmente con Null-Safety el cual es un estándar hoy en día para crear aplicaciones modernas con Flutter.',
    syllabus = 'Sección 1: Introducción
Sección 2: Flutter Web - Introducción
Sección 3: Primeros pasos en Flutter Web
Sección 4: Segmentos de URL y Query Parameters
Sección 5: Scrollable Landing Page
Sección 6: Desplegando una aplicación de Flutter Web
Sección 7: Admin Dashboard - UI Login
Sección 8: Formularios de ingreso, registro y navegación
Sección 9: Admin Dashboard Diseño
Sección 10: Backend para el panel administrativo
Sección 11: Autenticación y protección de rutas
Sección 12: Mantenimiento de categorías
Sección 13: Optimizaciones
Sección 14: Mantenimiento de usuarios
Sección 15: Carga de archivos y versión de producción
Sección 16: Despedida del curso',
    learning_outcomes = ARRAY['Serás capaz de desarrollar aplicaciones web profesionales utilizando Flutter.', 'Aprenderás a construir interfaces responsivas, paneles administrativos y sistemas de navegación avanzados.', 'Dominarás las herramientas necesarias para desplegar aplicaciones Flutter Web listas para producción.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de Flutter / Dart básico es necesario', 'Conocimiento de programación', 'Haber usado algún gestor de estados (opcional, pero recomendado)', 'Tener privilegios de administrador para realizar instalaciones']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1230,
    metadata_source_url = 'https://cursos.devtalles.com/courses/flutter-web',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'legacy-flutter-web'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- visual-studio-code
WITH changed AS (
  UPDATE courses SET
    description = 'Este curso se enfoca en 2 áreas principales: Aumentar tu velocidad de desarrollo y conocer más sobre VSCode.',
    syllabus = 'Sección 1: Introducción
Sección 2: Ediciones y tips básicos
Sección 3: Multi Cursores y edición rápida
Sección 4: Definiciones y Snippets
Sección 5: Extensiones
Sección 6: Cierre del curso',
    learning_outcomes = ARRAY['Editarás código considerablemente más rápido utilizando los atajos adecuados.', 'Conocerás funciones de Visual Studio Code que mejorarán tu productividad diaria.', 'Optimizarás tu flujo de trabajo sin importar el lenguaje o framework que utilices.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de VSCode es recomendado pero no obligatorio']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 120,
    metadata_source_url = 'https://cursos.devtalles.com/courses/visual-studio-code',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'visual-studio-code'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- dart-cero-hasta-detalles
WITH changed AS (
  UPDATE courses SET
    description = 'Aquí aprenderás desde lo más básico de Dart hasta temas más complejos y necesarios para trabajar con frameworks. Aquí adentro tendrás tareas, ejercicios, exámenes, explicaciones y herramientas indispensables que te ayudarán a ser un eficiente desarrollador utilizando Dart.',
    syllabus = 'Sección 1: Introducción
Sección 2: Primeros pasos en Dart - Tipos de datos
Sección 3: Variables, comentarios y operadores
Sección 4: Control de flujo
Sección 5: Funciones en Dart
Sección 6: Tipos no tan comunes en Dart
Sección 7: Introducción a las Clases en Dart
Sección 8: Herencia en clases
Sección 9: Documentaciones y detalles
Sección 10: Paquetes, ejecutar programas, depurar y Http
Sección 11: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento de programación estructurada es recomendable', 'El curso se puede seguir en Windows, Mac OSX o Linux', 'Este curso es para aprender Dart, no es para aprender programación.']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 600,
    metadata_source_url = 'https://cursos.devtalles.com/courses/dart-cero-hasta-detalles',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'dart-cero-hasta-detalles'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- javascript-moderno
WITH changed AS (
  UPDATE courses SET
    description = 'Al completar el curso, tendrás la base sólida de JavaScript que necesitas y su comprensión total, mediante ejercicios prácticos y explicaciones que pondrán aprueba incluso a las personas que conocen bien el lenguaje.',
    syllabus = 'Sección 1: Introducción
Sección 2: Introducción a JavaScript y la consola
Sección 3: Fundamentos de JavaScript, primitivos, arreglos, objetos y funciones básicas
Sección 4: Ciclos y estructuras de control
Sección 5: Laboratorio 1 - Blackjack
Sección 6: Patrón módulo y optimizaciones
Sección 7: Clases en JavaScript y ESNext private properties
Sección 8: Módulos y Vite
Sección 9: Git - Github y GitHub Pages
Sección 10: Laboratorio - Vite Lista de tareas
Sección 11: Callbacks, promesas y generadores
Sección 12: Peticiones HTTP
Sección 13: CRUD - App - No Frameworks
Sección 14: ES Next
Sección 15: Despedida del curso
Archivado - Sección 9: Despliegue a Github y Github pages
Archivado - Sección 10: Laboratorio 2: Aplicación de lista de tareas
Archivado - Sección 11: Callbacks y Promesas',
    learning_outcomes = ARRAY['Dominarás JavaScript moderno y sus características más importantes.', 'Podrás desarrollar aplicaciones utilizando JavaScript puro sin depender de frameworks.', 'Obtendrás una base sólida para aprender React, Angular, Vue, Node.js y cualquier tecnología basada en JavaScript.', 'Estarás preparado para afrontar proyectos reales y continuar creciendo como desarrollador profesional.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Pueden seguir el curso en Windows, OSX, Linux', 'Tener derechos de administrador para instalaciones', 'Saber sobre programación básica ayudará mucho']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1710,
    metadata_source_url = 'https://cursos.devtalles.com/courses/javascript-moderno',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'javascript-moderno'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- legacy-git-github
WITH changed AS (
  UPDATE courses SET
    description = 'Este curso te ayudará a no volver a perder un trabajo por culpa de fallas técnicas o bien por un descuido. Al finalizar el curso, sabrás Git, GitHub, Markdown, uso de repositorios, Wikis, Issues, milestones, proyectos, trabajo en equipo y mucho más.',
    syllabus = 'Sección 1: Inicio del curso del curso
Sección 2: Git - Fundamentos
Sección 3: Un poco más allá de los fundamentos de GIT
Sección 4: Ramas, uniones, conflictos y tags
Sección 5: Git Stash y Git Rebase - Para realizar cambios de emergencia
Sección 6: Inicios en GitHub, Git Remote, Push & Pull
Sección 7: GitHub - Básico
Sección 8: GitHub - Avanzado
Sección 9: GitHub Issues, MileStones y Colaboradores
Sección 10: Wikis, Proyectos y GitHub Pages
Sección 11: Organizaciones y Equipos
Sección 12: Gist
Sección 13: Fin del curso',
    learning_outcomes = ARRAY[]::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY[]::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 690,
    metadata_source_url = 'https://cursos.devtalles.com/courses/git-github-control-versiones',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'legacy-git-github'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- typescript-guia-completa
WITH changed AS (
  UPDATE courses SET
    description = 'Este curso es ideal para cualquier persona que desee entrar a trabajar con TypeScript sin importar si es Angular, React, Vue, React Native, NativeScript, Nestjs, ionic, Node o cualquier framework o librería que use TypeScript.',
    syllabus = 'Sección 1: Introducción a TypeScript
Sección 2: Introducción a TypeScript
Sección 3: Tipos básicos
Sección 4: Funciones y objetos
Sección 5: Objetos y tipos personalizados en TypeScript
Sección 6: Depuración de Errores y el archivo tsconfig.json
Sección 7: Características de ES6 o JavaScript2015 disponibles a través TypeScript
Sección 8: Clases en TypeScript
Sección 9: Interfaces
Sección 10: NameSpaces
Sección 11: Genéricos - Generics
Sección 12: Decoradores
Sección 13: Usando librerías que no están escritas en TypeScript ( Como jQuery )
Sección 14: Final del curso',
    learning_outcomes = ARRAY['Dominarás los fundamentos y las características más importantes de TypeScript.', 'Escribirás código más seguro, legible y fácil de mantener.', 'Obtendrás una base sólida para trabajar con cualquier framework que utilice TypeScript.', 'Estarás preparado para desarrollar aplicaciones modernas siguiendo las mejores prácticas de la industria.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Conocimiento básico de JavaScript: variables, ciclos y funciones', 'Conocimiento básico de programación estructurada es recomendado', 'Ganas de aprender un nuevo lenguaje basado en tipos', 'Posibilidad de instalar programas como administrador en su equipo']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 510,
    metadata_source_url = 'https://cursos.devtalles.com/courses/typescript-guia-completa',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'typescript-guia-completa'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- react-pro
WITH changed AS (
  UPDATE courses SET
    description = 'El curso tiene por objetivo pulir tus habilidades existentes de React con Hooks y llevarlas a un nivel superior para que tus aplicaciones de React sean aún mejores.',
    syllabus = 'Sección 1: Introducción
Sección 2: Reforzamiento sobre React
Sección 3: Opcional - Construcción del proyecto inicial
Sección 4: LazyLoad - Chunks - React Router Dom V5
Sección 5: Patrones de componentes - Compound Component Pattern
Sección 6: Patrones de componentes - Extensible Styles
Sección 7: Patrones de componentes - Control Props
Sección 8: State initializer + Function Child = Render Props - Formik implementation
Sección 9: NPM Deploy - Desplegar paquete de componentes
Sección 10: Formik - React Forms
Sección 11: Formik Dynamic y Custom Forms
Sección 12: Storybook - Cama para creación y mantenimiento de componentes y paquetes
Sección 13: NPM Empaquetamiento y publicación
Sección 14: Aplicación de React y Backend para PWA
Sección 15: React + PWA
Sección 16: Workbox
Sección 17: Mapas - Marcadores - Rutas - Polylines - Mapbox
Sección 18: Despedida del curso',
    learning_outcomes = ARRAY['Elevarás tus habilidades de React a un nivel profesional.', 'Aprenderás a crear componentes y librerías reutilizables listas para producción.', 'Dominarás herramientas como Storybook, GitHub Actions y Workbox.', 'Serás capaz de desarrollar aplicaciones React modernas, escalables y optimizadas para entornos reales.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Tener las bases de React con Hooks', 'Saber TypeScript es útil pero no indispensable (introducción incluida)', 'Poder realizar instalaciones en el equipo como administrador']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 1470,
    metadata_source_url = 'https://cursos.devtalles.com/courses/react-pro',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'react-pro'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
-- solid-clean-code
WITH changed AS (
  UPDATE courses SET
    description = 'Si hablamos de diseño y desarrollo de aplicaciones, los principios S.O.L.I.D. son palabras que debes conocer. Este curso te brindará los conocimientos para lograr mejorar y escribir un código limpio, fácil de leer, expandir y mantener a futuro.',
    syllabus = 'Sección 1: Introducción
Sección 2: Clean Code y Deuda técnica
Sección 3: Clean Code - Clases y Comentarios
Sección 4: Acrónimo - STUPID
Sección 5: Principios SOLID
Sección 6: Fin del curso',
    learning_outcomes = ARRAY['Comprenderás los cinco principios SOLID y cuándo aplicarlos.', 'Aprenderás a identificar y reducir la deuda técnica en tus proyectos.', 'Escribirás código más limpio, legible, mantenible y preparado para crecer con el tiempo.']::text[],
    skills_taught = ARRAY[]::text[],
    prerequisites = ARRAY['Tener conocimiento básico de programación', 'Conocimiento básico de JavaScript y TypeScript', 'Tener conceptos de programación orientada a objetos', 'Poder realizar instalaciones y descomprimir archivos']::text[],
    target_audience = ARRAY[]::text[],
    duration_minutes = 390,
    metadata_source_url = 'https://cursos.devtalles.com/courses/solid-clean-code',
    metadata_origin = 'public-page-scrape-v1',
    metadata_verified_at = NULL,
    updated_at = NOW()
  WHERE slug = 'solid-clean-code'
    AND metadata_origin = 'inferred-seed-v1'
    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL
    AND description LIKE 'Propuesta inicial de aprendizaje para%'
  RETURNING course_id
) INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;
DELETE FROM course_embeddings WHERE course_id IN (SELECT course_id FROM imported_course_metadata_ids);
SELECT COUNT(*) AS imported_courses FROM imported_course_metadata_ids;
COMMIT;

