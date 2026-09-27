--
-- PostgreSQL database dump
--

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.0

-- Started on 2026-09-26 21:28:58

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 292 (class 1259 OID 17514)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 17513)
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categories ALTER COLUMN category_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categories_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 295 (class 1259 OID 17525)
-- Name: course_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_categories (
    course_id bigint NOT NULL,
    category_id bigint NOT NULL
);


ALTER TABLE public.course_categories OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 17540)
-- Name: course_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_tags (
    course_id bigint NOT NULL,
    tag_id bigint NOT NULL
);


ALTER TABLE public.course_tags OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 17495)
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    course_id bigint NOT NULL,
    slug character varying(160) NOT NULL,
    title character varying(255) NOT NULL,
    course_url text NOT NULL,
    image_url text NOT NULL,
    image_alt character varying(255) NOT NULL,
    level character varying(20),
    topics jsonb DEFAULT '[]'::jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    source_verified_at date NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    description text,
    duration_minutes integer,
    language character varying(35),
    learning_outcomes text[] DEFAULT ARRAY[]::text[] NOT NULL,
    metadata_source_url text,
    metadata_verified_at timestamp with time zone,
    prerequisites text[] DEFAULT ARRAY[]::text[] NOT NULL,
    skills_taught text[] DEFAULT ARRAY[]::text[] NOT NULL,
    syllabus text,
    target_audience text[] DEFAULT ARRAY[]::text[] NOT NULL,
    metadata_origin character varying(40),
    CONSTRAINT ck_courses_duration_minutes CHECK (((duration_minutes IS NULL) OR (duration_minutes > 0))),
    CONSTRAINT ck_courses_image_url CHECK ((image_url ~~ 'https://import.cdn.thinkific.com/%'::text)),
    CONSTRAINT ck_courses_level CHECK (((level IS NULL) OR ((level)::text = ANY ((ARRAY['Principiante'::character varying, 'Intermedio'::character varying, 'Avanzado'::character varying])::text[])))),
    CONSTRAINT ck_courses_url CHECK ((course_url ~~ 'https://cursos.devtalles.com/courses/%'::text))
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 17494)
-- Name: courses_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.courses ALTER COLUMN course_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.courses_course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 294 (class 1259 OID 17520)
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    tag_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 17519)
-- Name: tags_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tags ALTER COLUMN tag_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tags_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4078 (class 0 OID 17514)
-- Dependencies: 292
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (1, 'Fundamentos', 'fundamentos');
INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (2, 'Frontend', 'frontend');
INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (3, 'Backend', 'backend');
INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (4, 'C# y .NET', 'csharp');
INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (5, 'Datos', 'datos');
INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (6, 'Inteligencia artificial', 'ia');
INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (7, 'Desarrollo móvil', 'movil');
INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (8, 'Herramientas', 'herramientas');
INSERT INTO public.categories OVERRIDING SYSTEM VALUE VALUES (9, 'Automatización', 'automatizacion');


--
-- TOC entry 4081 (class 0 OID 17525)
-- Dependencies: 295
-- Data for Name: course_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course_categories VALUES (1, 1);
INSERT INTO public.course_categories VALUES (2, 3);
INSERT INTO public.course_categories VALUES (3, 3);
INSERT INTO public.course_categories VALUES (3, 6);
INSERT INTO public.course_categories VALUES (4, 6);
INSERT INTO public.course_categories VALUES (4, 3);
INSERT INTO public.course_categories VALUES (5, 8);
INSERT INTO public.course_categories VALUES (5, 6);
INSERT INTO public.course_categories VALUES (6, 8);
INSERT INTO public.course_categories VALUES (6, 6);
INSERT INTO public.course_categories VALUES (7, 6);
INSERT INTO public.course_categories VALUES (7, 3);
INSERT INTO public.course_categories VALUES (8, 6);
INSERT INTO public.course_categories VALUES (9, 3);
INSERT INTO public.course_categories VALUES (10, 6);
INSERT INTO public.course_categories VALUES (11, 6);
INSERT INTO public.course_categories VALUES (12, 1);
INSERT INTO public.course_categories VALUES (13, 1);
INSERT INTO public.course_categories VALUES (14, 3);
INSERT INTO public.course_categories VALUES (15, 2);
INSERT INTO public.course_categories VALUES (16, 2);
INSERT INTO public.course_categories VALUES (17, 2);
INSERT INTO public.course_categories VALUES (18, 9);
INSERT INTO public.course_categories VALUES (19, 3);
INSERT INTO public.course_categories VALUES (20, 4);
INSERT INTO public.course_categories VALUES (20, 3);
INSERT INTO public.course_categories VALUES (21, 2);
INSERT INTO public.course_categories VALUES (22, 4);
INSERT INTO public.course_categories VALUES (22, 2);
INSERT INTO public.course_categories VALUES (23, 3);
INSERT INTO public.course_categories VALUES (24, 3);
INSERT INTO public.course_categories VALUES (25, 9);
INSERT INTO public.course_categories VALUES (25, 6);
INSERT INTO public.course_categories VALUES (26, 2);
INSERT INTO public.course_categories VALUES (27, 7);
INSERT INTO public.course_categories VALUES (27, 6);
INSERT INTO public.course_categories VALUES (28, 3);
INSERT INTO public.course_categories VALUES (29, 4);
INSERT INTO public.course_categories VALUES (29, 3);
INSERT INTO public.course_categories VALUES (29, 5);
INSERT INTO public.course_categories VALUES (30, 3);
INSERT INTO public.course_categories VALUES (31, 7);
INSERT INTO public.course_categories VALUES (31, 6);
INSERT INTO public.course_categories VALUES (32, 2);
INSERT INTO public.course_categories VALUES (33, 1);
INSERT INTO public.course_categories VALUES (34, 4);
INSERT INTO public.course_categories VALUES (34, 1);
INSERT INTO public.course_categories VALUES (35, 1);
INSERT INTO public.course_categories VALUES (36, 3);
INSERT INTO public.course_categories VALUES (37, 2);
INSERT INTO public.course_categories VALUES (38, 1);
INSERT INTO public.course_categories VALUES (39, 7);
INSERT INTO public.course_categories VALUES (40, 2);
INSERT INTO public.course_categories VALUES (41, 2);
INSERT INTO public.course_categories VALUES (42, 3);
INSERT INTO public.course_categories VALUES (43, 2);
INSERT INTO public.course_categories VALUES (44, 2);
INSERT INTO public.course_categories VALUES (45, 3);
INSERT INTO public.course_categories VALUES (46, 6);
INSERT INTO public.course_categories VALUES (46, 2);
INSERT INTO public.course_categories VALUES (46, 3);
INSERT INTO public.course_categories VALUES (47, 6);
INSERT INTO public.course_categories VALUES (47, 2);
INSERT INTO public.course_categories VALUES (47, 3);
INSERT INTO public.course_categories VALUES (48, 2);
INSERT INTO public.course_categories VALUES (49, 3);
INSERT INTO public.course_categories VALUES (50, 7);
INSERT INTO public.course_categories VALUES (51, 3);
INSERT INTO public.course_categories VALUES (52, 7);
INSERT INTO public.course_categories VALUES (53, 5);
INSERT INTO public.course_categories VALUES (54, 2);
INSERT INTO public.course_categories VALUES (55, 2);
INSERT INTO public.course_categories VALUES (56, 7);
INSERT INTO public.course_categories VALUES (57, 7);
INSERT INTO public.course_categories VALUES (58, 2);
INSERT INTO public.course_categories VALUES (59, 8);
INSERT INTO public.course_categories VALUES (60, 3);
INSERT INTO public.course_categories VALUES (61, 1);
INSERT INTO public.course_categories VALUES (62, 3);
INSERT INTO public.course_categories VALUES (63, 2);
INSERT INTO public.course_categories VALUES (64, 2);
INSERT INTO public.course_categories VALUES (65, 7);
INSERT INTO public.course_categories VALUES (65, 2);
INSERT INTO public.course_categories VALUES (66, 8);
INSERT INTO public.course_categories VALUES (67, 1);
INSERT INTO public.course_categories VALUES (68, 1);
INSERT INTO public.course_categories VALUES (69, 8);
INSERT INTO public.course_categories VALUES (70, 1);
INSERT INTO public.course_categories VALUES (71, 2);
INSERT INTO public.course_categories VALUES (72, 1);


--
-- TOC entry 4082 (class 0 OID 17540)
-- Dependencies: 296
-- Data for Name: course_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course_tags VALUES (1, 39);
INSERT INTO public.course_tags VALUES (1, 40);
INSERT INTO public.course_tags VALUES (1, 24);
INSERT INTO public.course_tags VALUES (2, 41);
INSERT INTO public.course_tags VALUES (3, 49);
INSERT INTO public.course_tags VALUES (3, 66);
INSERT INTO public.course_tags VALUES (3, 44);
INSERT INTO public.course_tags VALUES (3, 80);
INSERT INTO public.course_tags VALUES (3, 48);
INSERT INTO public.course_tags VALUES (3, 79);
INSERT INTO public.course_tags VALUES (4, 84);
INSERT INTO public.course_tags VALUES (4, 46);
INSERT INTO public.course_tags VALUES (4, 44);
INSERT INTO public.course_tags VALUES (4, 50);
INSERT INTO public.course_tags VALUES (4, 73);
INSERT INTO public.course_tags VALUES (4, 2);
INSERT INTO public.course_tags VALUES (4, 12);
INSERT INTO public.course_tags VALUES (5, 62);
INSERT INTO public.course_tags VALUES (5, 44);
INSERT INTO public.course_tags VALUES (6, 17);
INSERT INTO public.course_tags VALUES (6, 44);
INSERT INTO public.course_tags VALUES (7, 16);
INSERT INTO public.course_tags VALUES (7, 73);
INSERT INTO public.course_tags VALUES (7, 2);
INSERT INTO public.course_tags VALUES (7, 59);
INSERT INTO public.course_tags VALUES (7, 44);
INSERT INTO public.course_tags VALUES (8, 71);
INSERT INTO public.course_tags VALUES (8, 44);
INSERT INTO public.course_tags VALUES (9, 85);
INSERT INTO public.course_tags VALUES (9, 46);
INSERT INTO public.course_tags VALUES (9, 6);
INSERT INTO public.course_tags VALUES (10, 43);
INSERT INTO public.course_tags VALUES (10, 44);
INSERT INTO public.course_tags VALUES (11, 92);
INSERT INTO public.course_tags VALUES (11, 44);
INSERT INTO public.course_tags VALUES (12, 41);
INSERT INTO public.course_tags VALUES (12, 36);
INSERT INTO public.course_tags VALUES (13, 66);
INSERT INTO public.course_tags VALUES (13, 36);
INSERT INTO public.course_tags VALUES (14, 85);
INSERT INTO public.course_tags VALUES (14, 46);
INSERT INTO public.course_tags VALUES (14, 52);
INSERT INTO public.course_tags VALUES (15, 4);
INSERT INTO public.course_tags VALUES (15, 95);
INSERT INTO public.course_tags VALUES (15, 15);
INSERT INTO public.course_tags VALUES (16, 74);
INSERT INTO public.course_tags VALUES (16, 95);
INSERT INTO public.course_tags VALUES (16, 15);
INSERT INTO public.course_tags VALUES (17, 88);
INSERT INTO public.course_tags VALUES (17, 26);
INSERT INTO public.course_tags VALUES (18, 71);
INSERT INTO public.course_tags VALUES (18, 55);
INSERT INTO public.course_tags VALUES (18, 11);
INSERT INTO public.course_tags VALUES (19, 85);
INSERT INTO public.course_tags VALUES (19, 46);
INSERT INTO public.course_tags VALUES (19, 54);
INSERT INTO public.course_tags VALUES (19, 7);
INSERT INTO public.course_tags VALUES (20, 30);
INSERT INTO public.course_tags VALUES (20, 25);
INSERT INTO public.course_tags VALUES (20, 90);
INSERT INTO public.course_tags VALUES (20, 53);
INSERT INTO public.course_tags VALUES (21, 60);
INSERT INTO public.course_tags VALUES (21, 94);
INSERT INTO public.course_tags VALUES (22, 13);
INSERT INTO public.course_tags VALUES (22, 30);
INSERT INTO public.course_tags VALUES (22, 25);
INSERT INTO public.course_tags VALUES (22, 18);
INSERT INTO public.course_tags VALUES (23, 33);
INSERT INTO public.course_tags VALUES (23, 71);
INSERT INTO public.course_tags VALUES (23, 5);
INSERT INTO public.course_tags VALUES (24, 85);
INSERT INTO public.course_tags VALUES (24, 46);
INSERT INTO public.course_tags VALUES (25, 55);
INSERT INTO public.course_tags VALUES (25, 51);
INSERT INTO public.course_tags VALUES (25, 11);
INSERT INTO public.course_tags VALUES (25, 2);
INSERT INTO public.course_tags VALUES (25, 44);
INSERT INTO public.course_tags VALUES (26, 74);
INSERT INTO public.course_tags VALUES (27, 32);
INSERT INTO public.course_tags VALUES (27, 37);
INSERT INTO public.course_tags VALUES (27, 44);
INSERT INTO public.course_tags VALUES (28, 46);
INSERT INTO public.course_tags VALUES (28, 68);
INSERT INTO public.course_tags VALUES (28, 22);
INSERT INTO public.course_tags VALUES (28, 64);
INSERT INTO public.course_tags VALUES (29, 30);
INSERT INTO public.course_tags VALUES (29, 25);
INSERT INTO public.course_tags VALUES (29, 87);
INSERT INTO public.course_tags VALUES (29, 48);
INSERT INTO public.course_tags VALUES (29, 10);
INSERT INTO public.course_tags VALUES (30, 28);
INSERT INTO public.course_tags VALUES (30, 71);
INSERT INTO public.course_tags VALUES (31, 34);
INSERT INTO public.course_tags VALUES (31, 37);
INSERT INTO public.course_tags VALUES (31, 44);
INSERT INTO public.course_tags VALUES (32, 74);
INSERT INTO public.course_tags VALUES (32, 76);
INSERT INTO public.course_tags VALUES (32, 31);
INSERT INTO public.course_tags VALUES (33, 71);
INSERT INTO public.course_tags VALUES (33, 36);
INSERT INTO public.course_tags VALUES (34, 25);
INSERT INTO public.course_tags VALUES (34, 36);
INSERT INTO public.course_tags VALUES (35, 46);
INSERT INTO public.course_tags VALUES (35, 36);
INSERT INTO public.course_tags VALUES (36, 56);
INSERT INTO public.course_tags VALUES (36, 90);
INSERT INTO public.course_tags VALUES (36, 70);
INSERT INTO public.course_tags VALUES (36, 69);
INSERT INTO public.course_tags VALUES (37, 4);
INSERT INTO public.course_tags VALUES (38, 64);
INSERT INTO public.course_tags VALUES (39, 75);
INSERT INTO public.course_tags VALUES (39, 74);
INSERT INTO public.course_tags VALUES (39, 32);
INSERT INTO public.course_tags VALUES (39, 45);
INSERT INTO public.course_tags VALUES (39, 3);
INSERT INTO public.course_tags VALUES (40, 4);
INSERT INTO public.course_tags VALUES (41, 9);
INSERT INTO public.course_tags VALUES (42, 56);
INSERT INTO public.course_tags VALUES (42, 59);
INSERT INTO public.course_tags VALUES (42, 65);
INSERT INTO public.course_tags VALUES (42, 78);
INSERT INTO public.course_tags VALUES (43, 82);
INSERT INTO public.course_tags VALUES (43, 1);
INSERT INTO public.course_tags VALUES (43, 20);
INSERT INTO public.course_tags VALUES (44, 94);
INSERT INTO public.course_tags VALUES (44, 21);
INSERT INTO public.course_tags VALUES (45, 56);
INSERT INTO public.course_tags VALUES (45, 52);
INSERT INTO public.course_tags VALUES (46, 61);
INSERT INTO public.course_tags VALUES (46, 4);
INSERT INTO public.course_tags VALUES (46, 56);
INSERT INTO public.course_tags VALUES (46, 44);
INSERT INTO public.course_tags VALUES (46, 8);
INSERT INTO public.course_tags VALUES (47, 61);
INSERT INTO public.course_tags VALUES (47, 74);
INSERT INTO public.course_tags VALUES (47, 56);
INSERT INTO public.course_tags VALUES (47, 44);
INSERT INTO public.course_tags VALUES (47, 8);
INSERT INTO public.course_tags VALUES (48, 96);
INSERT INTO public.course_tags VALUES (48, 74);
INSERT INTO public.course_tags VALUES (48, 38);
INSERT INTO public.course_tags VALUES (49, 59);
INSERT INTO public.course_tags VALUES (49, 10);
INSERT INTO public.course_tags VALUES (49, 80);
INSERT INTO public.course_tags VALUES (49, 18);
INSERT INTO public.course_tags VALUES (50, 34);
INSERT INTO public.course_tags VALUES (50, 14);
INSERT INTO public.course_tags VALUES (50, 38);
INSERT INTO public.course_tags VALUES (51, 59);
INSERT INTO public.course_tags VALUES (52, 81);
INSERT INTO public.course_tags VALUES (52, 38);
INSERT INTO public.course_tags VALUES (53, 86);
INSERT INTO public.course_tags VALUES (53, 67);
INSERT INTO public.course_tags VALUES (54, 57);
INSERT INTO public.course_tags VALUES (54, 74);
INSERT INTO public.course_tags VALUES (55, 72);
INSERT INTO public.course_tags VALUES (56, 34);
INSERT INTO public.course_tags VALUES (56, 77);
INSERT INTO public.course_tags VALUES (57, 34);
INSERT INTO public.course_tags VALUES (58, 4);
INSERT INTO public.course_tags VALUES (58, 58);
INSERT INTO public.course_tags VALUES (59, 29);
INSERT INTO public.course_tags VALUES (59, 23);
INSERT INTO public.course_tags VALUES (60, 56);
INSERT INTO public.course_tags VALUES (60, 42);
INSERT INTO public.course_tags VALUES (60, 5);
INSERT INTO public.course_tags VALUES (61, 36);
INSERT INTO public.course_tags VALUES (62, 56);
INSERT INTO public.course_tags VALUES (62, 59);
INSERT INTO public.course_tags VALUES (63, 94);
INSERT INTO public.course_tags VALUES (63, 63);
INSERT INTO public.course_tags VALUES (64, 89);
INSERT INTO public.course_tags VALUES (64, 38);
INSERT INTO public.course_tags VALUES (65, 34);
INSERT INTO public.course_tags VALUES (65, 35);
INSERT INTO public.course_tags VALUES (66, 93);
INSERT INTO public.course_tags VALUES (67, 27);
INSERT INTO public.course_tags VALUES (67, 36);
INSERT INTO public.course_tags VALUES (68, 47);
INSERT INTO public.course_tags VALUES (68, 36);
INSERT INTO public.course_tags VALUES (69, 39);
INSERT INTO public.course_tags VALUES (69, 40);
INSERT INTO public.course_tags VALUES (69, 24);
INSERT INTO public.course_tags VALUES (70, 91);
INSERT INTO public.course_tags VALUES (71, 74);
INSERT INTO public.course_tags VALUES (72, 83);
INSERT INTO public.course_tags VALUES (72, 19);


--
-- TOC entry 4076 (class 0 OID 17495)
-- Dependencies: 290
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (15, 'angular-sockets-bun', 'Angular + Sockets: Aplicaciones en tiempo real con Bun', 'https://cursos.devtalles.com/courses/Angular_socket_bun', 'https://import.cdn.thinkific.com/643563/abdhTcCTQCmySk3eb8Ma_ANGULAR_WEBSOCKET_BUN_DEVTALLES.png', 'Portada del curso: Angular + Sockets: Aplicaciones en tiempo real con Bun', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a crear y configurar aplicaciones en tiempo real usando la implementación nativa de websockets junto a un backend en Bun.', 870, 'es', '{}', 'https://cursos.devtalles.com/courses/Angular_socket_bun', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de JavaScript o TypeScript (variables, funciones, async/await).","Conocimientos básicos de Angular.","Poder realizar instalaciones en el equipo (editor de código, extensiones y Bun)","Ganas de practicar: vamos a construir varios proyectos y probar con múltiples navegadores.","No necesitas experiencia previa con WebSockets ni con Bun."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Primeros pasos en los WebsSockets
- Introducción
- Temas puntuales
- ¿Qué son? y ¿Cómo funcionan los WebSockets?
- Bun - Configuración del servidor
- Bun - Servir archivos HTML
- Conectar cliente al servidor de WebSockets
- Cliente - Métodos nativos de WebSockets
- Optimizar conexión y desconexión
- Enviar y recibir mensajes
- Publicar mensajes a todo el canal
- Enviar cookies y searchParams
- Protección de conexión
- Código fuente

Sección 3: Backend - Partidos políticos
- Introducción
- Temas puntuales
- Explicación de lo que construiremos
- Inicio de proyecto - Partidos Políticos
- Configuraciones del servidor y websockets
- Handler - Controlador de mensaje general
- Manejo de errores y respuestas
- Configurar todas las respuestas
- Resolución de la tarea
- Crear diseño del Store
- Crear servicio - PartyService
- Conectar controladores con el servicio
- Probar implementación de WebSockets
- Zod - Esquema de validación
- Asignar el tipo de data al payload
- Código fuente

Sección 4: Angular - Partidos políticos
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - Partidos políticos
- ChartJS - Nuestra primera gráfica
- Configuraciones de gráfica
- Diseño del formulario de partidos políticos
- Tipos de datos
- Levantar WebSocket Server
- WebSocket - Servicio de conexión
- Reconexión al servidor
- Enviar y escuchar mensajes
- Mostrar información de la gráfica
- Tarea - Mostrar data del formulario
- Signal outputs
- Emitir mensajes al servidor
- Solución a la tarea - Agregar Partidos
- Actualizar gráfica en tiempo real
- Código fuente

Sección 5: Backend - Mapas y movimientos
- Introducción
- Temas puntuales
- Explicación de lo que construiremos
- Inicio de proyecto - SocketMap
- Interfaces, tipos y estructuras de mensajes
- Identificar cliente en la conexión inicial
- Esquema de validación de payload
- Manejadores de mensajes
- Punto de control - Comprobar backend
- Configuración del Store
- Configuración del Servicio
- Conectar manejadores con servicio
- Resolución de la tarea
- Registrar ingreso y salida de clientes
- Pruebas del backend
- Código fuente

Sección 6: Angular - Mapas en tiempo real
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - SocketMaps
- Formulario reactivo - ConnectForm
- Mostrar un mapa en pantalla
- Emitir ubicación central del mapa
- Conectarnos a nuestro servidor de WebSockets
- Reconexión y cambios en pantalla
- Crear marcadores
- Emitir movimientos de marcadores
- Actualizar y remover marcadores
- Código fuente

Sección 7: Backend - Sistema de colas
- Introducción
- Temas puntuales
- Explicación de lo que construiremos
- Inicio de proyecto - TicketApp
- Store y tipos de datos
- Métodos del Store
- Asignar siguiente ticket
- Ticket Service
- WebSockets - Tipos de mensajes
- Manejadores de mensajes
- Tarea - Implementar respuestas
- Tarea - Implementar solicitud de ticket
- Pruebas de funcionamiento
- Código fuente

Sección 8: Angular - Sistema de colas
- Introducción
- Temas puntuales
- Demostración
- Preparación de proyecto
- WebSocket Server - Tipado estricto
- WebSocket Service - Servicio de conexión
- Crear nuevo ticket
- Pantalla de escritorio - Siguiente ticket
- Solución de la tarea
- Ticket Service - Servicio para controlar los tickets
- Cola atendida de tickets
- Código fuente

Sección 9: Backend - Chat - Seguridad
- Introducción
- Temas puntuales
- Explicación de lo que construiremos
- Inicio de proyecto - ChatApp
- Base de datos - PostgreSQL
- Prisma ORM - Conectar backend con PostgreSQL
- Diseño y esquema de base de datos
- Migraciones y Cliente de Prisma
- Semilla de base de datos
- Solicitud Post - Login de usuario
- Generar JsonWebToken
- Código fuente

Sección 10: Backend - Chat con mensajes privados - Websockets
- Introducción
- Temas puntuales
- Continuación de sección
- Crear tipos de mensajes y estructuras
- Zod - Esquemas de validación
- Servicio de mensajes
- Obtener mensajes grupales
- Manejar mensajes del cliente
- Implementar seguridad de WebSockets
- User Service - Controlar usuarios
- Emitir mensajes de respuesta
- Formulario de login y envío de mensajes
- Probar envío de mensajes
- Código fuente

Sección 11: Mensajes privados y usuarios conectados
- Introducción
- Temas puntuales
- Continuación de proyecto
- Store - Usuarios conectados
- Solución de tarea - Usuarios conectados
- Crear y obtener mensajes privados
- Handlers - Mensajes directos
- Enviar mensaje directo
- Mostrar usuarios conectados
- Prueba de mensajes directos y globales
- Tarea - Creación de un frontend
- Código fuente

Sección 12: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (40, 'angular-pro', 'Angular Pro: Lleva tus bases al siguiente nivel', 'https://cursos.devtalles.com/courses/angular-pro', 'https://import.cdn.thinkific.com/643563/EWRrDzSVRybXmB6yJMHU_Angular%20pro%20COVER-DEVTALLES-ANGULAR-PRO.jpg', 'Portada del curso: Angular Pro: Lleva tus bases al siguiente nivel', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Angular PRO, es un curso que llevará tu conocimiento de Angular al siguiente nivel con SSR, SSG, Testing, Zoneless, TanStack, optimizaciones y mucho más.', 1290, 'es', '{}', 'https://cursos.devtalles.com/courses/angular-pro', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de Angular es necesario","Poder realizar instalaciones como administrador","Poder subir repositorios a GitHub"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas

Sección 2: Zoneless Calculator
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - ZonelessCalculator
- Diseño y estructura
- Separación de componentes
- Host Element - Content Projection
- InputSignal y HostBindings
- ViewEncapsulation
- Espacio para cálculos previos
- Código fuente

Sección 3: Señales, comportamiento y lógica
- Introducción
- Temas puntuales
- Demostración
- Continuar proyecto
- OutputEmitterRef y Signal ViewChild
- HostListener - Host Property
- viewChildren - Señal para obtener elementos hijos
- Calculator Service
- Construir número - Validaciones
- Construir número - Parte 2
- Realizar cálculos
- Código fuente de la sección

Sección 4: Testing - Zoneless Calculator
- Introducción
- Temas puntuales
- Introducción a las pruebas automáticas
- Configuración Vitest
- Mi primera prueba
- Fixture, compiled y component instance
- Evaluar estructura HTML del componente
- Tarea - Confirmar atributos de un elemento HTML
- Pruebas en servicios con señales
- Pruebas CalculatorService
- Pruebas CalculatorService - Operadores
- Pruebas CalculatorService - Resultados
- Pruebas CalculatorService - Operadores especiales
- Vitest espías - vi.spyOn
- Pruebas en el CalculatorView
- Simular importación de componentes
- Cobertura de pruebas
- Pruebas CalculatorButton - HostElement
- Emitir eventos
- Efectos visuales de la calculadora
- Probar el contenido proyectado
- Mocks de servicios - Calculator
- Pruebas físicas de la calculadora
- Eventos del teclado
- Evaluar contenido proyectado
- Código fuente

Sección 5: Angular - SSR - SSG - Hydration
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - PokemonSSR
- SPA Tradicional
- Navbar - Navegar entre páginas
- Habilitar - Server Side Rendering
- Titulo y Metatags - SEO Friendly
- PLATFORM_ID - Cliente y Server
- Construcción y ejecución
- Desplegar a Netlify - SSR
- Código fuente

Sección 6: Angular SSR - SSG - Con peticiones HTTP
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Creación de componentes
- Skeleton Loader
- ApplicationRef - STABLE
- Realizar peticiones HTTP
- Efectos e Inputs - Mostrar información en pantalla
- Página actual - QueryParameters
- Actualizar QueryParams y Título de la página
- Mostrar Skeleton
- Página del Pokémon
- @let syntax finalizar pantalla
- Metatags y Title
- Desplegar y probar metatags
- Código fuente

Sección 7: Static Site Generation - Pre-Rendering SSG + Hybrid
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Paginación por segmentos de ruta
- Prerendering - Static Site Generation - SSG
- Construir Routes.txt automáticamente
- Construir Routes basado en peticiones HTTP
- Pruebas en producción
- Código fuente

Sección 8: Testing - PokemonSSR
- Introducción
- Temas puntuales
- Pruebas en AppComponent
- Técnicas para renderizar componentes
- Fotografías del HTML - Snapshots
- Pruebas en el App Routes
- Probar carga perezosa y navegación
- Resolución de la tarea - App Routes
- Pruebas en PokemonCardComponent
- Probar atributos y directivas
- Pruebas en PokemonListComponent
- Pruebas con Servicios HTTP - Preparación
- Pruebas de peticiones HTTP
- Probar peticiones HTTP fallidas
- Conectar testing con el método build
- Código fuente de la sección

Sección 9: TanStack Query - Angular
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - GitHub Issues
- Crear páginas y rutas
- TanStack Query - Instalación
- GitHub Api - GetLabels
- Realizar petición HTTP
- Mostrar labels en pantalla
- Environments y GetIssues
- Mostrar issues en pantalla
- Obtener issue por número
- Mostrar información del issue
- Mostrar comentarios del issue
- Código fuente

Sección 10: TanStack - Filtros y optimizaciones
- Introducción
- Temas puntuales
- Demostración
- Continuar aplicación
- PrefetchQuery
- SetQueryData
- Mostrar issues por estado
- Condición completa - Filtrar por estado y etiquetas
- Código fuente

Sección 11: GitHub Issues App Testing
- Introducción
- Temas puntuales
- Continuación de aplicación
- Pruebas - GetIssue Action
- Manejo de excepciones
- Pruebas - GetIssueComments
- Pruebas - IssueService + TanStack
- Pruebas en los métodos del servicio
- Pruebas - Obtener etiquetas con TanStack
- Aplicar filtros con señales
- Código fuente

Sección 12: Crear paquetes personalizados de Angular a NPM
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto
- Panel administrativo
- Terminar componente de SideMenu
- Crear monorepo y librería - apx-workspace
- Comandos útiles para la librería
- Ejecutar librería dentro del monorepo
- Funcionalidad y estilo de la librería
- Testing del paquete
- Publicar a NPM
- Utilizar paquete en otros proyectos
- Añadir y actualizar paquete
- Código fuente

Sección 13: Angular internationalization - i18n
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto
- Estructura y componentes
- Escribir y leer Cookies
- Instalación de ngx-translate
- Archivos de traducciones
- Reemplazar textos por traducciones
- Tarea - Cambiar textos faltantes
- Custom Injection Tokens
- Leer y utilizar cookies desde el servidor
- Código fuente

Sección 14: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso

Archivado: Jasmine Karma - Zoneless Calculator
- Introducción
- Temas puntuales
- Introducción al testing automático
- Configuración Karma - Jasmine
- Mi primera prueba
- Evaluar RouterOutlet y refactorización
- Evaluar clases y atributos HTML
- Pruebas en servicios con señales
- Ciclo de vida - ReInicialización
- Construir número y cálculos
- Pruebas con operadores especiales
- Pruebas en CalculatorView
- CalculatorButton - HostElement
- Espías - Métodos y Done Function
- Probando contenido proyectado
- Preparar pruebas en CalculatorComponent
- Mock CalculatorService
- Utilizar la instancia del Mock Service
- Pruebas en ViewChildren y Content Projected
- Simulando acciones de KeyPress
- Código fuente

Archivado: Jasmine Karma - PokemonSSR
- Introducción
- Temas puntuales
- Pruebas en AppComponent
- Component Mock
- Pruebas en App Routes
- Probar la carga del componente
- Pruebas en PokemonCardComponent
- Tarea - Pruebas en PokemonCardComponent
- Pruebas en PokemonListComponent
- Pruebas con Servicios HTTP - Preparación
- Prueba - Cargar la primera página de Pokémons
- Cargar la página 5 y un Pokémon por ID
- Pruebas si no se encuentra la información
- Conectar testing con Build
- Código fuente

Archivado: Jasmine Karma - GitHub Issues App Testing
- Introducción
- Temas puntuales
- Continuación
- Pruebas - GetIssue
- Pruebas - GetIssue con error
- Pruebas - GetIssueComments
- Pruebas - IssueService + TanStack
- Pruebas - Debe de cargar labels
- Pruebas - Aplicar filtros con señales
- Pruebas - Filtrar por label
- Código fuente', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (41, 'astro', 'Astro: El framework para sitios web orientados al contenido', 'https://cursos.devtalles.com/courses/Astro', 'https://import.cdn.thinkific.com/643563/8b0gaETkTXeL6iB3f1Pn_ASTRO.jpg', 'Portada del curso: Astro: El framework para sitios web orientados al contenido', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Framework de desarrollo web diseñado para construir sitios web rápidos y eficientes con las tecnologías que ya conoces.', 1530, 'es', '{}', 'https://cursos.devtalles.com/courses/Astro', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de JavaScript es necesario","Conocimiento básico de maquetación HTML y CSS (recomendado)","Saber TypeScript no es necesario (pero es de utilidad)"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funciona el curso?
- ¿Preguntas?
- Instalaciones necesarias

Sección 2: Introducción a Astro
- Introducción a la sección
- Temas puntuales de la sección
- Presentación sobre Astro
- Nuestro primer sitio en Astro
- Estructura de un proyecto
- Sintaxis y funcionamiento de los archivos .astro
- Tarea - Actualizar momento actual
- Navegación entre páginas
- Reutilización de componentes
- Layouts y Props
- Estilos por componente y globales
- Página 404
- View Transitions
- Recapitulación
- Despliegue
- Código fuente de la sección

Sección 3: Rutas dinámicas y paginación estática
- Introducción
- Temas puntuales de la sección
- Demostración
- Inicio de proyecto - PokemonStatic
- Crear estructura y layouts
- Peticiones HTTP en tiempo de construcción
- Componentes y Props
- Páginas dinámicas - Argumentos por URL
- Props dinámicos
- Crear 151 páginas estáticas
- Estilo condicional
- ViewTransition + Name Transition
- Paginación estática
- Controles de la paginación
- Tarea - Páginas por ID
- TypeScript - Path Alias
- Metadatos - Image y descripción
- Desplegar sitio y confirmar metadatos
- Zero JavaScript - ViewTransitions
- Código fuente de la sección

Sección 4: Añadir dinamismo a nuestro sitio estático
- Introducción a la sección
- Temas puntuales de la sección
- Demostración
- Continuación del proyecto
- Indicador de ruta activa
- Astro Icon
- Client Side Scripting
- Ciclo de vida del View Transition
- LocalStorage
- Indicador si existe en el LocalStorage
- Astro Islands - Integración con SolidJS
- Directivas del lado del cliente
- Props y Componentes hacia las islas
- Mostrar listado de favoritos
- Mostrar y remover favoritos
- View Transition - Desde Isla
- Código fuente de la sección

Sección 5: Colecciones e imágenes
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - Blog
- Markdown y MDX
- Layouts para los markdown
- Estructura de nuestro blog
- Astro Glob y Props
- Colecciones de Astro - Astro Collections
- Mostrar entradas de blog - Colecciones
- Mostrar contenido del post
- Componente Image
- Formatos y resoluciones de imágenes
- Imágenes en colecciones
- Código fuente de la sección

Sección 6: Relaciones de colecciones
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Relaciones en colecciones
- Mostrar información del autor
- Todas las entradas del autor
- Aplicar filtro en las colecciones
- Tarea - Listado de autores
- Resolución de la tarea
- Código fuente de la sección

Sección 7: Astro Themes
- Introducción
- Temas puntuales
- Inicio de proyecto
- Usando temas de terceros
- Documentación con Starlight
- Agregar contenido a los Docs

Sección 8: RSS Feed
- Introducción
- Temas puntuales
- Demostración de la sección
- Continuación de proyecto
- HTTP Get - Endpoint
- RSS Feed - Astro
- Desplegar sitio web
- Descubrimiento automático y pruebas
- Imagen y contenido en el News Feed
- Código fuente de la sección

Sección 9: Server Side Rendering y Endpoints
- Introducción
- Temas puntuales
- Demostración de la sección
- Inicio de proyecto - Astro Http
- Restful API estáticos
- GET - Obtener todos los Posts
- SSR Adapters
- Hybrid vs Server vs Static
- Query Parameters - Opcionales
- Segmentos de Ruta - Params
- Post, Put, Delete Endpoints
- Despliegue a Cloudflare
- Código fuente de la sección

Sección 10: Astro DB
- Introducción - Turso
- Temas puntuales
- Demostración - Turso
- Astro DB
- Crear tabla de clientes
- Tarea - Clients CRUD
- CRUD con Astro DB - Post y Get
- CRUD con Astro DB - Patch y Delete
- Turso - Una base de datos para desarrolladores
- Get de clientes individuales - Turso
- Desplegar a Cloudflare
- Código fuente de la sección

Sección 11: Server Actions - Funciones de Blog - Likes Counter
- Introducción
- Temas puntuales
- Demostración
- Estructura y Seed
- Get - Obtener los likes actuales
- Put - Incrementar la cantidad de likes
- Like Counter - Componente con Vue.js
- Vue - Props y cantidad de likes
- Vue - Incrementar localmente
- Vue - Actualizar la cantidad en base de datos
- Lodash Debounce
- Ver cambios en producción - Turso
- Introducción - Server Actions
- Server Actions - Obtener Likes
- Actualizar likes - Action
- Código fuente de la sección

Sección 12: Autenticación y protección de rutas
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto
- Navegación y estructura
- Astro Middleware
- Autenticación propia
- Acción: Registro de usuario
- Cookies: Recordar usuario
- Firebase Auth - Configuración de proyecto
- Autenticación por Correo y Contraseña
- Mostrar información del usuario autenticado
- Logout - Cerrar sesión
- Login - Inicio de sesión
- Solución de Tarea - Implementación del login
- DisplayName y Verificación de correo
- Google SignIn
- Astro Locals - env.d.ts
- Proteger rutas desde Middleware
- Desplegar a producción
- Código fuente de la sección

Sección 13: Autenticación y autorización - Auth.js
- Introducción
- Temas puntuales
- Demostración
- Inicio del proyecto
- Astro DB - Tabla de usuarios y seed
- AuthJs - Configuraciones de Login
- AuthJS - Credentials Provider
- AuthJS - Iniciar sesión
- Middleware y cerrar sesión
- AuthJS - Expandir objeto de sesión
- Código fuente de la sección

Sección 14: Productos, paginación y SEO
- Introducción
- Temas puntuales
- Demostración
- Continuación y preparación
- Batch Transactions
- Action: Obtener productos por página
- AstroDB - Raw Queries
- Mostrar productos - Integración con React
- Product Card - Componente de React
- Paginación - Componente de Astro
- Paginar basado en server actions
- Página de producto
- Swiper - Carrusel de imágenes
- Funcionalidad - Agregar al carrito
- Mostrar ícono de carrito
- Código fuente de la sección

Sección 15: Carrito - Cookies y Nanostores
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Client Cookies
- Grabar y leer cookies
- Action: Cargar productos del carrito
- Action: Cargar productos del carrito - Parte 2
- Pantalla del carrito de compras
- Eliminar del carrito de compras
- Compartir información entre islas - NanoStores
- View Transitions - Persistencia y eventos
- Código fuente de la sección

Sección 16: Mantenimiento de productos
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Listado de productos
- Pantalla para editar producto
- Action: Actualizar Producto
- Crear producto
- Action: Recibir archivos a cargar
- Cloudinary - Preparación de servicio
- Cargar imágenes a Cloudinary
- Actualización y grabación por lote
- Eliminar imágenes
- Eliminar y actualizar DOM
- Drag & Drop - Estilos y comportamiento
- Drag & Drop - Manejar el evento DROP
- Aprovisionar base de datos - Turso
- Turso - Llenar base de datos
- Desplegar a Netlify
- Meta tags - SEO
- Código fuente de la sección

Sección 17: Server Islands - Prisma
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto
- NeonTech - PostgreSQL en Serverless
- Prisma con NeonTech y Astro
- Server Actions con Prisma
- Mostrar lugar en la tarjeta
- Páginas estáticas de lugares
- Astro Server Islands - Demostración
- Creando un Server Island
- Código fuente

Opcional: Astro con PostgreSQL
- Introducción
- Temas puntuales
- Demostración
- Continuación de la aplicación
- Tarea - Client Endpoints
- Neon.tech - PostgreSQL en la nube
- Prisma y PostgreSQL con Astro
- Insertar y obtener registros
- Path Alias - TypeScript
- Obtener cliente por ID
- Actualizar y eliminar clientes
- Código fuente

Opcional: Astro con PosgreSQL + Actions continuación
- Introducción
- Temas puntuales
- Demostración
- Continuación de la aplicación
- Componente - LikeCounter - VueJS
- Preparar tabla y esquema
- Seed de base de datos
- Lógica del componente - LikeCounter
- Server Actions
- Server Action - getLikes
- Server Action - updateLikeCount
- Debounce - Esperar un momento antes de enviar
- Preparar para despliegue en Render
- Desplegar en Render
- Código fuente

Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (6, 'claude-code-guia-completa', 'Claude Code: Guía completa para desarrolladores de software', 'https://cursos.devtalles.com/courses/claude-code-guia-completa', 'https://import.cdn.thinkific.com/643563/hWQRull4RXmytJSqs3e4_COVER-DEVTALLES-CLAUDE-CODE.jpg', 'Portada del curso: Claude Code: Guía completa para desarrolladores de software', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a usar Claude Code sin importar si ya lo has usado antes. Desde la instalación y flujos de trabajo diarios, hasta personalización con CLAUDE.md, conexión a servicios externos vía MCP, automatización con hooks y mucho más.', 1050, 'es', '{}', 'https://cursos.devtalles.com/courses/claude-code-guia-completa', '2026-09-24 15:49:29.94579+00', '{"Experiencia básica de programación (no hace falta ser experto).","Una suscripción a Claude Code para seguir las prácticas paso a paso. (Se enseña Ollama para seguir el curso gratis en su mayoría)","Conocimientos básicos de Git y línea de comandos son recomendables pero no obligatorios."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones iniciales

Sección 2: Instalación y consumo de tokens
- Introducción
- Temas puntuales
- Instalación de ClaudeCode
- Revisa consumo de servicio
- Visual Studio Code - Extensión como terminal
- Importante - ¿Cómo crece el contexto y consumo de tokens?
- Gestionar costos de manera efectiva
- Gestionar costos de manera efectiva - Parte 2
- Configuraciones personales

Sección 3: ClaudeCode con modelos de Ollama
- Introducción
- Temas puntuales
- Correr y configurar modelos locales

Sección 4: Fundamentos - ClaudeCode 101
- Introducción
- Temas puntuales
- Tour por ClaudeCode
- Comando /rewind - Volver a estados anteriores
- El ciclo del agente
- Información de una base de código
- Claude.md - Memoria persistente
- Memoria rápida
- Multi Modal Inputs
- Corregir errores de código
- ClaudeCode puede ver Git
- Implementar una nueva funcionalidad
- Código fuente de la sección
- Repaso interactivo: Fundamentos - ClaudeCode 101

Sección 5: Fundamentos - Flujo de trabajo
- Introducción
- Temas puntuales
- Inicio de proyecto - Tetris
- Comandos iniciales - Comandos de ClaudeCode
- Comandos de flujo diario
- Comandos útiles que debes conocer
- GitHub App - Integraciones
- Revisar cambios de GitHub ClaudeCode
- Formateador de Issues
- Implementar cambios desde GitHub ClaudeCode
- Solventar problemas localmente - Thinking mode (effort)
- Tarea - Nuevas funcionalidades
- Código fuente
- Repaso interactivo: Fundamentos - Flujo de trabajo

Sección 6: Avanzado - Batch - Worktrees
- Introducción
- Temas puntuales
- Preparación de proyecto
- Comando/batch
- Comando /batch - Parte 2
- Batch - Unir trabajo
- Git WorkTrees - Manualmente
- Agentes en paralelo manualmente
- Unir Worktrees
- Comando personalizado /worktree
- Uso de comandos personalizados
- Unir Worktrees y commits
- Código fuente
- Repaso interactivo: Avanzado - Batch - Worktrees

Sección 7: Intermedio - Spec Driven Design
- Introducción
- Temas puntuales
- Explicación - Spec Driven Design
- Explicación - Anatomía de un spec útil
- Introducción a las Skills
- Spec Driven Design - Configuración
- Spec Driven Design - Spec MVP
- Implementar Spec MVP
- No usar Specs
- Spec Driven - Animación de destrucción
- Implementar Spec - Animación de destrucción
- Tarea - Sonidos y niveles
- Solución de la tarea - Sonidos y niveles
- Solución - Implementación sonidos y niveles
- Prompts rápidos de edición
- Actualizar referencias
- Código fuente
- Repaso interactivo: Intermedio - Spec Driven Design

Sección 8: Intermedio - Skills y Playwright MCP
- Introducción
- Temas puntuales
- Inicio de proyecto - Arcade Vault
- Inicializaciones y repositorio
- Frontend Skill
- spec - MVP de Arcade Vault
- impl - MVP de Arcade Vault
- MCP - Playwright
- PR - MVP de Arcade Vault
- Tarea - Spec Home
- Solución - Spec Home
- Solución - Impl Home
- Spec - Página de about y envío de correo
- Finalizar implementación
- Código fuente
- Repaso interactivo: Intermedio - Skills y Playwright MCP

Sección 9: Intermedio - Hooks y MCPs
- Introducción
- Temas puntuales
- Continuación de proyecto - Arcade Vault
- Hooks - Notificación básica
- Hooks - Linter y Prettier
- Opcional - Configurar formato de código
- Añadir y administrar MCPs
- Opcional - Push de configuraciones
- Spec - Supabase con Next.js
- Impl - Supabase con Next.js
- Spec - Juego de Asteroides
- Imp - Asteroides
- Spec - Leaderboard
- Impl - Leaderboard
- Código fuente
- Repaso interactivo: Intermedio - Hooks y MCPs

Sección 10: Intermedio - Skills y comandos basados en Specs
- Introducción
- Temas puntuales
- Continuación de proyecto
- Creación de Skills y comandos
- Skill add-game - En acción
- Impl - Tetris
- Tarea - Arkanoid
- Impl - Arkanoid
- Tarea - Snake
- Solución - Snake
- Código fuente de la sección
- Repaso interactivo: Skills y comandos basados en Specs

Sección 11: Avanzado - Agentes - Patrón Orquestador/Trabajador
- Introducción
- Temas puntuales
- Introducción a los agentes
- Levantar proyecto - Arcade Vault
- Actualizar claude.md
- Crear mi primer agente
- Agente - game-planner
- Agente - game-jam
- Pruebas de agente - game-jam
- Agente - skin-designer
- Pruebas de agente - skin-designer
- Problema y solución viable
- Impl - Controles táctiles
- Ajustes del GamePad
- Agente - mobile-porter
- Opcional - Gamepad skin
- Código fuente
- Repaso interactivo: Agentes - Patrón Orquestador/Trabajador

Sección 12: Avanzado - Skill con agentes + rutinas
- Introducción
- Temas puntuales
- Continuación de proyecto
- Comando personalizado con agentes
- Invocar nueva habilidad colectiva
- Importante - Actualización de Frogger
- Agente - Game performance
- Rutinas y Cron Jobs
- Editar, eliminar y recrear rutinas
- Código fuente
- Repaso interactivo: Skill con agentes + rutinas

Sección 13: Intermedio - Autenticación y seguridad
- Introducción
- Temas puntuales
- Continuación de proyecto
- Spec - Autenticación
- Imp - Autenticación
- Pruebas de autenticación
- Autenticación - Email y password
- Spec - Seguridad en la aplicación
- Impl - Seguridad en la aplicación
- Agente auditor de seguridad
- Código fuente
- Repaso interactivo: Autenticación y seguridad

Sección 14: Intermedio - Skills, Plugins y utilidades
- Introducción
- Temas puntuales
- Continuación de proyecto
- ClaudeCode plugin marketplace
- Typescript-lsp (language server protocol)
- code-simplifier - Simplifica y mejora el código
- security-guidance - Revisión de código
- Remote access
- Brainstorming Superpowers
- Context7 - Documentación actualizada
- Notificaciones vía Telegram
- Código fuente de la sección
- Repaso interactivo: Skills, Plugins y utilidades

Sección 15: Avanzado - Producción
- Introducción
- Temas puntuales
- Continuación de proyecto
- Supabase en producción
- Preparar plan de migración
- Google y GitHub - Configuraciones
- Desplegar a producción
- Opcional - Acceso de solo lectura a Prod
- Código fuente
- Repaso interactivo: Producción

Sección 16: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida
- Material extra: Presentación del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (34, 'csharp', 'C#: Empieza tu camino en el lenguaje', 'https://cursos.devtalles.com/courses/csharp', 'https://import.cdn.thinkific.com/643563/ZQiNIKAJR4upzwEpMIVt_C-SHARP-COVER%20(1).jpg', 'Portada del curso: C#: Empieza tu camino en el lenguaje', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende C# desde cero, domina desde la sintaxis básica, estructuras de control y POO, manejo de excepciones, LINQ y manejo de archivos JSON, arquitectura MVC e introducción a desarrollo api web con ASP.NET Core.', 690, 'es', '{}', 'https://cursos.devtalles.com/courses/csharp', '2026-09-24 15:49:29.94579+00', '{"No se necesita experiencia previa en C#","Se recomienda una noción básica de programación (variables, condicionales, bucles)","Tener instalado Visual Studio Code y .NET 8 (el curso guía este proceso)","Ganas de aprender con ejercicios prácticos y construir proyectos reales"}', '{}', 'Sección 1: Introducción
- Introducción al curso C#
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Nota de actualización: Trabajar con solution explorer
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Sintaxis básica de C#, variables y tipos de datos
- Introducción sección
- Temas puntuales
- ¿Qué es C#?
- Creación primer proyecto y Hola mundo
- Cómo declarar e inicializar variables
- Sintaxis básica
- Tipos de datos
- Tipo de dato numérico
- Tipo de dato string
- Ejercicio - Generador reporte de venta
- Tarea - Calculadora de salario
- Manejo de fechas
- Ejercicio - Días vividos
- Tarea - Días para próximo cumpleaños
- Tipos de valor y referencia
- Tipos de referencia no nulificables
- Operadores
- Arreglos
- Índices y rangos
- Ejercicio - Gestor de inventario
- Tarea - Completar el gestor de inventario
- Listas y diccionarios
- Clases, structs y records
- Genéricos
- Continuando con genéricos
- Código de la sección

Sección 3: Estructuras de control, casteo y funciones
- Introducción
- Temas puntuales
- Configuración importación estática
- Condicionales
- Bucles while y do-while
- Bucles for y for-each
- Tarea - FizzBuzz: Aplicando loops y operadores
- Sentencias de salto y bucles infinitos
- Ejemplo bucles infinitos
- Cómo realizar transformaciones con casteos
- Parseo de strings a fechas
- Declarar tus propias funciones(métodos)
- Ejemplo imprimir tabla de multiplicar
- Tarea - Calcular el factorial
- Uso de tuplas en una función
- Expresiones lambda y funciones anónimas
- Código de la sección

Sección 4: Clases,objetos, herencia y polimorfismo, propiedades
- Introducción
- Temas puntuales
- Definición de clases
- Uso de propiedades
- Uso de métodos
- Creación e instanciación de objetos
- Constructores y destructores
- Ejercicio gestión de inventario
- Tarea - gestión de flota de buses
- Tarea - gestión de flota de buses continuación
- Herencia
- Polimorfismo de métodos
- Polimorfismo con clases abstractas
- Visibilidad (public, private, protected)
- Visibilidad implementación
- Interfaces
- Tarea - Gestión de empleados
- Tarea - Gestión de empleados implementación
- Código de la sección

Sección 5: Manejo de excepciones, colecciones e introducción a LINQ
- Introducción
- Temas puntuales
- Manejo de Excepciones
- Lanzar excepciones, uso de finally
- Tipos de colecciones uso de list
- Colecciones dictionary y hashset
- Introducción a LINQ
- Consultas simples utilizando LINQ
- Consultas simples ordenar y obtener elementos específicos
- Consultas avanzadas: agrupación y unión
- Consultas avanzadas: agregaciones
- Tarea - Análisis de ventas
- Código de la sección

Sección 6: Manejo de archivos
- Introducción
- Temas Puntuales
- Clase File
- Clase Directory
- Clase Path
- Clase StreamWriter
- Ejemplo: serializar y deserializar
- Código de la sección

Sección 7: TaskMaster - Gestor de tareas
- Introducción
- Temas puntuales
- Configuración del proyecto
- Listado de tareas
- Usando paquete BetterConsoleTables
- Añadir tarea
- Marcar tarea como completada
- Editar tarea
- Eliminar tarea
- Consultas por estado (pendiente/completada)
- Buscar por descripción de tarea
- Código de la sección

Sección 8: Introducción a ASP.NET Core
- Introducción
- Temas puntuales
- ¿Qué es ASP.NET Core?
- Primer proyecto .NET
- Explicación archivo Program.cs
- Organización del código con archivos estáticos
- Organización del código para clases y modelos
- Código de la sección

Sección 9: TaskMasterAPI
- Introducción
- Temas puntuales
- Creación de Proyecto
- Creación de modelo y servicio
- Controlador, listar y obtener tarea
- Crear Tarea
- Actualizar Tarea
- Eliminar Tarea
- Código de la sección

Sección 10: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (67, 'dart-cero-hasta-detalles', 'Dart: De cero hasta los detalles - Fernando Herrera', 'https://cursos.devtalles.com/courses/dart-cero-hasta-detalles', 'https://import.cdn.thinkific.com/643563/zCw5CYnStGlg2IlblHjd_DART-NEW.jpg', 'Portada del curso: Dart: De cero hasta los detalles - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aquí aprenderás desde lo más básico de Dart hasta temas más complejos y necesarios para trabajar con frameworks. Aquí adentro tendrás tareas, ejercicios, exámenes, explicaciones y herramientas indispensables que te ayudarán a ser un eficiente desarrollador utilizando Dart.', 600, 'es', '{}', 'https://cursos.devtalles.com/courses/dart-cero-hasta-detalles', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de programación estructurada es recomendable","El curso se puede seguir en Windows, Mac OSX o Linux","Este curso es para aprender Dart, no es para aprender programación."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo realizar preguntas?
- Instalaciones necesarias
- Instalación de Dart
- Instalación de Dart - Windows
- Null Safety - Versión
- Hoja de atajos - Dart
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Primeros pasos en Dart - Tipos de datos
- Introducción a la sección
- Temas puntuales de la sección
- Palabras reservadas
- Nuevas palabras reservadas
- Hola Mundo en Dart
- Otras formas de ejecutar el código en VSCode
- Tipado de datos: Números
- Tipado de datos: Strings
- Tipado de datos: Booleans
- Tipado de datos: Listas
- Tipado de datos: Sets
- Tipado de datos: Mapas
- Quiz 1: Examen de la sección 2
- Quiz 2: Examen de la sección 2
- Código fuente de la sección

Sección 3: Variables, comentarios y operadores
- Introducción a la sección
- Temas puntuales de la sección
- Variables, Constantes y Final
- Palabra reservada - Late
- Comentarios en Dart
- Operadores aritméticos
- Operadores de asignación, condicional, relacional y de tipo
- Operadores relacionales y por tipo (segunda parte)
- Quiz 2: Examen de la sección 3
- Código fuente de la sección

Sección 4: Control de flujo
- Introducción a la sección
- Temas puntuales de la sección
- Entradas de información de usuario
- If y Else
- Resolución tarea IF y ELSE
- Ciclo For
- Solución de la tabla de multiplicar con un ciclo For
- For in
- Ciclo While
- Ciclo Do While
- Break y Continue
- Ciclo For con etiquetas
- Switch
- Quiz 3: Examen de la sección 4
- Código fuente de la sección

Sección 5: Funciones en Dart
- Introducción a la sección
- Temas puntuales de la sección
- Funciones básicas
- Argumentos a las funciones - Posicionales
- Argumentos a las funciones - Por nombre
- Argumentos por valor y referencia
- Lambda functions o funciones de flecha
- Callbacks
- Tarea sobre funciones
- Resolución de la tarea sobre funciones
- Código fuente de la sección

Sección 6: Tipos no tan comunes en Dart
- Introducción a la sección
- Temas puntuales de la sección
- Queue - Colas
- Enum - Enumeraciones
- Futures
- Futures - Segunda parte
- Async-Await
- catchError
- Streams
- Streams - onError, onDone y cancelOnError
- Streams - Tipado y Broadcast
- Código fuente de la sección

Sección 7: Introducción a las Clases en Dart
- Introducción a la sección
- Temas puntuales de la sección
- Estructura de una clase en Dart
- Clases en archivos independientes
- Propiedades privadas
- Setters y Getters
- Constructores básicos
- Constructores con nombre
- Propiedades finales
- Constructores constantes
- Constructores factory
- Propiedades y métodos estáticos
- Patrón Singleton
- Quiz 4: Examen sobre la sección 7
- Código fuente de la sección

Sección 8: Herencia en clases
- Introducción a la sección
- Temas puntuales de la sección
- Extends
- Clase abstracta
- Super constructor
- Override
- Mixins
- Código fuente de la sección

Sección 9: Documentaciones y detalles
- Introducción a la sección
- Temas puntuales de la sección
- Bonus: Dart Styling
- Bonus: Dart language specification
- Docs: Double
- Docs: Double - Propiedades y métodos
- Docs: String - Propiedades y métodos
- Strings - Operadores y más métodos
- Docs: Lists - Propiedades y métodos
- List: Más métodos
- Mapas: Propiedades y métodos
- Método Map de los mapas
- Quiz 5: Examen teórico sobre la documentación de Dart
- Código fuente de la sección

Sección 10: Paquetes, ejecutar programas, depurar y Http
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del proyecto - Paquetes
- Estructura de un proyecto en Dart
- Depurar un programa en Dart
- Peticiones HTTP
- Extraer y usar el body de una petición http
- Mapear la respuesta a una instancia de clase
- Parte 2: Mapear la respuesta a una instancia de clase
- Optimizaciones del código anterior
- Tarea de HTTP - Explicación
- Solución de la tarea de Colombia
- Código fuente de la sección

Sección 11: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (30, 'django', 'Django: Crea aplicaciones web robustas con Python', 'https://cursos.devtalles.com/courses/django', 'https://import.cdn.thinkific.com/643563/aA89gxXgTQGtRR7YojXB_DJANGO1.jpg', 'Portada del curso: Django: Crea aplicaciones web robustas con Python', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende Django desde cero con este curso práctico. Crea sitios web, conecta bases de datos, desarrolla APIs REST y publica tu proyecto. Ideal para convertirte en desarrollador web backend con Django.', 2640, 'es', '{}', 'https://cursos.devtalles.com/courses/django', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de Python","Conocimientos básicos de HTML, CSS y JS","Conocimientos básicos de SQL (No obligatorio pero deseable)","Poder realizar instalaciones en el equipo como administrador","Usar sistema operativo Mac (OSx), Windows o Linux","Ganas de aprender una tecnología desde cero","Compromiso para mejorar carrera profesional y hacer los ejercicios, proyectos realizados en el curso."}', '{}', 'Sección 1: Introducción al curso
- Introducción al curso
- Prerrequisitos del curso
- ¿Cómo realizar el curso?
- Temas y contenidos del curso
- ¿Cómo hacer preguntas?
- Instalar Python en Windows
- Instalar Python en MacOs
- Instalaciones recomendadas
- Hola mundo en Python
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos necesarios de Python
- Introducción a la sección
- Temas puntuales de la sección
- Variables
- Tipos de datos
- Condicionales
- Operadores lógicos
- Listas
- Diccionarios
- Tuplas
- Sets
- Ciclo for
- Ciclo while
- Funciones
- Args y Kwargs
- Funciones de orden superior (HOF)
- Decoradores
- Clases y objetos
- Atributos y métodos
- Classmethods y staticmethods
- Programación Orientada a Objetos parte 1
- Programación Orientada a Objetos parte 2
- Programación Orientada a Objetos parte 3
- Manejo de errores
- Módulos y paquetes
- Librerías
- Manejo de archivos
- Código fuente de la sección

Sección 3: Introducción a Django
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Django?
- Instalando Django de forma global
- Instalando Django en entorno virtual
- Creando un proyecto en Django
- Analizando el proyecto creado en Django
- Inicializar servidor de desarrollo
- Django Apps
- Analizando la app creada
- Código fuente de la sección

Sección 4: URLs y Vistas
- Introducción a la sección
- Temas puntuales de la sección
- Crear un nuevo proyecto en Django
- ¿Qué es una URL y una vista?
- Creando nuestra primera URL y vista
- Creando más URLs y vistas
- Rutas dinámicas
- Convertidores de rutas
- Simplificando la lógica de forma dinámica
- Redirecciones
- HTTP Status Codes
- Named URLs
- Función reversiva
- Regresando un HTML
- Código fuente de la sección
- Repaso interactivo: URLs y Vistas

Sección 5: Templates
- Introducción al curso
- Temas puntuales de la sección
- ¿Qué es un template?
- Creando una aplicación nueva
- Registrando un template
- Renderizando un template
- Django Template Language e Interpolación de variables
- Filtros
- Tags
- If tag
- For tag
- URLs Dinámicas y URL Tag
- Herencia de templates (Block tag)
- Ejercicio de templates en quotes (instrucciones)
- Ejercicio de templates en quotes (solución)
- Fragmentos de templates (include tag)
- Template 404
- Archivos estaticos
- Archivos estaticos globales
- Código fuente de la sección
- Repaso interactivo: Templates

Sección 6: Proyecto - URLs, Views y Templates
- Introducción a la sección
- Temas puntuales de la sección
- Proyecto
- Nuestro proyecto y su alcance
- Creando nuestro proyecto
- Creando aplicaciones necesarias
- Agrupando aplicaciones
- Maqueta del proyecto HTML, CSS y JS
- Creando templates globales
- Cursos (URLs y Views)
- Exploración de cursos - Adaptando template
- Exploración de cursos - Cargar imágenes
- Creando bloque de scripts y enlaces
- Exploración de cursos - Envio de variables
- Detalles del curso - Adaptando template
- Reutilizando secciones de HTML
- Detalles del curso - Enviando variables
- Detalles del curso - Imagen y enlace
- Sección de lecciones - Adaptando template
- Sección de lecciones - Enviando variables
- Dashboard - URLs, Views y Templates
- Perfil de usuario - URLs, Views y Templates
- Agregando enlaces al sidebar
- Código fuente de la sección
- Proyecto - URLs, Views y Templates

Sección 7: Modelos y bases de datos
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al modelado de datos
- Fundamentos de Bases de Datos Relacionales
- Configurar SQLite en Django
- Creanto tablas y relaciones con SQL
- Insertar registros con SQL
- Consultas básicas con SQL
- Actualizar y eliminar datos con SQL
- Ordenar y contar registros
- Filtrar con condiciones
- Consultas anidadas con SQL
- ¿Qué es un ORM y cómo funciona en Django?
- Creando app Minilibrary
- Tipos de campos y parámetros comunes
- Crear modelos y migraciones
- Shell en Django
- Código fuente de la sección
- Repaso interactivo: Modelos y bases de datos

Sección 8: Manipulación de datos con el ORM
- Introducción a la sección
- Temas puntuales de la sección
- Modelos y migraciones repaso
- Creación de registros con el ORM usando create
- Creación de registros con el ORM usando save
- Crear registros en lote
- Creando registros de forma segura
- Consultas básicas con el ORM
- Ordenando objetos
- Filtrando objetos y obteniendo el SQL
- Filtrados con Case sensitive y Case insensitive
- Filtrando por rangos
- Filtrando por fechas
- Encadenamiento de filtros y excluir datos
- Limitando conjunto de consultas
- Consulta avanzada: Q
- Consulta avanzada: F
- Actualización de registros
- Eliminar registros
- Eliminar registros con relaciones
- Aggregates
- Annotations
- Transaction Atomic
- Código fuente de la sección
- Repaso interactivo: Manipulación de datos con el ORM

Sección 9: Relaciones entre modelos
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las relaciones entre modelos
- Relación uno a muchos (Foreign Key)
- Relación muchos a muchos (ManyToManyField)
- Asignar y obtener valores en un ManyToMany
- Relación uno a uno (One to One)
- Select related
- Prefetch related
- Modelo User
- Modelo Review
- Modelo Loan
- Through
- Seeds
- Consultas avanzadas
- Código fuente de la sección
- Repaso interactivo: Relaciones entre modelos

Sección 10: Django Admin
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Django Admin?
- Registrar modelos en el admin
- Personalizar modelos en admin parte 1
- Personalizar modelos en admin parte 2
- Registrando datos en Django admin
- Inlines (Registros en linea)
- Inlines en modelos registrados
- Más personalizaciones en admin
- Actions en Admin
- Autocomplete fields y Raw id fields
- Seguridad, accesos y grupos en el admin
- Asignar permisos desde código
- Personalizar el branding del Admin
- Código fuente de la sección
- Repaso interactivo: Django Admin

Sección 11: Filtros, búsquedas y paginación en listas
- Introducción a la sección
- Temas puntuales de las sección
- Creando URLs, Vistas y templates para Minilibrary
- Filtrando datos en vistas
- Busqueda por texto GET
- Paginación manual con paginator (Parte 1)
- Paginación manual con paginator (Parte 2)
- Filtros por fecha
- Conservando filtros en paginador
- Código fuente de la sección
- Repaso interactivo: Filtros, búsquedas y paginación en listas

Sección 12: Proyecto - Modelos y Django admin
- Introducción a la sección
- Temas puntuales de la sección
- Modelado del proyecto y configuración del proyecto
- Modelo User e InstructorProfile
- Externalizando nuestros modelos
- Modelo Category y Course
- Modelo Module
- Modelo Enrollment y Progress
- Modelo Review
- Creando migraciones
- Agregando User al admin
- Agregando modelos Course al admin Parte 1
- Agregando modelos Course al admin Parte 2
- Fixtures y dumpdata
- Signals
- Modelo Content
- Tipos de herencia para contenido polimórfico
- Implementando modelo polimórfico
- Modelo personalizado: OrderModel
- Agregando modulo de ordenamiento
- Probando el modelo OrderField
- Agregando campos al modelo Course
- Código fuente de la sección
- Repaso interactivo: Proyecto - Modelos y Django admin

Sección 13: Proyecto - Renderizado, paginación y búsquedas
- Introducción a la sección
- Temas puntuales de la sección
- Configuraciones para nuestro proyecto
- Página de cursos: renderizar información
- Página de cursos: agregar buscador
- Página de cursos: agregar paginador (parte 1)
- Página de cursos: agregar paginador (parte 2)
- Detalles del curso: agregando slug a la URL
- Detalles del curso: renderizando información
- Detalles del curso: agregando modulos
- Detalles del curso: agregando contenido a los módulos
- Detalles del curso: contar clases y agregar enlace
- Contenido del curso: renderizar información básica
- Código fuente de la sección
- Repaso interactivo: Proyecto - Renderizado, paginación y búsquedas

Sección 14: Formularios y validaciones
- Introducción a la sección
- Temas puntuales de la sección
- Forms y Bootstrap
- Usando Form: creando rutas y form
- Usando Form: creando vista
- Usando Form: creando template
- ModelForm
- Validaciones personalizadas
- Validaciones cruzadas
- Ejercicio extra: BadWords
- Personalización de formulario usando ModelForm
- Código fuente de la sección
- Repaso interactivo: Formularios y validaciones

Sección 15: Function-Based Views (FBV) vs. Class-Based Views (CBV)
- Introducción a la sección
- Temas puntuales de la sección
- Function Based-Views vs Class Based-Views (FBV vs CBV)
- View
- TemplateView
- TemplateView con contexto
- ListView
- DetailView
- CreateView
- UpdateView
- DeleteView
- Código fuente de la sección
- Repaso interactivo: Function-Based Views (FBV) vs. Class-Based Views (CBV)

Sección 16: Middlewares
- Introducción a la sección
- Temas puntuales de la sección
- Middlewares
- Middlewares personalizados: View Timing
- Middleware: bloquear IPs
- Middleware: bloquear horas
- Middleware: validar inicio de sesión
- Código fuente de la sección
- Repaso interactivo: Middlewares

Sección 17: Sesiones de usuario
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son las sesiones?
- Leer y crear una sesión
- Modificar tiempos de una sesión
- Ejemplo de guardar un último elemento visto
- Solución de último elemento visto
- Código fuente de la sección
- Repaso interactivo: Sesiones de usuario

Sección 18: Autenticación y permisos de usuarios
- Introducción a la sección
- Temas puntuales de la sección
- LoginView
- LogoutView
- Protección de vistas individuales
- Permisos y grupos en Django Admin
- Permisos desde código con Function Based-View
- Permisos desde código con Class Based-View
- Restricciones de permisos desde ModelAdmin
- Código fuente de la sección
- Repaso interactivo: Autenticación y permisos de usuarios

Sección 19: Subir archivos
- Introducción a la sección
- Temas puntuales de la sección
- Subir archivos parte 1
- Subir archivos parte 2
- Validación de archivos en formularios
- Renderizando imágenes
- Recomendaciones al subir imágenes
- Código fuente de la sección
- Repaso interactivo: Subir archivos

Section 20: Proyecto - CBV, Autenticación, permisos, forms, etc
- Introducción a la sección
- Temas puntuales de la sección
- Permisos y roles
- LoginView y LogoutView
- Separando rutas y vistas
- Instructor - InstructorMixing y listado de cursos
- Instructor - Plantilla de listado de cursos
- Instructor - Agregar paginador en listado de cursos
- Instructor - Agregar curso
- Instructor - Estilos y ejemplos de crear curso
- Instructor - Actualizar curso
- Instructor - Eliminar curso
- Instructor - Listado de modulos del curso
- Instructor - Template para listado de módulos del curso
- Instructor - Agregar módulo del curso
- Instructor - Actualizar módulo del curso
- Instructor - Eliminar módulo del curso
- Instructor - Listado de contenidos del módulo
- Instructor - Botones para agregar contenido con ContentTypes
- Instructor - Crear contenido parte 1
- Instructor - Crear contenido parte 2
- Instructor - Crear contenido parte 3 (URLs y Views)
- Instructor - Eliminar contenido
- Instructor - Ordenando módulos (rutas)
- Instructor - Ordenando módulos (script - SortableJS)
- Instructor - Ordenar contenido
- Estudiante - Cambiando rutas para estudiantes
- Estudiante - Sección de lecciones (Módulos y vistas)
- Estudiante - Agregando vista - Mark Complete
- Estudiante - Modificando template para lessons (parte 1)
- Estudiante - Modificando template para lessons (parte 2)
- Estudiantes - Modificando template para lessons (parte 3)
- Estudiantes - Corección de variables
- Estudiantes - Arreglando NextContent y corrigiendo enlaces
- LoginRedirect
- Middleware Login
- Sidebar y logout
- Detalles del template
- Código fuente de la sección
- Repaso interactivo: Proyecto - CBV, Autenticación, permisos, forms, etc

Section 21: Proyecto - Complementos (Reseñas, cambiar contraseña, emails, dashboard)
- Introducción a la sección
- Configuraciones en el proyecto
- Profile - Modelo
- Profile - Formulario
- Profile - Vista
- Profile - URLs y Admin
- Profile - Template
- Profile - Subir imagen
- Profile - Context Processors
- Profile - Signal (crear usuario)
- Registro - Form y vista
- Registro - Template
- Configuración - Cambio de contraseña (parte 1)
- Configuración - Cambio de contraseña (parte 2)
- Soporte - Formulario
- Soporte - Email View (parte 1)
- Soporte - Email View (parte 2)
- Soporte - Template
- Soporte - Configuración email
- Soporte - Configuración de variables de entorno (.env)
- Cursos - Agregando filtros de inscritos
- Cursos - Agregando estilos a los filtros
- Cursos - Agregando estilos al paginador
- Detalle del curso - Corrigiendo detalles
- Detalle del curso - Agregando Sweet Alert
- Reseñas - Formulario
- Reseñas - Vista
- Reseñas - Template (parte 1)
- Reseñas - Template (parte 2)
- Reseñas - Estadísticas en detalles del curso
- Reseñas - Comentarios en detalles del curso
- Reseñas - Probando funcionalidad
- Dashboard - Cursos y perfil (parte 1)
- Dashboard - Cursos y perfil (parte 2)
- Dashboard - Último curso visto (Django Session)
- Código fuente de la sección
- Repaso interactivo: Proyecto - Complementos (Reseñas, cambiar contraseña, emails, dashboard)

Section 22: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida

Bonus: Django y PostgreSQL
- Introducción a la sección
- Instalar PostgreSQL
- Creando base de datos en PostgreSQL
- Conectar PostgreSQL con Django
- Cargar datos a PostgreSQL
- Código fuente de la sección
- Repaso interactivo: Django y PostgreSQL

Bonus: Introducción a Django Rest Framework
- Introducción a la sección
- ¿Qué es Django Rest Framework?
- Crear proyecto y configurar DRF
- Creando modelo Task
- TaskSerializer
- APIView - Método GET y POST
- APIView - Probando método GET y POST
- APIView - Método PUT, PATCH y DELETE
- APIView - Probando método PUT, PATCH y DELETE
- Filtrar por QueryParams
- Paginar lista de tareas
- CRUD con ViewSet
- Agregando actions
- Creando modelo de registro
- Creando archivo de permisos
- Vista para autenticación
- Rutas para autenticación
- Probando endpoints de autenticación
- Código fuente de la sección
- Repaso interactivo: Introducción a Django Rest Framework

Bonus: Deploy en Render
- Introducción a la sección
- Desplegar en render primeros pasos
- Archivos estáticos
- Configurando bash script
- Deploy Database (PostgreSQL)
- Deploy Django web service
- Probando deploy
- Corrigiendo error 400 con AllowedHost
- Solución al superuser (con truco)
- Repaso interactivo: Deploy en Render', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (7, 'ia-para-developers', 'IA para Developers: Claude API, RAG y Agentes con Node', 'https://cursos.devtalles.com/courses/ia-para-developers', 'https://import.cdn.thinkific.com/643563/GqifE6ONSsOHYhVpNPRS_COVER-DEVTALLES.jpg', 'Portada del curso: IA para Developers: Claude API, RAG y Agentes con Node', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Construye un agente de IA desde cero con Claude API, RAG y function calling en Node.js. Sin frameworks, sin magia: solo Anthropic SDK, OpenAI para embedding y SQLite. Pasa de tu primera llamada a la API a un asistente desplegable en producción.', 480, 'es', '{}', 'https://cursos.devtalles.com/courses/ia-para-developers', '2026-09-24 15:49:29.94579+00', '{"Programación para principiantes - Primeros pasos.","TypeScript: Tu completa guía y manual de mano.","Ingeniería de prompts: Para la vida real (Opcional)."}', '{}', 'Sección 1: Introducción
- Bienvenido al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Intalaciones recomendadas

Sección 2: Setup y fundamentos
- Introducción
- Temas puntuales
- Setup inicial del proyecto
- Setup inicial documentación
- Configuración de variables y versionamiento
- Configuración tipos de herramientas y de mensaje
- Configuración de tipos para RAG
- Configuración de tipos para configuración y agente
- Configuración variables de entorno y proveedor
- Configuración tipada y validación
- Punto de entrada de la aplicación
- Código de la sección

Sección 3: Tu primera integración con Claude API
- Introducción
- Temas puntuales
- Cliente para anthropic
- Primera llamada a Claude API
- System prompts efectivos
- Demo con system prompts efectivos
- Streaming de respuestas
- Demo streaming de respuestas
- Conversaciones multi-turno
- Control de contexto y estadísticas de uso
- CLI interactivo
- CLI interactivo (continuación)
- Demo CLI interactivo
- CLI code reviewer
- Demo CLI code reviewer
- Código de la sección

Sección 4: Function Calling: cuando Claude necesita hacer cosas
- Introducción
- Temas puntuales
- Definir herramientas
- Arquitectura del ejecutador y constantes
- Primera línea de defensa resolveSecurePath
- Exploración recursiva de directorios collectFiles
- La primera herramienta completa executeListFiles
- Lectura con límite de tamaño executeReadFile
- Búsqueda con contexto de líneas executeSearchCode
- Búsqueda con contexto de líneas executeSearchCode (continuación)
- Dispatcher executeTool
- Configuración del agentic loop
- Caso uno y loop principal
- Caso 2: Ejecutar herramientas
- Caso 3 y límite de iteraciones
- Integrar agentic loop con herramientas
- Código e infografía de la sección

Sección 5: RAG: dale conocimiento a tu aplicación (OpenAI)
- Introducción
- Temas puntuales
- Introducción a embeddings
- Configuración de embeddings con text-embedding-3-small
- Introducción a chunking
- Chunking: definición de la función
- Chunking: caso de sección completa
- Chunking : caso de subdivisión por párrafos
- Chunking: caso de subdivisión por párrafos - Parte 2
- Lee todos los archivos Markdown
- Vector Store: concepto, imports e interfaces
- Vector Store: clase y constructor
- Vector Store: createTables
- Vector Store: insert
- Vector Store: search, clear, size y close
- Pipeline de ingestión
- Pipeline de ingestión - Parte 2
- Recuperar contexto relevante
- Integración RAG y Claude
- Integración RAG y Claude - Parte 2
- CLI con RAG integrado
- CLI con RAG integrado - Parte 2
- Código e infografía de la sección

Sección 6: Construyendo un agente: todo junto
- Introducción
- Temas puntuales
- System prompt del agente
- Registro de herramientas
- Buscar en la documentación ingestada
- Crear un issue como archivo Markdown
- Ejecutar cualquier tool por nombre
- DevAssistantAgent: introducción
- DevAssistantAgent: clase, propiedades y configuración inicial
- DevAssistantAgent: agentic loop y caso end_turn
- DevAssistantAgent: caso tool_use y ejecución en paralelo
- DevAssistantAgent: caso inesperado y límite
- DevAssistantAgent: métodos auxiliares
- Demo automatizado
- DevAssistantAgent: CLI final
- Código de la sección

Sección 7: De demo a producción: lo que nadie te enseña
- Introducción
- Temas puntuales
- Guardrails: introducción e Interfaces
- Guardrails: clase RateLimiter
- Guardrails: métodos utilitarios
- Guardrails: patrones de inyección
- Guardrails: primera capa de defensa
- Guardrails: segunda capa de de defensa
- Guardrails: orquestando las tres capas
- Guardrails: ejemplos
- Guardrails: integración en CLI
- Calculadora de costos: tabla de precios
- Calculadora de costos: interfaces y formato
- Calculadora de costos: función principal
- Calculadora de costos: integración en CLI
- Documentación
- Código e infografía de la sección

Sección 8: Despliegue en GitHub Codespaces
- Introducción
- Temas puntuales
- Configuración base para GitHub Codespaces
- Configuración automática al crear el Codespace
- Crear Github Codespace
- Actualizar README con el uso de Codespaces
- Código de la sección

Sección 9: Fin de curso
- Más información sobre nuestros otros cursos
- Fin de curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (59, 'docker-guia-practica', 'Docker - Guía práctica de uso para desarrolladores', 'https://cursos.devtalles.com/courses/docker-guia-practica', 'https://import.cdn.thinkific.com/643563/MtehrUISVW8hP7CfCWV1_DOCKER.jpg', 'Portada del curso: Docker - Guía práctica de uso para desarrolladores', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'En este curso aprenderás qué es Docker, porqué es tan popular y para qué te puede servir. Realizaremos ejercicios prácticos que te ayudarán a conocer las características que Docker ofrece y te permitirá agregar esta nueva herramienta a tu repertorio de software para convertirte en un mejor desarrollador.', 840, 'es', '{"Fundamentos de Docker: Contenedores, imágenes, Docker CLI y Docker Desktop.","Construcción de imágenes: Dockerfiles, Docker Compose y Buildx para múltiples arquitecturas.","Automatización: Variables de entorno, GitHub Actions y despliegues automáticos.","Introducción a Kubernetes: Primeros pasos para comprender el mundo de la orquestación de contenedores.","Docker CLI: Uso profesional de la línea de comandos.","Dockerfiles y Compose: Creación de imágenes y aplicaciones multicontenedor.","Buildx: Generación de imágenes para múltiples arquitecturas.","GitHub Actions: Automatización de pruebas, construcción y despliegues.","Imágenes populares: Nginx, PostgreSQL, MongoDB, Node, Alpine, PgAdmin, PHPMyAdmin y más.","Cloud: DigitalOcean, registros privados y públicos.","Introducción a Kubernetes.","Serás capaz de crear, administrar y desplegar contenedores utilizando Docker.","Aprenderás a construir imágenes personalizadas y automatizar tus despliegues.","Obtendrás una base sólida para comenzar a trabajar con Kubernetes y tecnologías de contenedores."}', 'https://cursos.devtalles.com/courses/docker-guia-practica', '2026-09-24 15:49:29.94579+00', '{"Poder realizar instalaciones como administrador","Una computadora PC, Mac o Linux con los requisitos mínimos para correr Docker (revisar sitio web para confirmar)","Saber comandos básicos de consola o terminal es recomendado (no obligatorio)"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- Instalación Docker - Linux Ubuntu
- Instalación Docker - Linux manual
- Guía de atajos para el curso
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Bases de Docker
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Docker? y ¿Por qué debo saberlo?
- Hola Mundo en Docker
- Borrar contenedores e imágenes
- Docker Desktop - Mismos comandos ejecutados
- Publish and Detached modes
- Variables de entorno
- Usar la imagen de Postgres
- Multiples instancias de Postgres
- Logs del contenedor
- Tarea - Borrar todas las imágenes de Postgres

Sección 3: Volúmenes y Redes
- Introducción a la sección
- Temas puntuales de la sección
- Ejercicio sin volúmenes - Montar Base de Datos
- Tipos de volúmenes
- PHPMyAdmin
- Redes de contenedores
- Asignar la red desde la inicialización
- Bind Volumes
- Ejercicio - Bind Volumes
- Probar el enlace de directorios
- Terminal interactiva -it
- Limpieza de lo realizado en esta sección

Sección 4: Multi-container Apps - Docker Compose
- Introducción a la sección
- Temas puntuales de la sección
- Laboratorio: Reforzamiento de lo aprendido
- Resolución del laboratorio
- Docker Compose - Multi Container Apps
- Correr, limpiar y otras consideraciones - Docker Compose
- Limpiar el docker compose y conectar volumen externo
- Bind Volumes - Docker Compose
- Código final del docker compose
- Multi-container app - Base de datos Mongo
- Variables de entorno - MongoDB
- Multi-container app - Visor de Base de datos
- Multi-container app - Aplicación de Nest
- Código fuente de la sección

Sección 5: Dockerfile - Crear imágenes
- Introducción a la sección
- Temas puntuales de la sección
- Cron-Ticker - Aplicación simple
- Dockerfile - primeros pasos
- Construir la imagen
- Reconstruir una imagen
- Subir imagen a Docker Hub
- Consumir nuestra imagen de DockerHub
- Añadir pruebas automáticas al código
- Incorporar testing en la construcción
- Examinar la imagen creada
- Dockerignore
- Remover archivos y carpetas de la imagen
- Tarea - Subir imagen a docker hub
- Forzar una plataforma en la construcción
- Buildx
- Buildx - Construcción en multiples arquitecturas
- Código fuente y breve resumen

Sección 6: Multi-State Build
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Multi-State Build
- Solución de la tarea
- Subir la imagen a Docker hub
- Build con otras arquitecturas
- Cron-Ticker - Código fuente
- Nota Importante
- Docker compose build - Preparación
- Docker compose - Target State
- Ejecutar partes específicas del Dockerfile
- Probar el BindVolume desde el compose
- Generar production build
- Código fuente de la sección

Sección 7: Deployments y Registros
- Introducción a la sección
- Temas puntuales de la sección
- Construcción de imagen - Multiples Arquitecturas
- Solución de la tarea
- Tablas en Markdown
- Prueba de la imagen creada
- Digital Ocean - Aprovisionamiento de Base de Datos
- Probar la base de datos
- Conectar contenedor con la base de datos
- Prueba local de la nueva imagen
- Desplegar la imagen directamente desde DockerHub
- Crear registro y desplegar imagen en él
- Subir imagen al registro
- Nota de actualización
- Desplegar imagen de registro privado
- Recordatorio de limpieza

Sección 8: Construcciones automáticas - Github Actions
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto
- Github - Repositorio de proyecto
- Configurar credenciales - Github Secrets
- Primeros pasos de Github Actions
- Resolución de la construcción de la imagen
- Github Actions - Steps
- Step - Construir imagen
- Renombrar Latest
- Versionamiento semantico automático
- Tag automático
- Código fuente de la sección

Sección 9: nginx
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - SPA nginx
- nginx - DockerHub
- Inspeccionar nginx
- Construir la imagen de nuestra aplicación
- nginx config
- Copiar los recursos estáticos
- Código fuente de la sección

Sección 10: Introducción a Kubernetes - K8s
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a Kubernetes
- Instalación y configuración de MiniKube
- ConfigMap
- Secrets
- Pods, Services y Deployments
- Desplegar la base de datos en el cluster
- Agregar PG-Admin al cluster
- Desplegar PG-Admin al cluster
- Agregar el BackendApp al Cluster
- Desplegar Backend al cluster
- Probar backend y limpieza
- Código fuente de la sección

Sección 11: Fin del curso
- Códigos fuente de todas las secciones
- Más información sobre nuestros otros cursos
- Cierre del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (27, 'expo-gemini', 'Expo + Gemini: Aplicaciones con inteligencia artificial', 'https://cursos.devtalles.com/courses/expo-gemini', 'https://import.cdn.thinkific.com/643563/hVinmMVNQq6v8R7Was0K_COVER-DEVTALLES2.jpg', 'Portada del curso: Expo + Gemini: Aplicaciones con inteligencia artificial', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'En este curso aprenderás a integrar la inteligencia artificial de Gemini usando la librería oficial y conectándola, a través de un backend personalizado, con nuestra aplicación de Expo.', 420, 'es', '{}', 'https://cursos.devtalles.com/courses/expo-gemini', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de JavaScript o TypeScript.","Experiencia previa con React Native o React.","Tener los simuladores un un dispositivo físico para probar la aplicación."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Creación y explicación del UI - Opcional
- Introducción
- Temas puntuales
- Inicio de proyecto - GeminiApp
- Estructura del proyecto

Sección 3: Backend - NestJS
- Introdución
- Temas puntuales
- Inicio de proyecto - Gemini Backend
- Configuraciones del backend
- DTOs - Data Transfer Objects
- Google Projects y Gemini
- Mi primera consulta a Gemini
- Caso de uso - BasicPrompt
- Código fuente

Sección 4: Consulta básica - React Native
- Introducción
- Temas puntuales
- Continuación de proyectos
- Variables de entorno y Axios
- Acción - Obtener respuesta de Gemini
- Gestor de estado - Zustand
- Zustand - Crear mensaje
- Conectar caja de texto con el store
- Indicador de procesamiento
- Mostrar mensajes en formato Markdown
- Código fuente

Sección 5: Backend - Stream Response
- Introducción
- Temas puntuales
- Continuación de backend
- Stream Response
- Código fuente

Sección 6: Frontend - Stream Response
- Introducción a la sección
- Temas puntuales
- Continuación
- Caso de uso - Prompt como stream
- Mostrar mensaje parcial mientras es creado
- Código fuente

Sección 7: Backend - Recibir archivos y retornar stream
- Introducción
- Temas puntuales
- Continuación e instalaciones
- Recibir y leer imágenes
- Enviar archivos a Gemini
- Código fuente

Sección 8: Frontend - Enviar archivos
- Introducción
- Temas puntuales
- Continuación de aplicación
- Seleccionar imágenes de la galería
- Mostrar imágenes seleccionadas
- Form MultiPart - Parte 1
- Form Multipart - Parte 2
- Código fuente

Sección 9: Backend - Contexto conversacional
- Introducción
- Temas puntuales
- Continuación de proyecto
- Conversaciones de varios turnos
- Chat con historial - Caso de uso
- Bonus - Refactorizar carga de archivos
- Mantener en memoria el historial
- Regresar historial por chatID
- Código fuente

Sección 10: Frontend - Contexto conversacional
- Introducción
- Temas puntuales
- Continuación
- Nuevo caso de uso - Chat
- Nuevo store - useChatContextStore
- Consumo de acción y store
- Código fuente

Sección 11: Backend - Generación y edición de imágenes
- Introducción
- Temas puntuales
- Continuación de proyecto
- Creación de endpoint y DTOs
- Generación de imágenes - Caso de uso
- Crear imagen física y retornar url
- Convertir imágenes al formato deseado
- Código fuente

Sección 12: Frontend - Generación y edición de imágenes
- Introducción
- Temas puntuales
- Continuación de proyecto
- Acciones y genéricos
- Creación de ImagePlayground State
- Implementación del Store
- Acción - Generar imagen
- Acción - Generar siguiente imagen
- Carousel y estilos
- Conectar estado con la interfaz de usuario
- Generar imagen desde prompt
- Aplicar estilos de arte
- Funcionalidad de seleccionar imagen
- Enviar imagen seleccionada
- Código fuente

Sección 13: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (50, 'flutter-bloc', 'Mini-Curso: Flutter BLoC', 'https://cursos.devtalles.com/courses/flutter-bloc', 'https://import.cdn.thinkific.com/643563/If0EvY5HQpiOEvnnISAN_FLUTTER-BLOC.jpg', 'Portada del curso: Mini-Curso: Flutter BLoC', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este mini-curso sobre Flutter Bloc te enseñará a utilizar este gestor de estado de una forma organizada, pasando desde cubits, blocs simples y compuestos, pero también aprenderás a como comunicarlos entre sí.', 210, 'es', '{}', 'https://cursos.devtalles.com/courses/flutter-bloc', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de Flutter y Dart:","Saber crear widgets, usar estados, y manejar estructuras comunes.","Familiaridad con el concepto de manejo de estado:","Haber usado alguna solución como Provider, Riverpod, o setState de los stateful widgets.","Instalación funcional de Flutter en tu entorno local:","Tener acceso al emulador o dispositivo físico para pruebas.","Conocimientos básicos de programación orientada a objetos:","Entender clases, constructores y métodos en Dart."}', '{}', 'Flutter BLoC
- Introducción al curso
- Instalaciones para seguir el curso
- Descarga del proyecto inicial
- Estructura del proyecto
- Flutter Bloc - Instalación
- Cubit Simple
- BlocProvider y BlocMultiProvider
- Consumir y cambiar el estado del cubit
- BlocBuilder
- Cubit + Go_Router - Estado Complejo del cubit
- Counter Cubit
- ThemeCubit - Cubit + State
- Solución de la tarea - UsernameCubit
- Service Locator - Get_it
- GuestBloc - Estado complejo
- Bloc Events - Relacionado al fIltro
- Emitir nuevo estado basado en eventos
- Reaccionar visualmente al nuevo estado
- Mostrar lista de invitados
- Crear un nuevo invitado
- Cambiar el estado de un invitado
- Pokemon Screen - Preparación del ejercicio
- PokemonBloc
- FetchPokemon desde el Bloc
- Inyección de dependencias
- Comunicación entre BLoCs - Geolocation
- Colocar simuladores en movimiento
- Permisos y obtener la ubicación
- Historic Location Bloc
- Comunicación entre Blocs
- Mostrar listado de ubicaciones
- Código fuente de la sección
- Más información sobre nuestros otros cursos
- Cierre del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (31, 'flutter-gemini', 'Flutter + Gemini: Aplicaciones con inteligencia artificial', 'https://cursos.devtalles.com/courses/Flutter-Gemini', 'https://import.cdn.thinkific.com/643563/dMU9FLDmQETZktVFX7gX_COVER-DEVTALLES3.jpg', 'Portada del curso: Flutter + Gemini: Aplicaciones con inteligencia artificial', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a trabajar con la inteligencia artificial de Google Gemini y su SDK nativo, siguiendo buenas prácticas y recomendaciones de la documentación oficial.', 510, 'es', '{}', 'https://cursos.devtalles.com/courses/Flutter-Gemini', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de Flutter (widgets, navegación, estado).","Conocimientos básicos de node o APIs es recomendado.","Tener Flutter instalado y un entorno de desarrollo como VS Code.","Conocimientos básicos de HTTP y consumo de APIs REST.","Se recomienda, pero no es obligatorio, experiencia previa trabajando con algún gestor de estado de Flutter."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Creación del UI - Opcional
- Introducción
- Temas puntuales
- Inicio de proyecto - GeminiApp
- Pantallas y rutas
- Tema global
- Diseño del chat
- Riverpod: Configuración y primeros providers
- Proveedor User y Proveedor isWriting
- BasicChat Provider
- Fake - Respuesta de Gemini
- Código fuente

Sección 3: Backend - NestJS
- Introdución
- Temas puntuales
- Inicio de proyecto - Gemini Backend
- Configuraciones del backend
- DTOs - Data Transfer Objects
- Google Projects y Gemini
- Mi primera consulta a Gemini
- Caso de uso - BasicPrompt
- Código fuente

Sección 4: Consulta básica - Flutter
- Introducción
- Temas puntuales
- Continuación de proyectos
- Variables de entorno - BaseURL
- Implementación de Gemini
- Obtener respuesta de Gemini
- Optimización y refactorización
- Código fuente

Sección 5: Backend - Stream Response
- Introducción
- Temas puntuales
- Continuación de backend
- Stream Response
- Código fuente

Sección 6: Frontend - Stream Response
- Introducción
- Temas puntuales
- Continuación
- Petición HTTP y retorno de stream
- ChatProvider - Escuchar el stream
- Código fuente

Sección 7: Backend - Recibir archivos y retornar stream
- Introducción
- Temas puntuales
- Continuación e instalaciones
- Recibir y leer imágenes
- Enviar archivos a Gemini
- Código fuente

Sección 8: Frontend - Enviar archivos
- Introducción
- Temas puntuales
- Continuación de aplicación
- Selección de imágenes
- Mostrar imágenes en el chat
- Flutter Multipart - Enviar imágenes y texto
- Código fuente

Sección 9: Backend - Contexto conversacional
- Introducción
- Temas puntuales
- Continuación de proyecto
- Conversaciones de varios turnos
- Chat con historial - Caso de uso
- Bonus - Refactorizar carga de archivos
- Mantener en memoria el historial
- Regresar historial por chatID
- Código fuente

Sección 10: Frontend - Contexto conversacional
- Introducción
- Temas puntuales
- Continuación de aplicación
- Chat Stream - Implementación
- Proveedor - Chat con contexto
- Pantalla del chat conversacional
- Bonus - Refactorización
- Código fuente

Sección 11: Backend - Generación y edición de imágenes
- Introducción
- Temas puntuales
- Continuación de proyecto
- Creación de endpoint y DTOs
- Generación de imágenes - Caso de uso
- Crear imagen física y retornar url
- Convertir imágenes al formato deseado
- Código fuente

Sección 12: Frontend - Generación y edición de imágenes
- Introducción a la sección
- Temas puntuales
- Continuación de proyecto
- Gemini - Generar imagen
- Proveedores necesarios
- Proveedor - Generador de imágenes
- Consumo del generador de imágenes - Parte 1
- Consumo del generador - Parte 2
- Selector de estilos de arte
- Historial de imágenes generadas
- Editar imágenes
- Editar imágenes previamente creadas
- Ideas del editor de imágenes
- Código fuente

Sección 13: Bonus: Respuestas de Gemini en formato JSON
- Introducción
- Temas puntuales
- Continuación de proyecto
- DTO, Controlador y Caso de uso
- Generador de trivias
- Controlador y Servicio de trivias
- Código fuente

Sección 14: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (57, 'flutter-movil-cero-a-experto', 'Flutter - Móvil: De cero a experto - Fernando Herrera', 'https://cursos.devtalles.com/courses/flutter-movil-cero-a-experto', 'https://import.cdn.thinkific.com/643563/61TYzXMSTaKdnKUemoIn_FLUTTER-MOVIL-DE-CERO-A-EXPERTO.jpg', 'Portada del curso: Flutter - Móvil: De cero a experto - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'El curso cubre todo lo necesario de Flutter para crear aplicaciones móviles para iOS y Android hasta su despliegue en las tiendas. Cuando termines el curso, habrás creado diferentes aplicaciones móviles y comprender el proceso de publicación de las mismas.', 3000, 'es', '{"Fundamentos de Dart: Sintaxis, programación orientada a objetos, programación asíncrona y buenas prácticas.","Flutter moderno: Widgets, manejo de estado, navegación, consumo de APIs y desarrollo de interfaces.","Arquitectura profesional: Domain Driven Design, Clean Code, patrones de diseño y organización de proyectos.","Aplicaciones listas para producción: Bases de datos, autenticación, notificaciones, despliegues y publicación en tiendas.","Dart: Desde \"Hola Mundo\" hasta funciones generadoras, clases, mixins y programación orientada a objetos.","Flutter: Widgets, widgets personalizados y ciclo de vida de componentes.","Manejo de estado: Riverpod, Flutter Bloc, Cubits, Provider y Stateful Widgets.","Arquitectura: Domain Driven Design, Clean Code y buenas prácticas recomendadas por el equipo de Flutter.","Backend e integración: Docker, PostgreSQL, APIs REST, JWT, carga de imágenes y multipart.","Persistencia: Variables de entorno, Shared Preferences e ISAR.","Características móviles: Cámara, galería, videos, notificaciones Push (FCM/APNs), iconos y Splash Screens.","Navegación y UI: GoRouter, protección de rutas, formularios, validaciones, grids, Masonry y Pull to Refresh.","Publicación: Google Play, App Store, TestFlight y versiones Alpha/Beta.","Y mucho más...","Dominarás Dart y Flutter para desarrollar aplicaciones móviles profesionales.","Aprenderás a estructurar proyectos utilizando Domain Driven Design y patrones de arquitectura modernos.","Serás capaz de crear aplicaciones escalables, consumir APIs, trabajar con bases de datos y utilizar recursos del dispositivo.","Tendrás el conocimiento necesario para desarrollar, desplegar y publicar aplicaciones listas para producción."}', 'https://cursos.devtalles.com/courses/flutter-movil-cero-a-experto', '2026-09-24 15:49:29.94579+00', '{"Es necesario tener conceptos de programación estructurada y orientada a objetos","Si no tienes conocimiento en el requisito anterior, es recomendado mi curso de programación para principiantes","Puedes seguir el curso en Windows, Mac o Linux (Instalaciones y configuraciones en Mac y Windows incluídas)","Revisar los requisitos mínimos de Flutter dependiendo de tu sistema operativo en Flutter-dev"}', '{}', 'Sección 1: Introducción
- Introducción a la sección y al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias - Menos Flutter
- Guías de atajos - Dart y Flutter
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a Dart
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Dart? - Exposición
- Hola Mundo - Dart
- Tipos de variables
- Dynamic type
- Maps
- List, iterables y Sets
- Funciones y parámetros
- Parámetros con nombre
- Clases
- @override
- Name constructors
- getters y setters
- Aserciones
- Clases abstractas y enumeraciones
- Extends
- Implements
- Nota de actualización - Mixins
- Mixins
- Ejercicio con Mixins
- Futures
- Async - Await
- Try, on, catch y finally
- Streams
- async* y await
- Código fuente de la sección

Sección 3: Instalación de Flutter y Virtuales - Mac y Windows
- Introducción a la sección
- Temas puntuales de la sección
- Windows - Instalación de Android Studio
- Windows - Instalación de Flutter
- Windows - Emuladores
- Windows - Probar dispositivo emulado
- A continuación: Instalaciones y configuraciones en Mac
- Mac - Instalación de Android Studio
- Mac - Instalación de Flutter
- Mac - iOS Setup
- Mac - Android Emulator
- Mac - Probar simuladores
- Mac - Probar en un iPhone físico
- Usuarios de Windows, Mac y Linux pueden seguir desde aquí
- Windows - Mac - Android físico

Sección 4: Flutter - Primeros pasos
- Introducción a la sección
- Temas puntuales de la sección
- Exposición - ¿Qué es Flutter?
- Hello World App - Explicación de cada archivo y directorio
- Explicación de directorios - Parte 2
- Hola Mundo
- Scaffold y buenas practicas
- Estructura de directorios - Nueva Pantalla
- Contador - Diseño de la pantalla
- Material Design 3
- Cambiar el estado de la aplicación
- Tarea - Cambiar la palabra clicks
- AppBar y Acciones
- Widgets personalizados
- VoidCallback - Función como argumento
- Código fuente de la sección

Sección 5: Yes No - Maybe App
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de App - YesNo App
- Estilo global para la aplicación
- Chat Screen
- ListView - área de los mensajes
- Mis Mensajes - Burbuja de chat
- Mensajes de ella - Burbuja de chat
- Mostrar mensaje mientras se carga la imagen
- TextFormField
- Comportamiento del FormField
- Código fuente de la sección

Sección 6: Yes No - Maybe App - Funcionalidad
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto
- Entidad - Message
- Provider - Gestor de estado
- Instalar Provider
- Mostrar los mensajes del provider
- Tarea - Argumentos al Widget
- Añadir mensajes al provider
- Mover el Scroll al final
- Nota de actualización
- Respuesta de YesNo - wtf
- Mappers
- QuickType.io al rescate
- Tarea - Mensajes de ella
- Código fuente de la sección

Sección 7: TokTik - Videos verticales
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de aplicación
- Estructuras y entidades
- Provider - Y problemática futura
- Mapper - VideoPost - LocalVideo
- Leer y asignar los videos al Provider
- CircularProgress y PageView
- Botones de like y views
- Números humanamente legibles
- Bonus - Icono girando - animate_do
- Más sobre animate_do
- Video Player
- Controlador del video - FutureBuilder
- Reproducir videos
- Pausar videos
- Gradiente de fondo
- Código fuente de la sección

Sección 8: Conceptos de Clean Architecture -Datasources - Repositories
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Datasource y Repositorios
- Implementaciones
- Usando el repositorio y origen de datos
- Código fuente de la sección

Sección 9: Widgets App
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Widgets App
- Tema y estilos de la aplicación
- Opciones de nuestra aplicación
- ListView
- Navegación entre pantallas
- go_router
- Rutas con nombre
- Diferentes botones pre-configurados
- Botón personalizado
- Cards
- Tarjetas con borde
- Tarjetas con relleno e imágenes
- Crear todas las pantallas faltantes
- Código fuente de la sección

Sección 10: Widgets App - Continuación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- ProgressIndicators
- Linear y Circular progress controlados
- Snackbars
- Diálogos y Licencias
- Animated Container
- Animar las propiedades del contenedor
- Checkbox, Radios y otros Tiles
- ExpansionTile y CheckboxTile
- PageView - App Tutorial
- Finalizar tutorial
- Determinar último slide
- InfiniteScroll - Inicio
- InfiniteScroll - Imágenes infinitas
- Mostrar indicador de carga
- Refresh Indicator
- Mover scroll de forma automática
- Código fuente de la sección

Sección 11: Riverpod - Menú y Temas
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- NavigationDrawer - Menú Lateral
- Consideraciones de Notch y Opciones del menú
- Navegar desde el menú
- Preparación de pantalla para Riverpod
- Nota de actualización - Riverpod annotations
- Introducción a Riverpod
- Cambiar valores y modificadores
- Pantalla para cambiar colores
- Indice del color seleccionado
- Riverpod - StateNotifier
- Usar el StateNotifier
- Tarea - Cambiar el color del tema
- Código fuente de la sección

Sección 12: Full App - Cinemapedia
- Introducción a la aplicación
- Temas puntuales de la sección
- Reforzamiento de conceptos de Arquitectura
- Inicio de aplicación - Estilo y Router
- Entidad - Repositories y Datasources
- TheMovieDB
- Environment Variables y Git
- Datasource - Obtener películas en cines
- TheMovieDB - Modelos
- MovieMappers - MovieDB hacia Movie Entity
- Realizar el mapeo de la respuesta de MovieDB
- MovieRepository - Implementación
- Crear la instancia del repositorio - Riverpod
- NowPlaying Provider y Notifier
- Resumen y archivo de barril
- Mostrar películas en pantalla
- Código fuente de la sección

Sección 13: Cinemapedia - Continuación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Custom AppBar
- MovieSlideShow - Carrusel de películas
- Terminar el carrusel de películas
- SwiperPagination
- Movies Slideshow Provider
- CustomBottomNavigationBar
- Movie Horizontal ListView
- Mostrar las películas en el ListView
- HumanFormats - Números cortos
- InfiniteScroll Horizontal
- Evitar peticiones simultáneas
- SingleChildScrollView y CustomScrollView
- Obtener películas populares
- Tarea: getUpcoming y getTopRated
- Solución de la tarea
- FullScreen Loader - Diseño
- Escuchar múltiples providers simultáneamente
- Código fuente de la sección

Sección 14: Películas individuales y actores
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Navegar a otra pantalla con parámetros
- Obtener película por ID - Datasource
- MovieDB to Entity
- Movie Details - Caché Local
- Realizar la petición HTTP y probar caché
- Diseño de la pantalla de película
- Descripción de la película
- Actores de la película
- Mappers e implementaciones de actores
- Repositorio y Provider - Implementación
- Probar obtención de actores
- Mostrar los actores de la película
- Detalles estéticos
- Código fuente de la sección

Sección 15: SearchDelegate - Búsquedas
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Datasource y Repository - SearchMovies
- SearchDelegate
- Leading y Actions
- Construir sugerencias - Petición Http
- Posibles valores nulos en las películas
- Mostrar las películas en la búsqueda
- Mostrar calificación de la película
- Regresar de la búsqueda con argumentos
- Debounce Manual
- Debounced Movies - Stream
- Search Movies Providers
- Mantener un estado con las películas buscadas
- Mostrar las películas previamente almacenadas
- BuildResults
- Don''t Repeat Yourself - DRY
- Indicador de carga
- Código fuente de la sección

Sección 16: ShellRoutes - Go Router - Tabs
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Preparación de Vistas - Views
- ShellRoute - GoRouter
- Bottom Navigation Bar - Navegación
- Código fuente - Fin Router - Go Router Oficial
- Regresar al punto anterior
- Creación de Vistas
- Configuración del Router
- Funcionamiento del bottom navigation bar
- Resolver la navegación
- Código fuente de la sección

Sección 17: Local Databases
- Introducción a la sección
- Temas puntuales
- Continuación de la aplicación
- Botón para marcar como favorito
- Resolución de la tarea
- Drift Database
- Pruebas de inserción y eliminación
- Repositorios y Datasources
- Drift Datasource Implementation
- Implementación - Cargar películas
- Provider favoriteMovies
- Añadir película a favoritos desde el Provider
- Future Provider - Con argumentos
- Mostrar películas favoritas
- Resolución de la tarea - Películas favoritas
- StaggeredGridView - MasonryGridView
- Masonry Infinite Scroll
- Arreglar la navegación del SearchDelegate
- Mostrar mensaje si no hay favoritos
- Código fuente

Sección 18: Estudios adicionales
- Introducción a la tarea
- Código fuente de la sección

Sección 19: BLoC (Business Logic Component) - FlutterBloc y Cubits
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - FormsApp
- Estructura inicial de la aplicación
- Counter Cubit - Gestor de Estado
- Consumir y utilizar el CounterCubit
- Llamar métodos del cubit
- Equatable
- BLoC y Flutter BLoC
- Simplificar el handler del BLoC
- Utilizar Counter Bloc
- Solución de la tarea
- Opcional - Disparar eventos dentro del BLoC
- Código fuente de la sección

Sección 20: Manejo de formularios
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Consideraciones con inputs y scroll
- Diseño del campo de texto
- Finalizar el custom form field
- Formulario tradicional
- Código fuente - Formularios tradicionales
- Register Form Cubit
- Conectar cubit con el formulario
- Código fuente - Formularios con gestor de estado
- Formz - Crear inputs individuales
- Usar los inputs personalizados
- Password Custom Input
- Mostrar errores en pantalla
- Centralizar los errores en el input
- Email Custom Input

Sección 21: Push Notifications + Local Notifications
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de aplicación
- Bloc y FlutterFire
- Solicitar permisos
- Configurar proyecto de Firebase
- Cambiar id de la aplicación
- Configurar Flutter con proyecto de Firebase
- Inicializar la aplicación de Firebase en Flutter
- Actualizar el estado acorde a los permisos
- Token del dispositivo y determinar permiso actual
- Escuchar mensajes Push
- Recibir nuestra primera notificación Push
- Notificaciones cuando la app está terminada
- Entidad para el manejo de notificaciones
- Actualizar el estado con la nueva Notificación
- Solución de la tarea
- Segunda pantalla - Información de la notificación
- Navegar a la segunda pantalla
- Manejar interacciones con las notificaciones
- Código fuente de la sección

Sección 22: Enviar notificaciones desde una Rest API
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - PushApp
- Rest - Forma Simple - No recomendada
- Servidor para obtener Bearer Token
- Rest - Forma recomendada

Sección 23: Local Notifications
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- LocalNotifications - Android
- Configuración - LocalNotifications
- Mostrar la LocalNotification
- Evitar dependencias ocultas
- Reaccionar al tocar una Local Notification
- Código fuente de la sección

Sección 24: IOS - Push + Local Notifications
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Push Notification - Primeros Pasos y requisitos
- Enlazar APNs con FCM
- Registrar el Identificador de la aplicación
- Generar el perfil de aprovisionamiento
- Permitir imágenes en las notificaciones
- Probar Push en dispositivo físico
- Local Notifications - IOS
- Código fuente de la sección

Sección 25: Preparación de Backend con Autenticación JWT
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de sección - Backend - Nest - Postgres - Docker
- Probar el backend

Sección 26: Autenticación - Jwt - Riverpod
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de aplicación
- Levantar el backend
- Riverpod - Inputs y LoginState
- LoginForm Provider y Notifier
- Conectar formulario con Provider
- Cambiar el estilo del error
- Variables de entorno
- Auth - Repositorio y Datasource
- Implementación del AuthDataSource - Login
- Auth Provider
- Login y Logout desde el provider
- Obtener el Token de acceso
- Manejo de errores
- Mostrar el error en pantalla
- Resolución de la tarea
- Código fuente de la sección

Sección 27: Go Router - Protección de Rutas
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Preferencias de usuario - Shared Preferences
- Implementar el patrón adaptador
- Guardar Token en el dispositivo
- Revisar el estado de la autenticación
- Check Auth Status Screen
- Resolución de la tarea
- Go_Router - Protección de Rutas
- GoRouterNotifier
- Navegar dependiendo de la autenticación
- Bloquear botón de login
- Código fuente de la sección

Sección 28: Obtener productos - Datasources y Repositories
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de aplicación
- onFieldSubmitted
- Entidades, datasources y repositorios
- Implementación - getProductsByPage
- Product Mapper
- Riverpod - Product Repository Provider
- Riverpod - StateNotifierProvider - State
- Riverpod - StateNotifierProvider - Notifier
- Riverpod - StateNotifierProvider - Provider
- Pantalla de Productos
- Tarjetas de producto
- Scroll Infinito - Tarea
- Pantalla de Producto
- Código fuente de la sección

Sección 29: Crear y Actualizar Productos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de aplicación
- Product Provider
- Implementar la carga del producto
- Product Screen - Fix
- Diseño de la pantalla
- Campos adicionales de formulario - Formz
- Product Form Provider - State
- Product Form Provider - Notifier
- Product Form Provider - Notifier Parte 2
- Product Form Provider - Provider
- Conectar el provider con el formulario
- Mostrar errores en Stock y Price
- Conectar campos faltantes
- Probar el backend - Actualización de Producto
- Implementar método createUpdateProduct
- Actualizar producto desde la App
- Actualizar la pantalla de productos
- Mostrar mensaje de actualización
- Crear un nuevo producto
- Ocultar teclado cuando ya no se necesita
- Código fuente de la sección

Sección 30: Cámara, Galería y carga de archivos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Postman - Subir imagen
- PubDev - Cámara y Galería
- Patrón adaptador - Servicio
- Probar la cámara y galería - Path de la fotografía
- Mostrar imágenes desde Paths absolutos
- POST - Subir la imagen al backend
- POST - Subir la imagen al backend - Parte 2
- Código fuente de la sección

Sección 31: Despliegues a Play Store y Apple App Store
- Introducción a la sección
- Temas puntuales de la sección
- Preparación del proyecto a subir
- Cambiar Bundle ID - App ID semi-automáticamente
- Cambiar ícono de la aplicación
- SplashScreen
- Android - Llaves de Release y Upload
- Android - Crear el App Bundle
- Android - Google Play Console
- Android - Google Play Console - Generalidades
- IOS - Preparar el build de producción
- IOS - Verificar la aplicación
- IOS - Subir la aplicación
- IOS - TestFlight configuration
- IOS - External Testing
- IOS - Public Link
- Código fuente - Pubspec y Readme

Sección 32: Cierre del curso
- Más información sobre nuestros otros cursos
- Despedida del curso :(', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (56, 'flutter-movil-intermedio', 'Flutter Móvil: Recursos Nativos - Nivel Intermedio', 'https://cursos.devtalles.com/courses/flutter-movil-intermedio', 'https://import.cdn.thinkific.com/643563/1KaCF2nnTI2eoV6HYpum_FLUTTER-MOVIL-RECURSOS-NATIVOS.jpg', 'Portada del curso: Flutter Móvil: Recursos Nativos - Nivel Intermedio', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este curso se enfoca en la utilización de recursos nativos del dispositivo móvil, que van desde el giroscopio, cámara, sensores, contactos, conexión a internet, etc. Pero también emplearemos ese conocimiento para poder crear aplicación que van más allá de peticiones HTTP y mostrar información.', 960, 'es', '{"Recursos del dispositivo: Sensores, brújula, biometría, ubicación y permisos.","Arquitectura moderna: Riverpod, Domain Driven Design, Isar y bases de datos locales.","Integraciones: Deep Linking, AdMob, Quick Actions y procesos en segundo plano.","Buenas prácticas: Streams, Futures, GoRouter y actualización de proyectos Flutter.","Flutter moderno: Riverpod, Dart Records y desestructuración.","Sensores: Giroscopio, magnetómetro y animación de brújulas.","Navegación: GoRouter y Deep Linking.","Procesos avanzados: Streams, Futures y tareas en segundo plano.","Permisos y seguridad: Biometría, Local Auth, Face ID, lectores de huellas y permisos del dispositivo.","Ubicación: Mapas, seguimiento en tiempo real y marcadores.","Persistencia: Isar y bases de datos locales.","Integraciones: AdMob, Share Plugins, Railway y Quick Actions.","Y mucho más...","Serás capaz de desarrollar aplicaciones Flutter que aprovechen los recursos físicos del dispositivo.","Aprenderás a integrar sensores, biometría, mapas, Deep Linking y procesos en segundo plano.","Comprenderás cómo estructurar aplicaciones móviles modernas utilizando Riverpod y buenas prácticas de arquitectura.","Tendrás los conocimientos necesarios para desarrollar aplicaciones móviles mucho más completas y profesionales."}', 'https://cursos.devtalles.com/courses/flutter-movil-intermedio', '2026-09-24 15:49:29.94579+00', '{"Conocimiento previo de Flutter es necesario","Conocimiento previo de Dart es requerido","Este curso no es ideal para aprender Flutter"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones y configuraciones recomendadas
- Otras recomendaciones
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Reforzamiento sobre Flutter
- Introduccion a la seccion
- Inicio de proyecto - RiverApp
- Temas puntuales de la sección
- Go Router
- Diseño de pantalla - State Provider
- Nota de actualización - Riverpod Code Generator
- Riverpod - StateProvider
- Cambiar nombre aleatoriamente
- Riverpod - Modificadores
- Riverpod - Future Provider
- Consumir un Future Provider
- Riverpod - Modificador Family
- Comunicar providers entre si
- Stream Provider
- Trabajar con un stream real
- Diseño de pantalla y modelo
- Riverpod - State Notifier Provider
- Agregar nuevo invitado
- Cambiar el estado de un invitado
- Todos los providers de Riverpod
- Código fuente de la sección

Sección 3: Permisos y estado de la aplicación
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Inicio de proyecto - Misceláneos
- Pantallas y Rutas
- App Lifecycle State
- Almacenar el LifeCycle State
- Permission Handler - Android
- Permission Handler - IOS
- Permissions Provider
- Permissions Notifier
- Uso del Permissions Provider
- Cambio de permisos - Fuera de la aplicación
- Otorgar otros permisos
- Código fuente de la sección

Sección 4: Sensores
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de aplicación
- Menú, rutas y pantallas
- Giroscópio - Provider
- Mostrar datos del giroscópio
- Acelerómetro - Provider
- Magnetómetro - Provider
- Diseño de pantalla - Mover Widget con el giroscópio
- AnimatedPositioned - Mover usando el giroscópio
- Brújula - Pantalla inicial
- Brújula - Diseño
- Mover la aguja hacia el norte
- Animaciones a la brújula
- Código fuente de la sección

Sección 5: Actualizaciones de Flutter
- Introducción a la sección
- Temas puntuales de la sección
- Actualizar proyecto - Flutter y Dart
- Dart Fix
- Código fuente de la sección

Sección 6: Deep Links - Preparación de proyecto
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- PokemonsScreen
- InfiniteScroll de Pokémons
- PokemonScreen - Pokemon individual
- DDD - Domain Driven Design
- Implementaciones
- Mapeo y respuesta
- FutureProvider - Obtener información del Pokémon
- share_plus - Compartir información vía
- Código fuente de la sección

Sección 7: Deep-Link - Configuraciones
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la aplicación
- Deep-Linking - Explicación
- Continuación de proyecto
- Preparación del sitio web
- Cambiar identificador de aplicación
- Android - Configuraciones para deep-linking
- Desplegar sitioweb
- Android - Probar deep linking
- IOS - Configuraciones
- IOS - Pruebas de app
- Código fuente de la aplicación

Sección 8: Biométricos - FaceID - FingerPrint Reader
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la aplicación
- Continuación de aplicación
- Local Auth
- Wrapper - LocalAuthPlugin
- Riverpod - LocalAuth Providers
- Riverpod - LocalAuth NotifierProvider
- Probar la autenticación biométrica
- Pruebas en IOS
- Código fuente de la sección

Sección 9: Ubicación de usuario y seguimiento
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la aplicación
- Continuación de aplicación
- Geolocator - Ubicación del usuario
- Obtener ubicación de usuario
- Darle seguimiento al usuario
- Google Maps Api Keys
- Usar las llaves - Android e IOS
- Mostrar un mapa básico
- Código fuente de la sección

Sección 10: Mapas, controllers y marcadores
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Diseño de pantalla
- Map Controller Provider
- Ir a la ubicación del usuario
- Seguir los movimientos del usuario
- Solución de la tarea
- Última ubicación conocida
- Marcadores en el Mapa
- Auto dispose - Map Provider
- Código fuente de la sección

Sección 11: Quick Actions e indicador de notificaciones
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Quick Actions
- Reaccionar a las acciones
- Colocar iconos en las acciones
- Configuraciones en IOS
- App Badge - Preparación
- App Badger
- Código fuente de la sección

Sección 12: adMob - Ads- Banner, FullScreen y Reward
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Google AdMob
- Configurar Banner de anuncios
- Mostrar Banner en pantalla
- Interstitial ad
- Interstitial ad - Parte 2
- Ad Rewarded
- Acumular puntos tras cada anuncio visto
- Share Preferences Plugin
- Mostrar y ocultar Ads
- Nota importante
- Código fuente de la sección

Sección 13: Base de datos local - Drift
- Introducción
- Temas puntuales
- Inicio de proyecto - DriftApp
- Instalar y configurar Drift
- Insertar y leer en base de datos
- Riverpopd con anotaciones
- DAO - Data Access Object
- Providers - Notas y Notas por ID
- Mostrar notas en pantalla
- Editar y crear notas
- Eliminar y cambiar importancia
- Código fuente

Sección 14 - Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso

Archivado - Sección 13: Background tasks y Periodic Tasks
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Work Manager
- Constraints
- Preparación de una nueva pantalla
- Establecer background Tasks Keys
- Nota importante
- Isar - Base de datos local
- Repositorios y Datasources
- Implementaciones de base de datos
- Insertar desde background process
- Mostrar pokemons de base de datos
- Preparación para tareas periódicas
- Activar y desactivar background fetch
- Código fuente de la sección
- Nota - Workmanager IOS', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (65, 'legacy-flutter-web', 'Flutter Web: Aplicaciones y páginas web - Fernando Herrera', 'https://cursos.devtalles.com/courses/flutter-web', 'https://import.cdn.thinkific.com/643563/0rSjGVxiQca8Tezfu4tG_COVER-DEVTALLES-web-legacy.jpg', 'Portada del curso: Flutter Web: Aplicaciones y páginas web - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'En este curso nos enfocamos en expandir tu conocimiento existente sobre Flutter para crear aplicaciones nativas para IOS, Android y ahora también Web y Desktop. El curso esta construido totalmente con Null-Safety el cual es un estándar hoy en día para crear aplicaciones modernas con Flutter.', 1230, 'es', '{"Flutter Web: Responsive Design, navegación, layouts y vistas.","Desarrollo profesional: Formularios, tablas, modales, alertas y carga de archivos.","Backend e integración: Peticiones HTTP, manejo de tokens, interceptores y LocalStorage.","Producción: Protección de rutas, páginas 404 y despliegues.","Responsive Design: Interfaces adaptables para diferentes tamaños de pantalla.","Routing: Segmentos, Query Parameters, configuración y protección de rutas.","UI: Layouts, Views, tablas, modales, alertas, animaciones y efectos Hover.","Integraciones: Formularios, carga de archivos, HTTP, interceptores y LocalStorage.","Proyecto final: Desarrollo de un panel administrativo completo.","Y mucho más...","Serás capaz de desarrollar aplicaciones web profesionales utilizando Flutter.","Aprenderás a construir interfaces responsivas, paneles administrativos y sistemas de navegación avanzados.","Dominarás las herramientas necesarias para desplegar aplicaciones Flutter Web listas para producción."}', 'https://cursos.devtalles.com/courses/flutter-web', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de Flutter / Dart básico es necesario","Conocimiento de programación","Haber usado algún gestor de estados (opcional, pero recomendado)","Tener privilegios de administrador para realizar instalaciones"}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción
- Pre-requisitos del curso
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Nota Importante
- Instalaciones recomendadas y obligatorias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Flutter Web - Introducción
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a Flutter Web - Consideraciones importantes
- Recursos adicionales de Flutter Web antes de comenzar
- Materiales y enlaces

Sección 3: Primeros pasos en Flutter Web
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Bases de Flutter Web
- Página de contador con Stateful Widget
- Re-utilización de Widgets
- Creando un menú de navegación
- Navegación tradicional en Flutter
- Router Generator
- Transición entre páginas
- Código específico para la web
- CounterProviderPage - Implementar Provider
- Layout Pages y Views
- Nota de actualización
- Layout Pages
- GlobalKey - NavigatorState
- Get_it
- Menú Responsivo
- Artículo sobre Flutter Navigation 2.0
- Código fuente de la sección

Sección 4: Segmentos de URL y Query Parameters
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto y explicación breve sobre Flutter Navigator 2.0
- Fluro - Router
- Rutas de mi aplicación y animaciones
- 404 Page
- Obtener segmentos del URL
- Leer la base por URL y aplicarlo al contador
- Leer la base por un query parameter
- Multiples segmentos de URL
- Separar los handlers de las rutas
- Código fuente de la sección

Sección 5: Scrollable Landing Page
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Créditos al que me dio la inspiración
- Inicio de proyecto - Scrollable Landing Page
- Configurando las rutas
- HomePage
- Crear un gradiente de fondo
- Menú superior - Botón y Texto
- Animaciones del menú
- Opciones del menú
- Detalles estéticos del menú
- Scroll hacia una página en específico
- Cambiar el URL al hacer click en un enlace
- Utilizar el segmento para definir la pantalla inicial
- Añadir un listener de movimiento del PageController
- Cambiar el titulo de la página web
- Código fuente de la sección

Sección 6: Desplegando una aplicación de Flutter Web
- Introducción a la sección
- Temas puntuales de la sección
- Generar el build web
- Configuración básica de una PWA
- Desplegar la aplicación de Flutter Web
- Flutter Web App - Android

Sección 7: Admin Dashboard - UI Login
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - AdminDashboard
- Definir rutas y AuthLayout
- No Page Found - Route
- Diseño del AuthLayout
- BackgroundTwitter
- Custom Title y espacio para la vista
- Barra de enlaces inferior y enlaces
- Anchor Tag
- Diseño para teléfonos
- Scrollbar
- Formulario de Login
- Botón personalizado de ingreso
- Formulario de Registro
- Centralizar estilos de los inputs
- Código fuente de la sección

Sección 8: Formularios de ingreso, registro y navegación
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - Admin Dashboard
- Formulario de ingreso
- Obtener email y contraseña
- Formulario de Registro
- AuthProvider - Autenticación Global
- Pequeña corrección de un expanded
- Remover inyección de dependencias
- LocalStorage
- NavigationService
- Dashboard Layout
- Splash Layout
- Dashboard Routes
- Condicionalmente mostrar el DashboardView o el LoginView
- Código fuente de la sección

Sección 9: Admin Dashboard Diseño
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - AdminDashboard
- Sidebar
- Items de menú y separadores
- Llenar las opciones del menú
- Navbar
- Notificaciones y Avatar
- Navbar y Sidebar responsive
- Controlador del sidebar
- Animar menú lateral
- Cerrar el menú lateral
- Dashboard View y Blank View
- Icons View y Ruta
- Navegación utilizando el sidebar
- Activando opciones del menú
- Tarea Blank View, ruta y menú
- Detalles finales del panel administrativo
- Código fuente de la sección

Sección 10: Backend para el panel administrativo
- Inicio de sección
- Temas puntuales de la sección
- Configuración de proyecto
- Conectar Backend con MongoAtlas
- Probar inserciones y queries

Sección 11: Autenticación y protección de rutas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo al final de la sección
- Continuación de proyecto
- Dio - Centralizar los llamados a nuestro backend
- Crear usuario - Http post
- Autenticando usuario en el registro
- Mostrar snackbars - NotificationsService
- Login de usuario
- Validar JWT
- Logout
- Submit cuando se presiona ENTER
- Código fuente de la sección

Sección 12: Mantenimiento de categorías
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Crear ruta y vista para las categorías
- PaginatedDataTable
- Configuraciones adicionales del PaginatedDataTable
- Cargar las categorías desde el backend
- Mapear categorías
- PaginatedDataTable con la información del Backend
- Mensaje de confirmación de eliminación
- Modal para editar y agregar categorías
- Contenido del modal de categoría
- Crear categorías
- Actualizar categoría
- Resolver tarea de actualización
- Eliminar categoría
- Snackbars de creación y actualización
- Código fuente de la sección

Sección 13: Optimizaciones
- Introducción a la sección
- Optimizaciones en el manejo de rutas
- Crear múltiples usuarios en nuestra base de datos

Sección 14: Mantenimiento de usuarios
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - Admin Dashboard
- Ruta y vista de usuarios
- UsersView temporal
- UsersProvider
- Llenar la tabla con los usuarios
- Ordenar la lista de usuarios
- Indicadores visuales de la columna ordenada
- User View y Ruta para un usuario independiente
- Validar UID contra el backend
- Diseño de la pantalla de User View
- Espacio para el avatar del usuario
- Espacio para el formulario de actualización
- Formulario de actualización de usuario
- Validaciones y valores actualizados del usuario
- Notificar Listeners cuando se cambia el usuario
- Actualizar usuario en el Backend
- Actualizar el listado de usuarios
- Manejo de errores
- Código fuente de la sección

Sección 15: Carga de archivos y versión de producción
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de la sección
- Seleccionar una imagen
- Subir imagen al backend
- Mensaje de carga de imagen
- Mostrar imagen actualizada
- Mostrar imagen del usuario en la lista de usuarios
- Reduciendo la cantidad de importaciones
- Generar build de producción
- Desplegar aplicación de Flutter en la Web
- Variables de entorno y logs de Heroku
- Actualizar version de producción
- Código fuente de la sección

Sección 16: Despedida del curso
- Más información sobre nuestros otros cursos
- Cierre del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (2, 'golang-backend-profesional', 'Golang: Backend Profesional', 'https://cursos.devtalles.com/courses/golang-backend-profesional', 'https://import.cdn.thinkific.com/643563/ChXFDCgeRKjOyfa2ppDQ_COVER-DEVTALLES-GO-BACKEND.jpg', 'Portada del curso: Golang: Backend Profesional', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Construye APIs REST profesionales en Go desde cero con un proyecto real desplegado en producción con criterio profesional.', 1530, 'es', '{"Fundamentos del Backend: HTTP, servidores, rutas, middlewares y manejo de solicitudes.","Arquitectura: Clean Architecture, patrones de diseño, handlers, dominios y casos de uso.","Persistencia y seguridad: PostgreSQL, Redis, autenticación y autorización.","Buenas prácticas: Validaciones, manejo de errores, logging y organización del código.","Backend con Go: HTTP, servidores, rutas, middlewares y JSON.","Arquitectura: Clean Architecture, Repository Pattern, Domain, Use Cases y Adapters.","Bases de datos: PostgreSQL, migraciones, SQLC y Redis.","Seguridad: JWT, Argon2id, autenticación, autorización y Token Store con Redis.","Calidad del código: Validaciones, Validator V10, manejo de errores, Sentinel Errors y RFC 7807.","Buenas prácticas: Logging, patrones de diseño y organización de proyectos.","Y mucho más...","Construirás APIs y aplicaciones Backend profesionales utilizando Go de forma nativa.","Comprenderás cómo diseñar aplicaciones escalables aplicando arquitectura limpia y buenas prácticas.","Estarás preparado para trabajar en proyectos profesionales o migrar fácilmente a cualquier framework del ecosistema Go.","Contarás con las habilidades necesarias para postularte a posiciones como Backend Developer, Go Developer o Software Engineer."}', 'https://cursos.devtalles.com/courses/golang-backend-profesional', '2026-09-24 15:49:29.94579+00', '{"Fundamentos de Golang, si aun no tienes esta base, te invitamos a que tomes el curso Golang: fundamentos del leguaje","Bases de datos estructuradas","Conocimiento en SQL","Git y Github","PostgreSQL (deseable)"}', '{}', 'Sección 1: Bienvenida al curso
- Bienvenida al curso
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Requisitos del curso

Sección 2: Setup entorno profesional
- Introducción a la sección
- Temas puntuales de la sección
- Instalar Go en MacOS
- Instalar Go en Windows
- Instalar Go en Linux
- Instalaciones recomendadas
- Estructura de proyecto profesional
- Makefile para Go
- golangci-lint (opcional)
- docker-compose básico para el curso
- Código fuente de la sección

Sección 3: HTTP en Go
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es HTTP?
- net/http
- Primer servidor HTTP en Go
- Handler vs HandlerFunc
- Agregar método de registro al servidor
- Routing desde Go 1.22
- Mover health handler
- Mover health handler - parte 2
- Código fuente de la sección
- Repaso interactivo: HTTP en Go

Sección 4: Middlewares para logs en Go
- Introducción a la sección
- Temas puntuales de la sección
- Middlewares
- Middleware - ResponseRecorder
- Middleware logger
- Middleware logger - parte 2
- Middleware recovery
- log/slog estructurado
- Context HTTP
- Graceful shutdown
- Graceful shutdown - parte 2
- Corrigiendo detalles en el proyecto
- Código fuente de la sección
- Repaso interactivo: Middlewares para logs en Go

Sección 5: JSON y validadores
- Introducción a la sección
- Temas puntuales de la sección
- encoding/json
- JSON tags
- Otras consideraciones para JSON
- Tipos basados en Strings ("enums")
- UnmarshalJSON
- Test unitario - UnmarshalJSON
- Validator V10
- Validator V10 aplicación
- Traduciendo tags de validator
- Corrigiendo detalles en el proyecto
- Código fuente de la sección

Sección 6: Errores y contratos de API
- Introducción a la sección
- Temas puntuales de la sección
- Sentinel errors
- Manejo de errores centralizado
- Manejo de errores centralizado - parte 2
- Problem Details (RFC 7807 - RFC 9457) - Opcional
- Implementando RFC 7807 - Opcional
- Contrato de paginación cursor-based
- Contrato de paginación cursor-based - parte 2
- Swagger con Swaggo
- Swagger con Swaggo - parte 2
- Corrigiendo detalles del proyecto
- Código fuente de la sección

Sección 7: Patrones de diseño aplicados a Go Backend
- Introducción a la sección
- Temas puntuales de la sección
- Patrones de diseño en Go
- Patrones útiles en Go
- Functional options
- Functional options actualizando server
- Decorator pattern
- Strategy pattern
- Strategy pattern - parte 2
- Anti-patrones
- Refactorizar main
- Refactorizar main - parte 2
- Corregir detalles del proyecto
- Código fuente de la sección

Sección 8: Arquitectura limpia aplicada a Go
- Introducción a la sección
- Temas puntuales de la sección
- El costo de no tener arquitectura
- Clean Architecture
- Clean Architecture - parte 2
- Capa de dominio - Entidad User
- Capa de dominio - Entidad Task
- Capa de dominio - Entidad Task - Validaciones
- Capa de use cases - User
- Capa de use cases - User - Métodos
- Conceptos para adapters
- Conceptos para adapters - parte 2
- Ports y adapters
- Ports y adapters - parte 2
- Ports y adapters - Test Unitario
- Capa interface adapter - Delivery
- Capa interface adapter - Delivery - parte 2
- Capa interface adapter - Delivery - parte 3
- Dependency injection y rutas
- Probando rutas
- Código fuente de la sección

Sección 9: Arquitectura limpia aplicada a Go - Task module
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es CQRS?
- Use case para Task - CQRS
- Use case para Task - Creación y validaciones
- Use case para Task - Ejercicio - Asignar tarea
- TaskRepository
- TaskRepository - Solución de la tarea
- Interface adapter - Delivery - Task
- Registrando rutas para Task
- Probando rutas para Task
- Solución al ejercicio - Obtener tarea - Use case y handler
- Solución al ejercicio - Obtener tarea - Docs y rutas
- Solución al ejercicio - Listar tareas - Use case y handler
- Solución al ejercicio - Listar tareas - Docs y rutas
- Solución al ejercicio - Actualizar estatus - Use case y handler
- Solución al ejercicio - Actualizar estatus - Use case y handler - parte 2
- Solución al ejercicio - Actualizar estatus - Docs y rutas
- Solución al ejercicio - Asignar tarea - Use case y handler
- Solución al ejercicio - Asignar tarea - Docs y rutas
- Refactorizando create
- Código fuente de la sección

Sección 10: Base de datos - Configuraciones y migraciones
- Introducción a la sección
- Temas puntuales de la sección
- PostgreSQL
- sqlc
- Instalar pgx, golang-migrate y sqlc
- Migraciones - Users
- Migraciones - Tasks
- Queries para Users
- Queries para Tasks
- Generar código con sqlc
- Connection pool
- Config
- Conectar pgxpool
- Código fuente de la sección

Sección 11: Base de datos - Repositorios Postgres
- Introducción a la sección
- Temas puntuales de la sección
- Repositorio postgres de Users
- Repositorio postgres de Users - parte 2
- Ejercicio GetByEmail
- Repositorio postgres de Tasks
- Repositorio postgres de Tasks - Update
- Repositorio postgres de Tasks - GetByID
- Repositorio postgres de Tasks - ListByProject
- Conectar postgres al servidor
- Verificar conexión y endpoints
- Código fuente de la sección

Sección 12: Autenticación y autorización - Redis, Argon2id y JWT
- Introducción a la sección
- Temas puntuales de la sección
- Autenticación y autorización segura
- Redis - Setup y cliente Go
- Redis - Agregar cliente redis al main
- Hashing seguro con Argon2id
- Hashing seguro con Argon2id - HashPassword
- Hashing seguro con Argon2id - HashPassword - parte 2
- Hashing seguro con Argon2id - parseHash
- Hashing seguro con Argon2id - Verificar password
- JWT - Teoría e instalación
- JWT en Go
- JWT - Generar token
- JWT - Generate y Refresh Token
- JWT - Verify token
- Token store en Redis
- Token store en Redis - Validate y revoked token
- Token store en Redis - RevokeAllUserTokens
- Código fuente de la sección

Sección 13: Autenticación y autorización - Use case y Handler
- Introducción a la sección
- Temas puntuales de la sección
- Auth use case - constructor
- Auth use case - Registro
- Auth use case - Generate token pair
- Auth use case - Login
- Auth use case - Refresh tokens
- Auth use case - Logout
- Auth handler - Configuración
- Auth handler - Register
- Auth handler - Login
- Auth handler - Refresh
- Auth handler - Logout
- Código fuente de la sección

Sección 14: Autenticación y autorización - Middlewares, auth, CORS y security headers
- Introducción a la sección
- Temas puntuales de la sección
- Middleware de autenticación
- Middleware de autenticación - parte 2
- Middleware de autenticación - GetClaims y GetUserID
- Middleware require role
- Actualizar handlers con user del context
- Headers de seguridad y CORS
- Agregar servicios al main
- Rutas públicas y rutas protegidas
- Corrigiendo errores
- Corrigiendo errores - parte 2
- Probando autenticación
- Revisar tokens en Redis
- Código fuente de la sección

Sección 15: Devboard - Modelado de datos
- Introducción a la sección
- Temas puntuales de la sección
- Correcciones antes de iniciar
- Diseño del modelo - Devboard
- Migraciones Workspace
- Migraciones Projects
- Migraciones - Modificar tabla
- Migraciones Comments
- Domain Workspace
- Domain Project
- Domain Comment
- Queries para Workspace
- Resolviendo ejercicio queries para Workspace
- Queries para projects
- Queries para comments
- Generar código con sqlc
- Código fuente de la sección

Sección 16: Devboard - Repository y Use case
- Introducción a la sección
- Temas puntuales de la sección
- Repository Workspace - CreateWorkspace
- Repository Workspace - GetWorkspaceByID y GetWorkspaceBySlug
- Repository Workspace -ListWorkspaceByUser
- Repository Workspace -AddMember y GetMember
- Repository Workspace - ListMember y RemoveMember
- Repository Project - Create Project
- Repository Project - GetByID y ListByWorkspace
- Repository Comments - Create Comment
- Repository Comments - GetByID y ListByTask
- Repository Comments - Delete
- Use Case Workspace - CreateWorkspace
- Use Case Workspace - GetWorkspace y ListUserWorkspaces
- Use Case Workspace - AddMember y ListMembers
- Use Case Workspace - Remove member
- Use Case Project - CreateProject
- Use Case Project - GetProject y ListWorkspaceProjects
- Use Case Comment - CreateComment
- Use Case Comment - ListTaskComments y DeleteComment
- Código fuente de la sección

Sección 17: Devboard - Handler y rutas
- Introducción a la sección
- Temas puntuales de la sección
- Handler Workspace - Crear workspace
- Handler Workspace - Listar workspaces
- Handler Workspace - Obtener workspace por ID
- Handler Workspace - Agregar miembro
- Handler Workspace - Listar miembros
- Handler Workspace - Eliminar miembro
- Handler Project - Crear proyecto
- Handler Project - Obtener proyecto por ID
- Handler Project - Listar proyectos de un Workspace
- Handler Comment - Crear comentario
- Handler Comment - Listar comentarios de una tarea
- Handler Comment - Eliminar comentario
- Agregar endpoint al main
- Agregando rutas al main - projects y comments
- Probando endpoints
- Probando endpoints - comentarios y miembros
- Código fuente de la sección

Sección 18: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (12, 'golang-fundamentos-lenguaje', 'GoLang: Fundamentos del lenguaje', 'https://cursos.devtalles.com/courses/golang-fundamentos-lenguaje', 'https://import.cdn.thinkific.com/643563/Jp4CugOyRxOPbI0IERhE_COVER_DEVTALLES_GO.png', 'Portada del curso: GoLang: Fundamentos del lenguaje', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende Golang desde cero, profesional y con buenas prácticas. Tipado estático, paquetes, funciones, structs, interfaces, errores y concurrencia. Ejemplos reales para código limpio y listo para desplegar, ideal si vienes de JS/Python/PHP y más.', 1380, 'es', '{}', 'https://cursos.devtalles.com/courses/golang-fundamentos-lenguaje', '2026-09-24 15:49:29.94579+00', '{"Tener conocimientos de programación básica","Conocer al menos un lenguaje de programación aunque no se domine el lenguaje (opcional pero útil)","Git y GitHub"}', '{}', 'Sección 1: Introducción al curso
- Bienvenida al curso
- ¿Cómo aprovechar el curso al máximo?
- Temas y contenido del curso
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a Go
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Go?
- Instalar Go en MacOS
- Instalar Go en Windows
- Instalar Go en Linux (Ubuntu)
- Primer programa en Go
- go fmt y go vet
- Go Playground
- Código fuente de la sección

Sección 3: Fundamentos de Go
- Introducción a la sección
- Temas puntuales de la sección
- Variables
- Constantes
- Tipos primitivos (parte 1)
- Tipos primitivos (parte 2)
- Zero values
- Conversiones de tipo explícitas
- Constantes tipadas y no tipadas
- var vs :=
- Comentarios
- Operadores aritméticos
- Operadores de comparación
- Operadores lógicos
- Entrada y salida por consola
- Errores comunes en Go
- Multiples variables
- Miniproyecto - Ticket con impuestos
- Código fuente de la sección
- Repaso interactivo: Fundamentos de Go

Seccion 4: Tipos compuestos de datos
- Introducción a la sección
- Temas puntuales de la sección
- Tipos compuestos en Go
- Go run usando CodeRunner
- Arrays
- Slices
- Comparando Slices
- Funciones para slices parte 1
- Funciones para slices parte 2
- Cortando slices (slice de slices)
- Strings y bytes
- Maps
- Inicializando maps
- Comma ok idiom
- Eliminando elementos de Map
- Comparando maps
- Structs
- Structs anónimos
- Mini proyecto
- Código fuente de la sección
- Repaso interactivo: Tipos compuestos de datos

Sección 5: Estructuras de control
- Introducción a la sección
- Temas puntuales de la sección
- Estructuras de control en Go
- Condicional If
- Variables de sombra
- Ciclo for completo
- Ciclo for de solo condición
- Ciclo for infinito
- Break y continue
- Ciclo for con rango
- Iterando maps
- Etiquetando al ciclo for
- Switch
- Switch en blanco
- Código fuente de la sección
- Repaso interactivo: Estructuras de control

Sección 6: Funciones
- Introducción a la sección
- Temas puntuales de la sección
- Funciones
- Primer función en Go
- Estructura del proyecto
- Declarando y llamando funciones
- Agregar y eliminar elementos a la orden
- Parámetros con struct
- Paso por valor y paso por referencia
- Parámetros variables (variadic)
- Aplicando cupones de descuento (variadic)
- Retornando múltiples valores
- Solución al ejercicio (múltiples valores)
- Manejo de errores
- Manejo de errores en cupones
- Retornando valores con nombre
- Retornando valores en blanco
- Código fuente de la sección
- Repaso interactivo: Funciones
- Ejercicios - Consolidando los Fundamentos de Go

Sección 7: Funciones - continuación
- Introducción a la sección
- Temas puntuales de la sección
- Defer
- Aplicando Defer
- Funciones como valores
- Funciones anónimas
- Funciones dentro de funciones (Closures)
- Funciones como parámetros
- Funciones como parámetros (incluir impuestos)
- Retornando funciones en funciones
- Métodos vs Funciones
- Métodos con Go
- Métodos con Go - Parte 2
- Recursividad
- Recursividad - Parte 2
- Aplicando recursividad al proyecto
- Aplicando descuento recursivo
- Mejorando formato de moneda
- Código fuente de la sección
- Repaso interactivo: Funciones - continuación

Sección 8: Punteros
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son los punteros?
- Punteros
- Valores y referencias
- Punteros * y &
- Solución al ejercicio
- Nil y errores típicos
- Zero value vs No value
- Mutabilidad
- Punteros en structs
- Receptores de métodos
- Slices con referencia
- Maps referencia interna
- Interfaces y nil interface trap
- Punteros como último recurso
- Código fuente de la sección
- Repaso interactivo: Punteros

Sección 9: Tipos, métodos e interfaces
- Introducción a la sección
- Temas puntuales de la sección
- Tipos, métodos e interfaces
- Tipos en Go
- Structs + iota
- Método con context
- Service como struct
- Interfaces
- Agregando métodos a la interfaz
- Embedding para composición
- Interface nil trap
- Código fuente de la sección
- Repaso interactivo: Tipos, métodos e interfaces

Sección 10: Generics
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son los Generics?
- Generics - Filter
- Generics - Map
- Test - Generic - Filter
- Test - Generic - Map
- Inferencia de tipos
- Generic - Comparable
- Test - Generic - Comparable
- Ejercicio Generic comparable
- Generic - Ordered
- Test - Generic - Ordered
- Generic - K comparable
- Test - Generic K comparable
- Crear función Reduce
- Pipelines de generics
- Constraints personalizados
- Test - Probando constraints personalizados
- Ejercicio final
- Solución ejercicio final
- Código fuente de la sección
- Repaso interactivo: Generics

Sección 11: Manejo de errores
- Introducción a la sección
- Temas puntuales de la sección
- Manejo de errores en Go
- Preparando proyecto para la sección
- Errores como valores
- errors.New y fmt.Errorf
- Sentinel errors
- Wrapping
- Test - Errors - usando strings
- Test - Errors - usando sentinels
- Error en close con Defer
- Shadowing errors
- Panic and recover
- Código fuente de la sección
- Repaso interactivo: Manejo de errores

Sección 12: Módulos, paquetes e imports
- Introducción a la sección
- Temas puntuales de la sección
- Módulos, paquetes e imports
- Crear un módulo
- Paquetes
- Importar paquete
- Exported vs Unexported
- Paquetes privados del módulo
- Alias en imports
- Flags
- Dependencia externa
- Paquete como dependencia
- Paquete propio como dependencia
- Proyecto - TaskManager
- Proyecto - Crear Task
- Proyecto - Store - Agregar y listar
- Proyecto - Store - Completar y eliminar
- Código fuente de la sección
- Repaso interactivo: Módulos, paquetes e imports

Sección 13: Goroutines y Go Channels
- Introducción a la sección
- Temas puntuales de la sección
- Concurrencia, paralelismo y goroutines
- Goroutine - Lanzar funciones concurrentes
- Go Scheduler
- Go Scheduler - Ejemplo
- Channels
- Channel Unbuffered
- Channel Buffered
- Herramientas esenciales
- Select
- WaitGroup
- Mutex - Proteger datos compartidos
- Context - Cancelación y timeouts
- Proyecto - Agregar Process
- Código fuente de la sección
- Repaso interactivo: Goroutines y Go Channels

Sección 14: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso
- ¿Ahora qué sigue?', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (1, 'git-github-control-versiones-desde-cero', 'GIT+GitHub: Control de versiones desde Cero', 'https://cursos.devtalles.com/courses/git-github-control-versiones-desde-cero', 'https://import.cdn.thinkific.com/643563/vyhm8XioTSeV0KPWLzrI_COVER-DEVTALLES-github2026.jpg', 'Portada del curso: GIT+GitHub: Control de versiones desde Cero', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Domina GIT y GitHub para gestionar y colaborar en proyectos de forma eficiente. Aprende desde lo básico hasta flujos de trabajo avanzados.', 690, 'es', '{"Fundamentos de Git: Control de versiones, repositorios locales y flujo básico de trabajo.","Git avanzado: Ramas, Stash, Rebase, Reflog, recuperación de proyectos y viajes en el tiempo.","GitHub: Repositorios remotos, Pull Requests, Teams, Organizaciones y Gists.","Trabajo colaborativo: Flujos de trabajo utilizados en equipos de desarrollo profesionales.","Git: Commits, ramas, merges, Stash, Rebase, Reflog y recuperación de proyectos.","GitHub: Repositorios remotos, Pull Requests, Tokens y trabajo colaborativo.","Organización: Teams, Organizaciones y Gists.","Buenas prácticas: Manejo seguro del historial y colaboración en proyectos reales.","Y mucho más...","Dominarás Git para controlar el historial y la evolución de tus proyectos.","Aprenderás a trabajar con GitHub utilizando flujos de trabajo profesionales.","Podrás colaborar con otros desarrolladores de forma segura y organizada.","Contarás con una habilidad indispensable para cualquier desarrollador o profesional del área tecnológica."}', 'https://cursos.devtalles.com/courses/git-github-control-versiones-desde-cero', '2026-09-24 15:49:29.94579+00', '{"No es necesario conocimiento alguno de Git","No es necesario conocimiento sobre GitHub","Navegación básica en el powershell o terminal es recomendada pero no necesaria","Se puede seguir el curso en Windows, OSX o Linux sin problemas"}', '{}', 'Sección 1: Introducción a GIT y GitHub
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Git - Fundamentos
- Introducción
- Temas puntuales
- ¿Por qué nos interesa un control de versiones?
- Primeros comandos de git
- Nuestro primer repositorio
- Nota - CRLF
- Flujo normal en Git
- ¿Qué hace git por nosotros en estos momentos?
- Tarea - Proyecto Omega
- Git Log - Ver historial de cambios
- Creando alias para nuestros comandos
- Repaso interactivo: Git - Fundamentos

Sección 3: Un poco más allá de los fundamentos de GIT
- Introducción
- Temas puntuales
- Git diff - cambios en archivos
- Git amend - Actualizar mensajes de commit
- Preparar repositorio para viajes en el tiempo
- Git reset y viajes en el tiempo
- Git reflog - Historial de cambios
- Git rm y mv - cambiar y eliminar archivos
- Cambiar el nombre y eliminar archivos fuera de git
- gitignore - Excluir y añadir excepciones
- Repaso interactivo: Un poco más allá de los fundamentos de GIT

Sección 4: Ramas, uniones, conflictos y tags
- Introducción
- Temas puntuales
- Introducción ramas, uniones y conflictos
- Preparar repositorio - Legion del mal
- Merge: Fast-Forward
- Trabajar en ramas no es opcional
- Merge: Union automática
- Merge: Uniones con conflictos
- Tags - Etiquetas
- Git tag: Crear etiquetas
- Repaso interactivo: Ramas, uniones, conflictos y tags

Sección 5: Git stash y rebase
- Introducción
- Temas puntuales
- Git stash: Trabajo a medias
- Git Stash: list, pop y apply
- Git stash: Conflictos y auto merge
- Git stash: Avanzado
- Git rebase: Introducción al comando
- Git rebase: Actualizando ramas
- Rebase interactivo - Squash
- Rebase interactivo - Reword
- Rebase interactivo - Edit
- Repaso interativo: Git stash y rebase

Sección 6: Inicios en GitHub, Git remote, push & pull
- Introducción
- Temas puntuales
- GitHub: Introducción al flujo de trabajo
- GitHub: Creación de cuenta
- Git push: Crear y subir repositorios
- GitHub CLI - Línea de comandos
- Github: Tags
- GitHub: Release tags
- Perfil de GitHub
- Shield.io - Imágenes dinámicas
- Git pull: Obtener cambios del remoto
- Warning - Pulling without reconcile strategy
- Git clone: Clonar un repositorio
- GitHub + Git: Causar conflicto de FF
- Git pull rebase
- Tarea: Resolver conflicto con rebase
- Repaso interactivo: Inicios en GitHub, Git remote, push & pull

Sección 7 - GitHub Básico
- Introducción
- Temas puntuales
- Tips y trucos: Interfaz de GitHub
- Tips y trucos: Interfaz de GitHub - Parte 2
- Markdown en GitHub
- Pull Request - Desde GitHub
- Git Fetch: Actualizar referencias
- GitHub: Flujo de trabajo
- Bonus: No confíen en commits no verificados
- Repaso interactivo: GitHub Básico

Sección 8 - GitHub real en el día a día
- Introducción
- Temas puntuales
- GitHub: Fork y Pull Request
- GitHub: Protección de rama main
- GitHub: Pull Request con cambios
- GitHub: Fork y actualizaciones del fork
- Git: remote upstream
- Tarea: Pull request
- Solución de la tarea: Pull Request
- Repaso interactivo: GitHub real en el día a día

Sección 9 - Issues, Milestones y colaboradores
- Introducción
- Temas puntuales
- GitHub: Issues
- Cerrar un issue mediante un commit
- Solución de la tarea: Cerrar issues
- Issue templates
- Labels - Etiquetas
- GitHub: Milestones - Un punto importante
- Colaboradores a un repositorio
- Repaso interactivo: Issues, Milestones y colaboradores

Sección 10 - Wikis, Proyectos y GitHub Pages
- Introducción
- Temas puntuales
- GitHub: Wikis
- GitHub: Proyectos
- GitHub Pages: Para sitios personales
- GitHub Pages: Para repositorios
- Repaso interactivo: Wikis, Proyectos y GitHub Pages

Sección 11: GitHub Actions y Workflows
- Introducción
- Temas puntuales
- Preparación del repositorio
- Mi primer Workflow
- Variables de usuario y entorno
- Action: checkout
- Recibir data externa hacia el workflow
- Instalaciones dentro del runner
- CRON Jobs - Programar tareas
- Ejecutar scripts personalizados
- Depurar scrips y workflows
- Tarea - Depurar Workflows
- Acciones creadas con AI - Responder a un issue
- Acciones creadas con AI - Releases automáticos
- Código fuente
- Repaso interactivo: GitHub Actions y Workflows

Sección 12 - Organizaciones y equipos
- Introducción
- Temas puntuales
- Creando una organización
- Trasferir repositorio a la organización
- GitHub Teams - Equipos de trabajo

Sección 13 - Gists
- Introducción
- Temas puntuales
- Creando un Gist
- Repaso interactivo: Organizaciones y equipos - Gists

Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (10, 'ingenieria-de-prompts', 'Ingeniería de prompts: Para la vida real', 'https://cursos.devtalles.com/courses/Ingenier%C3%ADa-de-prompts', 'https://import.cdn.thinkific.com/643563/p5tNOanKQAeu2lWSccuA_COVER-DEVTALLES.jpg', 'Portada del curso: Ingeniería de prompts: Para la vida real', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este es un curso donde aprenderás Prompt Engineering de forma simple, práctica y sin tecnicismos, para que puedas escribir mejores prompts y obtener excelentes resultados con herramientas de inteligencia artificial como ChatGPT, Claude, Gemini y más.', 150, 'es', '{}', 'https://cursos.devtalles.com/courses/Ingenier%C3%ADa-de-prompts', '2026-09-24 15:49:29.94579+00', '{"No se necesita experiencia previa. Solo necesitas curiosidad y ganas de aprender a trabajar mejor con la IA.","No se requiere experiencia en programación ni conocimientos técnicos.","Este curso fue diseñado desde cero para que cualquier persona."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones y herramientas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Prompts y estrategias iniciales
- Introducción
- Temas puntuales
- ¿Qué es un prompt?
- ¿Por qué fallan los prompts?
- Calidad de la respuesta
- "La formula base" - Tarea, contexto, audiencia y formato
- Formato de salida
- Tarea - Ejercicios de reforzamiento

Sección 3: Contexto y persona
- Introducción
- Temas puntuales
- Personas
- Ejemplos para el contexto
- Perspectivas múltiples
- Focalizar búsquedas - Prompt Injection
- Optimizar el prompt con AI
- Evitar alucinaciones
- Verificar resultados automáticamente
- Repaso interactivo: Prompts, estrategias iniciales, contexto y persona

Sección 4: Técnicas avanzadas - ACHIEVE Framework
- Introducción
- Temas puntuales
- Framework ACHIEVE
- Preparación de proyecto
- A - Ayudar a la coordinación humana
- C - Cortar tareas tediosas
- H - Proveer red de seguridad
- I-E-V - Inspirar mejor solución de problemas y creatividad
- E - Habilitar ideas que escalen rápidamente
- Tarea - Poner en practica lo aprendido

Sección 5: Técnicas avanzadas de pensamiento
- Introducción
- Temas puntuales
- Prompt Chaining - Encadenamiento de prompts
- Chain of though prompting - Cadena de pensamiento
- Tree of though prompting - Árbol de pensamiento
- Least-to-Most - De menor a mayor
- Iterative Refinement - Refinamiento Iterativo
- Repaso interactivo: Técnicas avanzadas - ACHIEVE Framework y Pensamiento

Fin del curso
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (28, 'java-avanzado', 'Java avanzado: reactividad, concurrencia y patrones', 'https://cursos.devtalles.com/courses/java-avanzado', 'https://import.cdn.thinkific.com/643563/rJCXtKQUQSmgJSQbArul_java-avanzado-devtalles.jpg', 'Portada del curso: Java avanzado: reactividad, concurrencia y patrones', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Lleva tu conocimiento de Java al siguiente nivel: código limpio, funcional y concurrente. Streams, RxJava, bases de datos, patrones, excepciones y más. Incluye proyectos prácticos y bonus de Spring MVC. Ideal para desarrolladores exigentes.', 1500, 'es', '{}', 'https://cursos.devtalles.com/courses/java-avanzado', '2026-09-24 15:49:29.94579+00', '{"Haber completado un curso inicial de Java o dominar sus fundamentos (POO, colecciones, excepciones)","Conocimientos básicos de desarrollo con IntelliJ IDEA.","Diseñado para quienes desean explorar nuevas formas de programar y estructurar sus proyectos","Acceso a internet para descargar recursos y librerías externas."}', '{}', 'Sección 1: Introducción
- Introducción al curso
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Genéricos: Tipos flexibles y reutilizables
- Introducción a la sección
- Temas puntuales de la sección
- Object & Genéricos: primeros pasos
- Uso de genéricos con restricciones
- Wildcards, ? extends y ? super
- LinkedList personalizada con genéricos
- LinkedList personalizada con genéricos parte 2
- Implementando un stack con genéricos
- Implementando una queue con genéricos
- Tarea: DataStore genérico parte 1
- Tarea: DataStore genérico parte 2
- La metáfora de los genéricos
- Código fuente

Sección 3: Repaso del patrón MVC y Lombok
- Introducción al curso
- Temas puntuales de la sección
- Introducción al patrón MVC
- MVC: El modelo parte 1
- MVC: El modelo parte 2
- MVC: El controlador parte 1
- MVC: El controlador parte 2
- MVC: La vista parte 1
- MVC: La vista parte 2
- Tarea: refactorizando entrada de datos
- MVC con persistencia utilizando Gson parte 1
- MVC con persistencia utilizando Gson parte 2
- Tarea: Update completed y listando parte 1
- Tarea: Update completed y listando parte 2
- Lombok Esencial: Funciones Básicas
- Código fuente

Sección 4: Programación funcional
- Introducción a la sección
- Temas puntuales de la sección
- Expresiones lambda
- Programación funcional
- Tarea: Calculator
- Interfaces funcionales: Consumer & Predicate
- Interfaces funcionales: Function & Supplier
- Interfaces funcionales con colecciones
- Stream con colecciones
- Api de Stream
- Operaciones intermedias y terminales parte 1
- Operaciones intermedias y terminales parte 2
- Repasando: Operadores ternarios
- Los records y la inmutabilidad
- Manejo avanzado de colecciones con Stream 1
- Manejo avanzado de colecciones con Stream 2
- Manejo avanzado de colecciones con Stream 3
- Código fuente

Sección 5: La clase Optional
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a la clase Optional
- Optional orElse vs. orElseGet vs. orElseThrow
- Optional: map vs flatmap
- Optional: filter y tarea
- Uso de Optional con: colecciones y streams 1
- Uso de Optional con: colecciones y streams 2
- Proyecto final: Definiendo la estructura
- Proyecto final: El repositorio
- Proyecto final: finalizando repositorio & inicio servicio
- Proyecto final: El servicio y la clase Validates
- Proyecto final: El controlador
- Proyecto final: validando el servicio
- Proyecto final: La vista parte 1
- Proyecto final: La vista - agregando el producto
- Proyecto final: La vista - mostrar, buscar y eliminar
- Proyecto final: La vista - actualizando el producto
- Proyecto final: probando la aplicación
- Código fuente

Sección 6: Hilos y concurrencia
- Introducción a la sección
- Temas puntuales de la sección
- La clase Thread
- La interfaz Runnable
- ExecutorService VS Thread
- 3 tipos de ExecutorService
- Concurrencia VS Paralelismo
- ExecutorService: shutdownNow()
- ExecutorService: awaitTermination()
- Callable & Future
- Tareas programadas: ScheduledExecutorService
- Tareas programadas: ScheduledExecutorService 2
- Proyecto final: la estructura
- Proyecto final: el modelo
- Proyecto final: la utilidad - LogParser
- Proyecto final: el servicio - LogService
- Lecture 88: Proyecto final: la tarea - LogProcessorTask
- Proyecto final: el main()
- Código fuente

Sección 7: Programación Reactiva
- Introducción a la sección
- Temas puntuales de la sección
- Parallel Stream Vs Stream
- Introducción a la programación reactiva
- RxJava: Observable & PublishSubject
- Sensor de temperaturas: con Observable
- Observable: create()
- Observable: fromIterable()
- RxJava: la relación Observer y Observable
- Combinando flujos con: merge, concat y zip
- filter, distinct, take y takeWhile
- Observables: flat VS flatMap
- RxJava: Scheduler
- Inicio del proyecto: Subject & PublishSubject
- Flujo Student MVC RxJava
- Tareas: StudentService
- Integrando el servicio y probando el proyecto
- Lecture 108: RxJava: Operadores Tarea - filter y map
- RxJava: operador flatMap
- RxJava: flujo de errores
- Código fuente

Sección 8: Introducción a SQL
- Introducción a la sección
- Temas puntuales de la sección
- neon.tech + Postgres con: TablePlus
- SQL: SELECT - parte 1
- SQL: funciones de agregación
- SQL: Insert, Update, Delete + Returning
- SQL: Data Definition Language
- SQL: Procedimientos y funciones almacenadas
- SQL: índices en base de datos
- SQL: Inner Join, Left Join & Right Join
- Transacciones desde SQL

Sección 9: Persistencia en base de datos con JDBC
- Introducción a la sección
- Temas puntuales de la sección
- DriverManager & Connection
- SQL desde Java: Select & Insert Into
- Problemas con: SQL Injection
- SQL desde Java: Update & Delete
- El patrón: La conexión Singleton
- Pool de conexiones: configuración HikariCP
- Pool de conexiones: HikariCP + logback
- La tabla categories y su relación con products
- Relaciones entre tablas: ProductDAO & CategoryDAO
- JDBC: Transacciones parte 1
- JDBC: Transacciones parte 2
- CRUD con transacciones: el ProductService
- Tareas- probando nuestro servicio
- JDBC: Funciones y procedimientos almacenados
- Código fuente

Sección 10: Integración: JDBC, DAO y Transacciones en una App MVC
- Introducción a la sección
- Temas puntuales de la sección
- Proyecto final: El pool de conexiones
- Proyecto final: persistiendo Category
- Refactorizando el: ProductDAO parte 1
- Búsquedas con: ProductDAO
- Repositorio híbrido: DAO + caché en memoria
- Tareas en: CategoryDAO
- Guardar category & product en la BD
- Modificando el producto - parte 1
- Modificando el producto - parte 2
- Proyecto final: Transacciones parte 1
- Proyecto final: Transacciones parte 2
- Proyecto final: Transacciones parte 3
- Finalizando la integración
- Código fuente

Sección 11: Patrones de diseño y UML
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a los Patrones de diseño
- Patrón de diseño: Strategy parte 1
- Patrón de diseño: Strategy + UML parte 2
- El patrón de diseño: Singleton parte 1
- Patrón de diseño: Singleton + UML parte 2
- Patrón de diseño: Factory method parte 1
- Patrón de diseño: Factory method + UML
- Patrón de diseño: Observer parte 1
- Patrón de diseño: Observer + UML
- El patrón de diseño: Command parte 1
- Patrón de diseño: Command + UML
- Patrón de diseño: Decorador parte 1
- Patrón de diseño: Decorador + UML
- Patrón de diseño: Builder parte 1
- Patrón de diseño: Builder + UML
- Código fuente

Sección 12: Manejo de Fechas - API java.time
- Introducción de la sección
- Temas puntuales de la sección
- API java.time VS Date & Calendar
- API java.time VS Date & Calendar parte 2
- Formateo y parsing con: java.time.format
- Operaciones con: fecha & hora
- Gestión Json con Jackson y java.time
- Persistencia de fechas con JDBC parte 1
- Persistencia de fechas con JDBC parte 2
- Fecha en español: Locale
- LocalTime: operaciones y formato
- LocalDateTime: operaciones y formato
- Zonas Horarias: ZoneId & ZonedDateTime
- Tarea: Programador de vuelos
- Código fuente

Sección 13: Introducción a Spring boot
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué usar algo como Spring boot?
- Spring boot: creando el proyecto
- Spring boot: La estructura del proyecto
- Spring boot: La primer ruta
- Spring boot: Model - Service - HTML
- Spring boot: El servicio
- Thymeleaf: del controller al HTML
- Thymeleaf: Datos personales
- Thymeleaf: Educación - el for
- Thymeleaf: Tarea - Finalizando el form
- Comunicación entre rutas: LandingController
- Thymeleaf: index.html
- Finalizando el proyecto
- Etapa de producción: Dockerfile
- Desplegando mi aplicación en Render
- Código fuente

Sección 14: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida: fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (68, 'javascript-moderno', 'JavaScript Moderno - Fernando Herrera', 'https://cursos.devtalles.com/courses/javascript-moderno', 'https://import.cdn.thinkific.com/643563/rfX8tJ4ZRHi6L4WFj2sW_JAVASCRIPT.jpg', 'Portada del curso: JavaScript Moderno - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Al completar el curso, tendrás la base sólida de JavaScript que necesitas y su comprensión total, mediante ejercicios prácticos y explicaciones que pondrán aprueba incluso a las personas que conocen bien el lenguaje.', 1710, 'es', '{"Fundamentos: Variables, tipos de datos, objetos, operadores, ciclos y funciones.","JavaScript moderno: ESNext, clases, propiedades privadas, promesas y funciones generadoras.","Desarrollo práctico: Manipulación del DOM, Fetch API, CRUD, carga de archivos y Vite.","Herramientas: Node.js, NPM, documentación con JSDoc y buenas prácticas.","Fundamentos de JavaScript: Tipos de datos, objetos, operadores, ciclos y estructuras de control.","ESNext: Clases, propiedades privadas, promesas, callbacks y funciones generadoras.","Desarrollo Web: Manipulación del DOM, Fetch API, CRUD y carga de archivos.","Herramientas modernas: Node.js, NPM, Vite, JSDoc y VS Code.","Y mucho más...","Dominarás JavaScript moderno y sus características más importantes.","Podrás desarrollar aplicaciones utilizando JavaScript puro sin depender de frameworks.","Obtendrás una base sólida para aprender React, Angular, Vue, Node.js y cualquier tecnología basada en JavaScript.","Estarás preparado para afrontar proyectos reales y continuar creciendo como desarrollador profesional."}', 'https://cursos.devtalles.com/courses/javascript-moderno', '2026-09-24 15:49:29.94579+00', '{"Pueden seguir el curso en Windows, OSX, Linux","Tener derechos de administrador para instalaciones","Saber sobre programación básica ayudará mucho"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo realizar preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a JavaScript y la consola
- Introducción a la sección
- Temas puntuales de la sección
- JavaScript y su historia
- Usos de JavaScript
- Hola Mundo
- Introducción a variables y comentarios
- Introducción a la consola
- Depuración y breakpoints
- Orden y lugar de las importaciones
- Principal problema con la inicialización de variables con Var
- Prompt, confirm y alert
- Código fuente de la sección

Sección 3: Fundamentos de JavaScript, primitivos, arreglos, objetos y funciones básicas
- Introducción a la sección
- Temas puntuales de la sección
- Tipos de datos primitivos
- Introducción general a los tipos primitivos
- Palabras reservadas y nombre de variables
- Arreglos
- Más detalles sobre los arreglos
- Objetos literales
- Más detalles sobre los objetos literales
- Funciones básicas y de flecha
- Retorno de las funciones
- Pro tip: Funciones, argumentos y desestructuración de objetos
- Código fuente de la sección

Sección 4: Ciclos y estructuras de control
- Introducción a la sección
- Temas puntuales de la sección
- Valor, referencia y romper la referencia
- If y Else
- Laboratorio - Alternativa al if else
- Lógica booleana
- Pro tip: Asignaciones con operadores
- Operador condicional ternario
- Pro tip: Otros usos del operador ternario
- Switch
- While y Do While
- For - For in - For of
- Código fuente de la sección

Sección 5: Laboratorio 1 - Blackjack
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección - Blackjack
- Inicio de proyecto - Blackjack
- Nota de actualización
- Estilo y estructura de nuestro juego
- Crear baraja de cartas
- Pedir carta
- Valor de cada carta
- Introducción al DOM y su manipulación
- Manipulación del DOM - Segunda parte
- Evento click - Pedir carta
- Crear cartas en el HTML
- Turno de la computadora
- Nuevo juego y mensaje de victoria
- Código fuente de la sección

Sección 6: Patrón módulo y optimizaciones
- Introducción a la sección
- Temas puntuales de la sección
- Problemática del código de Blackjack
- Patrón módulo
- Optimizaciones - Primera parte
- Optimizaciones - Segunda parte
- Optimizaciones - Tercera parte
- Detalle pendiente sobre los puntos del jugador
- Código fuente del juego de Blackjack
- Code Minify

Sección 7: Clases en JavaScript y ESNext private properties
- Introducción a la sección
- Temas puntuales de la sección
- Problemática y necesidad de clases
- Clases básicas en JavaScript
- Métodos en las clases
- Sets y Gets
- Propiedades, gets y métodos estáticos
- Extends - Clases con SubClases
- Propiedades privadas
- Singleton en JavaScript
- Protip: Multiples constructores
- Código fuente de la sección

Sección 8: Módulos y Vite
- Introducción a la sección
- Temas puntuales de la sección
- Introducción - Bundlers y Herramientas
- Inicio de proyecto - Vite - Node
- Ejecutar y explicar el proyecto
- Build y Despliegue en la nube
- Trabajar con Vite - Blackjack
- Desplegar Blackjack
- Refactorización de código
- Crear Deck - Módulos por defecto e individuales
- Mejorar la documentación JSDoc Comments
- Tarea - Refactorizar pedirCarta
- Archivos de Barril
- Refactorizar - Turno de la computadora
- Refactorizar - Crear Carta
- Código fuente de la sección

Sección 9: Git - Github y GitHub Pages
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- ¿Por qué debo de saber Git?
- Configurar Git en nuestro equipo
- Realizar nuevos cambios
- Desplegar en GitHub Pages
- 12 Comandos útiles que debes de saber

Sección 10: Laboratorio - Vite Lista de tareas
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - TodoApp
- Construir el HTML de nuestra aplicación
- Store - Concepto y ejecución
- UUID - Identificador único
- Métodos que ocuparemos del Store
- Implementar métodos del store
- toggleTodo - Cambiar estado
- Renderizar listado de Todos
- Validaciones y optimizaciones
- Crear un nuevo todo
- Toggle Todos
- Eliminar un Todo
- LocalStorage
- Borrar todos los TODOs completados
- Cambiar filtro - Visualmente
- Mostrar la cantidad de TODOs pendientes
- Desplegar en Netlify
- Código fuente de la sección

Sección 11: Callbacks, promesas y generadores
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Conceptos Avanzados
- Variables de entorno
- Componente rápido para futuros ejercicios
- Callbacks
- Manejo de errores en los Callbacks
- Callback Hell
- Promesas
- Utilizar una promesa
- Promise Hell
- Promise - All
- Promise Race
- Async
- Manejo de errores en funciones asíncronas
- Async - Await
- Errores en Async-Await
- Optimizar promesas no secuenciales
- for await y if await
- Funciones generadoras
- Ejemplo de función generadora
- Funciones generadoras asíncronas
- Código fuente de la sección

Sección 12: Peticiones HTTP
- Introducción
- Temas puntuales
- Inicio de proyecto - Http App
- PokemonApp - Componente principal
- Postman - Petición http
- FetchAPI - Petición http get
- Simplificar código de la petición
- Mostrar información en pantalla
- Listeners de botones
- Caché - Mejorar experiencia de usuarios
- Código fuente

Sección 13: CRUD - App - No Frameworks
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de nuestro backend
- Store central de nuestra información
- Cargar usuarios
- User Model y problemas relacionados
- Mappers
- Actualizar nuestro Store
- Crear una tabla HTML con los usuarios
- Botones - Next, Prev y página actual
- Funcionalidad de los botones
- Botón flotante
- Crear modal manualmente
- Comportamiento esperado del modal
- Tomar la data del formulario
- Caso de uso - Crear usuario
- Crear usuario
- Mapper - userModelToLocalhost
- Cargar información del usuario al modal
- Actualizar un usuario
- Eliminar un usuario
- Resumen de la sección
- Código fuente de la sección

Sección 14: ES Next
- Introducción a la sección
- Inicio de proyecto - EsNext
- structuredClone
- Array With
- Métodos "to"
- Código fuente de la sección

Sección 15: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso

Archivado - Sección 9: Despliegue a Github y Github pages
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué debo de saber Git?
- Configuración de Git en nuestro equipo
- Desplegar el proyecto a Github
- Github Pages

Archivado - Sección 10: Laboratorio 2: Aplicación de lista de tareas
- Introducción a la sección
- Temas puntuales de la sección
- TODO: Demostración del programa que haremos al final de la sección
- Inicio de proyecto - Todo
- Todo Class
- TodoList Class
- Construir las tareas en el HTML
- Evento para agregar un Todo
- Marcar como completado un Todo
- Eliminar un Todo
- Eliminar Todos completados
- LocalStorage y SessionStorage
- Guardando y recuperando Todos
- Reconstruyendo instancias de Todos
- Aplicar filtros
- Todos en la GitHub Pages
- Código fuente de la sección

Archivado - Sección 11: Callbacks y Promesas
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Callbacks y Promesas
- Callbacks
- Argumentos estándar de los callbacks
- Callback Hell
- Promesas
- Promise.all
- Promise.catch
- Promise.race
- Async
- Await
- Pro tip: Mejorar el uso del await
- Manejo de errores en el await
- for await, if await
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (3, 'laravel-ai', 'Laravel 13: AI, REST, JWT, Repository Pattern', 'https://cursos.devtalles.com/courses/laravel-ai', 'https://import.cdn.thinkific.com/643563/A9hqhmn1Qm6aYwAJAoL9_COVER-DEVTALLES%20LARAVEL.jpg', 'Portada del curso: Laravel 13: AI, REST, JWT, Repository Pattern', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a construir una API REST profesional con Laravel desarrollando una Movie API completa desde cero. Dominarás CRUD, JWT, el Repository Pattern, la caché, el versionado y mucho más, aplicando las buenas prácticas utilizadas en proyectos reales.', 810, 'es', '{"Fundamentos: Configuración del entorno, estructura del proyecto y primeros endpoints.","Desarrollo de la API: CRUD, validaciones, relaciones, autenticación y arquitectura limpia.","Buenas prácticas: Caché, versionamiento, documentación, testing y manejo de errores.","Producción: Integración con IA y despliegue completo en Railway.","Laravel: Laravel Herd, PHP 8.4, PostgreSQL y Docker.","APIs REST: Rutas, controladores, respuestas JSON, CRUD y API Resources.","Arquitectura: Repository Pattern, Form Requests y relaciones entre modelos.","Seguridad: JWT, autorización por roles, middleware y configuración de CORS.","Optimización: Caché con invalidación automática, filtros, búsquedas, ordenamiento y paginación.","Producción: Versionamiento de APIs, subida de imágenes, logging y manejo consistente de errores.","Documentación: OpenAPI 3.1 utilizando Scramble.","Inteligencia Artificial: Integración con Claude de Anthropic para generar sinopsis y recomendaciones.","Despliegue: Railway, PostgreSQL administrado y checklist de buenas prácticas.","Testing: Pruebas automatizadas como parte del flujo de desarrollo.","Y mucho más...","Desarrollarás una API REST profesional utilizando Laravel y las mejores prácticas del ecosistema.","Aprenderás a estructurar proyectos escalables con una arquitectura limpia y mantenible.","Integrarás autenticación, documentación, testing e Inteligencia Artificial dentro de una misma aplicación.","Desplegarás tu API en producción y contarás con un proyecto sólido para tu portafolio profesional."}', 'https://cursos.devtalles.com/courses/laravel-ai', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de programación o lógica de programación serán útiles.","Experiencia previa en PHP; aprenderás el uso de Laravel no acerca del lenguaje PHP.","Tener instalado un editor de código, preferiblemente Visual Studio Code.","Ganas de aprender y practicar escribiendo código durante el curso."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas

Sección 2: Creación de proyecto y estructura
- Introducción
- Temas puntuales
- Laravel con entorno verificado
- Primera migración
- Registro de rutas API
- Creación de controlador
- Trait ApiResponse
- Feature test y cliente HTTP
- Código de la sección

Sección 3: Creación de género
- Introducción
- Temas puntuales
- Diagrama ERD y simulación
- Migración para géneros
- Modelo Genre
- Seeder y traducciones
- GenreResource y rutas apiResource
- Listar y obtener género
- StoreGenreRequest y UpdateGenreRequest
- Crear, actualizar y borrar
- Pruebas CRUD Género
- Pruebas CRUD Género - Parte 2
- Código de la sección

Sección 4: Patrón repositorio y pruebas
- Introducción
- Temas puntuales
- Introducción a patrón repositorio
- Contratos patrón repositorio
- Implementación Eloquent BaseRepository
- Registrar e inyectar
- Fabrica género GenreFactory
- Pruebas para listar y obtener género
- Pruebas para crear, actualizar y borrar género
- Géneros api-requests
- Código de la sección

Sección 5: API género: búsqueda, filtrado y restauración
- Introducción
- Temas puntuales
- Demostración de filtros
- Filtros y ordenamiento
- Filtros y ordenamiento - parte 2
- Búsqueda por slug
- Restaurar un género eliminado
- Pruebas para filtros
- Pruebas para ordenamiento
- Pruebas para slug y restore
- Actualización géneros api-requests
- Código de la sección

Sección 6: API Película
- Introducción
- Temas puntuales
- Migraciones películas y tabla pivote
- Modelo película
- Datos semilla de películas
- Repositorio películas MovieRepository
- Repositorio películas MovieRepository - Parte 2
- Listar películas y recurso
- Pruebas de filtros y ordenamiento
- StoreMovieRequest y UpdateMovieRequest
- StoreMovieRequest y UpdateMovieRequest - Parte 2
- Completando métodos controlador películas
- Pruebas CRUD películas
- Fabrica película y pruebas
- Fabrica película y pruebas - Parte 2
- Pruebas de películas con géneros
- Actualización películas api-requests
- Código de la sección

Sección 7: API usuario, autenticación y JWT
- Introducción
- Temas puntuales
- Qué es JWT e instalación de jwt-auth
- Guard api con driver jwt
- User implementa JWTSubject
- Validar usuario y recurso
- Método para registro y respuesta con JWT
- Inicio de sesión y datos de usuario autenticado
- Cerrar sesión y refrescar token
- Rutas públicas y protegidas
- Pruebas de registro
- Pruebas de login, me y logout
- Actualización autenticación api-requests (gist)
- Código de la sección

Sección 8: CORS
- Introducción
- Temas puntuales
- ¿Qué es CORS?
- Configuración de CORS
- Probando CORS
- Probando CORS - Parte 2
- Código de la sección

Sección 9: Autorización y protección de rutas
- Introducción
- Temas puntuales
- Migración de roles
- Datos semilla de usuarios con roles
- Métodos de ayuda y recurso con rol
- Middleware CheckRole
- Permisos por rol MoviePolicy
- Rutas reorganizadas por rol
- Pruebas con roles
- Actualizando pruebas con actingAs
- Actualizando pruebas con actingAs - Parte 2
- Código de la sección

Sección 10: Caché
- Introducción
- Temas puntuales
- ¿Por qué cachear?
- Caché en géneros
- Caché en películas
- Caché con formato JSON
- Solucionar relaciones de películas con géneros
- Observers invalidación del caché
- Pruebas con caché
- Código de la sección

Sección 11: Versionamiento de la API
- Introducción
- Temas puntuales
- Por qué versionar la API
- Controladores a Api/V1 nuevo namespace
- Rutas con prefijo v1 y grupo v2
- Cambios a tests y api-requests.http
- Nuevo contrato películas V2
- Pruebas películas V2 y api-requests.http
- Limpieza de controladores sin versión
- Código de la sección

Sección 12: Subida de imágenes
- Introducción
- Temas puntuales
- Discos de almacenamiento y symlink (diagrama)
- Validar la imagen
- Controlador de poster y la ruta
- Prueba para poster
- Prueba automatizada para poster
- Código de la sección

Sección 13: Paginación y manejo de excepciones
- Introducción
- Temas puntuales
- Paginación concepto e interfaz
- Paginar películas desde el repositorio
- Paginar películas en el controlador
- Pruebas de paginación
- Manejador de excepciones
- Código de la sección

Sección 14: IA en Laravel
- Introducción
- Temas puntuales
- Instalación y configuración
- Servicio de comunicación con Claude
- Parseo defensivo de la respuesta
- Recomendaciones de películas
- Validar los géneros al obtener recomendaciones
- Controlador y rutas
- Pruebas manuales sinopsis y recomendaciones
- Pruebas para sinopsis
- Pruebas para recomendaciones
- Incluir título en la respuesta de sinopsis
- Actualizar requests.http
- Código de la sección

Sección 15: Despliegue en Railway
- Introducción
- Temas puntuales
- Crear el proyecto y la base de datos
- Crear el proyecto y la base de datos - Parte 2
- Variables de entorno
- Construcción y lanzamiento
- Verificación post-despliegue
- Código de la sección

Sección 16: Fin de curso
- Más información sobre nuestros otros cursos
- Fin de curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (25, 'n8n-mcp', 'n8n + MCP: Automatización y agentes de IA inteligentes', 'https://cursos.devtalles.com/courses/n8n-mcp', 'https://import.cdn.thinkific.com/643563/V4CDk5iUSKCh2Xw4MfX2_COVER-DEVTALLES-n8n-2.jpg', 'Portada del curso: n8n + MCP: Automatización y agentes de IA inteligentes', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a crear automatizaciones poderosas con n8n: desde flujos simples con Google Sheets y correos, hasta proyectos avanzados con lógica, manejo de errores y agentes de IA usando MCPs, tanto localmente como en la nube.', 1050, 'es', '{}', 'https://cursos.devtalles.com/courses/n8n-mcp', '2026-09-24 15:49:29.94579+00', '{"No se necesita experiencia previa en automatización o IA, el curso comienza desde lo básico y avanza paso a paso.","Conocimientos básicos de informática y manejo de aplicaciones en la web son recomendables, pero no obligatorios.","Contar con un ordenador e internet estable para instalar n8n localmente o trabajar en su versión web."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos e instalación de n8n
- Introducción
- Temas puntuales
- ¿Qué es n8n?
- n8n en la web
- Usuario Técnico - n8n en localmente
- Usuario Técnico - n8n con Docker
- Recomendación para seguir el curso

Sección 3: Introducción a n8n - Mi primer flujo de trabajo
- Introducción
- Demostración
- Temas puntuales
- Generalidades de la interfaz de usuario
- Interfaz de flujos de trabajo
- Nodo: Google Sheets - Hojas de cálculo
- Nodo: Http Request - Petición HTTP
- Nodo: Edit Fields - Editar, agregar y transformar
- Actualizar Google Sheets
- Nodo: Filter - Filtrar información
- Gmail Node: Enviar un correo electrónico
- Nodo: Aggregate - Unir elementos
- Archivo JSON con el ejercicio final
- Repaso interactivo: Introducción a n8n - Mi primer flujo de trabajo

Sección 4: Opcional (Usuario técnico) - Google Cloud - Cargar Flujos
- Introducción
- Temas puntuales
- Demostración
- Descargar y cargar archivos .json
- Google Cloud - Crear proyecto y configuraciones
- Google Cloud - Pantalla de consentimiento
- Google Cloud - Scopes para Google Sheets y Google Drive
- Google Cloud - Scopes para Gmail
- Repaso interactivo: Google Cloud - Cargar Flujos

Sección 5: Formularios y decisiones
- Introducción
- Demostración
- Temas puntuales
- Google Forms - Formularios y respuestas
- Filtrar y agregar solicitudes
- Code Node: Nodo de código
- Reducir inventario vía código
- Google Sheets - Actualizar respuestas
- Tarea - Reducir inventario en Google Sheets
- Merge Node: Unir flujos
- Disparar proceso cuando hay una nueva respuesta
- Archivo JSON con el ejercicio final
- Repaso interactivo: Formularios y decisiones

Sección 6: Opcional (Usuario técnico) - PostgreSQL y ciclos (Loops)
- Introducción
- Demostración
- Temas puntuales
- Ejecución local y problemas con el flujo anterior
- Aprovisionar PostgreSQL en la nube
- Crear tabla y registros de inventario
- Loop over items Node: Ciclo sobre elementos
- Nodo IF: Nodo para desiciones
- Nodo Edit: Editar valores en el flujo
- Tarea: Terminar flujo
- Archivo JSON con el ejercicio final
- Repaso interactivo: PostgreSQL y ciclos (Loops)

Sección 7: Solicitud de vacaciones y días de enfermedad
- Introducción
- Demostración
- Temas puntuales
- Form trigger node: Formularios como nodo de inicio
- Estilos personalizados de formularios
- Protección contra cambios de nombres de variables
- Calcular días entre fechas
- Nota de actualización
- Validaciones: 7 días hábiles
- Validaciones: Verificar fecha de inicio y fin
- Obtener cantidad de días disponibles
- Validaciones: Empleado tiene suficientes vacaciones
- Nodo Discord: Enviar un mensaje automático
- Nodo Wait: Esperar la intervención de RRHH
- Solicitud rechazada por RRHH
- Google Calendar Node: Calendario de Google
- Restar días de vacaciones en base de datos
- Tarea: Días de enfermedad
- Archivo JSON con el ejercicio final
- Repaso interactivo: Solicitud de vacaciones y días de enfermedad

Sección 8: Opcional (Usuario técnico) - WebHooks
- Introducción
- Demostración
- Temas puntuales
- Continuación de proyecto
- Google Calendar - Configuraciones en Google Cloud
- WebHook trigger node: Nodo de inicio
- Añadir autenticación
- Validar valores de entrada al WebHook
- Controlar respuesta de un WebHook
- Esperar respuesta de un WebHook - RRHH
- Ajustes adicionales
- Archivo JSON con el ejercicio final
- Repaso interactivo: WebHooks

Sección 9: Extraer información de sitios web - Scraping
- Introducción
- Demostración
- Temas puntuales
- Inicio del flujo - Scraping de sitio web
- Obtener información del sitio web
- OpenAI Node: Nodo de OpenAI y créditos
- OpenAI: Crear api keys
- Actualizar Google Sheets con la información
- Firecrawl: Nodo y API
- Google Docs Node: Crear y actualizar documentos
- Finalizar flujo
- Archivo JSON con el ejercicio final
- Repaso interactivo: Extraer información de sitios web - Scraping

Sección 10: Workflows - Scraping - Google Maps e información de contacto
- Introducción
- Demostración
- Temas puntuales
- Flujos comunitarios - Community Workflows
- Credenciales y accesos necesarios
- Credenciales de Firecrawl
- Archivo JSON con el ejercicio final
- Repaso interactivo: Workflows - Scraping - Google Maps e información de contacto

Sección 11: Introducción a los agentes de AI, Chatbots y modelos locales
- Introducción
- Demostración
- Temas puntuales
- Nuevo flujo - Agente de Wikipedia
- Gemini Model - Modelos de Google Gemini
- Uso y estilos de chat - Forma básica
- Usar chatbot dentro de un sitio web
- Usuario técnico - Instalar Ollama y descargar modelos locales
- Usuario técnico - Ollama desde Docker
- Archivo JSON y HTML con el ejercicio final
- Repaso interactivo: Introducción a los agentes de AI, Chatbots y modelos locales

Sección 12: Agentes con herramientas - Tools y MCP Servers
- Introducción
- Demostración
- Temas puntuales
- Inicio de flujo - Asistente personal
- Gmail Tools - Herramientas de correo
- Tarea - Obtener correos
- Google Calendar Tool - Herramientas de calendario
- Herramientas personalizadas - Custom Tools
- MCP Server - Model Context Protocol
- MCP Server - Google Calendar - Tarea
- Usuario técnico - Claude Desktop - MCP Conexión
- Seguridad y configuraciones adicionales
- Archivo JSON con los ejercicios finales
- Repaso interactivo: Agentes con herramientas - Tools y MCP Servers

Sección 13: Usuario Técnico - Agentes de AI contra backends personalizados
- Introducción
- Demostración
- Temas puntuales
- Inicio de proyecto y flujo - Agente de soporte
- Opcional - NgRok
- Instrucciones y herramientas para nuestro agente
- Creación de las herramientas
- Pruebas y ajuste de instrucciones
- Archivo JSON con las configuraciones
- Repaso interactivo: Usuario Técnico - Agentes de AI contra backends personalizados

Sección 14: Tipos de autenticación en n8n
- Introducción
- Demostración
- Temas puntuales
- Inicio de flujo - Autenticaciones de n8n
- Basic Auth - Autenticación básica
- Header Auth
- JWT - Json Web Tokens
- Extraer Payload del JWT
- Archivo JSON con las configuraciones
- Repaso interactivo: Tipos de autenticación en n8n

Sección 15: Sistemas RAG - Consultas a bases de conocimiento
- Introducción
- Demostración
- Temas puntuales
- Inicio de flujo - Sistema RAG
- Cargar y crear base de datos
- Consumo y consultas al vector store
- PostgreSQL en nuestro sistema RAG
- Google Drive - Cargar documentos
- Google Drive - Recursivo
- Problema con el proceso actual
- Proceso de carga completo
- Proceso de carga completo - Parte 2
- Pruebas y consultas a la base de datos
- Archivos JSON con las configuraciones
- Repaso interactivo: Sistemas RAG - Consultas a bases de conocimiento

Sección 16: Agentes de voz con herramientas
- Introducción
- Demostración
- Temas puntuales
- Inicio de proyecto - Asistente de voz
- Configuraciones iniciales del agente
- Importante - Antes de continuar la sección - NGROK
- NGROK - n8n localmente
- Tool: Obtener productos populares
- Conectar herramienta con agente de voz
- Tool: Obtener información de una orden
- Probar herramienta desde el asistente de voz
- Poner en producción el agente
- Archivos JSON con las configuraciones
- Repaso interactivo: Agentes de voz con herramientas

Sección 17: Telegram Bots
- Introducción
- Demostración
- Temas puntuales
- Inicio de proyecto - Telegram Bot
- Usuario técnico - Correr localmente desde Docker
- Recibir mensajes de Telegram
- Enviar stickers
- Enviar mensajes de texto
- Responder con mensaje en lugar de herramienta
- Analizar imágenes
- Responder a imágenes
- Procesar audio
- Audio de Eleven Labs
- Archivos JSON con las configuraciones
- Repaso interactivo: Telegram Bots

Sección 18: Whatsapp Bots
- Introducción
- Demostración
- Temas puntuales
- Inicio de proyecto - Whatsapp Bot
- Usuario técnico - Levantar ambiente local en la web
- Configuraciones de Meta para Whatsapp
- Enviar mensaje de texto por Whatsapp
- Configurar agente de AI y enviar respuestas de texto
- Enviar mensajes con imágenes
- Verificar MimeTypes de documentos
- Procesar audios de Whatsapp
- Archivos JSON con las configuraciones
- Repaso interactivo: Whatsapp Bots

Sección 19: Despliegues alternativos y consideraciones
- Introducción
- Temas puntuales
- Desplegar en Render - Consideraciones
- Desplegar en Railway

Sección 20: Manejo de errores y logs
- Introducción
- Temas puntuales
- Inicio de proyecto - Flujo principal
- Aprovisionar tabla y base de datos
- Logger - Subworkflow
- Ejecutar SubWorkflow desde flujo principal
- Utilizar tabla de logs
- Archivos JSON con las configuraciones
- Repaso interactivo: Manejo de errores y logs

Sección 21: Despedida
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (127, 'react-native', 'React Native: Apps para iOS y Android - Nueva edición', 'https://cursos.devtalles.com/courses/react-native', 'https://import.cdn.thinkific.com/643563/wDbe4t7NS5ajImOOreHx_COVER-DEVTALLES-cli-legacy.jpg', 'Portada del curso: React Native: Apps para iOS y Android - Nueva edición', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Curso completo de React Native CLI que te dará las bases sólidas sobre este framework, con más de 42 horas de contenido en video y despliegues en la Google PlayStore y Apple AppStore incluído en el curso.', 2520, 'es', '{}', 'https://cursos.devtalles.com/courses/react-native', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Importante: Antes de empezar con React Native CLI
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo realizar preguntas?
- Instalaciones necesarias y recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Reforzamiento de las bases - Conocimiento requerido para continuar
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué TypeScript?
- Inicio de proyecto - Introducción React con TypeScript
- Preparar proyecto
- Tipos Básicos - TypeScript
- Objetos literales e interfaces
- Funciones, retorno y argumentos
- Hook - useState
- Custom Hook - useCounter
- Zustand - Gestor de estado
- Login y Logout
- Peticiones HTTP - Axios
- Establecer el tipo - Respuestas HTTP
- Mostrar usuarios en pantalla
- Paginación de resultados
- Custom Hook - useUsers
- Formularios
- Envío y valores del formulario
- Código fuente de la sección

Sección 3: Instalación y configuración de ReactNative con emuladores y dispositivos físicos
- Introducción a la sección
- Temas puntuales de la sección
- Diferencia entre EXPO CLI y ReactNative CLI
- Windows: Instalaciones necesarias
- Windows: Crear un dispositivo virtual
- Windows: Dispositivo físico
- Mac OSX: Instalaciones necesarias - Android
- Mac OSX: Android Studio
- Mac OSX: Emulador de Android
- Mac OSX: Instalaciones para IOS
- Mac OSX: Simulador de IOS
- Mac OSX: Android Físico USB Debugging
- Mac OSX: Correr en un iPhone físico
- Correr dos simuladores simultáneamente

Sección 4: Mi primera App en React Native - CounterApp
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - MyFirstApp
- Hola Mundo
- Explicación de archivos y directorios
- Crear pantallas independientes
- Propiedades de un componente
- Crear un contador
- Personalización Pressable
- Componente personalizado PrimaryButton
- Tip: ¿Cómo ver los ejemplos de la documentación?
- Componentes estilizados
- React Native Paper - Instalación
- Floating Action Button - FAB
- Iconos en React Native - Android
- Iconos en React Native - IOS
- Configurar iconos globales
- Resumen de lo aprendido hasta el momento
- Código fuente de la sección

Sección 5: Flex, Position y Box Object Model
- Introducción a la sección
- Temas puntuales de la sección
- Box Object Model - Fundamentos del diseño
- Continuación de proyecto - Diseños y Flexbox
- Padding, Margin, Border, Width y Height
- Height, Width porcentual y dimensiones de la pantalla
- Position - Fundamentos del diseño
- Posición relativa
- Posición absoluta
- Flexbox - Fundamentos del diseño en React Native
- Flex
- Flex Direction
- Align Items
- Align Self
- Flex Wrap
- Preparación para la tarea
- Tarea sobre diseños
- Resolución de la tarea de diseños
- Código fuente de la sección

Sección 6: Aplicación - Calculadora de IOS
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - Calculadora
- Estructura inicial
- Diseño de pantalla y estilos globales
- Botones y estilos
- Botón de calculadora
- Completar botón de la calculadora
- Construir el número base
- Tarea - Botón de borrar última entrada
- Solución a la tarea
- Botones de operaciones aritméticas
- Realizar el cálculo
- Extra - Calculadora de Pixel
- Mostrar el resultado mientras escribe
- Código fuente de la sección

Sección 7: NavegaciónApp - Todos los tipos de navegación
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - NavigationApp
- Explicación sobre el sistema de navegación
- Archivos y directorios del proyecto
- React Navigation - Pre-requisitos
- React Navigation - Stack
- Navegar a otras pantallas
- Estilizando el Stack Navigator
- FlatList - Pantalla de productos
- Enviar argumentos entre pantallas
- Stack - PopToTop
- React Navigation - Drawer
- Configurar Drawer básico
- Toggle Drawer - Mostar / Ocultar
- Drawer personalizado
- useSafeAreaInserts
- Código fuente de la sección

Sección 8: Tabs, MaterialTabs y Material Top Scrollable Tabs
- Introducción a la sección
- Temas puntuales de la sección
- Demostración objetivo de la sección
- Continuación de proyecto
- Explicación sobre el Bottom Tab Navigator
- Crear el BottomTabNavigator
- Personalizando el BottomTabNavigator
- Menú de hamburguesa
- Material Top Tab Navigator
- Iconos - Instalaciones
- Instalación de íconos en IOS
- Colocando íconos
- Código fuente de la sección

Sección 9: Compartir estado global - Zustand
- Introducción a la sección
- Temas puntuales de la sección
- Introducción - Gestor de estado
- Inicio de proyecto - Context App
- Preparación de la aplicación y tarea
- Resolución de la tarea
- Zustand - Gestor de Estado
- Cambios en el Store
- Tarea - CounterStore
- Solución de la tarea
- Código fuente de la sección

Sección 10: Aplicación de Películas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo al final de la sección
- Inicio de proyecto - MoviesApp
- Configuración de pantallas y directorios
- Navegación entre pantallas
- Obtener películas - TheMovieDB
- Patrón adaptador - HttpAdapter
- Caso de uso - Now Playing
- CustomHook - useMovies
- Patrón Mapper - MovieMapper
- Tarea - Casos de uso restantes
- Resolución de la tarea
- Explicación adicional y resumen
- Código fuente de la sección

Sección 11: Aplicación de películas - Segunda Parte
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Carrusel de posters
- Terminar carrusel y navegación
- Carrusel de películas con FlatList
- Infinite Scroll - Horizontal
- Infinite Scroll - Parte 2
- Información de la película por ID
- Get Movie - Caso de uso
- Pantalla de detalles - Header
- Detalles de la película
- Estructuras de datos para los actores
- Mostrar actores en pantalla
- Variables de entorno en React Native
- FullScreen Loader
- Código fuente de la sección

Sección 12: Componentes de ReactNative
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - ComponentsApp
- Preparación y estructura de proyecto
- Crear Stack e instalar iconos
- Solución de la tarea - Navigator
- Solución de la tarea - iconos
- Menú principal y estilos
- Opciones del menú
- Animated API
- Easing - Bounce
- Custom Hook - useAnimation
- Animated ValueXY
- Componentes personalizados
- Componente - Switch
- Componente - Separador
- Componente - Alert
- Componente - Alert Prompt
- Prompt IOS y Android
- Componente - TextInput
- Scroll y Teclado
- Pull to refresh
- Componente - SectionList
- Componente - Modal
- InfiniteScroll
- InfiniteScroll con imágenes
- Animated Image
- Cierre de sección
- Código fuente de la sección

Sección 13: Temas y Slideshow de pantalla completa
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - ComponentsApp
- Carousel - Slideshow introductorio
- Paginación de Slides
- Theme Light y Dark - Generalidades
- ThemeContext
- Cambiar entre Light y Dark
- Resolución de la tarea
- React Navigation Theme
- Tema basado en el Sistema Operativo
- Estado de la aplicación - AppState
- Simplificar los componentes del tema
- Código fuente de la sección

Sección 14: Pokedex
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - Pokédex
- Stack Navigator
- Estructura de directorio a usar
- React Native Paper
- Tema light y dark automático
- Interfaces, entidades y petición http
- TanStack Query - Peticiones y caché
- Interfaces de PokeAPI
- Mapeo de PokeApi a Entidad
- Diseño del HomeScreen
- Diseño del HomeScreen Parte 2
- FadeIn Image y useAnimation
- Detectar el color predominante
- Pokémons InfiniteScroll
- Navegar a la pantalla de detalle
- Pantalla del Pokemon y Formato
- Actualizar caché de antemano
- Información adicional del Pokemon
- Código fuente de la sección

Sección 15: Debouncer y Búsquedas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - Pokédex
- SearchComponent - Diseño
- Pre-cargar la información para buscar por nombre
- Filtrar listado por id y nombre
- Mostrar resultados en pantalla
- useDebounceValue - CustomHook
- Código fuente de la sección

Sección 16: RutasApp - Permisos - Aplicación con mapas - Google y Apple Maps
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - MapsApp
- Instalar iconos
- Rutas y StackNavigator
- Android: Configuración inicial de permisos de GPS
- IOS: Configuración inicial de permisos de GPS
- Solicitar y revisar permisos - Request Permission
- Revisar permiso de ubicación
- PermissionStore - Zustand
- Consumir nuestro Store
- Revisar el permiso de GPS al regresar a la aplicación
- Loading Screen - Pantalla de espera
- Código fuente de la sección

Sección 17: RutasApp - Aplicación con mapas - Google y Apple Maps
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - MapasApp
- Configuración de GoogleMaps
- Configurar IOS y Android
- Marcadores y componente Mapa re-utilizable
- MapView - Mostrar la ubicación del usuario
- Acciones de localización
- Store - Información de la ubicación
- FAB - Componente personalizado
- Mover la cámara a las coordenadas del usuario
- Acciones de seguimiento y limpieza
- Seguimiento de usuario - Store
- Darle seguimiento al usuario (Mover cámara constantemente)
- Detener seguimiento
- Mostrar y ocultar las polylines
- Código fuente de la sección

Sección 18: Autenticación y Productos - Backend
- Introducción a la sección
- Temas puntuales de la sección
- Descarga y configuración del backend
- Funcionamiento del backend

Sección 19: Autenticación - ProductsApp
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - ProductsApp
- Preparación de archivos y directorios
- Stack Navigator
- UI Kitten - Componentes estilizados
- Diseño del login
- Componente personalizado - MyIcon
- Pantalla de registro y navegación
- Variables de entorno
- Axios - Preparar cliente
- Acciones de autenticación
- Auth Store - Fuente central de información
- Obtener token de autenticación
- Async Storage
- Verificar estado de la autenticación
- AuthProvider
- Cerrar sesión
- Código fuente de la sección

Sección 20: Productos
- Introducción a la sección
- Temas puntuales de la sección
- Objetivo al final de la sección
- Continuación de proyecto
- Product - Interfaces y petición HTTP
- Explicación de lo sucedido
- TanStack Query
- MainLayout - Diseño y AppBar
- Listado de Productos - Parte 1
- Listado de Productos - Parte 2 - Tarjetas
- useInfiniteQuery - InfiniteScroll de productos
- Pantalla de Producto
- Diseño de la pantalla de producto
- Selectores de Género y Talla
- Formik - Formulario de producto
- Actualizar producto
- useMutation - TanStack
- Actualizar caché del query client
- Actualizar caché - PullToRefresh
- Componente FAB
- Creando un nuevo producto
- Detalles finales y optimizaciones
- Código fuente de la sección

Sección 21: Cámara, galería y carga de imágenes al backend
- Introducción a la sección
- Temas puntuales de la sección
- Objetivo al final de la sección
- Continuación de proyecto - ProductsApp
- Preparar el UI para abrir la cámara
- Abrir la cámara y tomar una fotografía
- Probar cámara en dispositivo físico
- Seleccionar de la galería de fotos
- Subir imagen a nuestro backend
- Código fuente de la sección

Sección 22: Despliegues en Google Play Store y Apple App Store
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de proyecto
- Android: Cambiar ícono y nombre
- IOS: Cambiar ícono y nombre
- Cambiar Bundle Identifiers
- Android: SplashScreen y ajustes
- IOS: SplashScreen y ajustes
- Generar Android App Bundle - AAB
- Subir AAB a la PlayStore
- Configuraciones adicionales en la Google PlayStore
- IOS: Portal de developer de Apple
- TestFlight - Probar la aplicación
- Código fuente de la sección

Sección 23: Despedida del curso
- Más información sobre nuestros otros cursos
- Información adicional sobre React Native
- Fin y cierre del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (60, 'nest-graphql', 'Nest + GraphQL: Evoluciona tus APIs - Fernando Herrera', 'https://cursos.devtalles.com/courses/nest-graphql', 'https://import.cdn.thinkific.com/643563/DYTo4ghhS2c799ZISyNu_NEST-GRAPHQL-NEW.jpg', 'Portada del curso: Nest + GraphQL: Evoluciona tus APIs - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Nest + GraphQL: Aprende a integrar ambas tecnologías para lograr crear endpoints que le permitan auto servir la información exacta que necesita el FrontEnd.', 1080, 'es', '{"Fundamentos de GraphQL: Queries, Mutations, Resolvers y diferencias frente a REST.","Desarrollo con NestJS: Code First, DTOs, validaciones y documentación automática.","Backend profesional: PostgreSQL, JWT, autorización, relaciones y paginación.","Producción: Docker, Docker Compose, DigitalOcean y GitHub.","GraphQL: Queries, Mutations, Variables, Fragments, Scalars y Object Types.","NestJS: Code First, DTOs, Resolvers, validaciones y decoradores personalizados.","Consultas avanzadas: Paginación, filtros y relaciones entre entidades.","Seguridad: JWT, autenticación y protección de rutas y campos.","Bases de datos: PostgreSQL y relaciones.","Despliegue: Docker, Docker Compose, Docker Hub y DigitalOcean.","Documentación y herramientas: Generación automática de documentación, Git y GitHub.","Y mucho más...","Serás capaz de desarrollar APIs GraphQL completas utilizando NestJS.","Comprenderás cuándo utilizar GraphQL y las ventajas que ofrece frente a una API REST tradicional.","Implementarás autenticación, autorización, relaciones, paginación y despliegues siguiendo buenas prácticas.","Podrás crear endpoints que permitan a los equipos Frontend consumir exactamente la información que necesitan."}', 'https://cursos.devtalles.com/courses/nest-graphql', '2026-09-24 15:49:29.94579+00', '{"Estar familiarizado con Nest (decoradores, clases, módulos)","No es necesario saber nada sobre GraphQL (esto es cubierto en el curso)","Conocimiento de JavaScript y TypeScript es recomendado","Este NO es un curso para aprender Nest puro, es para aprender Nest con GraphQL"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará este curso?
- ¿Cómo realizar preguntas?
- Instalaciones necesarias
- Guía de atajos para Nest y Nest con GraphQL
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Breve reforzamiento sobre Nest
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Bases de Nest
- Crear un recurso completo (CRUD)
- Seleccionar TODOS
- Crear TODO
- Actualizar un TODO
- Eliminar un TODO
- Resumen del repaso
- Código fuente de la sección

Sección 3: Nest + GraphQL - Introducción
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a GraphQL + Nest
- Creando un nuevo proyecto de Nest con GraphQL
- Instalar GraphQL en Nest
- Mi primer Resolver
- Instalar Apollo Studio en lugar del GraphQL Playground
- Generar un nuevo query
- Tarea - Generar un random entre cero y otro número
- Arguments
- Resumen de la sección
- Código fuente de la sección

Sección 4: GraphQL TODO - Continuación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Todo Resolver y Custom object types
- Services
- Regresar un Todo por ID
- Fragments
- Mutation e Inputs
- Validaciones y creación de Todo
- Actualizar un Todo
- Eliminar un Todo
- Agregar filtros
- Resolución de la tarea - Filtros
- Agregar conteos como campos adicionales
- ObjectTypes - Aggregation
- Código fuente de la sección

Sección 5: Anylist - GraphQL + Postgres
- Inicio de sección
- Temas puntuales de la sección
- Inicio de proyecto
- Instalar GraphQL y recursos
- Levantar base de datos - Docker
- Instrucciones y consideraciones adicionales
- Conectar base de datos a Nest
- Item Entity
- Crear items - Servicio y DTOs
- Insertar en base de datos
- Obtener el listado de items
- Resolución de la tarea - findOne
- Actualizar un item
- Eliminar un item
- Código fuente de la sección

Sección 6: Autenticación y autorización
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- User Entity, Resolver, Servicio y Auth
- Resolución de la tarea
- Auth Module, Resolver y Servicio
- Tipos, Inputs y ObjectTypes
- Crear usuario
- Manejo de errores en signup
- Encriptar la contraseña
- Login de usuario
- Login parte 2
- Passport Module y JWT Module
- JWT Strategy
- Generar nuestro JWT
- JwtAuthGuard
- Validar usuario del JWT
- Custom Decorator - CurrentUser
- Retornar usuario y nuevo token
- Autorización de usuarios - Roles
- Cierre de la sección
- Código fuente de la sección

Sección 7: Usuarios y enumeraciones - Admin Roles
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de enumeraciones
- Continuación de la sección
- CustomArgs ValidRoles
- GraphQL Enumerations
- Ejecutar consulta en Postgres con arreglos
- Proteger todos los queries de usuarios
- Buscar usuario findOne
- Bloquear un usuario - ManyToOne - Misma Tabla
- Tarea - Guardar usuario que actualizó el registro
- Actualizar un usuario
- Bonus - Bloquear GQLSchema Introducción
- Bonus - GraphQLModule forRootAsync
- Código fuente de la sección

Sección 8: Items + Usuarios - Peticiones autenticadas
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Relación entre items y users
- Crear items asociados al usuario
- findAll por usuario
- FindOne y RemoveItem
- Update item
- Items por usuario
- ResolveField con información del padre
- Código fuente de la sección

Sección 9: Seed Data - Cargar y purgar base de datos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Seed Resolver
- Seed - Paso 1: Protección
- Seed - Paso 2: Borrar registros anteriores
- Seed - Paso 3: Crear usuarios
- Seed - Paso 4: Crear items
- Código fuente de la sección

Sección 10: Paginaciones, paginaciones anidadas y filtros
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Paginar resultados - Args
- Aplicar la paginación
- Múltiples Args - Búsquedas por nombre
- Aplicar la búsqueda por nombre
- Simplificar la consulta
- Aplicar filtros a sub-campos
- Tarea extra
- Código fuente de la sección

Sección 11: Entidad para el manejo de listas Maestro Detalle
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Tarea - Lists Resolver completo
- Resolución de la tarea - List CRUD
- Resolución de la tarea - Parte 2
- ListItems - Detalle de las listas
- Relaciones entre ListItems
- Nota de actualización
- Insertar ListItems - Constraints
- Traer información de los items y conteos
- Filtrar por lista, paginar y conteo
- Buscar in ListItem por ID
- Actualizar un ListItem
- Actualizar usando query builder
- Lists y ListsItems - Seed Limpieza
- Lists y ListItems - Seed Inserción
- Regresar información completa tras creación
- Código fuente de la sección

Sección 12: Despliegues
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- DigitalOcean - Preparar base de datos
- Configuraciones de base de datos
- Conectar NestApp con Postgres - DigitalOcean
- Desplegar Aplicación de Node
- Finalización del despliegue
- Generalidades de imágenes de Docker
- Construir la imagen de docker
- Resolver Bcrypt y Construir de nuevo
- Construir usando postgres de DigitalOc
- Usar la imagen y regenerarla sin compose
- Subir a Docker hub
- Código fuente de la sección

Sección 13: Despedida del curso
- Más información sobre nuestros otros cursos
- Cierre del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (45, 'nestjs-microservicios', 'NestJS + Microservicios: Aplicaciones escalables y modulares', 'https://cursos.devtalles.com/courses/nestjs-microservicios', 'https://import.cdn.thinkific.com/643563/vOOZ5j1Qta2gvaiOlMqE_MICROSERVICIOS.jpg', 'Portada del curso: NestJS + Microservicios: Aplicaciones escalables y modulares', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Es momento de crear un sistema distribuido utilizando múltiples bases de datos, transportadores y técnicas para escalar de forma independiente cada microservicio.', 1260, 'es', '{"Fundamentos de arquitectura: Arquitectura monolítica vs. microservicios, ventajas, desventajas y casos de uso.","Microservicios con NestJS: Uso de los paquetes oficiales, Message Patterns, comunicación mediante mensajes y eventos.","Comunicación entre servicios: Implementación de transportadores como TCP, HTTP y NATS para conectar aplicaciones distribuidas.","Persistencia de datos: Manejo de múltiples bases de datos utilizando Prisma, relaciones, filtros y paginación.","Arquitectura: Monolitos vs. microservicios, comunicación entre servicios y Gateways.","NestJS Microservices: Paquetes oficiales, Message Patterns y manejo de excepciones.","Transportadores: TCP, HTTP y NATS.","Control de versiones: Git Submodules y Git Organizations.","Persistencia: CRUDs, múltiples bases de datos, Prisma, modelos y relaciones.","Consultas avanzadas: Filtros, paginación y estructuras maestro-detalle para órdenes y detalles de orden.","Contenedores y despliegue: Dockerización, Kubernetes, Google Cloud y Google Kubernetes Engine (GKE).","Infraestructura: Registros privados para artefactos en Google Cloud, manejo de variables de entorno y secretos de Google.","Automatización: Integración continua y despliegue continuo (CI/CD).","Pagos: Integración con Stripe y manejo de Webhooks.","Otros conceptos: Proxys y muchas herramientas adicionales utilizadas en proyectos reales.","Comprenderás cuándo utilizar una arquitectura monolítica y cuándo implementar microservicios.","Serás capaz de construir, configurar y comunicar múltiples microservicios utilizando NestJS.","Aprenderás a desplegar aplicaciones en la nube utilizando Docker, Kubernetes y Google Cloud.","Estarás preparado para integrarte rápidamente a proyectos profesionales que utilicen arquitecturas de microservicios o implementar esta arquitectura en tus propios desarrollos."}', 'https://cursos.devtalles.com/courses/nestjs-microservicios', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de TypeScript es necesario","Conocimiento básico de NestJS es requerido","Es un curso para personas que han creado API Rest anteriormente"}', '{}', 'Sección 1: Introducción
- Introducción al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Reforzamiento de NestJS
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Reforzamiento de Nest
- Rest - Products CRUD
- Crear producto y validaciones
- Servicios y Respuestas
- Listar y eliminar productos
- Actualizar producto
- Variables de entorno
- Joi - Esquema de validación
- Código fuente de la sección

Sección 3: Introducción - Microservicios
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a los microservicios
- Características de los microservicios
- Otros problemas de los microservicios
- NestJS - Formas de crear aplicaciones

Sección 4: Products Microservice
- Introducción a la sección
- Temas puntuales de la sección
- Nota importante
- Inicio de microservicio - Products
- Entidad y DTOs
- Configurar variables de entorno
- Prisma - SQLite
- Insertar y comprobar la base de datos
- Obtener productos y paginarlos
- Paginar mediante Prisma
- Retornar producto por ID
- Actualizar producto
- Eliminar un producto
- Eliminación suave - No disponible
- Transformar a microservicio
- Message Patterns
- GitHub Organizations - Agrupar repositorios
- Código fuente de la sección

Sección 5: Gateway
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - ClientGateway
- Rutas y Variables de entorno
- Levantar Products Microservice y conectarlo al Gateway
- Obtener todos los productos
- Paginar resultados y enviar payload
- Manejo de excepciones
- Microservice Exception Filter
- Implementar el RpcCustomExceptionFilter
- Implementar métodos faltantes
- Código fuente de la sección

Sección 6: Orders Microservice
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Orders Microservice
- Configurar OrdersMicroservice
- Conectar Gateway con OrdersMicroservice
- Docker - Levantar PostgreSQL
- Prisma - Modelo y conexión
- Crear una nueva Orden
- Guardar orden en base de datos
- Obtener orden por ID
- Paginación y filtro
- Paginación y filtro alternativo
- Cambiar estado de la orden
- Código fuente de la sección

Sección 7: Order Details - Maestro detalle
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - OrdersMicroservice
- OrderItems - Detalles de la orden
- DTOs de creación de orden
- ProductsMicroservice - Validar productos por Ids
- Comunicar OrdersMS con ProductsMS
- Grabar Orden y Detalle en base de datos
- Grabar detalle y retornar información
- Buscar order por ID con su detalle
- Problemas y posibles soluciones
- Código fuente de la sección

Sección 8: Nats Server
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a Nats - Problema / Solución
- Continuación de la aplicación
- Levantar servidor de Nats
- Products Microservice - Cambiar de TCP a NATS
- Client Gateway - Cambiar TCP a NATS
- NatsModule - Módulo personalizado
- Tarea - Conectar OrdersMS de TCP a NATS
- Docker Network - Problema y Necesidad
- Código fuente de la sección

Sección 9: Docker - Crear docker compose
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Levantar manualmente
- Crear red y levantar todo con un solo comando
- Añadir NATS Server y Products Microservice
- Docker compose build - ¿Qué pasa?
- Tarea - Configurar OrdersMS y PostgreSQL
- Variables de entorno
- Expandir nuestro custom exception filter
- Monorepo o no Monorepo
- Git SubModules
- Probar Launcher
- Subir otros sub-módulos
- Trabajar basado en el Launcher
- Código fuente de la sección

Sección 10: Pagos - Payments Microservice
- Introducción a la sección
- Temas puntuales de la sección
- Explicación del objetivo de la sección
- Payments - Microservice
- Configuración de Stripe
- Crear sesión de pago
- Payment Session DTO
- Probando Webhooks de Stripe
- Implementar el Webhook
- Hookdeck - Event Gateway - Forwarder
- Enviar y recibir el ID de la orden
- Configurar variables de entorno faltantes
- Código fuente de la sección

Sección 11: Integrar Orders MS y Payments MS
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Products Launcher
- Agregar repositorio al Products Launcher
- Microservicio Híbrido - REST - Nats
- PaymentSession desde Orders MS
- Retornar URLs de sesión
- Hookdeck - Levantar proxy y forwarder
- EventPattern - Emitir eventos
- Preparar base de datos y PaidOrderDto
- Actualizar order como pagada
- Código fuente de la sección

Sección 12: Autenticación - Auth Microservice
- Introducción a la sección
- Temas puntuales de la sección
- Integración de proyecto - Auth-MS
- Tarea - Comunicar Gateway con Auth-MS
- Solución de la tarea
- Login y Register DTOs
- Aprovisionar MongoDB
- Conectar Prisma con MongoDB
- Registro de un usuario
- Encriptar contraseña
- Login de usuario
- Generar JWT
- Recibir JWT desde los headers
- Decoradores personalizados
- Auth MS - Validar y revalidar token
- Bonus - Generar token desde insomnia
- Importar endpoints en Insomnia
- Código fuente de la sección

Sección 13: Containerization - Construcción de imágenes - PROD
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Docker - Construir a producción
- Docker - MultiStage Build
- Docker Compose - Build & Run
- Construir todas las imágenes simultáneamente
- Orders MS - Postgres en la nube
- Enviar variables en tiempo de construcción
- Código fuente de la sección

Sección 14: Google Cloud - CI/CD
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Google Cloud - Configuración de proyecto
- Google Cloud - Registro y configuraciones
- Instalar Google Cloud CLI - gcloud
- Inicializar nuestro proyecto - gcloud
- Subir imágenes al registro
- Renombrar usando docker compose
- Continuos Integration / Continuos Deployment
- CI/CD - Especificar pasos de construcción
- CI/CD - Resto de repositorios
- Google Secret Manager
- Código fuente de la sección

Sección 15: Kubernetes - Configuración local
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a K8s
- K8s y Helm - Instalaciones
- Configuración de proyecto
- Crear deployment
- Acceso de lectura al registro de Google Cloud
- Configurar variables de entorno
- Crear servicio - Comunicar con mundo exterior
- Crear deployment y servicio de NATS
- Añadir ProdutosMS al cluster
- Secrets - Orders MS
- Secrets - Auth MS
- Secrets - Payments MS
- Payments Service
- Editar Secrets
- Código fuente de la sección

Sección 16: GCloud - Kubernetes Engine
- Introducción a la sección
- Temas puntuales de la sección
- Health-check - Controlador y módulo
- Reforzamiento - Generar nuevas imágenes de producción
- GCloud - Preparar Kubernetes Engine
- Configurar GKE
- Borrar archivos innecesarios
- Ingress - Balanceadores de carga
- Código fuente de la sección

Sección 17: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (42, 'nestjs-reportes', 'NestJs + Reportes: Genera PDFs desde Node', 'https://cursos.devtalles.com/courses/nestjs-reportes', 'https://import.cdn.thinkific.com/643563/wceGycQdRnSJGdIFdaO3_NEST-JS-REPORTES.jpg', 'Portada del curso: NestJs + Reportes: Genera PDFs desde Node', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Crea reportes en PDF utilizando NestJS. Aprenderás a integrar y utilizar Pdfmake y ChartJS para generar reportes profesionales y personalizados.', 390, 'es', '{}', 'https://cursos.devtalles.com/courses/nestjs-reportes', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de Nest es necesario","Conocimiento básico de JavaScript y TypeScript es recomendado"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones

Sección 2: Preparación de proyecto
- Introducción
- Temas puntuales de la sección
- Demostración del objetivo
- Inicio de proyecto - Report Server
- Docker, PostgreSQL y PGAdmin
- Tabla de empleados
- Conectar NestJS con Prisma
- Instrucciones para levantar el backend
- Código fuente de la sección

Sección 3: Constancia de empleo
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuar proyecto
- PdfMake - Primer PDF
- Refactorización y modularización
- ¿Cómo funciona PdfMake?
- Constancia de empleo - Reporte
- Encabezado: Imágenes y columnas
- Formatear fechas
- Report Components - Header
- Cargar información del empleado
- Colocar data del empleado en el reporte
- Código fuente de la sección

Sección 4: Tablas - Listado de países
- Introducción
- Temas puntuales de la sección
- Demostración
- Continuación de proyecto
- Base de datos de Países
- Reportes con tablas
- Personalizar el encabezado
- Mostrar listado de países
- Pie de página con numeracón
- Mostrar totales de tabla
- Estilo personalizado de tablas
- Código fuente de la sección

Sección 5: Recibo de compra - Maestro detalle relacionado
- Introducción a la seción
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Preparar módulo, controlador y servicio
- Factura - Estructura del reporte
- Creación del reporte
- Código QR
- Estilo en la misma línea
- Tabla con el detalle
- Relaciones de base de datos
- Prisma - Información completa del recibo
- Mostrar información del recibo
- Código fuente de la sección

Sección 6: Gráficos y SVGs
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Mostrar SVGs
- Mostrar un gráfico - Chart.js
- Parámetros adicionales - QuickChart
- Utilidades para Chart.js
- Reporte de dona - Mejores 10 países
- Mostrar información en el reporte
- Reutilizar código para otras gráficas
- Mostrar tabla - Mejores 10 países
- Sección de encabezado
- Gráfica lineal
- Gráfico de barras
- Tarea adicional
- Código fuente de la sección

Sección 7: Utilidades y diseño complejo
- Introducción
- Temas puntuales
- Demostración
- Continuación de proyecto
- HTML to PdfMake
- HTML complejo
- Personalización de tablas - Parte 1
- Personalización de tablas - Parte 2
- Personalización de tablas - Parte 3
- Tamaños de página
- Código fuente de la sección

Sección 8: Despedida del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (36, 'nestjs-testing', 'NestJS + Testing: Pruebas unitarias y end to end (e2e)', 'https://cursos.devtalles.com/courses/NestJS-Testing', 'https://import.cdn.thinkific.com/643563/ay0QQ3qaTkiHRwytCLnt_COVER-DEVTALLES-TESTING.jpg', 'Portada del curso: NestJS + Testing: Pruebas unitarias y end to end (e2e)', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aquí aprenderán a realizar pruebas unitarias, integración y de extremo a extremo (E2E) de sus aplicaciones hechas en NestJS utilizando Jest, siguiendo estándares recomendados.', 750, 'es', '{}', 'https://cursos.devtalles.com/courses/NestJS-Testing', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de NestJS previo es necesario","No es un curso para aprender NestJS","Conocer qué es un Restful API sería útil","No es necesario saber sobre pruebas automáticas o Jest","Conocimiento de TypeScript sería ideal"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a las pruebas
- Introducción
- Presentación - Pruebas automáticas

Sección 3: Nuestras primeras pruebas
- Introducción
- Temas puntuales
- Inicio de proyecto - MyPokemonApp
- Testing Scripts y depuración en VSCode Lecture
- Mi primera prueba
- Creación de un Restful API
- Funcionamiento del API
- Transformación de resultados
- Generar informe de cobertura
- Test - Pagination.dto
- Test - Pagination.dto - Parte 2
- Class Transformer - Pruebas de conversión de tipo
- Test - Create.dto
- Otras pruebas sobre Create y Update Dtos
- Código fuente

Sección 4: Pruebas sobre módulos, controladores y servicios
- Introducción
- Temas puntuales
- Continuación de proyecto
- Test - App.module
- Test - PokemonService.ts
- Test - NotFound Exception
- Test - Pruebas de paginación con caché
- Test - Object containing
- Test - PokemonController
- SpyOn - mockImplementation
- Tarea - Pruebas con espías
- Test - Main.ts
- Test - Pruebas de configuración del Bootstrap
- Test - useGlobalPipes
- Cobertura hasta el momento
- Código fuente

Sección 5: Tarea - Cobertura al 100%
- Introducción
- Temas puntuales
- Continuación de proyecto
- Explicación de la tarea
- Solución de la tarea
- Solución de la tarea - Parte 2
- Solución de la tarea - Parte 3
- Solución - Prueba sobre la entidad
- Código fuente

Sección 6: E2E - End to end testing
- Introducción
- Temas puntuales
- Continuación
- Configuraciones para e2e
- E2E - Post: Crear pokemon
- E2E - Post: Con y sin body
- Solución a la tarea - Post
- E2E - Get: Con parametros de query
- E2E - Get: Obtener información de un registro
- E2E - Update: Actualizar registro
- E2E - Delete: Eliminar registros
- Conectar unit test con e2e en construcción
- Código fuente

Sección 7: Unit Testing - Aplicación real
- Introducción
- Temas puntuales
- Preparación de proyecto
- Test - Interfaces y enumeraciones
- Test - DTO''s Create y Login User
- Test - Pagination DTO
- Test - RoleProtected Decorator
- Test - RawHeaders Decorator
- Test - GetUser Decorator
- Test - ApplyDecorators
- Test - User Entity
- Cobertura hasta el momento
- Test - UserRole Guard
- Test - Guard: Excepciones
- Código fuente

Sección 8: Unit Testing - Autenticación, controladores y strategies
- Introducción
- Temas puntuales
- Continuación
- Test - Strategies & Repositories
- Test - Funcionamiento de la estrategia
- Test - Auth Controller
- Test - Métodos del controlador
- Test - AuthModule
- Test - AuthService
- Test - Crear usuario
- Tarea - Probar un internal server error
- Test - Login
- Test - Unauthorized Exception
- Test - Main.ts
- Pruebas de configuración en el Main
- Confirmar que el Swagger sea llamado
- Código fuente

Sección 9: Unit Testing - Productos y carga de archivos
- Introducción
- Temas puntuales
- Continuación
- Test - ProductsService
- Test - Creación de productos
- Test - Creación fallida
- Test - Búsqueda de productos
- Test - Buscar producto por término
- Test - Pruebas con el QueryBuilder
- Test - Query Runner
- Test - commitTransaction
- Test - FilesModule
- Test - FilesController
- Test - Métodos del FileController
- Test - FilesService
- Código fuente

Sección 10: E2E - Pruebas de extremo a extremo
- Introducción
- Temas puntuales
- Continuación de proyecto - Configuración
- E2E - Auth - Login
- E2E - Tarea sobre login
- E2E - Insertar a base de datos manualmente
- E2E - Tarea - Registro de usuarios
- E2E - Rutas protegidas
- E2E - Rutas privadas
- E2E - Preparación carga de archivos
- E2E - Probar si es o no una imagen
- E2E - Cobertura
- Código fuente

Sección 11: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (29, 'net-backend', '.NET Backend: .NET Core, SQL Server y seguridad JWT', 'https://cursos.devtalles.com/courses/NET-Backend', 'https://import.cdn.thinkific.com/643563/7c18RVDvTFezQ4VL9JeM_NET-DEVTALLES.jpg', 'Portada del curso: .NET Backend: .NET Core, SQL Server y seguridad JWT', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Construye desde cero una API RESTful profesional en .NET para un e-commerce real. Aprende sobre JWT, Entity Framework, control de acceso, subida de imágenes, cache, versionado y despliegue en la nube.', 660, 'es', '{}', 'https://cursos.devtalles.com/courses/NET-Backend', '2026-09-24 15:49:29.94579+00', '{"Tener conocimientos básicos de programación (estructuras de control, variables, métodos, clases).","Haber trabajado previamente con C# o completado un curso introductorio.","Conocimientos básicos sobre HTTP y JSON.","Visual Studio Code instalado y configurado con .NET 8.","Acceso a internet para instalar paquetes NuGet y realizar pruebas con herramientas externas como Postman."}', '{}', 'Sección 1: Introduction
- Bienvenido al curso .Net Backend
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Nota de actualización: Trabajar con solution explorer
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Breve introducción a C# y fundamentos esenciales para .NET
- Introducción a la sección
- Temas puntuales
- Preparación del proyecto
- Tipos básicos
- Clases e interfaces
- Herencia
- Patrón adaptador
- Inyección de dependencias
- Métodos asíncronos
- Atributos o decoradores
- Código de la sección

Sección 3: Creación de proyecto
- Introducción a la sección
- Temas puntuales
- ¿Qué es .NET?
- Creación proyecto
- Explicación archivo principal Program.cs
- Creación de la estructura de directorios
- Creación de imagen y contenedor para SQL Server
- Código de la sección

Sección 4: Creación de categoría
- Introducción a la sección
- Temas puntuales
- Modelo Categoria: definición de propiedades
- Conexión a base de datos
- Instalación de paquetes necesarios
- Creación archivo de contexto
- Configuración conexión SQL
- Primera migración a Base de Datos
- Código de la sección

Sección 5: Repositorio categoría
- Introducción a la sección
- Temas puntuales
- Introducción al patrón repositorio en .NET
- Interface ICategoryRepository
- Implementación de CategoryRespository
- Código de la sección

Sección 6: API Categoría
- Introducción a la sección
- Temas puntuales
- ¿Qué es DTO?
- DTO para categoría
- Automapper configuración básica
- Introducción a controladores
- Endpoint: Listar todas las categorías
- Endpoint: Obtener categoría por ID
- Manejo de categoría no encontrada
- Endpoint: Crear nueva categoría
- Endpoint: Actualizar categoría
- Endpoint: Eliminar categoría
- Código de la sección

Sección 7: API Producto
- Introducción a la sección
- Temas puntuales
- Modelo Producto: definición y relación con categoría
- Migración para el modelo producto
- Definición de DTOs para Product
- Tarea Interfaz repositorio para producto
- Creación de repositorio para producto
- Creación de repositorio para producto (continuación)
- Controlador ProductsController
- Endpoint: Listar productos
- Endpoint: Obtener producto
- Endpoint: Crear producto asociado a categoría
- Obtener descripción de la categoría del producto (carga anticipada)
- Tarea Endpoint: Obtener productos por categoría
- Endpoint: Buscar producto por nombre o descripción
- Endpoint: Comprar producto
- Endpoint: Actualizar producto
- Endpoint: Eliminar producto
- Código de la sección

Sección 8: API Usuario, autenticación y JWT
- Introducción a la sección
- Temas puntuales
- Introducción a la seguridad en APIs REST
- Modelo usuario
- DTOs para User
- Tarea: interfaz Usuario
- Implementar interfaz usuario
- Desarrollo método register
- Introducción JWT
- Desarrollo método Login
- Desarrollo método Login continuación
- Tarea: controlador UserController y listar
- Tarea: obtener usuario
- Crear Usuario
- Acceso a usuario (login)
- Código de la sección

Sección 9: CORS
- Introducción a la sección
- Temas puntuales
- ¿Qué es CORS?
- Configuración de CORS
- Permitir controladores o métodos
- Código de la sección

Sección 10: Autorización
- Introducción a la sección
- Temas puntuales
- Protegiendo Accesos
- Endpoints públicos y privados
- Uso de postman: Categorías
- Uso de Postman: Usuarios
- Uso de Postman: Exportar colección
- Incorporar autenticación en Swagger
- Código de la sección

Sección 11: Caché
- Introducción a la sección
- Temas puntuales
- Introducción a caché
- Añadir Cache
- Configuración perfiles de caché
- Manejo de constantes para caché
- Código de la sección

Sección 12: Versionando API
- Introducción a la sección
- Temas puntuales
- Introducción al versionamiento de las APIs
- Extensiones necesarias
- Configuración para soportar versionamiento
- Configurando múltiples versiones en controladores
- Documentación por versiones (Versión 1)
- Tarea: agregar documentación v2
- Organización de código para múltiples versiones
- Endpoints neutrales y método obsoleto
- Código de la sección

Sección 13: Autenticación y autorización con Identity
- Introducción a la sección
- Temas puntuales
- Introducción a .NET Core Identity
- Integrar autenticación con .NET Identity
- Creación de modelo y soporte para uso de Identity
- Migración para uso de Identity
- Configuración para el método login
- Cambios en el método de registro
- Cambios en el listar y obtener usuario
- Pruebas de funcionalidad y correcciones
- Código de la sección

Sección 14: Implementar subida de imagen
- Introducción a la sección
- Temas puntuales
- Configuraciones para subir un archivo
- Subida de imagen al crear producto
- Subida de imagen al actualizar producto
- Pruebas y refactorización al subir imagen
- Código de la sección

Sección 15: Seed, paginación y uso de agente
- Introducción a la sección
- Temas puntuales
- Datos iniciales (Seed)
- Refactorizando proceso de seeding
- Paginación
- Implementación de paginación
- Refactorizando respuesta para paginación
- Introducción a Mapster
- Uso de agente para migración a Mapster
- Código de la sección

Sección 16: Publicando API en Azure
- Introducción a la sección
- Temas puntuales
- Configuración en Azure
- Probar la conexión con la base de datos
- Migración a la base de datos en Azure
- Publicar API en azure app services
- Prueba de API en producción
- Código de la sección

Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (22, 'netfullstack', '.NET Fullstack: Arquitectura limpia al frontend y Blazor', 'https://cursos.devtalles.com/courses/netfullstack', 'https://import.cdn.thinkific.com/643563/LcwHwtf1Q0WlRGiv9VY3_COVER-DEVTALLES%20(1).jpg', 'Portada del curso: .NET Fullstack: Arquitectura limpia al frontend y Blazor', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende desarrollo web Fullstack con C# y .NET Core. Domina Clean Architecture, Blazor Server y WebAssembly, CQRS con MediatR, EF Core, ASP.NET Core Identity, autenticación, autorización por roles, SQL Server, Tailwind CSS y QuickGrid en un proyecto.', 840, 'es', '{}', 'https://cursos.devtalles.com/courses/netfullstack', '2026-09-24 15:49:29.94579+00', '{"Necesitas dominio de los fundamentos de C#","Haber completado nuestros cursos introductorios de C# y .NET Backend te dará la base ideal para avanzar de forma más cómoda y aprovechar al máximo este curso."}', '{}', 'Sección 1: Introducción
- Bienvenido al curso .NET Fullstack: Arquitectura limpia al frontend y blazor
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Nota de actualización: Trabajar con solution explorer
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Breve introducción a C# y fundamentos esenciales para .NET (Opcional)
- Introducción a la sección
- Temas puntuales
- Preparación del proyecto
- Tipos básicos
- Clases e interfaces
- Herencia
- Patrón adaptador
- Inyección de dependencias
- Métodos asíncronos
- Atributos o decoradores
- Código de la sección

Sección 3: Creación del Proyecto
- Introducción a la sección
- Temas puntuales
- Creación proyecto blazor
- Revisión del proyecto
- Separar la lógica del componente
- Código de la sección

Sección 4: Arquitectura limpia
- Introducción a la sección
- Temas puntuales
- Introducción a la arquitectura limpia
- Agregando capa de dominio y aplicación
- Implementando la capa de dominio
- Implementando la capa de aplicación
- Implementando la inyección de dependencias
- ¿Por qué centralizamos la inyección de dependencias?
- Visualizando notas con blazor
- Código de la sección

Sección 5: Capa de infraestructura: Base de datos y entity framework
- Introducción a la sección
- Temas Puntuales
- ¿Por qué necesitamos una capa de infraestructura?
- ¿Qué es entity framework?
- Implementando la capa de infraestructura
- Adicionando el ApplicationDbContext
- Creación de imagen y contenedor SQLServer
- Agregando la cadena de conexión y paquete para SQLServer
- Conectando con inyección de dependencia
- Agregando una entidad base abstracta
- Realizando la migración
- Creando la clase ApplicationDbContextFactory
- Verificando y creando notas
- Implementando el repositorio para notas
- Mostrando notas desde la base de datos
- Código de la sección

Sección 6: Introducción a CQRS y al patrón mediador
- Introducción a la sección
- Temas puntuales
- ¿Qué es CQRS y el Patrón Mediador?
- Instalando el paquete MediatR
- Implementando la consulta (query) para notas
- Utilizando GetNotesQuery en Blazor
- Código de la sección

Sección 7: CRUD con CQRS y Blazor SSR
- Introducción a la sección
- Temas puntuales
- Introducción Blazor SSR
- Comando para crear una nota
- Usando DTO para respuesta de nota
- Utilizando Mapster
- Crear componente y modelo para nota
- Introducción a formulario y componentes
- Desarrollando formulario para nota
- Reestructurando la capa de presentación (Features)
- Obteniendo nota (tarea)
- Actualizando nota
- Cambiando formulario para actualizar
- Cambiando formulario para actualizar - continuación
- Borrando nota (tarea)
- Borrar una nota desde presentación
- Código de la sección

Sección 8: Mejoras experiencia de usuario y desarrollador
- Introducción a la sección
- Temas puntuales
- Agregando objeto resultado
- Agregando resultado genérico
- Conociendo el operador de conversión implícita estática
- Utilizando el operador de conversión implícita estática
- Mejorando la interfaz de solicitud para comandos y consultas
- Cambiando las solicitudes de notas
- Manejo global de using
- Cambiando las implementaciones de notas
- Código de la sección

Sección 9: Incluyendo Tailwind y mejorando el estilo en la capa de presentación
- Introducción a la sección
- Temas puntuales
- Introducción a Tailwind CSS
- Instalación de Tailwind
- Listado de notas con Tailwind
- Notas con colores
- Refactorizando manejo de colores para las notas
- Creando nuevo diseño
- Agente cambiando al componente NoteEditor
- Código de la sección

Sección 10: Autenticación con ASP.NET Core Identity y Google
- Introducción a la sección
- Temas puntuales
- Agregando paquetes NuGet
- Agregando interfaz y clase para usuarios
- Cambiando DbContext y migraciones
- Creando interfaz para registro e inicio de sesión de usuarios
- Implementando interfaz para registro e inicio de sesión
- Registro de servicios para autenticación
- Crear comando de inicio de sesión
- Crear comando para registro de usuario (Tarea)
- Implementando página de registro
- Implementando página de inicio de sesión
- Utilizar el componente AuthorizeView
- Implementar página para Logout
- Proteger la página editor de notas
- Agregar el autor a las notas
- Mostrar nombre de autor en las notas
- Mostrar autor al editar nota
- Instalación y configuración para autenticación con Google
- Crear las credenciales Google GCP
- Controlador para manejo de cuenta Google
- Agregar botones registro e inicio de sesión Google
- Código de la sección

Sección 11: Autorización mediante roles con ASP.NET Core Identity
- Introducción a la sección
- Temas puntuales
- Habilitando roles con Identity
- Agregar roles manualmente y controlar el acceso
- Agregar rol al registrarse
- Mostrar una sola nota y botón para editar
- Agregando UserService
- Agregando el HttpContextAccessor
- Implementar el UserService y manejo de excepción personalizada
- Refactorizar: Crear una nota
- Refactorizar: Actualizar una nota
- Refactorizar: Borrar una nota (Tarea)
- Refactorizar: Editar si es el autor
- Refactorizar: Editar nota desde su detalle
- Agregar rol al usuario de google
- Código de la sección

Sección 12: Gestión de usuarios con interactividad con blazor server
- Introducción a la sección
- Temas puntuales
- Introducción del modo de renderizado de servidor interactivo
- Agregar un nuevo componente y enlace solo para administradores
- Implementar método para obtener los usuarios
- Implementar la consulta GetUsers
- Agregar QuickGrid
- Agregar roles a nuestro grid
- Agregar un botón para cambiar los roles de usuario
- Implementar el modal
- Obtener los roles del usuario
- Agregar un rol
- Refactor: Lista de usuarios con roles
- Eliminar un Rol (Tarea)
- Código de la sección

Sección 13: Gestión de notas Interactividad con Blazor WebAssembly
- Introducción a la sección
- Temas puntuales
- Introducción a Blazor WebAssembly
- Habilitar el modo de renderizado WebAssembly
- Agregar el proyecto del cliente
- Agregar un componente de cliente
- Agregar método obtener notas del usuario
- Implementar la consulta GetNotesByCurrentUser
- Agregar el controlador NotesController
- Realizar la llamada desde el cliente
- Agregar QuickGrid al cliente
- Implementar commando para modificar el estado publicado (toggle)
- Implementar controlador y servicio
- Crear servicio en el cliente
- Código de la sección

Sección 14: Reemplazar MediatR
- Introducción a la sección
- Temas puntuales
- ¿Por qué vamos a reemplazarlo?
- Crear las interfaces para las peticiones
- Implementar el Sender
- Implementando el mediador (Mediator)
- Arreglando todas las referencias
- Código de la sección

Sección 15: Desplegar en AWS
- Introducción a la sección
- Temas puntuales
- Introducción a AWS RDS y Elastic Beanstalk
- Creación de base de datos con RDS
- Prueba y configuración de la base de datos
- Creación de usuario y notas
- Generar credenciales access-id y secret-key
- Desplegar en AWS
- Pruebas de funcionamiento aplicación en la nube
- Código de la sección

Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (54, 'nextjs', 'Next.js: El framework de React - Fernando Herrera', 'https://cursos.devtalles.com/courses/nextjs', 'https://import.cdn.thinkific.com/643563/j1fWunR0QJa9diyy2e1t_NEXT-APP-ROUTER2.jpg', 'Portada del curso: Next.js: El framework de React - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este curso tiene por objetivo enseñarte Next.js de forma completa con muchas tareas y ejercicios. Al final del curso no solo aprenderás Next.js, también habrás desarrollado una tienda electrónica con cobros, mantenimientos, carga, optimizaciones para SEO, desplegarla y tenerla en tu portafolio de proyectos.', 2340, 'es', '{"Fundamentos de Next.js: Routing, TypeScript, estrategias de renderizado y consumo de APIs.","Desarrollo Full Stack: Autenticación, bases de datos, APIs, CRUD y manejo de usuarios.","Optimización para producción: Docker, despliegues, SEO, cookies, middlewares y rendimiento.","Proyecto final: Desarrollo de un eCommerce completo listo para publicar.","Next.js moderno: App Router, rutas dinámicas y estrategias de renderizado (ISR, SSR, SSG y CSR).","TypeScript: Integración completa y migración desde proyectos en JavaScript.","Backend: APIs REST, autenticación personalizada, JWT y NextAuth.","Bases de datos: MongoDB y PostgreSQL.","Estado y formularios: Zustand y React Hook Form.","UI: Material UI, NextUI y diseño responsivo.","Producción: Docker, despliegues automáticos, SEO y optimización de imágenes.","Pagos: Integración con PayPal y tarjetas de crédito.","Middlewares: Protección de rutas, autenticación y redirecciones.","Y mucho más...","Introducción a Next.js: Primer proyecto para comprender los fundamentos del framework.","PokemonApp: Implementación de ISR y SSG.","OpenJira: Aplicación para gestión de tareas utilizando SSR.","CookieMaster: Manejo avanzado de cookies.","TesloShop: Tienda en línea completa con autenticación, pagos, dashboard administrativo, carga de imágenes y optimización para producción.","Dominarás Next.js para desarrollar aplicaciones modernas listas para producción.","Comprenderás cuándo utilizar ISR, SSR, SSG y CSR para optimizar el rendimiento de tus aplicaciones.","Construirás una tienda en línea completa con autenticación, pagos, bases de datos y despliegue.","Tendrás proyectos reales que podrás incorporar a tu portafolio profesional."}', 'https://cursos.devtalles.com/courses/nextjs', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de React con Hooks es necesario","NO es necesario saber TypeScript (pero será útil)","NO es necesario saber Node (pero será útil)","NO es necesario saber Next para empezar este curso"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a Next.js
- Introducción a la sección
- Temas puntuales de la sección
- Recomendaciones antes de empezar
- Problematica y solución
- Importante: Next 13+
- Creando mi primer proyecto
- Modificaciones y Turbopack
- Explicación de archivos y directorios
- Rutas adicionales
- Metadata - Metatags
- Layouts y Layouts anidados
- Barra de navegación
- Server Components - Async await
- Next/Link
- Pensemos en server components
- usePathname - ActiveLink
- Resumen de la sección
- Código fuente de la sección

Sección 3: Despliegues a Vercel y Docker Images
- Introducción a la sección
- Temas puntuales de la sección
- Preparar proyecto para publicarlo
- Generar build de producción
- Subir repositorio a GitHub
- Desplegando en Vercel
- Docker - Construcción simple
- Docker - Construcción recomendada
- Código fuente de la sección

Sección 4: Server Side + Cliente Side Rendering
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - MyDashboard
- Estructura de nuestro dashboard
- Sidebar y contenido principal
- Next/Image
- Iconos y ruta activa
- Solución de la tarea
- Counter - Manejo de estado - useState
- Pensemos en hojas y pequeños componentes
- Punto interesantes a contemplar
- Código fuente de la sección

Sección 5: Generación dinámica - SSR
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Data Fetching - Next13+
- Asignar tipo de datos y mostrar imágenes
- Resolución de la tarea
- Pensemos en componentes pequeños
- Image Priority - Prioridad de carga
- Next - Error Page
- Rutas dinámicas - Argumentos por URL
- Cargar información del Pokémon por ID
- Metadata dinámica
- Pantalla del Pokemon
- Depurar código - Breakpoints
- Not found Page - 404
- Observaciones finales
- Código fuente de la sección

Sección 6: Incremental & Static Generation
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Generación estática y Revalidación
- Consideración importante
- Tarea - Generación estática
- Resolución de la tarea
- Caché y caché components
- Revalidar e invalidar caché
- Código fuente de la sección

Sección 7: Global State - Redux y LocalStorage
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Antes de comenzar - Materiales adicionales
- Continuación de la aplicación
- Instalación y configuración de Redux Toolkit
- Counter Slice
- Exportando redux toolkit hooks
- Counter Reducer y acciones
- Server al client state
- Tarea - Store, Props y Links
- Solución de tarea
- RESTful Api - Get Counter
- Valor del counter desde API
- Código fuente de la sección

Sección 8: Estado Global - Favoritos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- PokemonSlice
- Mostrar cambios en el UI - Favoritos
- Toggle Favorite
- Página de favoritos
- Mantener favoritos
- Almacenar en LocalStorage
- Redux Toolkit - Middlewares
- Localstorage build time error
- Server Components + LocalStorage
- Código fuente de la sección

Sección 9: Next API Routes - RESTful Api Handlers
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - AdminTodo
- Configurar Postgres localmente
- Recomendaciones - README.md
- Prisma + NextJs
- Conectar Prisma con Next
- Generar semilla de base de datos
- Listar todas las entradas
- Paginación simple
- Retornar una única entrada
- POST - Crear una nueva entrada
- Yup - Validation Schema
- Actualizar entradas - PUT
- Validaciones en la actualización
- Código fuente de la sección

Sección 10: Next + RestAPI - AdminTodos
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Prisma CLI reference
- Tarea - Estructura del proyecto
- Resolución de la tarea
- Sistema de navegación
- Listar las entradas
- Estructura y diseño de los TODOs
- Estructura y diseño - Parte 2
- Actualizar Todo
- Actualizar Server Component
- Crear un TODO
- Solución de la tarea
- Eliminar completados
- Código fuente de la sección

Sección 11: Server Actions - Optimistic Updates - Next 14+
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Preparar pantalla de Server Actions
- Server Actions - Toggle Todo
- Crear un nuevo Todo
- Eliminar completados
- useOptimistic Hook - React
- Revalidación de la data
- Código fuente de la sección

Sección 12: Cookies - Server y Client Side
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Introducción a las cookies
- Diseño de pantalla y componentes
- Cookies - Client Side
- Cookies - Server Side
- Diseño de pantalla de productos
- Mostrar listado de productos
- Shopping-Cart - Client Side
- Shopping-Cart - Server Side
- Eliminar productos del carrito
- Diseño de la pantalla de carrito
- Tarea - Agregar y eliminar
- Total + impuesto
- Detalle final
- Código fuente de la sección

Sección 13: Better Auth - Manejo de autenticación
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - BetterAuthApp
- NeonTech - Base de datos
- Better Auth - Configuraciones iniciales
- Proveedores - Email, Google y GitHub
- Registro de usuarios - Google y GitHub
- Registro de usuarios - Email y Password
- Login - Ingresar y validar correos
- Cerrar sesión
- Información del usuario - Server y Client Side
- NextJS - Proxy
- Configurar Two Factor Authentication
- Activar Two Factor en una cuenta
- Desactivar Two Factor Authentication
- Login con Two Factor Authentication
- Código fuente

Sección 14 - E-Commerce - Diseño - TesloShop
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - TesloShop
- NextJS Fonts
- Estructura de directorios y primeras páginas
- Creando rutas de la aplicación
- TopMenu
- Página 404 - Categorías
- Página 404 - Personalizada
- Componente - Title
- Grid de Productos
- Tarjeta de producto
- Cambiar imagen - MouseOver
- Menú lateral - Primera parte
- Menú lateral - Segunda parte
- Zustand - UI Store
- Código fuente de la sección

Sección 15 - E-Commerce - Diseño parte 2
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Continuación de la aplicación
- Tarea - Pantalla de categorias
- Pantalla de producto
- Selector de tallas
- Selector de cantidad
- Slideshow de imágenes
- Slideshow con Thumbs - Parte 1
- Slideshow con Thumbs - Parte 2
- Slideshow mobile
- Pantalla carrito de compras
- Pantalla carrito de compras - Parte 2
- Pantalla de dirección del cliente
- Pantalla de verificación de compra
- Pantalla de orden de pago
- Pantalla de ordenes de compra
- Pantalla de carrito de compras vacío
- Footer - Pie de página
- Login - Registro y Auth Layout
- Detalle estético del carrito de compras
- Código fuente de la sección

Sección 16 - Preparación de base de datos
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- PostgreSQL - Base de datos relacional
- Conectarnos a la base de datos - Table Plus
- Configurar Prisma Client
- Esquema de Prisma
- Esquema de Prisma - Parte 2
- Semilla de base de datos - Configuración inicial
- Prisma Client - Borrar contenido de tablas
- Semilla de base de datos - Categorías
- Semilla de base de datos - Relación Productos - Categorías
- Semilla de base de datos - Productos
- Semilla de base de datos - ProductImages
- Código fuente de la sección

Sección 17 - Paginación del lado del servidor
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Cargar productos de base de datos
- Mostrar productos en pantalla
- Paginación manual
- Controlar cuando no hay productos en la página
- Paginación - Determinar el total de páginas
- Paginación - Componente HTML
- Paginación - Funcionamiento
- Paginación - Generar el número de páginas
- Paginación - Mostrar el número de páginas
- Tarea - Productos por género
- Solución de la tarea - Productos por género
- Revalidación de rutas
- Generar el build de producción
- Código fuente de la sección

Sección 18 - Pantalla de Producto
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Cargar producto por SLUG
- Client Side - Sólo lo necesario
- Resolución de la tarea - Cargar existencias
- Skeleton - Mostrar loading en el stock
- Optimizando Metadata
- Probar enlaces para compartir
- Código fuente de la sección

Sección 19 - Carrito de compras
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Client Side - Tallas y Cantidad
- Client Side - Tarea con la cantidad
- Mensaje de error si no hay talla seleccionada
- Client Side - Cart Store
- Store - addProductToCart
- Agregar producto al carrito de compras
- Hacer persistente el carrito de compras
- Mostrar número de elementos en el carrito
- Mostrar los elementos del carrito de compras
- Cambiar cantidad desde el carrito de compras
- Remover producto del carrito
- Resumen de la orden
- Formato de moneda
- Carrito de compras vacío
- Código fuente de la sección

Sección 20 - NextAuth
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Agregar autenticación - NextAuh
- Configuración de Credentials Provider
- Conectar Login Form con NextAuth
- Modelo de Usuario
- SEED - Insertar usuarios
- Validar usuario - NextAuth
- Mejorar la experiencia de usuario
- Server Side - Saber el usuario conectado
- Cerrar sesión
- Redirección manual después del login
- Client Side - Obtener la sesión
- Mostrar y ocultar opciones del menú
- Expandir el objeto de sesión
- Tarea - Mostrar y ocultar opciones según rol
- Formulario para crear usuarios
- Mostrar errores en pantalla
- Server Action - Crear usuario
- Autenticar después de crear usuario
- Middleware
- Código fuente de la sección

Sección 21 - Dirección de entrega
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Formulario de dirección
- Controlar el formulario - useForm Hook
- Seed Countries
- Resolución de la tarea
- Mostrar los países en el formulario
- Zustand - Almacenar la dirección
- Guardar y cargar de Zustand la dirección
- Dirección del usuario - Relación 1 a 1
- Server Action - Guardar y actualizar dirección
- Guardar y eliminar la dirección
- Eliminar la dirección de base de datos
- Cargar la dirección desde el servidor
- Tarea - Agregar la ciudad en la base de datos
- Nota de actualización
- Código fuente de la sección

Sección 22 - Creación de Ordenes
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Continuación de proyecto
- Pantalla de confirmación - Parte 1
- Pantalla de confirmación - Parte 2
- Bloquear botón y mensajes de error
- Modificaciones a nuestro esquema
- Actualizar nuestro seed
- Colocar orden - Server Action
- Colocar orden - Productos y cantidades
- Colocar orden - Total, SubTotal e Impuesto
- Colocar orden - Transacción - Múltiples inserciones y actualizaciones
- Transacción - Crear Encabezado y Detalle
- Transacción - Insertar la dirección
- Transacción - Actualizar inventario
- Mensaje de error y navegar a la página de orden
- Pantalla de orden por ID
- Resolución de la tarea - Pantalla de Orden
- Listado de ordenes
- Código fuente de la sección

Sección 23 - Pagos - PayPal
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Modificaciones adicionales en la orden
- PayPal developer dashboard
- Botones de Paypal
- Mostrar Skeleton mientras se carga
- Crear orden de pago - PayPal - TransactionID
- Server Action - Actualizar el TransactionID
- Postman - Verificar pagos desde PayPal
- Server Action - Verificar Pago - Parte 1
- Server Action - Verificar Pago - Parte 2
- Server Action - Verificar el pago en PayPal
- Server Action - Marcar order como pagada
- PayPal - Invoice ID
- Ocultar botones si está pagada la orden
- Código fuente de la sección

Sección 24 - Mantenimientos administrativos
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Visor de ordenes
- Cambiar roles de usuario - Diseño de pantalla
- Server Action - Cambiar rol del usuario
- Guard de protección de rutas administrativas
- Listado de productos
- Pantalla de Producto
- Tarea - Cargar categorías
- Cargar formulario con el producto
- Mostrar imágenes actuales del producto
- Mostrar las tallas seleccionadas
- Server Action - Esquema de validación de objetos
- Actualizar producto
- Crear un producto
- CustomImage - Componente
- Invalidar Paths y Redireccionar
- Server Action - Carga de archivos
- Cargar a Cloudinary
- Insertar registro de imágenes en base de datos
- Server Action - Eliminar imagen
- Código fuente de la sección

Sección 25 - Desplegar Tienda
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Revisión y corrección de Warnings y Errores
- Aprovisionar base de datos
- Preparación para despliegue
- Desplegar a Vercel

Sección 26 - Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso

Archivado - Sección 13: Auth.js - Autenticación de protección de rutas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de aplicación
- Auth.js - Configuraciones iniciales
- GithubProvider
- Información del usuario - Server Side
- Tarea - Mostrar información del usuario
- Información del usuario - Client Side
- Google Provider
- Logout y SignIn
- Prisma Adapter - AuthJS
- UUID en lugar CUID
- Campos adicionales al usuario
- Modificar Auth.js User
- CredentialsProvider
- Relaciones y semilla de base de datos
- Todos por usuario
- Crear TODO con usuario
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (49, 'node-clean-architecture', 'Node - Autenticación Rest con Clean Architecture', 'https://cursos.devtalles.com/courses/node-clean-architecture', 'https://import.cdn.thinkific.com/643563/QbFhQhHcRBCapBIpm9nf_NODE-AUTENTICATION-REST.jpg', 'Portada del curso: Node - Autenticación Rest con Clean Architecture', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'El objetivo del curso es crear una autenticación y registro de usuarios mediante un Restful API utilizando Clean Architecture y diferentes patrones de desarrollo. Pasando por la configuración de Node con TypeScript hasta la verificación de nuestro Json Web Token.', 240, 'es', '{"Arquitectura limpia: Organización del proyecto utilizando Repository Pattern, casos de uso y separación de responsabilidades.","Persistencia de datos: Integración con MongoDB mediante Mongoose para construir una capa de acceso a datos robusta.","Autenticación segura: Implementación de registro e inicio de sesión utilizando JSON Web Tokens (JWT).","Buenas prácticas: Manejo personalizado de errores, DTOs, validaciones e inyección de dependencias.","Repository Pattern: Separación de la lógica de acceso a datos mediante una arquitectura desacoplada.","Arquitectura limpia: Organización del proyecto basada en responsabilidades y casos de uso.","MongoDB y Mongoose: Modelado y persistencia de información utilizando una base de datos NoSQL.","DTOs: Validación y transferencia de datos entre las distintas capas de la aplicación.","Autenticación: Registro, inicio de sesión y protección de rutas mediante JSON Web Tokens (JWT).","Inyección de dependencias: Desarrollo de aplicaciones más desacopladas, reutilizables y fáciles de mantener.","Manejo de errores: Creación de excepciones personalizadas y respuestas consistentes para la API.","Docker: Configuración del entorno de desarrollo para facilitar la ejecución y despliegue de la aplicación.","Serás capaz de construir APIs modernas utilizando Node.js y TypeScript siguiendo buenas prácticas de arquitectura.","Aprenderás a estructurar proyectos escalables mediante Repository Pattern e inyección de dependencias.","Implementarás autenticación segura con JWT y desarrollarás funcionalidades reales como registro e inicio de sesión de usuarios.","Tendrás una base sólida para desarrollar APIs profesionales utilizando MongoDB, Mongoose y Docker."}', 'https://cursos.devtalles.com/courses/node-clean-architecture', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de JavaScript o TypeScript:","Entender funciones, clases, módulos y tipado básico.","Familiaridad con Node.js y Express:","Haber creado rutas y manejado peticiones HTTP.","Experiencia básica con bases de datos:","Conocer conceptos de modelos, esquemas y consultas simples."}', '{}', 'Sección 1: Requisitos de instalación y materiales
- Instalaciones para seguir el curso
- Introducción Clean Architecture + Node
- Inicio de proyecto - Node + TypeScript
- Explicación de directorios a usar
- Creación de Servidor de Express
- Configurar variables de entorno
- Rutas y controladores de express
- Controladores de autenticación
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Repository Pattern
- Entidades de aplicación
- Data Transfer Objects - Dtos
- Implementar Register DTO
- Generar el DTO Desde el body de la request
- Orígenes de datos y Repositorios
- Manejo personalizado de errores
- Implementación del AuthDatasource
- Implementación del AuthRepository
- Consumir el repositorio directamente

Sección 3: Base de datos
- Configurar MongoDB con Docker
- Configurar Mongoose en Node
- Conectar Node con MongoDB
- Crear esquema y modelo de mongoose
- Crear usuario de base de datos
- Encriptar contraseñas
- Inyectar funciones como dependencias
- Mapear objetos a entidades
- Depurar aplicaciones de Node con TypeScript
- Manejo de errores HTTP

Sección 4: Generacion de Json Web Tokens
- Manejo de Json Web Tokens - Adaptador
- Generar Json Web Token
- Validar rutas usando middlewares
- Validar JWT desde el middleware
- Verificar el payload del JWT
- Genéricos en TypeScript
- Verificar usuario de base de datos con el token
- Generar semilla de JWT

Sección 5: Casos de uso
- Registar usuario - Case de uso
- Implementar Registro Use Case
- Conectar el use case en el controlador
- Tarea - Proyecto final - Login de usuario
- Resolución del proyecto final - Login de usuario
- Resolución de la tarea - Login Use Case

Sección 6: Cierre del curso
- Resumen de lo aprendido
- Código fuente de la aplicación', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (51, 'nodejs-de-cero-a-experto', 'Node.Js: De cero a experto', 'https://cursos.devtalles.com/courses/nodejs-de-cero-a-experto', 'https://import.cdn.thinkific.com/643563/w47TVfD0T6OFrOPDxYlQ_NODE%20JS%20DE%20CERO%20A%20EXPERTO.jpg', 'Portada del curso: Node.Js: De cero a experto', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende Node.js desde los fundamentos, usos comunes y no tan comunes, despliegues, construcción de imágenes, testing y muchas más habilidades que son necesarias hoy en día con este runtime-environment de JavaScript.', 2250, 'es', '{"Fundamentos de Node.js: Event Loop, File System, NPM, variables de entorno y aplicaciones de consola.","Desarrollo Backend: APIs REST, autenticación, WebSockets, Webhooks y comunicación entre servidores.","Arquitectura profesional: Clean Architecture, Domain Driven Design, Repository Pattern e inyección de dependencias.","Herramientas modernas: TypeScript, Prisma, Mongoose, PostgreSQL, MongoDB, Testing y despliegues.","Node.js y TypeScript: Interfaces, clases, tipos y buenas prácticas.","Arquitectura: Clean Architecture, Domain Driven Design y Repository Pattern.","Bases de datos: MongoDB, PostgreSQL, Prisma y Mongoose.","Backend moderno: APIs REST, autenticación con JWT, middlewares y carga de archivos.","Comunicación en tiempo real: WebSockets y aplicaciones basadas en eventos.","Testing: Pruebas unitarias, de integración, mocks, spies y cobertura.","Integraciones: GitHub Webhooks, CRON Jobs, envío de correos, Axios y Bots de Discord.","Despliegue: Railway, Netlify Edge Functions y entornos de producción.","Y mucho más...","Serás capaz de desarrollar aplicaciones backend profesionales utilizando Node.js y TypeScript.","Comprenderás cómo estructurar proyectos escalables aplicando patrones de diseño y principios de Clean Code.","Podrás construir APIs, automatizaciones, WebSockets e integraciones con múltiples servicios y bases de datos.","Contarás con una base sólida para desarrollar aplicaciones modernas preparadas para entornos de producción."}', 'https://cursos.devtalles.com/courses/nodejs-de-cero-a-experto', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de JavaScript es altamente recomendado","No es necesario saber TypeScript pero es útil","Poder realizar instalaciones en tu equipo","Es necesario tener bases de programación estructurada"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Node Version Manager - NVM
- Node Version Manager - Windows
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos de Node - Primeros pasos
- Introducción a la sección
- Temas puntuales de la sección
- Preguntas comunes sobre NodeJS
- Hello World - En Node
- Archivos de JavaScript
- Leer archivos - FileSystem
- Tarea - Contador de palabras
- Orden de ejecución - Introducción
- Node - Code Execution
- Node - Event Loop
- Código fuente de la sección

Sección 3: Desarrollando en Node
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Fundamentos
- Package.json Scripts
- Importaciones y exportaciones
- Nodemon - Paquetes de terceros
- Variables de entorno por defecto
- Depuración de aplicaciones de Node
- Callbacks
- Arrow Functions
- Factory Functions - Introducción
- Factory Functions - Necesidad
- Patrón adaptador
- Factory Functions - Aplicado
- Promesas
- Promesas en cadena
- Async - Await
- Patrón adaptador - FetchAPI
- Axios - Cliente para peticiones HTTP
- Código fuente de la sección

Sección 4: Bases de Node + TypeScript - Continuación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Node Logger - Winston
- Winston - Parte 2
- TypeScript - Proyecto básico
- Configuración de TypeScript en Node
- Creación de Scripts
- Trabajando con Node y TypeScript juntos
- Migrar proyecto a TypeScript
- Migrar proyecto - Segunda Parte
- Código fuente de la sección

Sección 5: Introducción al testing
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las pruebas automáticas
- Continuación de proyecto - Bases
- Configurar ambiente de pruebas
- Nota para próximas clases
- Arrange, Act y Assert
- Pruebas en 01-Template
- Pruebas en 02-Destructuring
- Pruebas en 03-Callbacks
- Pruebas en 03-Callbacks - Exito
- Pruebas en 05-Factory
- Pruebas en 06-Promises
- Pruebas en GetAge Adapter
- SpyOn - Métodos de objetos
- Pruebas en GetUUID Adapter
- Pruebas en HttpClient Adapter
- Pruebas en el Logger Adapter
- Testing Coverage
- Conectar Build + Testing
- Código fuente de la sección

Sección 6: Aplicación de consola - Clean Architecture - Primeros Pasos
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - MultiplicationApp
- Tarea - Impresión de consola y archivo
- Argv - Argument Values
- yargs
- Función anónima auto-invocada
- Opciones de Yargs
- Checks - Validaciones adicionales
- Usando Yargs empiricamente
- Refactorizar - Organizar lógicamente el código
- Clean Architecture - Use Cases
- CreateTable - UseCase
- SaveFile - UseCase
- Tarea - Reforzar todo lo aprendido
- Solución de la tarea
- Subir repositorio a GitHub
- Código fuente de la sección

Sección 7: Aplicación de consola - Testing
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Configurar Jest + TS
- Pruebas - CreateTable UseCase
- Pruebas - SaveFile UseCase
- Pruebas - SaveFile UseCase custom values
- SpyOn + Mock Implementation
- Pruebas - Argv
- Pruebas - Argv valores personalizados
- Pruebas - ServerApp
- ServerApp - Ejecutar proceso esperado
- ServerApp - Pruebas unitarias
- Depurando paso a paso con breakpoints
- Pruebas - App.ts
- Código fuente de la sección

Sección 8: Aplicación de Monitoreo - NOC
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a la aplicación - Clean Architecture + Repository Pattern
- Inicio de proyecto - NOC Tasks
- Main - Server App
- CRON Tasks
- CronService
- CheckService - UseCase
- JSON-Server
- Inyección de dependencias
- Cierre de sección
- Código fuente de la sección

Sección 9: Clean Architecture - Repository Pattern
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de aplicación
- LogEntity
- Datasources y Repositorios - Abstractos
- FileSystem - Datasource
- FileSystem - SaveLog
- FileSystem - GetLogs
- LogRepository - Implementation
- Inyectar repositorio en caso de uso
- Probar la implementación
- Depuración del proceso
- Variables de entorno
- Configurar variables de entorno
- Readme.md
- Código fuente de la sección

Sección 10: Correos electrónicos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Tarea - Refactorización y nueva propiedad
- Solución de la tarea
- Preparación de envío de correo
- Gmail Keys - Two-factor authentication
- Nodemailer - Gmail
- Enviar archivos adjuntos
- Inyectar Repositorio
- SendEmail - UseCase
- Resumen de lo visto
- Código fuente de la sección

Sección 11: MongoDB y PostgreSQL
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Base de datos MongoDB
- Probar MongoDB
- Node + Mongo - Mongoose
- Schema & Models Mongo
- Crear y leer de Mongo
- MongoLogDatasource
- Grabar Logs en Mongo
- LogEntity FromJson - Depuración
- PostgreSQL - Instalación
- Probar instalación de PostgreSQL
- Prisma - ORM
- Pruebas de inserción y lectura
- PosgresLog DataSource
- Grabar en Mongo, PosgreSQL y FS simultáneamente
- Cierre de la sección
- Código fuente de la sección

Sección 12: NOC - Testing - Clean Architecture
- Introducción a la sección
- Temas puntuales de la sección
- Preparación del testing
- Configurar Testing
- Montar Bases de datos y ENVs de Testing
- Pruebas en ENVs
- Pruebas en la conexión de MongoDB
- Pruebas en modelo de Mongo
- Pruebas en clases abstractas
- Pruebas en el LogEntity
- Pruebas en CheckService UseCase
- Pruebas en CheckServiceMultiple UseCase
- Pruebas en SendEmailLogs UseCase
- Pruebas en MongoLogDatasource
- Pruebas en FileSystemDatasource
- FileSystem Datasource - Pruebas faltantes
- 100% Coverage y sus implicaciones
- Pruebas en LogRepositoryImpl
- Pruebas en CronService
- Pruebas con EmailService
- Código fuente de la sección

Sección 13: WebServer - Http/Http2
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - RestWeb
- Webserver http/1
- Diferentes respuestas
- Responder demás archivos
- Http2 - OpenSSL
- Express
- Servir SPA con Router
- Variables de entorno
- Subir repositorio a GitHub
- Desplegar en Railway
- Código fuente de la sección

Sección 14: RestServer
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Rest Server
- Rutas y Controladores
- Todo Controller
- CRUD - Read
- CRUD - Create
- Crear el TODO en el arreglo
- CRUD - Actualizar
- CRUD - Delete
- Desplegar Restful API a la web
- Código fuente de la sección

Sección 15: RestServer + PostgreSQL
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de aplicación
- Base de datos - Postgres
- Prisma - Postgres
- Crear TODO
- CRUD Completo
- DTOs - Data Transfer Objects
- Update Todo DTO
- Aprovisionar base de datos en la nube
- Desplegar cambios a Railway
- Código fuente de la sección

Sección 16: Rest - Clean Architecture
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- TodoEntity
- DataSources y Repositorios
- TodoDatasource Implementation
- Finalizar la implementación
- Uso del repositorio en los controladores
- Casos de Uso
- Consumir los casos de uso
- Express Best Practices + CleanArchitecture
- Código fuente de la sección

Sección 17: Rest Testing
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Configurar testing
- Pruebas en el App.ts
- Aprovisionar Postgres
- Supertest - Pruebas sobre Restful endpoints
- Prisma en Testing
- Prueba - GET - api/todos
- Prueba - GET - api/todos/:id
- Prueba - GET - api/todos/:id - Not Found
- Prueba - Create - api/todos
- Prueba - Update - api/todos/:id
- Resolución de la tarea
- Prueba - Delete api/todos/:id
- Fix coverage
- Custom errors
- Centralizar la respuesta con error
- Código fuente de la sección

Sección 18: Autenticación y Autorización
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto
- Modulo Auth - Rutas y Controladores
- Conectar MongoDB
- User Model
- Errores personalizados
- User Entity
- Register User Dto
- AuthService
- Crear usuario y manejo de errores
- Encriptar contraseñas
- Login de usuario
- Resolución de la tarea
- Introducción a JWTs
- Generar JWTs desde nuestro backend
- JWT Seed
- Cierre de sección
- Código fuente de la sección

Sección 19: Enviar correo + Validación de Tokens
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto
- Email Service
- Enviar correo electrónico con link de verificación
- Probar envio de correo con enlace
- Validar Token y actualizar Mongo
- ngrok - Tunneling - Instalación
- Prueba real desde el celular
- VSCode Ports
- Código fuente de la sección

Sección 20: Protección de rutas, relaciones, middlewares y paginación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Preparación de los modelos restantes
- Category - Rutas y Controlador
- Create Category DTO
- AuthMiddleware - Proteger Rutas
- AuthMiddleware - Validar token
- Probar AuthMiddleware
- Crear category en base de datos
- Retornar todos las categorias
- Pagination DTO
- Aplicar la paginación
- Resumen de la sección
- Código fuente de la sección

Sección 21: Relaciones y semilla
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Rutas y controlador de productos
- Create Product Dto
- Implementar métodos del ProductService
- Validar MongoID y Crear Categoria
- Populate y propiedades adicionales
- Crear semilla para poblar base de datos
- Llenar base de datos
- Código fuente de la sección

Sección 22: Carga de archivos - Simple y Múltiple
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- FileUpload - Ruta y Controlador
- FileUpload - Service y Middleware
- Mover el archivo a su destino permanente
- Cambiar nombre y validar archivo
- Colocar archivo en sub-directorios
- Middleware de verificación de archivos
- Carga múltiple de archivos
- Middleware para verificar el tipo
- Retornar una imagen
- Otros frameworks para servidores
- Código fuente de la sección

Sección 23: WebHooks
- Introducción a la sección
- Temas puntuales de la sección
- Explicación sobre WebHooks
- Preparación de proyecto - GitHub - Webhooks
- Creación de GitHub Endpoint
- Conectar Github Webhooks con nuestro backend
- GitHub - Eventos y Payload
- Colocar tipado estricto en las respuestas
- Servicio para controlar las respuestas
- Retornar mensaje con los issues
- Discord Server y Bots
- Enviar mensaje a Discord
- Enviar gif animado a Discord
- Código fuente de la sección

Sección 24: Seguridad de Webhooks
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Generar secret token
- Autenticar las peticiones
- Código fuente de la sección

Sección 25: Edge Functions con Netlify
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - EdgeFunctions
- Instalación de NetlifyCLI
- Hola Mundo con funciones
- Variables de entorno
- Desplegar funciones en producción
- Discord messages desde Edge Functions
- Webhooks- Github hacia Netlify hacia Discord
- Código fuente de la sección

Sección 26: Websockets
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - WebSockets
- WS - Websocket Library
- Frontend - Websocket
- Enviar mensajes al servidor
- Cliente - Escuchar mensajes del servidor
- Server Broadcast
- Client Broadcast - A todos menos el emisor
- Cliente - Reconectar en caso de perder conexión
- Refactorizar el código
- Código fuente de la sección

Sección 27: RESTApi + WebSockets - Aplicación de colas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la aplicación
- Inicio de proyecto - SocketServer
- WSS - WebSocket Service
- Conectar Servidores - Express y WS
- Endpoints REST para nuestra aplicación
- Ticket Service
- Implementar el Ticket Service
- Tickets que se encuentran en pantalla
- Inicializar las rutas
- Preparación del Frontend
- Pantalla - Nuevo Ticket
- Pantalla de escritorio - Tickets pendientes
- Detalles de la pantalla de escritorio
- Solicitar Ticket para trabajar
- Marcar terminado un ticket
- Pantalla pública - Mostrar el trabajo actual
- Pantalla pública - Websockets
- Código fuente de la sección

Sección 28: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (21, 'nuxt', 'Nuxt: El marco de trabajo web progresivo (Nuxt 4+)', 'https://cursos.devtalles.com/courses/nuxt', 'https://import.cdn.thinkific.com/643563/0QSiNkebRGFH4hPY25zf_NUXT-COVER-DEVTALLES.jpg', 'Portada del curso: Nuxt: El marco de trabajo web progresivo (Nuxt 4+)', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende Nuxt.js, el framework basado en Vue.js para crear aplicaciones web rápidas, modernas y optimizadas para SEO, desde los fundamentos hasta el despliegue con SSR, SSG y API Routes.', 810, 'es', '{}', 'https://cursos.devtalles.com/courses/nuxt', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de JavaScript y/o TypeScript.","Idealmente haber usado alguna vez Vue.js, aunque el curso incluye un reforzamiento completo.","Tener instalado Node.js y un editor de código como VSCode.","No se necesita experiencia previa con Nuxt; el curso cubre conceptos desde cero y avanza hasta nivel profesional."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Reforzamiento sobre Vue.js
- Introducción
- Temas puntuales
- Inicio de proyecto - Bases de VueJS
- Componentes, props y variables reactivas
- Emitir eventos y manejo de estado
- Directivas v-if, v-for
- Composable functions
- Ciclo de vida y peticiones HTTP
- useFetch - Composable
- Implementar useFetch
- Genéricos y tipado estricto
- Reactividad y caché
- Código fuente
- Repaso interactivo: Reforzamiento sobre Vue.js

Sección 3: Nuxt - Primeros pasos
- Introducción
- Temas puntuales
- Nuxt - ¿qué es? y ¿por qué?
- Mi primer proyecto en Nuxt
- Estructura de directorios
- Vue.js con SSR - Server Side Rendering
- Estilos globales
- Despliegue de SPA
- Páginas basadas en directorios "File System"
- Páginas de error
- Navegación entre rutas - NuxtLink
- Nuxt Layout - Plantillas
- Organización de la carpeta pages
- SEO Metatags - Configuraciones globales
- Generación estática del sitio web
- Código fuente
- Repaso interactivo: Nuxt - Primeros pasos

Sección 4: NuxtUI - Estructuras y componentes
- Introducción
- Temas puntuales
- Demostración de la sección
- Continuación
- NuxtUI - Instalación y configuración
- NuxtUI - Layout y errores
- Bonus: iconos de iconify
- Diseño principal del sitio web público
- Footer - Pie de página
- Página de login y registro
- Pantalla de inicio - Estructura recomendada
- Marquee y separadores
- Cambiar el tema global
- Extraños atributos - non-props
- Diseño del panel administrativo
- Páginas de productos
- Página de producto individual
- Código fuente
- Repaso interactivo: NuxtUI - Estructuras y componentes

Sección 5: Nuxt - Server API - PostgreSQL
- Introducción
- Temas puntuales
- Continuación de proyecto
- Server endpoints
- Aprovisionar base de datos
- Prisma - NeonTech - Nuxt
- Opcional - pnpm Nuxt y Prisma
- Modelo - SiteReview
- Semilla de base de datos - Seed
- Mostrar reseñas de base de datos
- Solución a la tarea
- Código fuente
- Repaso interactivo: Nuxt - Server API - PostgreSQL

Sección 6: Server Endpoints y paginación
- Introducción
- Temas puntuales
- Continuación de proyecto
- Modelo de producto y semilla
- Server endpoint con parámetros de query
- Products Composable - Personalizado
- Parámetros de query reactivos
- Finalizar componente de paginación
- NuxtUI Table - TanStack Table
- Server Endpoint - Producto por slug
- Server Endpoint - Sugerencias por slug
- useFetch y useLazyFetch
- Componente perezoso de sugerencias
- Código fuente
- Repaso interactivo: Server Endpoints y paginación

Sección 7: Autenticación y autorización
- Introducción
- Temas puntuales
- Continuación
- Usuarios - Semilla y esquema
- Encriptar contraseñas - Hash de una sola vía
- Server Endpoint: Inicio de sesión
- Nuxt Auth
- useAuthentication - Composable personalizado
- Cookie segura de sesión
- Consumir información de sesión
- Route Middlewares
- Tarea - NotAuthenticated Middleware
- Detalles finales del inicio de sesión
- Código fuente
- Repaso interactivo: Autenticación y autorización

Sección 8: Administración de productos y carga de archivos
- Introducción
- Temas puntuales
- Continuación de proyecto
- Componentes dinámicos de Nuxt en TanStack Table
- Server Endpoint: Validar sesión en APIs
- Server API Middlewares
- Composable - Control de creación y actualización
- Pantalla de edición y creación
- Validar campos del formulario
- Server Endpoint - Patch Form-Multipart
- Server Endpoint - Patch Form-Multipart - Parte 2
- Mostrar mensaje de actualización
- Creación de producto - Forma tradicional
- Leer parámetros de query
- Código fuente
- Repaso interactivo: Administración de productos y carga de archivos

Sección 9: Carga de archivos
- Introducción
- Temas puntuales
- Continuación de proyecto
- Cloudinary - Preparar lugar de almacenamiento
- Función de carga de archivos
- Opcional - Cambiar pnpm por yarn
- Enviar y recibir archivos
- Enviar archivos a Cloudinary
- Limpieza después de cargar las imágenes
- Mostrar vistas previas locales
- Código fuente
- Repaso interactivo: Carga de archivos

Sección 10: Maestro detalle - Reseñas de productos
- Introducción
- Temas puntuales
- Continuación de proyecto
- Maestro detalle - Uno a muchos
- Seed de Reseñas de producto
- Añadir usuario a las reseñas
- Server Endpoint - Reseñas de producto
- Mostrar reseñas en pantalla
- Modal de reseñas - Preparación
- Solución a la tarea y problemas de hidratación
- Server Endpoint - Crear reseña
- Crear reseña desde el sitio web
- Código fuente
- Repaso interactivo: Maestro detalle - Reseñas de productos

Sección 11: Despliegues a producción
- Introducción
- Temas puntuales
- Continuación de proyecto
- Vista previa de producción
- Subir proyecto a GitHub
- Desplegar a Vercel
- useSEOMeta - Metadata para los productos
- Código fuente
- Repaso interactivo: Despliegues a producción

Sección 12: Despedida
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (5, 'open-code-guia-completa', 'OpenCode: Guía completa para desarrolladores de software', 'https://cursos.devtalles.com/courses/open-code-guia-completa', 'https://import.cdn.thinkific.com/643563/5VQqSJ32SE6MgrM6fHPv_COVER-DEVTALLES-OPENCODE.jpg', 'Portada del curso: OpenCode: Guía completa para desarrolladores de software', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'OpenCode, el agente de IA open source para programar desde la terminal: instalación, CLI, configuración, agentes personalizados, MCP y flujos de trabajo. Un curso práctico y orientado a proyectos reales.', 840, 'es', '{"Fundamentos de OpenCode: Instalación, configuración, interfaz TUI y comandos principales.","Desarrollo asistido por IA: Agents, MCPs, Specs, automatizaciones y flujos paralelos.","Integración profesional: Git, GitHub, Supabase, Vercel, Next.js y herramientas modernas.","Proyecto Full Stack: Desarrollo de una aplicación real utilizando IA durante todo el proceso.","OpenCode: Instalación, configuración, TUI, comandos como /redo, /undo, /compact, /init y Plan Mode.","Proyectos prácticos: Weather App, Asteroids y una aplicación Full Stack desarrollada con IA.","Git y GitHub: Worktrees, GitHub App, comandos personalizados y revisiones asistidas.","Spec Driven Development (SDD): Creación de Specs, implementación, verificación y criterios de aceptación.","Agents y MCPs: Playwright, Context7, Supabase y ampliación de capacidades mediante herramientas externas.","Proyecto OpenDayCare: Next.js, React, TypeScript, Supabase, Resend y despliegue en Vercel.","Bases de datos: Diseño de esquemas, migraciones y conexión mediante MCP.","Automatizaciones: Agentes paralelos, mejores prácticas, accesibilidad, auditorías, migraciones y tareas programadas.","Metodologías: Grill Me, OpenSpec y revisión asistida por IA.","Producción: Configuración de entornos, despliegues y revisión final.","Y mucho más...","Integrarás OpenCode de forma profesional dentro de tu flujo de trabajo diario.","Aprenderás a utilizar agentes, MCPs y automatizaciones para aumentar tu productividad.","Desarrollarás aplicaciones reales utilizando IA durante todo el ciclo de desarrollo.","Comprenderás cómo diseñar procesos modernos con Specs verificables, automatizaciones y despliegues listos para producción."}', 'https://cursos.devtalles.com/courses/open-code-guia-completa', '2026-09-24 15:49:29.94579+00', '{"Poder realizar instalaciones en el equipo (Node, Bun, entre otras por ejemplo)","Cuenta gratuita en GitHub para seguir los ejercicios prácticos con repositorios reales.","Opcional - Conocimientos básicos de JavaScript/TypeScript y desarrollo web (no se requiere experiencia previa con IA).","Opcional - Manejo básico de la terminal y comandos de Git."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: OpenCode - Instalación y configuraciones
- Introducción
- Temas puntuales
- OpenCode - Instalación inicial
- Proveedores de modelos
- Proveedor - Modelos de OpenAI
- Proveedor - OpenCode Go
- Proveedor - Modelos de Ollama
- Instrucciones globales
- Configuraciones TUI.json
- Repaso interactivo: Instalación y configuraciones

Sección 3: OpenCode 101 - Primeros pasos
- Introducción
- Temas puntuales
- ¿Cómo crece el contexto?
- TUI - Terminal User Interface
- Comandos /redo y /undo
- Comando /compact
- Comando /init - Agents.md
- Patrones a ignorar
- Plan mode: Implementar funcionalidad
- Opcional - Resultados diferentes por agentes
- Código fuente
- Repaso interactivo: OpenCode 101 - Primeros pasos

Sección 4: Aplicación de consola
- Introducción
- Temas puntuales
- Inicio de proyecto - Weather App
- Agents.md - Configuración inicial
- Planear y construir la aplicación
- Ideas, problemas y ajustes
- Tarea - Mejorar la aplicación
- Solución de la tarea - Colores
- Solución de la tarea - Pronóstico
- Estructura de archivos
- Pruebas automáticas
- GitHub Actions - Build y Release Tags
- Código fuente
- Repaso interactivo: Aplicación de consola

Sección 5: Worktrees y comandos personalizados
- Introducción
- Temas puntuales
- Inicio de proyecto - Asteroids
- Añadir power-up - Velocidad
- Tarea - Estrella Fugaz
- Git - Worktrees manualmente
- Implementar y probar cada árbol
- Unir worktrees
- Comandos personalizados
- GitHub - Integración con OpenCode
- OpenCode+GitHub - Realizar cambios en la nube
- OpenCode + GitHub - Instrucción personalizada + privilegios
- Formatear issues de GitHub
- Código fuente
- Repaso interactivo: Worktrees y comandos personalizados

Sección 6: Spec Driven Development / Design
- Introducción
- Temas puntuales
- Metodología SDD - Exposición
- Consideraciones sobre el SDD
- Agent Skills - Introducción
- Preparación de proyecto - Instalación de skills
- Opcional - Bloquear rama principal
- Spec - 4 fantasmas en juego
- Implementar - 4 fantasmas en juego
- Unir mediante un pull request
- Tarea - Corregir punto de salida de fantasmas
- Spec - Corregir punto de salida
- Tarea - Power Pellets
- Spec - Power Pellets
- Opcional - Detalles del juego
- Código fuente
- Repaso interactivo: Spec Driven Development / Design

Sección 7: MCPs y Agentes personalizados
- Introducción
- Temas puntuales
- Inicio de proyecto - OpenDayCare
- MCP - Playwright
- MCP - Context7
- Skills - spec y spec-impl
- Spec - Crear HomePage
- Impl - Crear HomePage
- Agentes en OpenCode - Spec Verifier
- Criterios de aceptación automáticos
- Tarea - Pantalla de niños y perfil
- Resolución de la tarea
- Impl - Página de Niños y Perfill
- Código fuente
- Repaso interactivo: MCPs y Agentes personalizados

Sección 8: Maquetación de OpenDayCare
- Introducción
- Temas puntuales
- Continuación de proyecto - Configuración de comandos
- Tarea - Login y activar cuenta
- Tarea - Agregar niños
- GitHub + OpenCode - Revisión de spec
- GitHub + OpenCode - Aplicar revisiones
- Tarea - Vincular padre
- Tarea - Nueva publicación
- Código fuente
- Repaso interactivo: Maquetación de OpenDayCare

Sección 9: Referencias, esquemas y Supabase
- Introducción
- Temas puntuales
- Continuación de proyecto
- Referencias externas e internas
- Supabase - Preparar y conectar MCP
- Pruebas con Supabase
- Spec - Tabla de guarderías
- Spec Impl - Tabla de guarderías
- Spec - Tabla de usuarios
- Spec Impl - Tabla de usuarios
- Conectar NextJS con Supabase
- Spec - Login de usuarios
- Spec Impl - Login de usuarios
- Tarea - Agregar niños
- Spec - Invitar padres a la plataforma
- Spec Impl - Invitar padres a la plataforma
- Configuraciones adicionales
- Código fuente
- Repaso interactivo: Referencias, esquemas y Supabase

Sección 10: Automatizaciones y agentes en paralelo
- Introducción
- Temas puntuales
- Continuación de proyecto - OpenDayCare
- Formateadores
- ¿Cómo y para qué agentes?
- Agente - Mejores practicas en React
- Invocar semi-manual los agentes
- Agente - DB Migrator
- Agente - Accessibility Checker
- Agente - Auditor de base de datos
- CRON Jobs
- Código fuente
- Repaso interactivo: Automatizaciones y agentes en paralelo

Sección 11: Metodologías Grill Me y OpenSpec
- Introducción
- Temas puntuales
- Continuación de proyecto - OpenDaycare
- Grill-me: Junto al spec driven development
- Implementar - Creación de posts
- OpenSpec - Instalación y configuración
- OpenSpec - Explore y new
- OpenSpec - Apply
- OpenSpec - Verify
- OpenSpec - Archive
- Código fuente
- Repaso interactivo: Metodologías Grill Me y OpenSpec

Sección 12: Producción
- Introducción
- Temas puntuales
- Preparación para el despliegue
- Aprovisionar base de datos en producción
- Vercel - Configurar producción
- Migrar base de datos y usuarios
- Revisar y probar en Prod
- Repaso interactivo: Producción

Sección 13: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (47, 'openai-react-nestjs', 'OpenAI: Ejercicios prácticos y asistentes con React + NestJS', 'https://cursos.devtalles.com/courses/openai', 'https://import.cdn.thinkific.com/643563/fc1kmF7dS2SQojvt7q02_OPENAI-REACT.jpg', 'Portada del curso: OpenAI: Ejercicios prácticos y asistentes con React + NestJS', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'En este curso práctico de OpenAI, aprenderás la librería de OpenAI en Node, para consumir desde un frontend en React, y así consultar información, generar imágenes, editar, generar audio basado en texto, texto a audio, configurar tu asistente y más.', 600, 'es', '{"Integración con OpenAI: Configuración del backend en NestJS para consumir la API y gestionar las respuestas de manera eficiente.","Frontend con React: Consumo de respuestas y flujos (streams) enviados desde el backend utilizando una interfaz moderna construida con React, Vite y Tailwind CSS.","Arquitectura Full Stack: Separación de responsabilidades entre cliente y servidor utilizando TypeScript en todo el proyecto.","Aplicaciones reales: Implementación de funcionalidades que aprovechan diferentes capacidades de la inteligencia artificial de OpenAI.","Procesamiento de audio: Generación de audios a partir de texto y conversión de audio a texto.","Subtítulos: Transcripciones y traducciones automáticas a diferentes idiomas.","Manejo de archivos: Carga de archivos al backend para ser procesados por OpenAI.","Generación de imágenes: Creación de nuevas imágenes, variaciones y edición mediante máscaras utilizando inteligencia artificial.","Generación de contenido: Consultas inteligentes sobre cualquier tema utilizando los modelos de OpenAI.","Asistentes personalizados: Entrenamiento con material propio, personalización de comportamiento, instrucciones y consumo de su API.","Assistant API: Creación de threads, mensajes, runs, ejecución de procesos y lectura de respuestas.","Backend personalizado: Desarrollo y consumo de una API propia en NestJS para administrar asistentes de OpenAI.","Serás capaz de integrar la API de OpenAI dentro de aplicaciones desarrolladas con Node.js, NestJS y React.","Aprenderás a construir asistentes personalizados capaces de responder utilizando información específica de tus proyectos.","Podrás desarrollar aplicaciones que generen texto, audio, imágenes y contenido inteligente mediante inteligencia artificial.","Comprenderás cómo estructurar aplicaciones Full Stack donde el backend administra toda la lógica relacionada con OpenAI y el frontend consume las respuestas de forma eficiente."}', 'https://cursos.devtalles.com/courses/openai', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de JavaScript","Saber TypeScript es opcional, pero recomendado","Conocimiento básico de Node","Conocimiento de Nest es recomendado pero no obligatorio","Haber trabajado con React con Hooks","Nota de actualización - 12 de agosto de 2025:","Debido a cambios recientes en las políticas de OpenAI, posteriores a la grabación de las clases de este curso, es importante que tengan en cuenta lo siguiente:","Para poder trabajar con su API, ahora es necesario que tu cuenta tenga un consumo mínimo equivalente a 5 USD. El crédito gratuito que antes se otorgaba a nuevos usuarios fue discontinuado desde el año 2024.","Alternativas disponibles:","Gemini flash: es gratis y fácil de configurar.","Modelos locales: instalados directamente en el equipo, pero solo lo recomendamos para usuarios avanzados.","Les mantendremos informados en caso de que esta situación cambie nuevamente. Cualquier duda al respecto, les invitamos a dejarla en el panel de consultas para que podamos asistirles con este cambio.","Atentamente,","El equipo de DevTalles"}', '{}', 'Sección 1: Introducción
- Introducción al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Nota de actualización
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Frontend - Diseño y creación de la aplicación
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - ReactGPT
- Configurar TailwindCSS en React
- Rutas y páginas
- DashboardLayout - Diseño
- Resolución de la tarea
- Diseño de la pantalla del chat
- Indicador de escritura
- Caja de envío de mensajes
- Funcionalidad de mensajes
- Mensajes con archivos
- Mensajes con selectores
- Código fuente de la sección

Sección 3: Backend - Caso de uso - Ortografía
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - NestGPT
- Rutas y CORS
- Validaciones de la petición
- Pasar argumentos del DTO al UseCase
- OpenAI - Configuración de cuenta y token
- Nuestro primer prompt
- Corrector de ortografía - Use Case
- Retornar un JSON con la información
- Postman - Guardar endpoints
- Código fuente de la sección

Sección 4: Frontend - Ortografía
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Orthography Use Case
- Mostrar la respuesta en pantalla
- Código fuente de la sección

Sección 5: Backend - ProsCons Discusser - Streams
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Tarea - ProsCons - Controller, Service y UseCase
- Solución de la tarea
- ProsCons como Stream
- Código fuente de la sección

Sección 6: Frontend - ProsCons Discusser - Streams
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Tarea - ProsCons Discusser
- Solución de la tarea
- Leer respuesta de un stream
- Mostrar respuesta conforme es generada
- Stream con función generadora
- AbortSignals - Cancelar el stream
- Código fuente de la sección

Sección 7: Backend - Traducciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del backend - Traducciones
- Tarea - Construcción del endpoint
- Solución de la tarea - Traducciones
- Código fuente de la sección

Sección 8: Frontend - Traducciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Creación del UI necesario
- Caso de uso de traducción
- Código fuente de la sección

Sección 9: Backend - Texto a audio
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección - Texto a audio
- Texto a audio - Preparación
- Generación del audio
- Enviar MP3 como respuesta
- Regresar audios previamente generados
- Código fuente de la sección

Sección 10: Frontend - Texto a audio
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de aplicación - Texto a Audio
- Preparar la pantalla de texto a audio
- Obtener audio y reproducirlo
- Código fuente de la sección

Sección 11: Backend - Audio a texto
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección - Audio a texto
- Cargar archivos de audio
- Generar transcripciones y subtítulos
- Enviar instrucciones mediante el prompt
- Código fuente de la sección

Sección 12: Frontend - Audio a texto
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación - Audio a texto
- Selección de archivo y envío al caso de uso
- Implementación del caso de uso
- Mostrar respuesta en pantalla
- Código fuente de la sección

Sección 13: Backend - Generación de imágenes
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de aplicación - Generación de imágenes
- Preparación de Endpoint, DTO y Servicio
- Obtener la imagen basado en el prompt
- Guardar las imágenes en FileSystem
- GET - Retornar imagen previamente generada
- Convertir imagen a PNG
- Editar imágenes
- Retornar el URL de nuestro servidor
- Generar variación de imagen - Endpoint
- Implementar la variación de la imagen
- Aumentar el tamaño de la petición POST
- Corrección con el URL
- Código fuente de la sección

Sección 14: Frontend - Generación y edición de imágenes
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación - Generación de imágenes
- Caso de uso - Generación de Imagen
- Mostrar imagen en pantalla
- Generación de variaciones
- Seleccionar imágenes para variaciones
- Preparar el espacio para editar imágenes
- Convertir imagen a un canvas
- Dibujar, borrar y obtener la nueva imagen
- Editar la imagen
- Código fuente de la sección

Sección 15: Backend - Asistentes de OpenAI
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a los asistentes de OpenAI
- Continuación de la aplicación - Asistentes
- Creación de asistente - Desde OpenAI
- Probar asistente
- Crear módulo - Assistant
- Crear Thread - Caso de Uso
- Crear Mensaje - Caso de Uso
- Crear Run (ejecución) - Caso de uso
- Run Complete Status - Caso de Uso
- Lista de mensajes - Caso de uso
- Código fuente de la sección

Sección 16: Frontend - Asistentes
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Creación del Thread
- Realizar pregunta - Caso de Uso
- Mostrar los mensajes en el chat
- Más información a leer
- Código fuente de la sección

Sección 17: Tareas adicionales
- Introducción a la sección
- Imagen a texto
- Código fuente de la sección

Sección 18: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (128, 'reactivex-rxjs', 'ReactiveX-RxJs: De cero - Fernando Herrera', 'https://cursos.devtalles.com/courses/reactivex-rxjs', 'https://import.cdn.thinkific.com/643563/n80W0M1gSpizBJEEgGff_LEGACY-REACTIVE.jpg', 'Portada del curso: ReactiveX-RxJs: De cero - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso de ReactiveX está orientado a enseñarte desde los fundamentos e interioridades de las extensiones reactivas hasta los detalles de la mayoría de los operadores y funciones que trabajan con observables.', 570, 'es', '{}', 'https://cursos.devtalles.com/courses/reactivex-rxjs', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción
- ¿Cómo funcionará el curso?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a las extensiones reactivas y a la programación reactiva
- Introducción a la sección
- Temas puntuales de la sección
- Conceptos generales
- ¿Qué es ReactiveX? ¿Cómo funciona?
- ¿Cómo leer los diagramas de canicas?
- Configuración del proyecto

Sección 3: Observables
- Introducción a la sección
- Temas puntuales de la sección
- Nuestro primer observable
- Observer y subscriber
- Nota: Biblioteca de ejercicios
- Subscription y unsubscribe
- Terminar observables en cadena
- Subject
- Subject - Parte 2
- Código fuente de la sección

Sección 4: Funciones para crear Observables
- Introducción a la sección
- Temas puntuales de la sección
- of
- fromEvent
- range
- interval y timer
- timer - Configuraciones especiales
- asyncScheduler
- Más ejemplos con from y of
- Código fuente de la sección

Sección 5: Operadores básicos
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son los operadores?
- map
- pluck
- mapTo
- filter
- Cadenas de operadores
- tap
- Laboratorio - ProgressBar
- Laboratorio - ProgressBar (segunda parte)
- reduce
- scan
- Código fuente de la sección

Sección 6: Operadores no tan comunes
- Introducción a la sección
- Temas puntuales de la sección
- take
- first
- takeWhile
- takeUntil
- skip
- distinct
- distinctUntilChanged
- distinctUntilKeyChanged
- Código fuente de la sección

Sección 7: Operadores que trabajan con tiempo
- Introducción a la sección
- Temas puntuales de la sección
- debounceTime
- throttleTime
- sampleTime
- sample
- auditTime
- Código fuente de la sección

Sección 8: Ajax - Peticiones ajax usando RxJs/ajax
- Introducción a la sección
- Temas puntuales de la sección
- Conceptos generales de una petición ajax usando Fetch
- Manejo de errores con el Fetch Api
- Petición usando ajax de RxJs - catchError
- getJSON
- Diferencias entre getJson y ajax
- Métodos Post, Put, Delete
- Código fuente de la sección

Sección 9: Operadores de transformación
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al problema y necesidad de operadores de transformación
- mergeAll
- Tipando los operadores
- mergeMap
- Más ejemplos con mergeMap
- switchMap
- switchMap vs mergeMap
- concatMap
- exhaustMap
- Ejercicio de comparación entre el mergeMap, switchMap y exhaustMap
- Código fuente de la sección

Sección 10: Operadores y métodos de combinación de observables
- Introducción a la sección
- Temas puntuales de la sección
- startWith
- endWith
- Lab - startWith
- concat - Función
- merge - Método
- combineLatest
- forkJoin
- forkJoin Lab - Caso de uso más común
- Código fuente de la sección

Sección 11: Ejercicios de reforzamiento
- Introducción a la sección
- Material de la sección
- Ejercicio 01 - Capitalizar
- Ejercicio 02 - Reduce
- Ejercicio 03 - Randoms
- Ejercicio 04 - Cuenta regresiva
- Ejercicio 05 - Combinar
- Ejercicio 06 - Luke Skywalker

Sección 12: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (46, 'openai-angular-nestjs', 'OpenAI: Ejercicios y asistentes con Angular + NestJS', 'https://cursos.devtalles.com/courses/openai-angular-nestjs', 'https://import.cdn.thinkific.com/643563/XUcRyW81RJS3xgf1CRNf_OPENAI-ANGULAR.jpg', 'Portada del curso: OpenAI: Ejercicios y asistentes con Angular + NestJS', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'En este curso práctico de OpenAI, aprenderás la librería de OpenAI en Node, para consumir desde un frontend en Angular, y así consultar información, generar imágenes, editar, generar audio basado en texto, texto a audio, configurar tu asistente y más.', 660, 'es', '{"Integración con OpenAI: Configuración del backend en NestJS para consumir la API y gestionar las respuestas de manera eficiente.","Frontend con Angular: Consumo de respuestas y flujos (streams) enviados desde el backend utilizando una interfaz moderna construida con Angular y Tailwind CSS.","Arquitectura Full Stack: Separación de responsabilidades entre cliente y servidor utilizando TypeScript en todo el proyecto.","Aplicaciones reales: Implementación de funcionalidades que aprovechan diferentes capacidades de la inteligencia artificial de OpenAI.","Procesamiento de audio: Generación de audios a partir de texto y conversión de audio a texto.","Subtítulos: Transcripciones y traducciones automáticas a diferentes idiomas.","Manejo de archivos: Carga de archivos al backend para ser procesados por OpenAI.","Generación de imágenes: Creación de nuevas imágenes, variaciones y edición mediante máscaras utilizando inteligencia artificial.","Generación de contenido: Consultas inteligentes sobre cualquier tema utilizando los modelos de OpenAI.","Asistentes personalizados: Entrenamiento con material propio, personalización de comportamiento, instrucciones y consumo de su API.","Assistant API: Creación de threads, mensajes, runs, ejecución de procesos y lectura de respuestas.","Backend personalizado: Desarrollo y consumo de una API propia en NestJS para administrar asistentes de OpenAI.","Serás capaz de integrar la API de OpenAI dentro de aplicaciones desarrolladas con Node.js, NestJS y Angular.","Aprenderás a construir asistentes personalizados capaces de responder utilizando información específica de tus proyectos.","Podrás desarrollar aplicaciones que generen texto, audio, imágenes y contenido inteligente mediante inteligencia artificial.","Comprenderás cómo estructurar aplicaciones Full Stack donde el backend administra toda la lógica relacionada con OpenAI y el frontend consume las respuestas de forma eficiente."}', 'https://cursos.devtalles.com/courses/openai-angular-nestjs', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de JavaScript","Saber TypeScript es opcional, pero recomendado","Conocimiento básico de Node","Conocimiento de Nest es recomendado pero no obligatorio","Conocer sobre la sintaxis de Angular","Nota de actualización - 12 de agosto de 2025:","Debido a cambios recientes en las políticas de OpenAI, posteriores a la grabación de las clases de este curso, es importante que tengan en cuenta lo siguiente:","Para poder trabajar con su API, ahora es necesario que tu cuenta tenga un consumo mínimo equivalente a 5 USD. El crédito gratuito que antes se otorgaba a nuevos usuarios fue discontinuado desde el año 2024.","Alternativas disponibles:","Gemini flash: es gratis y fácil de configurar.","Modelos locales: instalados directamente en el equipo, pero solo lo recomendamos para usuarios avanzados.","Les mantendremos informados en caso de que esta situación cambie nuevamente. Cualquier duda al respecto, les invitamos a dejarla en el panel de consultas para que podamos asistirles con este cambio.","Atentamente,","El equipo de DevTalles"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Nota de actualización
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Frontend - Diseño y creación de la aplicación
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - AngularGPT
- Configurar TailwindCSS en Angular
- Creación de las páginas principales
- Router y rutas
- Diseño y estilos
- Menú lateral
- Burbujas de chat
- TypeScript - Alias de componentes
- Indicador de escritura
- Caja de envío de mensajes
- Comunicación entre componentes
- Caja de mensaje con archivos
- Caja de mensajes con selector
- Finalizar página de ortografía
- Servicio y detalles finales
- Código fuente de la sección

Sección 3: Backend - Caso de uso - Ortografía
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - NestGPT
- Rutas y CORS
- Validaciones de la petición
- Pasar argumentos del DTO al UseCase
- OpenAI - Configuración de cuenta y token
- Nuestro primer prompt
- Corrector de ortografía - Use Case
- Retornar un JSON con la información
- Postman - Guardar endpoints
- Código fuente de la sección

Sección 4: Frontend - Ortografía
- Introducción a la sección
- Temas puntuales de la sección
- Continuacion de proyecto
- Caso de uso - Ortografía
- Consumo del caso de uso
- Mostrar respuesta en pantalla
- Código fuente de la sección

Sección 5: Backend - ProsCons Discusser - Streams
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Tarea - ProsCons - Controller, Service y UseCase
- Solución de la tarea
- ProsCons como Stream
- Código fuente de la sección

Sección 6: Frontend - ProsCons - Discusser Streams
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Angular Markdown
- Tarea - ProsCos Discusser
- Solución de la tarea
- Preparación de la aplicación para stream
- Leer respuesta como Stream
- Funciones generadoras
- Mostrar el mensaje en pantalla
- AbortSignal - Cancelar el stream
- Código fuente de la sección

Sección 7: Backend - Traducciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del backend - Traducciones
- Tarea - Construcción del endpoint
- Solución de la tarea - Traducciones
- Código fuente de la sección

Sección 8: Frontend - Traducciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Caso de uso - Traducción
- Realizar la traducción
- Código fuente de la sección

Sección 9: Backend - Texto a audio
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección - Texto a audio
- Texto a audio - Preparación
- Generación del audio
- Enviar MP3 como respuesta
- Regresar audios previamente generados
- Código fuente de la sección

Sección 10: Frontend - Texto a audio
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Caso de uso - Texto a Audio
- Mostrar audio y reproducirlo
- Código fuente de la sección

Sección 11: Backend - Audio a texto
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección - Audio a texto
- Cargar archivos de audio
- Generar transcripciones y subtítulos
- Enviar instrucciones mediante el prompt
- Código fuente de la sección

Sección 12: Frontend - Audio a texto
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Caso de uso - Audio a texto
- Mostrar respuesta en pantalla
- Código fuente de la sección

Sección 13: Backend - Generación de imágenes
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de aplicación - Generación de imágenes
- Preparación de Endpoint, DTO y Servicio
- Obtener la imagen basado en el prompt
- Guardar las imágenes en FileSystem
- GET - Retornar imagen previamente generada
- Convertir imagen a PNG
- Editar imágenes
- Retornar el URL de nuestro servidor
- Generar variación de imagen - Endpoint
- Implementar la variación de la imagen
- Aumentar el tamaño de la petición POST
- Corrección con el URL
- Código fuente de la sección

Sección 14: Frontend - Generación y edición de imágenes
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de aplicación
- Caso de uso - Generación de Imagen
- Mostrar la imagen generada
- Caso de Uso - Generación de variaciones
- Mostrar imagen original en recuadro
- Generar variación
- Transformar imagen a un canvas
- Dibujar y recordar imagen
- Editar la porción de la imagen
- Código fuente de la sección

Sección 15: Backend - Asistentes de OpenAI
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a los asistentes de OpenAI
- Continuación de la aplicación - Asistentes
- Creación de asistente - Desde OpenAI
- Probar asistente
- Crear módulo - Assistant
- Crear Thread - Caso de Uso
- Crear Mensaje - Caso de Uso
- Crear Run (ejecución) - Caso de uso
- Run Complete Status - Caso de Uso
- Lista de mensajes - Caso de uso
- Código fuente de la sección

Sección 16: Frontend - Asistentes
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Creación del Thread
- Crear el thread ID
- Realizar pregunta y mostrar los mensajes
- Más información a leer
- Código fuente de la sección

Sección 17: Tareas adicionales
- Introducción a la sección
- Imagen a texto
- Código fuente de la sección

Sección 18: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (38, 'patrones-diseno', 'Patrones de Diseño: Soluciones prácticas y eficientes', 'https://cursos.devtalles.com/courses/patrones-diseno', 'https://import.cdn.thinkific.com/643563/GAaAh0OtQAmUmEOc5qiS_COVER-PATRONES-DE-DISE%C3%91O-DEVTALLES.jpg', 'Portada del curso: Patrones de Diseño: Soluciones prácticas y eficientes', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende 24 patrones de diseño clave para resolver problemas comunes y escribir código más limpio y escalable.', 600, 'es', '{}', 'https://cursos.devtalles.com/courses/patrones-diseno', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de TypeScript es recomendado","Conocimiento de Programación orientada a objetos es recomendado","Poder realizar instalaciones en el equipo es necesario"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Preparación de proyecto
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a los patrones
- Introducción a los patrones de diseño

Sección 3: Patrones creacionales
- Patrones creacionales

Sección 4: Builder
- Builder - Patrón
- Builder - Utilización
- Builder - Tarea
- Builder - Solución a la tarea
- Nota

Sección 5: Factory Method
- Factory Method - Patrón
- Factory Method - Utilización
- Factory Method - Tarea
- Factory Method - Solución a la tarea

Sección 6: Abstract Factory
- Abstract Factory - Patrón
- Abstract Factory - Utilización
- Abstract Factory - Tarea
- Abstract Factory - Solución a la tarea

Sección 7: Prototype
- Prototype - Patrón
- Prototype - Tarea
- Prototype - Solución a la tarea

Sección 8: Inmutabilidad con copia
- Inmutabilidad con copia - Patrón
- Inmutabilidad con copia - Utilización
- Inmutabilidad con copia - Tarea
- Inmutabilidad con copia - Solución a la tarea

Sección 9: Singleton
- Singleton - Patrón
- Singleton - Utilización
- Singleton - Tarea
- Singleton - Solución a la tarea
- Singleton - Alternativo

Sección 10: Factory Function
- Factory Function - Patrón
- Factory Function - Utilización
- Factory Function - Tarea
- Factory Function - Solución a la tarea

Sección 11: Código fuente
- Punto de control - Checkpoint

Sección 12: Patrones estructurales
- Preparación y explicación

Sección 13: Adapter
- Adapter - Patrón
- Adapter - Utilización
- Adapter - Tarea
- Adapter - Solución a la tarea

Sección 14: Bridge
- Bridge - Patrón
- Bridge - Utilización
- Bridge - Tarea
- Bridge - Solución a la tarea
- Bridge - Alternativa real

Sección 15: Composite
- Composite - Patrón
- Composite - Utilización
- Composite - Tarea
- Composite - Solución a la tarea

Sección 16: Decorator
- Decorator - Patrón
- Decorator - Utilización
- Decorator - Tarea
- Decorator - Solución a la tarea

Sección 17: Facade
- Facade - Patrón
- Facade - Utilización
- Facade - Tarea
- Facade - Solución a la tarea

Sección 18: Flyweight
- Flyweight - Patrón
- Flyweight - Utilización
- Flyweight - Tarea
- Flyweight - Solución a la tarea

Sección 19: Proxy
- Proxy - Patrón
- Proxy - Utilización
- Proxy - Tarea
- Proxy - Solución a la tarea

Sección 20: Código fuente
- Punto de control

Sección 21: Patrones de comportamiento
- Preparación y explicación

Sección 22: Chain of Responsibility
- Chain of Responsibility - Patrón
- Chain of Responsibility - Utilización
- Chain of Responsibility - Tarea
- Chain of Responsibility - Solución a la tarea

Sección 23: Command
- Command - Patrón
- Command - Utilización
- Command - Tarea
- Command - Solución a la tarea

Sección 24: iterator
- iterator - Patrón
- iterator - Patrón Parte 2
- iterator - Utilización
- iterator - Alternativo en JS/TS
- iterator - Tarea
- iterator - Solución a la tarea

Sección 25: Mediator
- Mediator - Patrón
- Mediator - Utilización
- Mediator - Tarea
- Mediator - Solución a la tarea

Sección 26: Memento
- Memento - Patrón
- Memento - Utilización
- Memento - Tarea
- Memento - Solución a la tarea

Sección 27: Observer
- Observer - Patrón
- Observer - Utilización
- Observer - Tarea
- Observer - Solución a la tarea

Sección 28: State
- State - Patrón
- State - Patrón Parte 2
- State - Utilización
- State - Tarea
- State - Solución a la tarea

Sección 29: Strategy
- Strategy - Patrón
- Strategy - Utilización
- Strategy - Tarea
- Strategy - Solución a la tarea

Sección 30: Template Method
- Template Method - Patrón
- Template Method - Utilización
- Template Method - Tarea
- Template Method - Solución a la tarea

Sección 31: Visitor
- Visitor - Patrón
- Visitor - Utilización
- Visitor - Tarea
- Visitor - Solución a la tarea

Sección 32: Código fuente
- Punto de control

Sección 33: Fin del curso
- Más información sobre nuestros otros cursos
- Cierre del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (13, 'php-moderno', 'PHP moderno: Empieza tu camino en el lenguaje', 'https://cursos.devtalles.com/courses/PHP-moderno', 'https://import.cdn.thinkific.com/643563/eQFwBD7MQhivG5bVLTx1_php.png', 'Portada del curso: PHP moderno: Empieza tu camino en el lenguaje', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende PHP moderno desde cero y con buenas prácticas. Domina fundamentos, control de flujo, funciones, POO, Composer, APIs y base de datos, hasta desplegar tu primer backend real y listo para producción. Ideal para iniciar tu camino profesional.', 600, 'es', '{}', 'https://cursos.devtalles.com/courses/PHP-moderno', '2026-09-24 15:49:29.94579+00', '{"Programación para principiantes primeros pasos (opcional)","No se requiere experiencia previa en PHP; aprenderás el lenguaje paso a paso desde los fundamentos.","Conocimientos básicos de programación o lógica de programación serán útiles, pero no obligatorios.","Tener instalado un editor de código, preferiblemente Visual Studio Code.","Ganas de aprender y practicar escribiendo código durante el curso."}', '{}', 'Sección 1: Introduction
- Bienvenido al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Intalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos de PHP moderno
- Introducción
- Temas puntuales
- ¿Qué es PHP?
- Agregar PHP de XAMPP al PATH
- Sintaxis básica y comentarios
- Variables y tipos de datos
- Variables y tipos de datos (continuación)
- Strings y concatenación
- Tipado estricto
- Operadores
- Operadores (pruebas)
- Código de la sección

Sección 3: Control de flujo
- Introducción
- Temas puntuales
- Condicionales if y else
- Condicionales switch y match
- Bucles (for, while, foreach)
- Break y continue
- Break y continue casos prácticos
- Código de la sección

Sección 4: Arrays y funciones útiles
- Introducción
- Temas puntuales
- Arrays
- Funciones útiles para arrays
- Funciones útiles para arrays (continuación)
- Casos de uso: Validar datos requeridos formulario
- Tarea: Preparar datos y filtrar stock
- Ordenar y buscar
- Código de la sección

Sección 5: Manejo básico de errores
- Introducción
- Temas puntuales
- Errores comunes
- Errores comunes (continuación)
- Introducción a try / catch (manejo controlado de errores)
- Revisión de código base
- Manejando errores comunes
- Manejando errores comunes (continuación)
- Validación de formulario (evitar errores antes de que ocurran)
- Código de la sección

Sección 6: Funciones e incluir archivos
- Introducción
- Temas puntuales
- Funciones básicas
- Parámetros, retorno y argumentos nombrados
- Funciones anónimas y de flecha
- Scope y variables
- Scope en funciones anónimas y funciones de flecha
- Validar y sanitizar información
- Incluir archivos
- Caso de uso: Procesar una orden de compra
- Calcular subtotal de los productos
- Aplicar descuento y cálculo con impuesto
- Tarea: procesar orden y prueba
- Código de la sección

Sección 7: Programación Orientada a Objetos (POO)
- Introducción
- Temas puntuales
- ¿Por qué POO en PHP?
- Clases y objetos
- Propiedades y métodos
- Constructores
- Visibilidad (public, private) y encapsulación
- Herencia
- Interfaces
- Clases abstractas
- Caso de uso: Reserva de habitación
- Código de la sección

Sección 8: Composer
- Introducción
- Temas puntuales
- ¿Qué es Composer?
- Instalación e inicialización de Composer
- Agregar librería
- Namespaces
- Autoloading (PSR-4)
- Código de la sección

Sección 9: Backend práctico: API simple
- Introducción
- Temas puntuales
- Introducción cliente servidor
- Requests y responses
- JSON entrada y salida
- Endpoints básicos (GET / POST)
- Validaciones
- Manejo de errores en la API
- Código de la sección

Sección 10: API productos
- Introducción
- Temas puntuales
- Bootstrap de la API
- Routing
- Respuestas JSON: respondJson y respondError
- Leer body JSON: readJsonBody
- Persistencia simple: loadProducts y saveProducts
- READ: listar y obtener por id
- CREATE: post
- UPDATE: put vs patch
- DELETE
- Código de la sección

Sección 11: Base de datos con MariaDB
- Introducción
- Temas puntuales
- Introducción bases de datos
- Fundamentos de SQL: CRUD
- Creación base de datos y tabla products
- Conexión usando PDO
- Implementando GET /products
- Implementando GET /products/{id}
- Implementando POST products
- Implementando put y patch
- Implementando delete
- Refactorización separación de responsabilidades
- Código de la sección

Sección 12: Introducción a Laravel
- Introducción
- Temas puntuales
- Introducción a Laravel
- Instalación global de composer
- Instalación de Laravel
- Preparar Laravel para API
- Generar modelo, migración, controlador
- Migración tabla products
- Modelo Product
- Controlador ProductController
- Crear producto
- Actualizar producto
- Borrar producto
- Seeders: datos iniciales
- Código de la sección

Sección 13: Despliegue en producción
- Desplegar API en producción
- Desplegar API en producción (continuación)

Sección 14: Fin de curso
- Más información sobre nuestros otros cursos
- Fin de curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (20, 'net-pruebascompletas', '.NET: Pruebas completas para minimal API', 'https://cursos.devtalles.com/courses/net-pruebascompletas', 'https://import.cdn.thinkific.com/643563/h80J6Pb5SHeRvZM6pdz5_NET-PRUEBAS-MINIMAL-API.jpg', 'Portada del curso: .NET: Pruebas completas para minimal API', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este curso te enseña a crear pruebas automatizadas para Minimal APIs en .NET de forma práctica y directa. Aprenderás a validar comportamientos, estructurar servicios y asegurar la calidad de tus aplicaciones desde el inicio.', 360, 'es', '{}', 'https://cursos.devtalles.com/courses/net-pruebascompletas', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de C# y .NET, no es necesario ser experto.","Nociones básicas de programación, como variables, condicionales y bucles.","Tener instalado Visual Studio Code y .NET 8, el curso guía paso a paso todo el proceso de configuración.","Interés en aprender pruebas automatizadas y buenas prácticas, con disposición para practicar y aplicar los conceptos en ejemplos reales."}', '{}', 'Sección 1: Introducción
- Bienvenido al curso .NET: Pruebas completas para minimal API
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Nota de actualización: Trabajar con solution explorer
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a pruebas - Parte 1
- Introducción a la sección
- Temas puntuales
- Introducción a las pruebas, tipos y AAA
- Introducción a xUnit
- Creación de proyectos
- Primera prueba (¿el proyecto de pruebas funciona?)
- Código base del dominio: productos y servicio
- Clase de pruebas para ProductService
- Todos cumplen la condición (Assert.All + Assert.True)
- No contiene productos más baratos (Assert.DoesNotContain)
- Caso sin resultados (Assert.Empty)
- Comprobar la cantidad esperada (Count + Assert.Equal)
- Verificar el contenido y el orden exacto (Assert.Collection)
- Clase CustomerNameService
- Clase de tests y primer test CustomerNameService
- Manejo de espacios extra (Trim)
- Aserciones con StartsWith y EndsWith
- Prueba con Contains
- Iniciales correctas (string)
- Iniciales devuelven null en casos inválidos (null / whitespace)
- Misma lógica, pero con [Theory] e [InlineData]
- Nombre completo válido (Assert.True)
- Casos inválidos (Assert.False + Theory)
- Código de la sección

Sección 3: Introducción a pruebas - Parte 2
- Introducción a la sección
- Temas puntuales
- Clase DiscountService (Tarea)
- Clase de tests para DiscountService y primer test
- Adulto estándar sin años de fidelidad
- Adulto mayor con descuento base
- Bonus por fidelidad (Theory con varios casos)
- Descuentos siempre en un rango válido (Assert.InRange)
- Excepción para edad y años negativos (Assert.Throws)
- Casos límite para edades (bordes de los rangos)
- Clases Customer, LoyalCustomer y CustomerFactory
- Es del tipo cliente normal
- Es del tipo cliente leal (Tarea)
- Theory optimizando para múltiples escenarios
- Código fuente

Sección 4: Creación de proyecto Minimal API
- Introducción a la sección
- Temas puntuales
- ¿Qué es Minimal API? Comparativa con Standard API
- Creando un proyecto con Minimal API
- Limpieza y adaptación del proyecto base
- Preparar la estructura de directorios por Features
- Productos: agregar modelos
- Productos: agregar datos
- Productos: implementar servicios
- Productos: agregar endpoints (listar, obtener, crear)
- Productos: agregar endpoints (actualizar y borrar)
- Clientes: agregar modelos
- Clientes: agregar datos
- Clientes: implementar servicios
- Clientes: agregar endpoints
- Órdenes: agregar modelos
- Órdenes: agregar datos
- Órdenes: implementar servicios
- Órdenes: agregar endpoints
- Agregar documentación del proyecto
- Código de la sección

Sección 5: Pruebas unitarias a la minimal API
- Introducción a la sección
- Temas puntuales
- ¿Por qué testear una Minimal API?
- Crear proyecto de pruebas y dependencias necesarias
- Usings globales para las pruebas
- Pruebas servicios productos
- Pruebas endpoints de productos
- Pruebas endpoints producto por id
- Pruebas creación producto
- Pruebas actualización producto
- Pruebas actualización producto no encontrado
- Pruebas borrar producto
- Pruebas servicios clientes
- Prueba endpoint clientes
- Pruebas endpoint cliente por Id
- Pruebas servicios órdenes
- Prueba endpoint órdenes
- Código de la sección

Sección 6: Pruebas de Integración con WebApplicationFactory
- Introducción a la sección
- Temas puntuales
- Introducción a pruebas de integración y WebApplicationFactory
- Instalar dependencia y configurar los usings
- Crear CustomWebApplicationFactory
- Pruebas listar clientes
- Pruebas obtener cliente
- Pruebas crear producto
- Pruebas actualizar producto
- Pruebas borrar producto
- Pruebas para órdenes
- Código de la sección

Sección 7: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (61, 'programacion-para-principiantes', 'Programación para principiantes - Fernando Herrera', 'https://cursos.devtalles.com/courses/programacion-para-principiantes', 'https://import.cdn.thinkific.com/643563/slRm7OvQRZySnHeaaw0w_PROGRAMACION%20PARA%20PRINCIPIANTES.jpg', 'Portada del curso: Programación para principiantes - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este curso de programación para principiantes, tiene por objetivo brindarte una base para comenzar tu camino en el desarrollo de aplicaciones de cualquier tipo.', 480, 'es', '{"Fundamentos de programación: Variables, constantes, tipos de datos, estructuras de control y funciones.","Programación moderna: JavaScript, TypeScript, objetos, clases, módulos y arreglos.","Proyecto práctico: Desarrollo de un juego y despliegue en la nube.","Primeros pasos en desarrollo: Introducción a React y Node.js.","Conceptos fundamentales: Lenguajes de programación, variables, constantes y librerías.","Programación: Funciones, ciclos, decisiones, arreglos, objetos y clases.","Estructuras de control: Lógica para resolver problemas paso a paso.","Proyecto final: Creación y despliegue de un juego web.","Introducción a tecnologías modernas: React y Node.js.","Y mucho más...","Comprenderás los fundamentos de la programación desde cero.","Desarrollarás la lógica necesaria para aprender cualquier lenguaje o tecnología en el futuro.","Crearás tu primera aplicación y adquirirás una base sólida para continuar especializándote.","Estarás preparado para iniciar tu camino en el desarrollo de software con confianza."}', 'https://cursos.devtalles.com/courses/programacion-para-principiantes', '2026-09-24 15:49:29.94579+00', '{"Debes poder realizar instalaciones en el equipo","Para seguir el curso, pueden hacerlo en Windows, OSX o Linux","Ganas de aprender a programar"}', '{}', 'Sección 1: Introducción al curso
- Introducción al curso
- ¿Cómo funcionará este curso?
- ¿Cómo realizar preguntas?
- Antes de comenzar con el curso
- Instalaciones requeridas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Primeros pasos en lógica y corriendo nuestro primer programa
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son lenguajes de programación?
- Lógica para resolver problemas
- Ejecutando nuestro primer programa
- Hola Mundo
- Configurar aplicación de Node
- Programación de manera secuencial
- Breve introducción a funciones
- Errores a la hora de escribir código
- Imprimir número de línea
- Código fuente de la sección
- Repaso interactivo: Primeros pasos en lógica y corriendo nuestro primer programa

Sección 3: Tipos de datos y flujo de control
- Introducción a la sección
- Temas puntuales de la sección
- Reglas para nombrar variables y constantes
- Tipos de datos
- Continuación de proyecto
- Ejemplo práctico de tipos de datos
- Continuación de ejemplo
- Estructuras de control - Decisiones
- Ejemplo de estructuras de control - IF
- If else anidado
- Tarea - If else
- Switch
- Ciclos o Loops
- Ciclo While
- Ciclo Do While
- Ciclo for
- Tarea - Ciclos
- Código fuente de la sección
- Repaso interactivo: Tipos de datos y flujo de control

Sección 4: Funciones y arreglos
- Introducción a la sección
- Temas puntuales de la sección
- Explicación sobre funciones
- Continuación de la aplicación
- Funciones
- Ejemplo de función
- Separar código en varios archivos
- Tarea - Tabla de multiplicar
- Explicación sobre arreglos
- Ejercicio básico de arreglos
- Tarea sobre arreglos
- Respaldo de código
- Código fuente de la sección
- Repaso interactivo: Funciones y arreglos

Sección 5: Objetos y Clases
- Introducción a la sección
- Temas puntuales de la sección
- Explicación sobre objetos
- Continuación del ejercicio
- Objetos literales en JavaScript / TypeScript
- Ejercicio práctico sobre objetos
- Arreglos de objetos
- Explicación sobre las clases
- Clases en programación
- Métodos de clase
- Métodos con argumentos
- Argumentos al constructor
- Nivel de acceso a propiedades y métodos
- Código fuente de la sección
- Repaso interactivo: Objetos y Clases

Sección 6: Ejercicios de programación - lógica
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación y PDF con los ejercicios
- Tarea 1 - Convertir de Libras a Kilogramos
- Tarea 2 - Convertir de kilómetros a millas
- Tarea 3 - área de un triángulo rectángulo
- Tarea 4 - ¿Cuál es el número mayor?
- Tarea 5 - Par e Impar
- Tarea 6 - Impresión de tabla
- Tarea 7 - Número mayor
- Tarea 8 - Nombre más largo
- Tarea 9 - Empiezan con una letra
- Código fuente de la sección
- Repaso interactivo: Ejercicios de programación - lógica

Sección 7: Creación de un juego de ahorcado - React
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - React App
- Introducción al proyecto
- Recursos del ahorcado
- Mostrar imágenes del ahorcado
- Manejar los intentos fallidos
- Manejar la palabra oculta
- Lógica para la palabra oculta
- Mostrar letras correctas en pantalla
- Mensaje de ganar o perder
- Seleccionar una palabra aleatoriamente
- Reiniciar el juego
- Desplegar juego a internet
- Código fuente de la sección
- Repaso interactivo: Creación de un juego de ahorcado - React

Sección 8: Fin del curso
- Más información sobre nuestros otros cursos
- Cierre del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (33, 'python', 'Python: Fundamentos hasta los detalles', 'https://cursos.devtalles.com/courses/python', 'https://import.cdn.thinkific.com/643563/gG1fvaYXRNmKMJTaMHYP_PYTHON-COVER%20(1).jpg', 'Portada del curso: Python: Fundamentos hasta los detalles', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende las bases de Python: variables, estructuras de control, ciclos, funciones, POO, errores, módulos y entornos virtuales. Ideal para principiantes o quienes desean reforzar conceptos con ejemplos prácticos y aplicar Python en distintas áreas.', 930, 'es', '{}', 'https://cursos.devtalles.com/courses/python', '2026-09-24 15:49:29.94579+00', '{"No se necesita experiencia previa en programación.","Tener una computadora con Windows, macOS o Linux.","Acceso a internet para instalar Python y un editor de código como VSCode.","Curiosidad y disposición para resolver problemas prácticos con código."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo realizar el curso y no desistir?
- Preguntas en el curso
- Instalación de Python en Windows
- Instalación de Python en MacOs
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Primeros pasos
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Python? y ¿Por qué usarlo?
- Ejecutar un programa en Python
- Primer Programa: Hola Mundo
- Comentarios en Python
- ¿Qué es una variable?
- Variables
- Tipos de datos básicos
- Todo en Python es un objeto
- Cadenas de texto
- Formatted Strings
- String Indexes
- String Indexes ejercicio
- Inmutabilidad
- Conversiones
- Operadores matemáticos básicos
- Funciones incorporadas
- Ingresar datos input()
- Ejercicio práctico
- Código fuente
- Preguntas: Primeros Pasos

Sección 3: Condicionales
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es una condicional?
- Condicional: If
- Condicional: elif
- Operador ternario
- Truthy vs Falsey
- None
- Operadores lógicos
- Operadores de comparación
- Operadores de pertenencia
- is vs ==
- Short Circuiting
- Control de flujo
- Ejercicio práctico
- Código fuente
- Preguntas: Condicionales

Sección 4: Listas
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es una lista?
- Listas
- List Slicing
- List Slicing - Solución al ejercicio
- Listas - Métodos de agregación
- Listas - Métodos de eliminación
- Listas - Métodos de búsqueda
- Listas - Métodos de ordenamiento
- Listas - Otras aplicaciones
- Matrices
- List unpacking
- Tarea de listas: Instrucciones
- Tarea de listas: Solución
- Código fuente
- Preguntas: Listas

Sección 5: Diccionarios
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son los diccionarios?
- Diccionarios
- Diccionarios: Keys
- Diccionarios - Métodos búsqueda
- Diccionarios - Métodos de agregación y eliminación
- Ejercicio práctico con diccionarios
- Código fuente

Sección 6: Tuplas y Sets
- Introducción a la sección
- Temas puntuales de la sección
- Tuplas
- Sets
- Sets: Métodos - Parte 1
- Sets: Métodos - Parte 2
- Sets: Métodos - Parte 3
- Sets: Ejercicio
- Convertidores de Estructuras de Datos
- Comparativa de Estructuras de Datos
- Código fuente

Sección 7: Loops (Ciclos, Bucles)
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son los loops (bucles)?
- Ciclo For
- Iterables
- Iterando con Range()
- Enumerate
- Ciclo While
- Break, Continue y Pass
- For vs While
- Listas anidadas
- Diccionarios anidados
- Mejorando ejercicio con ciclos
- Tarea de ciclos
- Código fuente
- Preguntas: Loops

Sección 8: Funciones
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es una función?
- Return
- Parámetros vs Argumentos
- Default Parameter y Keyword Argument
- Docstring
- Scopes
- Global Keyword
- Nonlocal keyword
- *args y **kwargs
- Tarea de funciones: Instrucciones
- Tarea de funciones: Solución
- Código fuente
- Preguntas: Funciones

Sección 9: Programación Orientada a Objetos (Parte 1)
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es la Programación Orientada a Objetos?
- Clases
- Constructores (__init__)
- Creando mi primer objeto
- Atributos y métodos públicos
- Atributos y métodos protegidos
- Atributos y métodos privados
- @classmethod
- @staticmethod
- Ejemplo @classmethod y @staticmethod
- Funciones vs Métodos
- Código fuente
- Preguntas: POO parte 1

Sección 10: Programación Orientada a Objetos (Parte 2)
- Introducción a la sección
- Temas puntuales de la sección
- Pilares de la Programación Orientada a Objetos
- Abstracción
- Encapsulación
- Herencia
- Polimorfismo
- Object Introspection
- Super()
- Herencia multiple
- Composition
- Clase abstracta
- Interfaz
- Dunder Methods
- Código fuente

Sección 11: Manejo de errores
- Introducción a la sección
- Temas puntuales de la sección
- Errores comunes
- Try - Catch
- Else - Finally
- Errores personalizados
- Ejercicio de manejo de errores
- Código fuente

Sección 12: Librerías, módulo y paquetes
- Introducción a la sección
- Temas puntuales de la sección
- Módulos
- Paquetes
- Name
- Formas de importar
- Defined Modules
- Pip
- Package Index
- Código fuente

Sección 13: Entornos Virtuales
- Introducción a la sección
- Temas puntales de la sección
- Virtual Environments
- Pipenv
- Entrar al environment con Poetry
- Poetry
- Código fuente

Sección 14: Manejo de Archivos
- Introducción a la sección
- Temas puntuales de la sección
- File
- Read, Write y Append
- File path
- File errors
- Archivo CSV
- Archivo JSON
- Archivo Logs
- Archivo Script
- Archivo PDF
- Ejemplo: Traductor
- Código fuente

Sección 15: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (32, 'react-router', 'React Router: Navegación declarativa y framework', 'https://cursos.devtalles.com/courses/react-router', 'https://import.cdn.thinkific.com/643563/0gGwQplTkS4tKB7oNc5K_COVER-DEVTALLES-REACT_ROUTER.jpg', 'Portada del curso: React Router: Navegación declarativa y framework', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a trabajar con React Router tanto como librería para proyectos tipo SPA o trabajarlo cómo Framework y obtener el máximo provecho de server actions, route modules, pre-rendering y mucho más!', 450, 'es', '{}', 'https://cursos.devtalles.com/courses/react-router', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de React:","Saber usar useState, useEffect, props y componentes funcionales.","Experiencia previa con JavaScript (al menos las bases):","Entender conceptos como funciones flecha, async/await y módulos ES6.","Familiaridad con HTML, CSS y herramientas como Vite o npm:","Poder iniciar proyectos, instalar paquetes y aplicar estilos básicos"}', '{}', 'Sección 1 - Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo realizar preguntas?
- Instalaciones recomendadas
- Tutorial oficial de React Router
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2 - React Router - Librería vs Framework
- Librería (Declarativa) vs Framework

Sección 3 - Declarativa - Preparación de proyecto
- Introducción
- Temas puntuales
- Inicio de proyecto - SupportChat
- Opcional - Cursor_ai: .cursorRules
- Diseño del login
- Diseño del chat
- Código fuente

Sección 4 - Declarativa - React Router
- Introducción
- Temas puntuales
- Inicio de proyecto - SupportChat
- React Router - Instalación y configuración
- Rutas hijas
- Carga perezosa de rutas
- useNavigate - Navegación manual
- Parametros por URL - Segmentos de ruta
- Separación de componentes adicionales
- Código fuente

Sección 5 - Declarativa - Protección y estados
- Introducción
- Temas puntuales
- Fake backend y fake data
- TanStack Query
- Mostrar listado de clientes
- useParams - Seleccionar el cliente activo
- Mostrar tarjeta del cliente
- Página de chat
- Rutas privadas
- Simulación de autenticación
- Invalidar queries
- Cerrar sesión
- Mutación - Enviar mensaje
- Código fuente

Sección 6 - Framework - Preparación de proyecto
- Introducción
- Temas puntuales
- Inicio de proyecto - SupportChat
- Opcional - Cursor_ai: .cursorRules
- Routing y Route Module
- Routing y Route Module - Parte 2
- Auth Layout
- Diseño de AuthLayout, Login y Register
- Chat Layout - Nested Routes
- Solución a la tarea - Diseño del Chat
- Navegar entre pantallas - Link, NavLink y useNavigate
- Cerrar sesión
- Código fuente

Sección 7 - Framework - Server side - Route Module
- Introducción
- Temas puntuales
- Continuación - Componentes de UI adicionales
- Fake backend
- Route Module - loader function
- Route Module - Configuración de ruta
- Metadata, Headers, Links y HydrateFallback
- Argumentos dinámicos - Segmentos de ruta
- Client y Server Actions
- Reaccionar durante una acción
- Código fuente

Sección 8 - Framework - Autenticación y sesiones
- Introducción
- Temas puntuales
- Continuación del proyecto - Sesiones
- Session Server - Servidor de manejo de sesiones
- Creación de sesión de usuario
- Cerrar sesión
- Solución a la tarea - Cerrar sesión
- Credenciales incorrectas - Login
- Código fuente

Sección 9 - Framework - Chat y despliegues
- Introducción
- Temas puntuales
- Continuación de proyecto - Usuario conectado
- Indicador de transición
- useLoaderData - Información del loader más cercano
- Formatear fechas
- Mostrar y crear mensajes de chat
- Prevenir carga del cliente en posteo
- Estrategias de renderizado
- Pre-renderizado de rutas dinámicas.
- Carga a GitHub
- Generar imagen de docker del proyecto
- Despliegue de la aplicación
- Código fuente

Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (8, 'python-ia-aplicada', 'Python: Inteligencia artificial aplicada', 'https://cursos.devtalles.com/courses/python-ia-aplicada', 'https://import.cdn.thinkific.com/643563/S221KTnsQESSijuA5CPO_COVER-DEVTALLES-python-ia.jpg', 'Portada del curso: Python: Inteligencia artificial aplicada', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Curso práctico de Python aplicado a IA: crea agentes, domina prompts, usa OpenAI, implementa RAG, orquesta con LangChain y despliega con FastAPI. Aprende a llevar IA real a producción con proyectos útiles.', 1110, 'es', '{"Introducción a la IA Aplicada: APIKey de OpenAI, Tokens y LLM.","Prompts: Zero-shot, Few-shot, Chain-of-Thought, Prompt template y System prompt (Roles).","Técnicas Avanzadas de Prompts: JSON return y Function calling.","RAG (Retrieval-Augmented Generation):
Bases de datos vectoriales
Embeddings e Indexación
Chroma DB
Similitud coseno","Bases de datos vectoriales","Embeddings e Indexación","Chroma DB","Similitud coseno","LangChain: LCEL (LangChain Expression Language).","Memoria Persistente: SQLite y PostgreSQL.","LangGraph: Nodos, Edges y Estados.","Y muchas cosas más…","Enfrentar proyectos y tareas sencillas con Python e IA","Postular a empleos como AI Engineer","Ser parte esencial de un equipo de desarrollo","O incluso lanzar tus propios proyectos que necesiten de la IA de forma personalizada."}', 'https://cursos.devtalles.com/courses/python-ia-aplicada', '2026-09-24 15:49:29.94579+00', '{"Python Fundamentos (Básico-Intermedio o intermedio)","Fundamentos de bases de datos.","Ingeniería de prompts (Deseable, no obligatorio)"}', '{}', 'Sección 1: Introducción al curso
- Bienvenida al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Requisitos del curso y software a utilizar
- Instalaciones recomendadas

Sección 2: Fundamentos
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- IA Aplicada vs Machine Learning
- Creando proyecto
- Obtener APIKey de OpenAI
- Tu primera llamada a la API
- Solución al ejercicio y uso de tokens
- Manejo de errores con la API
- Temperature
- Proyecto - CLI Chatbot - Crear clase
- Proyecto - CLI Chatbot - Obtener costos
- Proyecto - CLI Chatbot - Función main
- Código fuente de la sección
- Repaso interactivo: Fundamentos

Sección 3: Prompts para desarrolladores
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- Prompts para desarrolladores
- Rol: User
- Rol: System
- Rol: Assistant
- Aplicando roles y prompts
- Helper: Creación de cliente
- Técnicas de prompting
- Zero-shot
- Few-shot
- Chain-of-Thought
- Prompt Templates - Creando template
- Prompt Templates - Ejecutar prompt
- Código fuente de la sección
- Repaso interactivo: Prompts para desarrolladores

Sección 4: Técnicas de Prompts avanzados (JSON, Function calling)
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- Retornar formato: texto
- Retorno formato: JSON
- Extractor de noticias
- Servicio - Obtener noticias por API
- Extractor de noticias por API
- Function Calling - Introducción
- Function Calling -Tools y función principal
- Function Calling - Dispatcher y loop de ejecución
- Function Calling - Ejecutando tool
- Function Calling - Servicio API
- Function Calling - Utilizando servicio
- Código fuente de la sección
- Repaso interactivo: Técnicas de Prompts avanzados (JSON, Function calling)

Sección 5: Memoria y Contexto - RAG (Retrieval Augmented Generation)
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- Introducción a RAG
- El problema de la ventana de contexto
- Embeddings
- Similitud coseno
- Similitud coseno - parte 2
- Demostración de búsqueda semántica
- Bases de datos vectoriales
- ChromaDB - Teoría
- ChromaDB - Configurando la base de datos
- ChromaDB - Agregar documentos
- ChromaDB - Buscar documentos similares
- ChromaDB - Demo completa
- ChromaDB - Analizando base de datos vectorial
- RAG pipeline - Crear proyecto
- RAG pipeline - Indexación
- RAG pipeline - Consulta
- RAG pipeline - Respuesta - Contexto
- RAG pipeline - Generar respuesta con el LLM
- RAG pipeline - Demo completa
- Código fuente de la sección
- Repaso interactivo: Memoria y Contexto - RAG (Retrieval Augmented Generation)

Sección 6: Proyecto - RAG - Chatea con PDFs
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- Imports y configuración
- PDFProcessor
- IndexRegistry - Guardar de archivo a memoria
- IndexRegistry - Guardar de memoria a archivo
- IndexRegistry - Métodos de indexado y properties
- ChatWithPDFs - Constructor
- Indexar PDFs - Verificar PDFs indexados
- IndexarPDFs - Generar chunks de PDFs
- Mostrar estatus
- Método Chat
- Método Chat - Parte 2
- Main y Demo
- Código fuente de la sección
- Repaso interactivo: Proyecto - RAG - Chatea con PDFs

Sección 7: Introducción a LangChain
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- Introducción a LangChain
- Arquitectura del proyecto
- LangChain charla rápida (opcional)
- Nota de actualización - LangChain
- UV Gestor de paquetes
- Creando proyecto y primeras instalaciones
- Archivo de configuración
- Cliente LLM (centralizado)
- Demo LCEL - Main Function
- Cadena simple
- Inspección de pasos
- Batch
- Streaming
- Passthrough
- Código fuente de la sección
- Repaso interactivo: Introducción a LangChain

Sección 8: LangChain memoria persistente
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- Memoria persistente
- Interfaz base para memoria
- Memoria usando SQLite
- Instalación PostgreSQL con Docker
- Posibles problemas al usar PostgreSQL con Docker y en local
- Memoria usando PostgreSQL
- Módulo de memoria para importación
- Cadena base del asistente
- Demo Chatbot - Construir chatbot
- Demo Chatbot - Chat session
- Demo Chatbot - Chat session - parte 2
- Demo Chatbot - Main y pruebas
- Demo Chatbot - Pruebas con PostgreSQL
- Código fuente de la sección
- Repaso interactivo: LangChain memoria persistente

Sección 9: LangChain + RAG
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- Embeddings - Vector Store
- Pipeline RAG - Format Docs
- Pipeline RAG con LangChain
- Document loader - Cargar archivo
- Document loader - Cargar directorio
- Document loader - Split documents
- Demo RAG - Indexar documentos
- Demo RAG - Fuentes consultadas
- Demo RAG - Comandos especiales
- Demo RAG - Generar respuesta
- Código fuente de la sección
- Repaso interactivo: LangChain + RAG

Sección 10: LangGraph
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir?
- ¿Qué es LangGraph?
- Estados
- Nodo - Analizar pregunta
- Nodo - Recuperar documentos
- Nodo - Generar respuesta
- Función de decisión para Edge Conditional
- Construir agente RAG
- Módulo de grafos LangGraph
- Demo LangGraph - Setup Vectorstore
- Demo LangGraph - Memory Backend
- Demo LangGraph - Gestión de sesiones
- Demo LangGraph - Cargar historial
- Demo LangGraph - Guardar mensajes
- Demo LangGraph - Run Chat - Comandos especiales
- Demo LangGraph - Run Chat - Invocar Grafo
- Demo LangGraph - Run Chat - Respuesta
- Demo LangGraph - Main
- Demo LangGraph - Solucionando errores
- Demo LangGraph - Probando flujo completo
- Código fuente de la sección
- Repaso interactivo: LangGraph

Sección 11: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (35, 'java', 'Java: Explora el lenguaje desde cero', 'https://cursos.devtalles.com/courses/Java', 'https://import.cdn.thinkific.com/643563/eGxuDHajSO2qp1HxEbvL_JAVA-COVER3.jpg', 'Portada del curso: Java: Explora el lenguaje desde cero', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende Java desde cero, dominando la sintaxis, POO, estructuras de datos y manejo de excepciones. Explora la jerarquía de clases, colecciones, archivos y el uso de patrones como MVC.', 900, 'es', '{}', 'https://cursos.devtalles.com/courses/Java', '2026-09-24 15:49:29.94579+00', '{"Solo necesitas una computadora con Windows, macOS o Linux","Ganas de aprender y de practicar con ejemplos reales","Acceso a internet para descargar IntelliJ IDEA y el JDK de Java","Nociones básicas de programación estructurada"}', '{}', 'Sección 1: Introducción
- Introducción al curso
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Conclusión y Motivación
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Primeros pasos en Java
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Java? Filosofía y Usos
- Descargar e instalar Intellij IDEA en Windows
- JDK en Windows - Descargar e instalar
- Configurar entorno - Windows
- JDK en MacOS - Descargar e instalar
- Configurar entorno - MacOS
- Intellij IDEA en MacOS Descargar e instalar
- Primer proyecto
- Código fuente

Sección 3: Fundamentos del lenguaje
- Introducción a la sección
- Temas puntuales de la sección
- Teoría: Variables y Constantes - Tipos primitivos
- Teoría: Tipos de datos primitivos
- Teoría: Operadores básicos
- Java y javac: Compila y ejecuta sin IDE
- Variables primitivas
- Constantes - Buenas prácticas
- Fundamentos - Control de flujo
- Condicionales - if & switch
- Buenas prácticas - if
- Bucle - for
- Bucles while y do/while
- Bucle for - Buenas prácticas
- Entrada por teclado - La clase Scanner
- Refactorizando Ejemplo Scanner
- Proyecto Final
- Código fuente
- Quiz 1: Fundamentos de programación

Sección 4: Clases y Objetos
- Introducción a la sección
- Temas puntuales de la sección
- Clases y objetos - La teoría
- Atributos y métodos de clase
- Constructores de clase
- Modificadores de acceso
- Clases wrapper
- El contexto de las variables
- La clase String
- Métodos de la clase String
- Atributo static VS atributo de instancia
- Métodos de clase- static
- Bloque static
- El método main()- punto de entrada
- Refactorizando ejemplo final
- Relaciones entre clases
- Proyecto final - parte 1
- Proyecto final - parte 2
- Código fuente
- Quiz 2: Clases y Objetos

Sección 5: Programación Orientada a Objetos (POO)
- Introducción a la sección
- Temas puntuales de la sección
- Pilares fundamentales de la POO
- POO: abstracción y encapsulación
- POO: herencia
- Inmutabilidad de clases
- Polimorfismo: sobrecarga y sobreescritura
- Polimorfismo de inclusión
- Herencia vs composición
- Clases abstractas e interfaces: parte 1
- Clases abstractas e interfaces: parte 2
- La clase enum
- Proyecto final
- Código fuente
- Quiz 3: POO

Sección 6: Estructuras de Datos y Colecciones
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las estructuras de datos
- Arrays: parte 1
- Arrays: parte 2
- Collection: List y Set
- List: ArrayList
- List: LinkedList
- Nota importante
- Comparación de rendimientos: ArrayList y LinkedList
- Entendiendo el método: equals()
- Set: HashSet con clases wrapper
- Set: HashSet con clases personalizadas
- Set: HashSet CRUD
- LinkedHashSet con clases wrapper y clases personalizadas
- Set: TreeSet con clases wrapper
- Set: TreeSet con clases personalizadas
- TreeMap, HashMap y LinkedHashMap
- Map con wrapper: HasMap y TreeMap
- HashMap y TreeMap con clases personalizadas
- Iteradores y recorridos avanzados
- La interfaz: ListIterator
- Código fuente
- Quiz 4: Estructuras de datos y colecciones

Sección 7: Manejo de Excepciones
- Introducción a la sección
- Temas puntuales de la sección
- Conceptos básicos de excepciones
- Manejo de excepciones con archivos
- Refactorizando ejemplo de lectura de archivo
- Jerarquía de excepciones
- Exception personalizada: tipo checked
- Exception personalizada: tipo unchecked
- Exception con try-with-resources
- try-with-resources con Autocloseable
- Debugging de excepciones
- Ejercicio práctico de excepciones
- Excepciones proyecto final parte 1
- Excepciones proyecto final parte 2
- Excepciones proyecto final parte 3
- Código fuente
- Quiz 5: Excepciones

Sección 8: Manejo de JSON
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a JSON
- Serializar y deserializar JSON con Gson parte 1
- Serializar y deserializar JSON con Gson parte 2
- Cómo leer y escribir archivos JSON con Gson
- Cómo leer y escribir listas en archivos JSON
- Clases anidadas con JSON parte 1
- Clases anidadas con JSON parte 2
- Gson: escribir listas de objetos con arrays
- Gson: leer listas de objetos con arrays
- Validación de JSON con Json Schema parte 1
- Validación de JSON con Json Schema parte 2
- Código fuente
- Quiz 6: JSON

Sección 9: Aplicación práctica con el patrón MVC
- Introducción al curso
- Temas puntuales de la sección
- Introducción al patrón MVC
- MVC: El modelo parte 1
- MVC: El modelo parte 2
- MVC: El controlador parte 1
- MVC: El controlador parte 2
- MVC: La vista parte 1
- MVC: La vista parte 2
- Tarea: refactorizando entrada de datos
- MVC con persistencia utilizando Gson parte 1
- MVC con persistencia utilizando Gson parte 2
- Tarea: Update completed y listando parte 1
- Tarea: Update completed y listando parte 2
- Código fuente

Sección 10: Bonus: Lombok
- Lombok Esencial: Funciones Básicas
- Código fuente

Sección 11: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (18, 'python-n8n-automatiza-rutinas', 'Python + n8n: Automatiza rutinas cotidianas', 'https://cursos.devtalles.com/courses/python-n8n-automatiza-rutinas', 'https://import.cdn.thinkific.com/643563/ZEyBqiQ2S8KjhgvA87t2_PYTHON-N8N.jpg', 'Portada del curso: Python + n8n: Automatiza rutinas cotidianas', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a utilizar Python para tus proyectos de automatización cotidiana o para tus proyectos personales. Aprende conceptos n8n, crea scripts de automatización, servicios simples con FastAPI, manipulación de datos, Scraping y mucho más.', 540, 'es', '{"Fundamentos de n8n: Entendimiento del entorno de trabajo, nodos, triggers, workflows y gestión segura de credenciales.","El Nodo Code & HTTP Request: Dominio del nodo nativo de ejecución de Python dentro de n8n y comunicación con cualquier API externa.","Integración Híbrida: Uso de Python como el complemento perfecto cuando la interfaz visual de n8n no es suficiente.","Ecosistema con FastAPI: Creación y consumo de APIs simples con Python para conectar tus propios servicios locales con la nube.","Procesamiento inteligente: Limpieza, análisis y transformación de datos en flujo constante.","Automatización de archivos: Organización automática de directorios, detección de duplicados y lectura de archivos pesados por partes.","Comunicaciones automáticas: Configuración avanzada de correos, alertas y notificaciones automatizadas.","Arquitectura reutilizable: Diseño de flujos de trabajo modulares y escalables para casos de uso reales.","Capacidad para automatizar cualquier tarea repetitiva de tu trabajo o vida diaria.","Habilidad para ofrecer servicios de automatización como freelancer o aportar alto valor en tu empresa.","Estar preparado para dar el siguiente paso lógico: la integración de flujos avanzados de automatización con Inteligencia Artificial (Agentes y LLMs)."}', 'https://cursos.devtalles.com/courses/python-n8n-automatiza-rutinas', '2026-09-24 15:49:29.94579+00', '{"Conocimientos de Python a nivel básico o intermedio (requerido)","Fundamentos de n8n (deseable)","Conocimientos básicos de FastAPI (opcional)"}', '{}', 'Sección 1: Introducción al curso
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Instalar Python en Windows
- Instalar Python en MacOS
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos de N8N
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es automatizar?
- ¿Qué es n8n?
- n8n en la web
- n8n en local
- n8n con Docker
- Generalidades de la interfaz de usuario
- Interfaz de flujo de trabajo
- Nodos principales, triggers y webhooks
- Workflow sencillo con n8n
- IMPORTANTE: Actualización de n8n v1 a v2 usando Docker (Solución al problema)
- Actualizar n8n de la versión 1 a 2 en Docker
- Runners en n8n
- Crear contenedor task runners n8n v2

Sección 3: n8n y Python
- Introducción a la sección
- Demostración
- Temas puntuales de la sección
- ¿Cuándo usar n8n y cuando Python?
- n8n y Python usando el nodo code
- Agregando lógica a nuestro nodo code con Python
- Google Cloud - Crear proyecto y configuraciones
- Google Cloud - Pantalla de consentimiento
- Google Cloud - Permisos para Google Sheets y Drive
- Guardar clientes en Google Sheets
- Google Cloud - Permisos para Gmail
- Enviar correos con clientes potenciales
- Código fuente de la sección

Sección 4: n8n y Python usando nodo HTTPRequest
- Introducción a la sección
- Demostración
- Temas puntuales de la sección
- Introducción a n8n y Python con HTTPRequest
- Preparar el entorno con FastAPI
- Primer endpoint para recibir datos de n8n
- n8n con FastAPI usando HTTPRequest
- FastAPI procesando datos
- MIniproyecto - Analizador de texto (parte 1)
- Miniproyecto - Analizador de texto (parte 2)
- Código fuente de la sección

Sección 5: Proyecto - Convertidor de imagen a Webp
- Introducción a la sección
- Demostración
- Temas puntuales de la sección
- Objetivo y flujo del proyecto
- Servicio para convertir imágenes a Webp (parte 1)
- Servicio para convertir imágenes a Webp (parte 2)
- Flujo n8n: Google Drive, condicionales y descargas
- Enviar imagen a nuestro servicio
- Google Drive - Subir video
- Google Drive - Eliminar archivo original
- Google Drive - Mover archivos
- Pruebas del flujo
- Código fuente de la sección

Sección 6: Proyecto - Email Detox
- Introducción a la sección
- Demostración
- Temas puntuales de la sección
- Objetivo y flujo del proyecto
- Transformar HTML y normalizar texto
- Extraer enlaces y accionables
- Prioridad y resumen simple
- Endpoint del servicio
- Gmail Trigger y HTTP Request
- Enviar notificación por Discord
- Pruebas del flujo
- Código fuente de la sección

Sección 7: Proyecto - Eliminar duplicados de carpeta local
- Introducción a la sección
- Demostración
- Temas puntuales de la sección
- Objetivo y flujo del proyecto
- Modelos de validación
- Función para calcular sha256 del archivo
- Endpoint detectar duplicados por hash (parte 1)
- Endpoint detectar duplicados por hash (parte 2)
- Agregar ruta del folder al volumen de Docker
- Trigger y leer archivos binarios locales
- Convertir rutas de contenedor a rutas de host
- HTTPRequest al servicio
- Condicional y lista plana de duplicados
- Convertir rutas del host a rutas de contendor
- Mover y eliminar archivos duplicados
- Pruebas del flujo
- Código fuente de la sección

Sección 8: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (55, 'qwik-introduccion', 'qwik - Introducción al Framework', 'https://cursos.devtalles.com/courses/qwik-introduccion', 'https://import.cdn.thinkific.com/643563/rK74DwtRSZabgmUHhIdK_QWIK.jpg', 'Portada del curso: qwik - Introducción al Framework', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'El objetivo del curso es brindar una entrada robusta al nuevo framework qwik, que es muy interesante y completo; cubre muchos aspectos desde creación hasta despliegue, rutas, estados, peticiones http, SSR, reanudabilidad, integraciones ChatGPT y más', 480, 'es', '{"Fundamentos de Qwik: Resumabilidad, Server Side Rendering (SSR) y Client Side Rendering (CSR).","Desarrollo moderno: Routing, layouts, formularios, manejo de estado y TypeScript.","Integraciones: Cookies, LocalStorage, OpenAI y despliegues en producción.","Buenas prácticas: Arquitectura, protección de rutas y organización de proyectos.","Qwik y Qwik City: Fundamentos del framework y sistema de rutas.","TypeScript y Tailwind CSS: Desarrollo moderno con tipado y diseño responsivo.","Manejo de estado: Signals, Stores, Context API, Writable y Readonly Signals.","Componentes: Slots, Named Slots, Layouts y Nested Layouts.","Routing: Navegación, parámetros de URL y Query Parameters.","Formularios: Validaciones utilizando Zod.","Reactividad: useTask$, useVisibleTask$ y Custom Hooks.","Persistencia: Cookies, LocalStorage y proveedores.","Integraciones: OpenAI, modales y protección de rutas mediante cookies seguras.","Despliegue: GitHub y Railway.","Comprenderás cómo funciona Qwik y qué lo diferencia de otros frameworks modernos.","Serás capaz de desarrollar aplicaciones completas utilizando Qwik, Qwik City y TypeScript.","Aprenderás a implementar manejo de estado, formularios, autenticación e integraciones modernas.","Tendrás una base sólida para comenzar a desarrollar proyectos profesionales utilizando esta nueva tecnología."}', 'https://cursos.devtalles.com/courses/qwik-introduccion', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de JavaScript y TypeScript:","Saber trabajar con funciones, objetos, arreglos y tipos básicos.","Experiencia previa con React, Vue o algún framework web:","Entender conceptos como componentes, props y manejo de estado.","Conocimientos básicos de HTML y CSS:","Saber estructurar páginas y aplicar estilos con Tailwind (opcional).","Entorno de desarrollo configurado (Node.js + npm):","Poder instalar dependencias, ejecutar scripts y trabajar en local."}', '{}', 'Sección 1: Introducción
- Introducción al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Primeros pasos en Qwik
- Introducción a la sección
- Temas puntuales de la sección
- Qwik - Introducción al framework
- Demostración de la sección
- Inicio de proyecto - PokeQwik
- Archivos y directorios de qwik
- Archivos y directorios dentro del SRC
- Añadir Tailwind al proyecto
- Ordenar nuestro proyecto
- Mantener estado - Signals
- Cambiar el valor de una señal
- Funciones en el componente
- Comunicación entre componentes
- Solución de la tarea
- Mensaje de carga de imágenes
- Tarea - ¿Quien es ese pokémon?
- Código fuente de la sección

Sección 3: Server Side y Client Side Rendering
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Continuación de la sección
- Creación de rutas y navegación
- qwik-city - Link
- qwik-city - useNavigate
- useStylesScoped y useStyles
- Client - Obtener el parámetro por URL
- qwik-city - routeLoader$
- SSR - Petición HTTP
- Tipar y mostrar los pokemons
- Query Parameters
- Mostrar imágenes de los pokémons
- useStore - Objetos y arreglos
- useVisibleTask$
- useTask$
- InfiniteScroll
- Reducir las peticiones Http
- Código fuente de la sección

Sección 4: Context API - Estado global
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Creación del context
- Consumir y cambiar el valor del context
- Tarea - Contexto para el listado de pokémons
- Pokemon Provider
- Guardar en local storage
- Leer del local storage
- Código fuente de la sección

Sección 5: Custom Hooks
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- useCounter - Custom Hook
- usePokemonGame - Custom Hook
- Consumir el custom hook
- Código fuente de la sección

Sección 6: Slots
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Slots - Modals
- Named Slots
- Funcionalidad del modal y propiedades
- Cambiar contenido del Modal
- OpenAI - Api Key
- Integraciones con OpenAI
- Mostrar la respuesta de OpenAI
- Código fuente de la sección

Sección 7: Formularios, Validaciones, autenticación, Layouts y Rutas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Jugando con las rutas de qwik
- Nuevas rutas en nuestra aplicación
- Diseño de login
- Formulario tradicional básico
- Validaciones manuales
- Form y routeAction
- Cookies
- zod$ - Validaciones de formularios
- Protección de rutas
- Código fuente de la sección

Sección 8 - Despliegues
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Subir aplicación a GitHub
- Preparar para producción
- Desplegar aplicación en Railway
- Cross-site POST form - Solución
- Código fuente de la sección

Sección 9 - Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (26, 'react-de-cero', 'React: de cero a experto - Edición 2025', 'https://cursos.devtalles.com/courses/react-de-cero', 'https://import.cdn.thinkific.com/643563/TTTUJiUVTvGC5cy5Z3UW_COVER-DEVTALLES-REACT.jpg', 'Portada del curso: React: de cero a experto - Edición 2025', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'En este curso de React aprenderás desde los fundamentos de la librería hasta aspectos técnicos avanzados y despliegues, incorporando librerías adicionales ampliamente utilizadas en la industria. Todo el contenido está basado en TypeScript.', 2760, 'es', '{}', 'https://cursos.devtalles.com/courses/react-de-cero', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de JavaScript es necesario","Conocimiento básico de programación es necesario","Poder realizar instalaciones en el equipo como administrador","Pueden seguir el curso en OSX (Mac), Windows o Linux","Estar dispuesto a realizar las tareas y ejercicios adicionales"}', '{}', 'Sección 1 - Introducción
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2 - Introducción a React y conceptos generales
- Introducción
- Temas puntuales
- ¿Qué es React?
- Puntos importantes sobre React

Sección 3 - Reforzamiento JavaScript / TypeScript
- Introducción
- Temas puntuales
- Inicio de proyecto - Reforzamiento
- Explicación y estructura de directorios
- Variables y constantes
- Template String
- Objetos literales
- Interfaces de TypeScript
- Arreglos
- Funciones
- Funciones con múltiples retornos
- Desestructuración de objetos
- Desestructuración de arreglos
- Tarea - Desestructuración
- Interfaces y Enumeraciones
- Importaciones y exportaciones
- Tarea - Importación y exportación
- Promesas
- Giphy API - Obtener gifs
- Fetch API
- Interfaces y optimización
- Async - Await
- Código fuente
- Repaso interactivo: Reforzamiento JavaScript/TypeScript

Sección 4 - Primeros pasos en React
- Introducción
- Temas puntuales
- Primer proyecto en React
- Estructura de directorios
- Estructura de directorios - Parte 2
- Mi primer componente
- Tarea - Segundo componente
- Impresión de variables
- Colocar estilos de CSS
- Componente - ItemCounter
- Propiedades del componente - Props
- Mostrar listados de elementos
- Eventos de los elementos
- Hook - useState
- Archivos de CSS
- Código fuente
- Repaso interactivo: Primeros pasos en React

Sección 5 - Pruebas automáticas - Unit testing
- Introducción
- Temas puntuales
- Introducción a las pruebas automáticas
- Configuración Vitest
- Mis primeras pruebas automáticas
- Agrupar pruebas similares
- Pruebas sobre componentes de React
- Buscar elementos en el componente renderizado
- Evaluar "snapshots"
- Pruebas en el componente ItemCounter
- Disparar eventos
- Comprobar estilos
- Pruebas en "FirstStepsApp"
- Componentes fictícios - Mock Components
- Esperar argumentos específicos
- Índice de cobertura
- Código fuente
- Repaso interactivo: Pruebas automáticas - Unit testing

Sección 6 - GifExpertApp - Aplicación
- Introducción
- Temas puntuales
- Demostración de la sección
- Inicio de proyecto - GifsApp
- Estructura inicial, estilos y fuente
- Pensemos en componentes
- Solución a la tarea - GifList
- Manejo de estado - Búsquedas previas
- Manejo del componente de búsqueda
- useEffect - Debounce
- Tarea - Ver búsquedas previas
- Developers Giphy - API Key
- Obtener gifs mediante petición http
- Variables de entorno
- Solución a la tarea - Mostrar Gifs
- Código fuente
- Repaso interactivo: GifExpertApp - Aplicación

Sección 7 - Optimización y despliegue
- Introducción
- Temas puntuales
- Demostración
- Continuación de aplicación
- Problema que resuelve un "custom hook"
- Custom Hooks
- React DevTools
- Hook personalizado - useGifs
- Manejo en caché
- useRef - Mantener el valor entre re-renders
- Generar versión de producción
- Código fuente de la sección
- Repaso interactivo: Optimización y despliegue

Sección 8 - Testing - Pruebas sobre GifsApp
- Introducción
- Temas puntuales
- Configuración de pruebas
- Pruebas sobre "CustomHeader"
- Pruebas sobre "Custom Hooks"
- Continuación - Pruebas sobre "Custom Hooks"
- Componentes con "custom hooks"
- Simular estado de un "Custom Hook"
- Prueba sobre instancias de Axios
- Pruebas sobre acción - getGifsByQuery
- Axios mock adapter - Controlar resultados de Axios
- Excepciones en las peticiones
- Espías y sobre escritura de métodos
- Pruebas sobre useGifs
- Pruebas sobre useGifs - Caché
- Pruebas sobre efectos y debounce
- Pruebas adicionales sobre efectos
- Porcentaje de cobertura
- Integrar pruebas con la versión de producción
- Código fuente
- Repaso interactivo: Testing - Pruebas sobre GifsApp

Sección 9 - Profundizando Hooks y React
- Introducción
- Temas puntuales
- Demostración
- Inicio de aplicación - HooksApp
- TailwindCSS y Estilos
- useState - Estado que re-dibuja
- Tipado estricto en useState
- useEffect - Disparar efectos secundarios
- Recomendaciones del useEffect
- Tarea - CustomHook
- Solución de tarea - CustomHook
- Conectar varios "Custom Hooks" entre sí
- Parte 2 - Conectar varios "Custom Hooks"
- useRef - Valor que no dispara re-render
- Código fuente
- Repaso interactivo: Profundizando Hooks y React

Sección 10 - Profundizando Hooks - useReducer
- Introducción
- Temas puntuales
- Demostración
- Continuación de proyecto - useReducer
- ShadcnUI - ¿Qué acabamos de instalar?
- Lista de tareas con useState
- Patrón Reducer
- Configuración de la función reducer
- Solución a la tarea - Reducer
- Controlar estados complejos - useReducer
- Persistencia local - LocalStorage
- Validadores de objetos - Zod
- Tarea - Palabras revueltas
- Solución a la tarea - Palabras revueltas
- Scramble reducer - Controlar un estado complejo
- Lógica del reducer
- Parte 2 - Lógica del reducer
- Efectos secundarios con un reducer
- Código fuente
- Repaso interactivo: Profundizando Hooks - useReducer

Sección 11 - Memorización y optimizaciones
- Introducción
- Temas puntuales
- Continuación de aplicación
- React Memo - Función de memorización
- useCallback - Memorización de funciones
- useMemo - Memorización de valores
- useOptimistic - Preparación del ejercicio
- useOptimistic
- useTransition
- Simular fallo en useOptimistic + sonner
- Use API + Suspense - Preparación de ejercicio
- Use API + Suspense en acción
- Código fuente
- Repaso interactivo: Memorización y optimizaciones

Sección 12 - Use Context
- Introducción
- Temas puntuales
- Continuación de proyecto - HooksApp
- React Router - Manejo de rutas
- Navegar entre pantallas - Diseño de páginas
- Contextos y proveedores en React
- Contexto de usuario - Información global
- Consumir el contexto
- Persistencia del usuario
- Diseño condicional dependiendo de la sesión
- Rutas privadas y públicas
- Código fuente
- Repaso interactivo: Use Context

Sección 13 - Single Page Application - SPA
- Introducción
- Temas puntuales
- Demostración
- Creación de proyecto - HeroesApp
- Generadores visuales con AI
- Creación de rutas y pantallas
- Componente "Layout"
- Lazy Load - Carga perezosa
- Pensemos en componentes reutilizables
- Parte 2 - Pensemos en componentes
- Componentes de búsqueda
- Grid de personajes
- Shadcn Tabs
- Componente de paginación
- Menú superior - Identificar ruta activa
- Breadcrumb - Implementar componente
- Código fuente

Sección 14 - Funcionalidad, caché y optimizaciones
- Introducción
- Temas puntuales
- Continuación de proyecto
- Axios, variables de entorno y API
- TanStack Query - Gestor de estado asíncrono
- Tipado estricto de la data
- Mostrar la data de los héroes
- Navegación manual dentro de las tarjetas
- QueryParameters sobre useState
- Paginar datos
- Componente de paginación
- Mostrar resumen estadístico
- CustomHook - useSummary + solución de tarea
- Paginar por categoría
- Página de Héroe
- Solución de tarea - HeroPage
- Código fuente
- Repaso interactivo: Funcionalidad, caché y optimizaciones

Sección 15 - Context API - Búsquedas y favoritos
- Introducción
- Temas puntuales
- Continuación de aplicación
- Contexto para control de favoritos
- Contexto de favoritos - Parte 2
- Consumir el contexto de favoritos
- useRef - En valores de inputs
- Buscar héroes por nombre
- Solución de tarea - Buscar héroes
- Componentes de búsqueda adicionales
- Filtros avanzados
- Código fuente
- Repaso interactivo: Context API - Búsquedas y favoritos

Sección 16 - Testing HeroesApp
- Introducción
- Temas puntuales
- Continuación de la aplicación y configuraciones
- Variables de entorno para testing .env.test
- Test - getHeroAction
- Test - getSummaryAction
- Test - getHeroesByPageAction
- Parte 2 - Test - getHeroesByPageAction
- Test - useHeroSummary
- Parte 2 - Test - useHeroSummary
- Fallo - Test - useHeroSummary
- Test - usePaginatedHero
- Test - FavoriteHero Context
- Parte 2 - Test - FavoriteHero Context
- Parte 3 - Test - FavoriteHero Context
- Mock sobre objetos globales
- Test - HeroStats
- Parte 2 - Test - HeroStats
- Test - App Router
- Memory Router - Establecer rutas y argumentos
- Probar redirección
- Test - CustomPagination
- Parte 2 - Test - CustomPagination
- Parte 3 - Test - CustomPagination
- Test - HomePage
- Parte 2 - Test - HomePage
- Test - SearchPage
- Parte 2 - Test - SearchPage
- Test - SearchControls
- Parte 2 - Test - SearchControls
- Parte 3 - Test - SearchControls
- Código fuente
- Repaso interactivo: Testing HeroesApp

Sección 17 - Desplegar aplicación
- Introducción
- Temas puntuales
- Continuación de proyecto
- Desplegar backend en Render
- Desplegar aplicación de React
- Código fuente

Sección 18 - Panel administrativo de productos
- Introducción
- Demostración
- Temas puntuales
- Inicio de proyecto - TesloShop
- Configuración del router
- Tailwind + ShadCN UI + Google Fonts
- Diseño del HomePage
- HomePage - Paginación y productos
- HomePage - Parámetros por URL
- Sidebar - Filtro del precio
- Lógica adicional de la búsqueda
- Navegación entre pantallas
- Logo personalizado
- Diseño del login y registro
- Diseño - Panel administrativo
- Navegación del AdminSidebar
- Diseño - ProductsPage
- Diseño - ProductPage
- Código fuente
- Repaso interactivo: Panel administrativo de productos

Sección 19 - Productos y Backend
- Introducción
- Temas puntuales
- Continuación de proyecto
- Teslo Backend - Docker images
- Levantar backend y ejecutar semilla
- TanStack Query - DevTools y Axios
- Variables de entorno y Axios API
- Acción - getProductsAction
- Mostrar productos en pantalla
- Aplicar paginación
- Filtros por género y tallas
- Filtrar por rango de precios
- Filtrar por nombre de producto
- Código fuente
- Repaso interactivo: Productos y Backend

Sección 20 - Auth
- Introducción
- Temas puntuales
- Continuación de proyecto
- Explicación - Inicio de sesión - JWT
- Acción - Inicio de sesión
- Mensajes en pantalla sobre inicio de sesión
- Gestor de estado - Zustand
- Auth Store
- Cerrar sesión
- Acción Verificación de Token con interceptores
- Verificar estado de la autenticación
- Conectar TanStack con Zustand
- Zustand getters - Autorización
- Protección de ruta por roles
- Tarea - Registro de usuarios
- Código fuente
- Repaso interactivo: Auth

Sección 21 - Formularios y productos
- Introducción
- Temas puntuales
- Continuación de proyecto
- Tarea - Búsqueda, paginación y productos
- Acción - getProductById
- Validar y redireccionar productos
- Simplificar ProductPage
- Paquete de formularios - useForm
- Validaciones y posteo del formulario
- Validaciones de espacios y valores positivos
- useForm - Observar cambios en el formulario
- Tarea - Agregar y eliminar tallas y etiquetas
- Funciones como Props
- Acción - Actualizar o crear producto
- TanStack - useMutation
- Bloquear botón de submit mientras se postea
- Crear producto
- Código fuente
- Repaso interactivo: Formularios y productos

Sección 22 - Carga de archivos
- Introducción
- Temas puntuales
- Continuación de proyecto
- Mostrar archivos seleccionados en pantalla
- Preparar tipos y archivos para la carga
- Cargar imágenes
- Aprovisionar PostgreSQL en la nube
- Desplegar backend
- Desplegar aplicación de React
- Código fuente
- Repaso interactivo: Carga de archivos

Sección 23 - Punto de control
- Más información sobre nuestros otros cursos
- Punto de control del curso

Sección 24: MERN Calendar - Estructura y Diseño
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - MERN-Calendar
- Rutas de la aplicación
- LoginScreen y Navbar
- React Big Calendar
- Configuraciones adicionales al calendario
- Personalizar el cuadro de evento
- Escuchar eventos del calendario
- Creando un modal sobre el calendario
- Contenido del Modal
- Datepicker en español
- Obtener la información del formulario del evento
- Validaciones del formulario
- Instalación y configuración de Redux
- Mostrar y ocultar modal en base al Store
- CalendarSlice
- Cargar un evento en el modal
- Preparar la creación de un nuevo evento
- Añadir un nuevo evento
- Editar el evento activo
- Eliminar evento
- Redux - serializableCheck
- Código fuente de la sección
- Repaso interactivo: MERN Calendar - Estructura y Diseño

Sección 25: CalendarApp - Backend - Node, Express, Mongo
- Introducción a la sección
- Temas puntuales de la sección
- Objetivo al final de la sección
- Inicio de proyecto - CalendarApp Node Backend
- Configurando Express
- Variables de entorno y carpeta pública
- Creando las rutas relacionadas a usuarios
- Endpoints de remover, crear y login
- Recuperar información de un posteo
- Express Validator
- Custom Middlewares
- Configuración de base de datos
- Conectar Node a Mongo Atlas
- Crear un usuario en nuestra Base de Datos
- Validaciones del usuario
- Encriptar la contraseña
- Login de usuario
- Generar un Json Web Token
- Revalidar JWT
- Configurar CORS
- Código fuente de la sección
- Repaso interactivo: CalendarApp - Backend - Node, Express, Mongo

Sección 26: Backend - Eventos del calendario - CRUD
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - Calendar Backend
- Resolución de la tarea - CRUD
- Modelo Evento
- Validar campos necesarios
- Grabar el evento en la base de datos
- Obtener el listado de los Eventos
- Actualizar un Evento
- Eliminar Eventos
- Código fuente de la sección
- Repaso interactivo: Backend - Eventos del calendario - CRUD

Sección 27: Despliegue del backend a la nube
- Introducción a la sección
- Temas puntuales de la sección
- Subir proyecto a GitHub
- Pruebas antes de desplegar
- Desplegar a Railway
- Código fuente de la sección

Sección 28: MERN - Calendario + Backend
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Calendar + Backend
- Creando variables de entorno
- AuthSlice
- useForm - Login y Registro
- Axios - Configurar cliente para peticiones HTTP
- Realizar login de usuario
- Despachar acciones respectivas
- Mostrar error en la autenticación
- Creación de un nuevo usuario
- Mantener el estado de la autenticación
- Cambiar el URL después de una autenticación
- Logout y nombre de usuario
- Código fuente de la sección
- Repaso interactivo: MERN - Calendario + Backend

Sección 29: MERN CRUD - Eventos del calendario
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Calendar CRUD de Eventos
- Creando un nuevo Evento en el calendario
- Mostrar eventos de la base de datos
- Cargar los eventos al store
- Actualizar el evento
- Cambiar el color de los eventos según usuario
- Eliminar un evento
- Limpiar información del calendario
- Código fuente de la sección
- Repaso interactivo: MERN CRUD - Eventos del calendario

Sección 30: Fin el MERN - Desplegarlo a producción
- Introducción a la sección
- Temas puntuales de la sección
- Levantar proyectos localmente
- Desplegar backend y frontend a la nube
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (39, 'react-native-expo', 'React Native Expo: Aplicaciones nativas para IOS y Android', 'https://cursos.devtalles.com/courses/react-native-expo', 'https://import.cdn.thinkific.com/643563/1NsQU7EaRiG7xLnvaHvc_COVER-DEVTALLES.jpg', 'Portada del curso: React Native Expo: Aplicaciones nativas para IOS y Android', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Curso completo de React Native con Expo que te dará las bases sólidas sobre este framework, con más de 42 horas de contenido en video y despliegues en la Google PlayStore y Apple AppStore incluído en el curso.', 1200, 'es', '{}', 'https://cursos.devtalles.com/courses/react-native-expo', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de React es necesario","No es necesario saber TypeScript (pero es recomendado)","No necesitas saber nada de React Native o React Native CLI","Es necesario poder realizar instalaciones como administrador","No es necesario Mac o un equipo especial"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Reforzamiento sobre React y TypeScript
- Introducción
- Temas puntuales
- Inicio de proyecto
- Tipos básicos
- Objetos literales
- Funciones
- TailwindCSS
- Counter Component
- Custom hooks
- AuthContext - ContextAPI
- AuthContext - Enumeraciones y estado
- Métodos en el contexto
- Separación de componentes
- Peticiones HTTP
- Tipar Props
- Formularios
- Código fuente

Sección 3: Configuración de equipo - React Native - Expo
- Introducción
- Temas puntuales
- Mi primer proyecto - TestingApp
- MAC: Android Environment
- MAC: Android Emulator
- MAC: IOS Simulator
- Windows: Android Environment
- Windows: Android Emulator

Sección 4: Mi primera aplicación en React Native
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - CounterApp
- Estilos y botones
- Botón flotante personalizado
- Retroalimentación al tocar el botón
- Código fuente

Sección 5: Calculator App
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto
- ExpoRouter: index y _layout
- Fuentes personalizadas y diseño inicial
- Estilos globales
- Custom Text + Default Props
- Botones de la calculadora
- Botones de la calculadora - Parte 2
- Paquetes adicionales - Haptics y NavigationBar
- Lógica de la calculadora - useCalculator
- Construir número
- Limpiar, cambiar signo y borrar anterior
- Manejo de los botones de operaciones
- Calcular el resultado matemático
- Código fuente de la sección

Sección 6: Tipos de navegación y estilos
- Introducción
- Temas puntuales
- Demostración
- Inicio de aplicación - NavigationApp
- Estilos con Nativewind
- Fuentes personalizadas en Nativewind
- Colores personalizados
- Navegación entre pantallas
- CustomButtons y Link AsChild
- ForwardRef y Variantes
- StackNavigation
- Personalización del StackNavigation
- Listado de productos y detalle
- Código fuente

Sección 7: Tabs y Drawer
- Introducción
- Temas puntuales
- Demostración
- Continuación de aplicación
- Tabs
- Personalizar los tabs
- Drawer - Menú lateral
- Personalizar el Drawer
- DrawerContent
- Conectar Drawer, con Tabs con Stack
- Optimizar nombres de directorios
- Mostrar drawer controladamente
- Cambiar título basado en los argumentos
- Código fuente

Sección 8: MoviesApp - Peticiones HTTP - TanStack
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - MoviesApp
- Variables de entorno y API Key
- Cliente de Axios - Primera petición
- Mapear respuestas a objetos personalizados
- TanStack Query - Gestor de estado asíncrono
- Pantalla de carga y SafeArea manual
- Carousel de imágenes
- Nota de actualización
- Mostrar poster de la película
- FlatList Horizontal
- Tarea - Mejor Calificadas y Próximamente
- Código fuente

Sección 9: MoviesApp - InfiniteScroll y Detalles
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Determinar fin de scroll de un FlatList
- TanStack - InfiniteQuery
- Pantalla - Detalles de la película
- useMovie - TanStack
- Mostrar detalles de la película
- Gradiente sobre el poster
- Descripción de la película
- Tarea - Actores de las películas
- Resolución de la tarea
- Código fuente

Sección 10: Components App - Temas y estructura
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - ComponentsApp
- Nativewind y Paleta de colores
- ThemedView
- ThemedText
- Opciones de menú y rutas
- Menu Item
- Limpieza y cierre de sección
- Código fuente

Sección 11: Componentes de React Native
- Introducción
- Temas puntuales
- Demostración
- Continuación de proyecto
- Animaciones 101 - Básicas
- Animaciones 101 - Movimiento
- Custom Hook - useAnimation
- Animated XY
- Switch - ThemedSwitch
- Código por plataforma
- Alerts
- TextInput y ThemedTextInput
- KeyboardAvoidingView
- Código fuente

Sección 12: Lists, Infinite scrolls, Slides, Theme Changer, modals
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Pull to refresh
- Section List
- Modal Window
- Controles y segundo modal
- InfiniteScroll
- Configuraciones del infinite scroll
- Custom FadeInImage
- Carrusel controlado - Diseño y estructura
- Carrusel controlado - Funcionalidad
- ThemeChanger - Preparación
- ThemeChanger Context y Provider
- Cambio de tema desde el context
- Storage Alternatives - Async Storage
- Código fuente

Sección 13: Push Notifications
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - PushApp
- Expo Push Notifications
- ProjectID - Enviar Notificación Push
- usePushNotifications - CustomHook
- usePushNotification - Parte 2
- Enviar, recibir y mostrar notificaciones push
- Android: Credenciales para builds
- IOS: Credenciales para builds
- Prebuild - Custom Builds
- Tomar información y navegar a pantalla
- Aplicación terminada o en segundo plano
- IOS - Prebuild
- Backend - PushServer - Expo Push API
- Expo Server SDK
- Enviar notificaciones desde nuestro backend
- Código fuente

Sección 14: MapsApp - Permisos
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - MapsApp
- Acciones - Permisos de geolocalización
- Zustand - Gestor de estado
- Provider - Permission Checker
- Solicitar permiso de Geolocalización
- Permisos fuera de la aplicación
- Abrir ajustes de la aplicación
- Código fuente

Sección 15: MapsApp - Mapas y controles
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Expo - MapView
- Configuración de Google Cloud
- Prebuild con nuestras llaves
- Marcadores
- Acciones para seguir y ver la ubicación del usuario
- Location Store
- Componente CustomMap
- Ubicación del usuario y seguir su trayectoria
- Mover la cámara para seguir al usuario
- Botón flotante personalizado
- Acciones con el Mapa
- Polylines
- Código fuente

Sección 16: Backend personalizado
- Introducción
- Temas puntuales
- Descarga y pruebas del backend

Sección 17: Productos App - Autenticación
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - ProductsApp
- Fuentes y Colores
- Auth Store - Estado de la autenticación
- Auth Actions - Acciones de autenticación
- Conectar acciones con Store
- Variables de entorno y configuraciones
- Verificar estado de autenticación
- LoginScreen - Pantalla de ingreso
- ThemedTextInput - Caja de texto personalizada
- ThemedButton - Botón personalizado
- ThemedLink - Enlace personalizado
- Pantalla de registro
- Login - Estado y redirección
- Secure Storage Adapter - Secure Store
- Check Status - Axios interceptors
- Logout - Botón personalizado
- Código fuente

Sección 18: Products App - Listado y mantenimiento
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Obtener productos de forma paginada e individual
- TanStack + Custom Hooks
- Mostrar productos en pantalla
- Scroll infinito
- Pantalla de producto - Diseño
- Cargar data del producto - useProduct
- Carrusel de imágenes
- ButtonGroup personalizado
- Selector de género
- Formik - Gestor de formularios
- useMutation - TanStack
- Acciones para crear y actualizar productos
- Invalidar caché
- Crear un nuevo producto
- Código fuente

Sección 19: Cámara, galería y carga de imágenes
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Prepara pantalla para tomar fotografía
- Cámara y permisos
- Botón de captura y tomar fotografía
- Botones adicionales, girar cámara, galería y regresar
- Mostrar fotografía tomada
- Guardar imagen en galería
- Camera Store - Zustand
- Selector de imágenes
- Cargar imagen vía Postman
- Subir imágenes desde la app
- Subir imágenes - Parte 2
- Pull to refresh
- Código fuente

Sección 20: PlayStore y AppStore
- Introducción
- Temas puntuales
- Preparación de aplicación
- EAS Build - Android APK
- EAS Build - Android AAB
- Instalar App desde la PlayStore
- EAS Build - IOS
- EAS Publish - IOS

Sección 21: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (71, 'react-pro', 'React PRO: lleva bases al siguiente nivel - Fernando Herrera', 'https://cursos.devtalles.com/courses/react-pro', 'https://import.cdn.thinkific.com/643563/sHm63uuSkiPxQqbElhTQ_REACT-PRO-NEW.jpg', 'Portada del curso: React PRO: lleva bases al siguiente nivel - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'El curso tiene por objetivo pulir tus habilidades existentes de React con Hooks y llevarlas a un nivel superior para que tus aplicaciones de React sean aún mejores.', 1470, 'es', '{"React avanzado: TypeScript, Lazy Loading, modularización y patrones de componentes.","Desarrollo de librerías: Storybook, TSDX, NPM y documentación automática.","Formularios profesionales: Formik, Yup, formularios dinámicos y componentes reutilizables.","Producción: GitHub Actions, Semantic Release, PWAs, Workbox y estrategias offline.","React + TypeScript: Desarrollo moderno utilizando tipado estático.","Patrones de componentes: Compound Components, Control Props, State Initializer, Function Child y más.","Formularios: Formik, Yup, validaciones y formularios dinámicos.","Storybook: Documentación, publicación y creación de librerías reutilizables.","Automatización: GitHub Actions, Semantic Release y despliegues automáticos a NPM.","PWAs: Service Workers, Workbox, Background Sync, IndexedDB y funcionamiento offline.","Y mucho más...","Elevarás tus habilidades de React a un nivel profesional.","Aprenderás a crear componentes y librerías reutilizables listas para producción.","Dominarás herramientas como Storybook, GitHub Actions y Workbox.","Serás capaz de desarrollar aplicaciones React modernas, escalables y optimizadas para entornos reales."}', 'https://cursos.devtalles.com/courses/react-pro', '2026-09-24 15:49:29.94579+00', '{"Tener las bases de React con Hooks","Saber TypeScript es útil pero no indispensable (introducción incluida)","Poder realizar instalaciones en el equipo como administrador"}', '{}', 'Sección 1: Introducción
- Introducción al curso - Visión General
- Bienvenida al curso
- ¿Cómo funcionará el curso?
- ¿Cómo realizar preguntas?
- Instalaciones recomendadas y obligatorias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Reforzamiento sobre React
- Introducción a la sección
- Temas puntuales de la sección
- Videos adicionales antes de comenzar
- Inicio de proyecto - Bases de React
- Primer componente en TypeScript
- Trabajando con PropTypes
- Manejar un objeto como estado
- Optimizaciones y tipado
- useEffect - CounterEffect
- Realizar animación cuando se llega al valor máximo
- useRef y TimeLines
- CustomHooks con referencias HTML
- Parametrizar y pulir nuestro custom hook
- useReducer
- Función pura - Reducer
- IncreaseBy - Action
- Separar acciones, interfaces y reducer
- Action Creators
- Código fuente de la sección

Sección 3: Opcional - Construcción del proyecto inicial
- Introducción
- Temas puntuales
- Inicio de proyecto - ReactApp
- Código fuente

Sección 4: LazyLoad - Chunks - React Router Dom V5
- Introducción a la sección
- Temas puntuales de la sección
- Levantar proyecto - React App
- Rutas tradicionales - Sin Lazyload
- Crear archivo de rutas independiente
- Resolución de tarea de rutas estáticas
- LazyLoad y Suspense
- Cambiar el nombre de los chunks
- Nested Lazy Routes
- Subir cambios y ramas a GitHub
- Código fuente
- Nota: React Router Dom V5
- Preparación de proyecto - React-App
- Implementar las rutas hijas
- Código fuente de la sección

Sección 5: Patrones de componentes - Compound Component Pattern
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Patrones de componentes
- Componente básico tradicional
- CustomHook - useProduct
- Recibir props al componente hijo
- Compound Component Pattern - Primeros pasos
- Compound Component Pattern - Segundo Paso
- Unificar exportación de componentes
- Compound Component Pattern - Tercer Paso
- Separando la lógica en archivos independientes
- Asignar componentes a otro componente
- Realizar respaldo y rama
- Código fuente de la sección

Sección 6: Patrones de componentes - Extensible Styles
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección - Extensible Styles
- Custom className
- className en el ProductTitle y ProductImage
- className en ProductButtons
- Interfaces faltantes
- React CSSProperties
- Creación de rama y commit de los cambios
- Código fuente de la sección

Sección 7: Patrones de componentes - Control Props
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección - Control Props
- Problema y necesidad del control de propiedades
- Estado del carrito de compras
- Disparar función personalizada al cambiar estado
- Emitir argumentos en nuestro evento
- Crear carrito de compras
- Mostrar items del carrito de compras
- Mantener sincronizado los valores
- Sincronizar desde el carrito a las tarjetas principales
- Control Props
- Controlando el estado desde el padre
- useShoppingCart
- Respaldo de nuestra rama
- Código fuente de la sección

Sección 8: State initializer + Function Child = Render Props - Formik implementation
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Implementar la propiedad initialValues
- Mostrar el valor inicial en el componente
- Utilizar el MaxCount como limitante
- Función como hijo de un HOC
- Tarea: isMaxCountReaced
- Exponer funciones y propiedades fuera del componente
- Trabajar con toda la información expuesta como argumento
- Código fuente de la sección

Sección 9: NPM Deploy - Desplegar paquete de componentes
- Introducción a la sección
- Temas puntuales
- Preparaciones iniciales
- Nuevo proyecto - Librería de NPM
- Código fuente del paquete
- Configurar Rollup
- Configurar Vitest
- NPM - Carga y versionamiento semántico
- Utilizar paquete de npm
- Pruebas locales del paquete
- Código fuente

Sección 10: Formik - React Forms
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Forms
- Formulario tradicional
- Formulario tradicional - con useState
- Actualizar los inputs y tomar el valor del formulario
- CustomHook - useForm
- Expandir funcionalidad de nuestro custom hook
- Formik - Ejercicio básico
- Formik - Obtener información del formulario
- Formik - Validaciones manuales
- Formik - Mostrar errores en los campos
- Yup - ValidationSchema Builder
- Formik - getFieldProps
- Formik - Components
- Formik - Selects y Checks
- Formik - Abstraction - useField
- Formik - Custom Select
- Formik - Custom Checkbox
- Pequeñas optimizaciones
- Código fuente de la sección

Sección 11: Formik Dynamic y Custom Forms
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del ejercicio
- Tarea - Formulario de registro con Formik
- Formularios dinámicos
- Creando el initialValues de forma dinámica
- Selects de manera dinámica
- Validaciones dinámicas
- Validaciones dinámicas adicionales
- Código fuente de la sección

Sección 12: Storybook - Cama para creación y mantenimiento de componentes y paquetes
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - MyStoryBook
- Instalar y configurar Storybook
- Componente - MyLabel
- Añadir props y controles a nuestra historia y componente
- Documentar automáticamente las descripciones
- Tarea: Propiedades y controles adicionales
- Resolución de la tarea
- Desplegar Storybook a servidores
- Github y GitHub Pages
- Bonus: Chromatic
- Bonus: Chromatic - Atrapar cambios en el UI
- Código fuente de la sección

Sección 13: NPM Empaquetamiento y publicación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto
- Configuraciones en el package.json
- Configuraciones en el tsconfig.json
- Eliminar manualmente la carpeta de distribución
- Copiar recursos estáticos
- npm publish
- Información adicional del paquete
- Probar importación del paquete
- NP - A better npm publish
- Crear nueva versión de nuestro paquete
- Npm Check Updates
- Código fuente de la sección

Sección 14: Aplicación de React y Backend para PWA
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de la sección
- ¿Cómo funciona la aplicación actual?
- Introducción a las PWAs y Service Workers

Sección 15: React + PWA
- Introducción a la sección
- Temas puntuales de la sección
- Levantar los procesos de backend y frontend
- Service Worker para una aplicación existente - npx
- ¿Qué está sucediendo con la configuración por defecto?
- Manual - Descarga e instalación SW
- Manual - Grabar en caché
- Manual - Fetch dentro del service worker
- Manual - Network first with cache fallback
- Manual - Network first with cache fallback - Parte 2
- Tarea - Almacenar en caché los eventos
- Código fuente de la sección

Sección 16: Workbox
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Workbox CLI - Wizard
- Workbox SW Manual
- Workbox Cache Strategies
- Verificación de Token offline
- Background Sync - Posteos sin conexión
- Tarea - Put y Delete
- Optimizar nuestro service worker
- Mostrar mensaje de Online y Offline
- Código fuente de la sección

Sección 17: Mapas - Marcadores - Rutas - Polylines - Mapbox
- Temas puntuales de la sección
- Demostración del objetivo al final
- Inicio de Proyecto - MapasApp
- Crear el contexto de lugares
- PlacesReducer - Estado de nuestro contexto
- Obtener la geolocalización del usuario
- Mostrar la geolocalización del usuario en pantalla
- Mostrar mapa de Mapbox
- Crear el contexto para el mapa
- Establecer el mapa en el contexto
- Marcadores, Popups y botón de ubicación
- Mostrar logo de React
- SearchBar y Debounce manual
- Buscar lugares basados en el query de búsqueda
- Colocar el tipo de dato y almacenarlo en en el state
- Mostrar los lugares encontrados
- Colocar marcadores en cada lugar encontrado
- Volar y activar el lugar seleccionado
- DirectionsApi - Direcciones entre dos puntos
- Probar el API desde React
- Mostrar la polyline en el mapa
- Desplegar aplicación
- Código fuente de la sección

Sección 18: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (16, 'react-sockets', 'React+Sockets: Aplicaciones en tiempo real con Bun', 'https://cursos.devtalles.com/courses/react-sockets', 'https://import.cdn.thinkific.com/643563/ajXXN4TCTwuZ6uhDapF1_image.png', 'Portada del curso: React+Sockets: Aplicaciones en tiempo real con Bun', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a crear y configurar aplicaciones en tiempo real usando la implementación nativa de websockets junto a un backend en Bun.', 900, 'es', '{}', 'https://cursos.devtalles.com/courses/react-sockets', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de JavaScript o TypeScript (variables, funciones, async/await).","Conocimientos básicos de React (componentes, props, estado y hooks).","Poder realizar instalaciones en el equipo (editor de código, extensiones y Bun)","Ganas de practicar: vamos a construir varios proyectos y probar con múltiples navegadores.","No necesitas experiencia previa con WebSockets ni con Bun."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Primeros pasos en los WebsSockets
- Introducción
- Temas puntuales
- ¿Qué son? y ¿Cómo funcionan los WebSockets?
- Bun - Configuración del servidor
- Bun - Servir archivos HTML
- Conectar cliente al servidor de WebSockets
- Cliente - Métodos nativos de WebSockets
- Optimizar conexión y desconexión
- Enviar y recibir mensajes
- Publicar mensajes a todo el canal
- Enviar cookies y searchParams
- Protección de conexión
- Código fuente

Sección 3: Backend - Partidos políticos
- Introducción
- Temas puntuales
- Explicación de lo que construiremos
- Inicio de proyecto - Partidos Políticos
- Configuraciones del servidor y websockets
- Handler - Controlador de mensaje general
- Manejo de errores y respuestas
- Configurar todas las respuestas
- Resolución de la tarea
- Crear diseño del Store
- Crear servicio - PartyService
- Conectar controladores con el servicio
- Probar implementación de WebSockets
- Zod - Esquema de validación
- Asignar el tipo de data al payload
- Código fuente

Sección 4: React - Partidos políticos
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - Partidos Políticos
- ChartJS - Nuestra primera gráfica
- Configuración de la gráfica
- Estructura de los componentes
- Funcionalidades locales (Sin WebSockets)
- Levantar el WebSocket Server
- React - Contexto de WebSockets
- Escuchando cambios de conexión
- Recuperar conexión perdida
- Escuchar y enviar mensajes
- Tipado de las respuestas y mensajes
- Función para evaluar mensajes
- Actualizar interfaz de usuario
- Pruebas con varios navegadores
- useParties - Hook Personalizado
- Código fuente

Sección 5: Backend - Mapas y movimientos
- Introducción
- Temas puntuales
- Explicación de lo que construiremos
- Inicio de proyecto - SocketMap
- Interfaces, tipos y estructuras de mensajes
- Identificar cliente en la conexión inicial
- Esquema de validación de payload
- Manejadores de mensajes
- Punto de control - Comprobar backend
- Configuración del Store
- Configuración del Servicio
- Conectar manejadores con servicio
- Resolución de la tarea
- Registrar ingreso y salida de clientes
- Pruebas del backend
- Código fuente

Sección 6: Mapas en tiempo real
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - SocketMaps
- MapBox - Mostrar mapa
- Contexto y tipos de datos
- Configuraciones adicionales - WebSocketContext
- Cookies y suscriptores
- Levantar el WebSocket Server
- Conexión al WebSocket Server
- Recuperar conexión
- Escuchar mensajes desde Hooks
- Mostrar información del cliente
- Crear marcadores
- Actualizar coordenadas
- Mover, crear y remover marcadores
- Resolución de la tarea
- Código fuente

Sección 7: Backend - Sistema de colas
- Introducción
- Temas puntuales
- Explicación de lo que construiremos
- Inicio de proyecto - TicketApp
- Store y tipos de datos
- Métodos del Store
- Asignar siguiente ticket
- Ticket Service
- WebSockets - Tipos de mensajes
- Manejadores de mensajes
- Tarea - Implementar respuestas
- Tarea - Implementar solicitud de ticket
- Pruebas de funcionamiento
- Código fuente

Sección 8: React - Sistema de colas
- Introducción
- Temas puntuales
- Demostración
- Preparación de proyecto - TicketApp
- Socket Context
- Problemas de reconexión
- useSocketTicket - Hook para controlar eventos
- Solución a la tarea - Mostrar número de ticket
- Tarea - Pantalla de escritorio
- Solución a la tarea - Pantalla de escritorio
- Tarea - Mostrar cola de atención
- Código fuente

Sección 9: Backend - Chat - Seguridad
- Introducción
- Temas puntuales
- Explicación de lo que construiremos
- Inicio de proyecto - ChatApp
- Base de datos - PostgreSQL
- Prisma ORM - Conectar backend con PostgreSQL
- Diseño y esquema de base de datos
- Migraciones y Cliente de Prisma
- Semilla de base de datos
- Solicitud Post - Login de usuario
- Generar JsonWebToken
- Código fuente

Sección 10: Backend - Chat con mensajes privados - Websockets
- Introducción
- Temas puntuales
- Continuación de sección
- Crear tipos de mensajes y estructuras
- Zod - Esquemas de validación
- Servicio de mensajes
- Obtener mensajes grupales
- Manejar mensajes del cliente
- Implementar seguridad de WebSockets
- User Service - Controlar usuarios
- Emitir mensajes de respuesta
- Formulario de login y envío de mensajes
- Probar envío de mensajes
- Código fuente

Sección 11: Mensajes privados y usuarios conectados
- Introducción
- Temas puntuales
- Continuación de proyecto
- Store - Usuarios conectados
- Solución de tarea - Usuarios conectados
- Crear y obtener mensajes privados
- Handlers - Mensajes directos
- Enviar mensaje directo
- Mostrar usuarios conectados
- Prueba de mensajes directos y globales
- Tarea - Creación de un frontend
- Código fuente

Sección 12: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (52, 'riverpod-con-anotaciones', 'Flutter Riverpod con generación de código y anotaciones', 'https://cursos.devtalles.com/courses/riverpod-con-anotaciones', 'https://import.cdn.thinkific.com/643563/e2j5kc42TaKb8O9QQDSm_RIVERPOD.jpg', 'Portada del curso: Flutter Riverpod con generación de código y anotaciones', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Curso de Flutter Riverpod para aprender este gestor de estado con anotaciones y generación de código automático.', 120, 'es', '{}', 'https://cursos.devtalles.com/courses/riverpod-con-anotaciones', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de Flutter y Dart:","Saber construir interfaces, usar widgets y manejar el estado con setState.","Experiencia inicial con el concepto de providers o manejo de estado:Haber trabajado con Provider, Bloc, o alguna solución similar.","Entorno de desarrollo Flutter funcional:Poder correr proyectos localmente y tener acceso a simuladores o dispositivos.","Conocimientos básicos de programación asíncrona en Dart:Uso de Future, async/await, y Stream."}', '{}', 'Providers de Riverpod con generador de código
- Introducción al curso
- Instalaciones recomendadas
- Guía de atajos - Riverpod anotaciones
- Descarga de proyecto inicial
- Explicación del proyecto
- Instalación de Riverpod
- Provider de sólo lectura
- AppRouter como Provider
- Provider con cambios de estado
- Tarea - Providers con estado
- Resolución de la tarea - Providers con estado
- KeepAlive - Riverpod annotations
- TODOs - State Providers
- TODOs - Listado de invitados
- TODOs - Toggle
- TODOs - Aplicar el filtro seleccionado
- Future Provider
- Provider invalidar y dependencias
- Future provider con argumentos
- Stream Provider
- Más información sobre nuestros otros cursos
- Cierre del curso y código fuente', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (43, 'shadcn-ui', 'Shadcn/ui: Componentes accesibles y personalizables', 'https://cursos.devtalles.com/courses/shadcn-ui', 'https://import.cdn.thinkific.com/643563/UnSGHDPtQKKGytbP0iBP_SHADCN.jpg', 'Portada del curso: Shadcn/ui: Componentes accesibles y personalizables', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Una librería de componentes diferente, que te da control absoluto sobre cada pieza que importes en tu proyecto, aprende a usarla y configurarla en este curso.', 360, 'es', '{}', 'https://cursos.devtalles.com/courses/shadcn-ui', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de React y TypeScript:Saber crear componentes, usar props y hooks como useState.","Familiaridad con Tailwind CSS:Haber trabajado con clases utilitarias para estilos.","Entorno de desarrollo configurado (Node.js + npm/yarn):Poder instalar paquetes y ejecutar proyectos locales.","Experiencia básica con formularios y tablas en React:Saber manejar inputs, validaciones o manipular listas de datos."}', '{}', 'Sección 1: Introducción al curso
- Introducción al curso
- ¿Cómo hacer preguntas?
- ¿Cómo funcionará el curso?
- Instalaciones recomendadas

Sección 2: Preparación del proyecto
- Introducción a la sección
- Temas puntuales
- Inicio de proyecto - Shadcn-dashboard
- Pantallas adicionales
- Código fuente

Sección 3: Shadcn/ui - Componentes
- Introducción a la sección
- Temas puntuales
- Instalación de Shadcn/ui
- Accordion
- Anatomía y explicación de Shadcn/ui
- Alert
- Button
- Alert Dialog
- Dialog
- Badge
- Calendar
- Avatar
- Card
- Carousel
- Carousel auto play - Plugin
- Checkbox
- Command
- Combobox
- Context Menu
- Menu Bar
- Input OTP
- Progress
- Sheet
- Skeleton - Preparación
- Skeleton - Vista previa del contenido
- Slider
- Sonner
- Toast
- Tabs
- Más componentes
- Código fuente

Sección 4: Data table
- Introducción a la sección
- Temas puntuales de la sección
- Demostración
- Continuación de la sección
- Data Table
- Formato de celdas
- Acciones de fila
- Paginación
- Ordenar - Sorting
- Filtrar registros
- Visibilidad
- Seleccionar filas
- Filtro flexible personalizado
- Solución de la tarea - Filtro flexible
- Mostrar más registros por página
- Código fuente de la sección

Sección 5: Formularios
- Introducción a la sección
- Temas puntuales
- Demostración
- Continuación de proyecto
- Formulario básico
- Radio Group
- Date picker
- Switch
- Código fuente de la sección

Sección 6: Temas
- Introducción
- Temas puntuales
- Demostración
- Continuación de proyecto
- Cambiar tema de forma dinámica
- Tailwind Darkmode
- Código fuente de la sección

Sección 7: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (72, 'solid-clean-code', 'Principios SOLID y Clean Code - Fernando Herrera', 'https://cursos.devtalles.com/courses/solid-clean-code', 'https://import.cdn.thinkific.com/643563/eOnxKwRKRZ2vCYGEk8Lg_SOLID.jpg', 'Portada del curso: Principios SOLID y Clean Code - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Si hablamos de diseño y desarrollo de aplicaciones, los principios S.O.L.I.D. son palabras que debes conocer. Este curso te brindará los conocimientos para lograr mejorar y escribir un código limpio, fácil de leer, expandir y mantener a futuro.', 390, 'es', '{"Deuda técnica: Qué es, cómo se genera y cómo evitarla.","Principios SOLID: Explicación de cada principio con ejemplos aplicados al desarrollo de software.","Código limpio: Buenas prácticas para escribir software mantenible y escalable.","S – Single Responsibility Principle (SRP): Principio de Responsabilidad Única.","O – Open/Closed Principle (OCP): Principio Abierto/Cerrado.","L – Liskov Substitution Principle (LSP): Principio de Sustitución de Liskov.","I – Interface Segregation Principle (ISP): Principio de Segregación de Interfaces.","D – Dependency Inversion Principle (DIP): Principio de Inversión de Dependencias.","Comprenderás los cinco principios SOLID y cuándo aplicarlos.","Aprenderás a identificar y reducir la deuda técnica en tus proyectos.","Escribirás código más limpio, legible, mantenible y preparado para crecer con el tiempo."}', 'https://cursos.devtalles.com/courses/solid-clean-code', '2026-09-24 15:49:29.94579+00', '{"Tener conocimiento básico de programación","Conocimiento básico de JavaScript y TypeScript","Tener conceptos de programación orientada a objetos","Poder realizar instalaciones y descomprimir archivos"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- ¿De qué se trata este curso?
- Instalaciones necesarias
- Principales referencias del curso
- Preparación del laboratorio de ejercicios
- Nota importante
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Clean Code y Deuda técnica
- Introducción a la sección
- Temas puntuales de la sección
- Breve exposición - Deuda técnica y Clean Code
- Nombres pronunciables y expresivos
- Nombres según el tipo de dato
- Ejercicio de nombres según tipo
- Consideraciones para las clases
- Nombres de funciones, argumentos y parámetros
- Ejercicio con funciones
- Detalles adicionales sobre funciones
- Tarea - Refactorizar funciones
- Resolución de la tarea
- Principio DRY
- Aplicando DRY
- Código fuente de la sección

Sección 3: Clean Code - Clases y Comentarios
- Introducción a la sección
- Temas puntuales de la sección
- Breve introducción a las clases en TypeScript
- Herencia - Problemática
- Objetos como propiedades
- Principio de responsabilidad única
- Tarea - Responsabilidad única
- Posible solución a la tarea
- Estructura recomendada de una clase
- Comentarios en el código
- Uniformidad en el proyecto
- Código fuente de la sección

Sección 4: Acrónimo - STUPID
- Introducción a la sección
- Temas puntuales de la sección
- CodeSmells - STUPID
- Acoplamiento y cohesión
- Bajo acoplamiento y alta cohesión
- Code Smells adicionales
- Otros olores honoríficos
- Acopladores
- Código fuente de la sección

Sección 5: Principios SOLID
- Introducción a la sección
- Temas puntuales de la sección
- Principios SOLID - SRP - Responsabilidad Única
- Ejemplo de SRP
- Ejemplo de SRP - Segunda Parte
- Detectar incumplimiento de SRP
- OCP - Principio de abierto y cerrado
- Ejercicio de OCP
- Remover la dependencia de Axios
- Detectar violaciones de OPC
- Principio de Substitución de Liskov
- Ejercicio - Substitución de Liskov
- Solución aplicando los principios OCP y LSP
- Principio de segregación de interfaz
- Ejercicio - Segregación de interfaz
- Aplicar el principio de segregación de interfaz
- Detectar violaciones ISP
- Principio de inversión de dependencias
- Ejercicio de inversión de dependencias
- Mejorando nuestro código
- Aplicar Inversión de dependencias y Substitución de Liskov
- Código fuente de la sección

Sección 6: Fin del curso
- Presentaciones de las clases
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (4, 'spring-ai', 'Spring AI: LLMs, Tools, RAG, Agentes y Deploy en AWS', 'https://cursos.devtalles.com/courses/spring-AI', 'https://import.cdn.thinkific.com/643563/is89v3RgS22dqMndJMVZ_COVER-DEVTALLES-SPRING-IA.jpg', 'Portada del curso: Spring AI: LLMs, Tools, RAG, Agentes y Deploy en AWS', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Integra inteligencia artificial en Java con Spring AI 2.x. Construye un asistente médico educativo completo: Tool Calling, RAG, memoria persistente y agentes inteligentes. Del chatbot básico al deploy en AWS. Stack: Java 21, Spring Boot 4, Gemini.', 1110, 'es', '{"Fundamentos de Spring AI: Integración de LLMs, ChatClient, ChatModel, prompts y streaming.","Desarrollo de agentes: Memoria, Tool Calling, RAG, MCP y patrones de agentes inteligentes.","Infraestructura: PostgreSQL, Docker, Chroma y despliegue completo en AWS.","Proyecto real: Un asistente médico educativo construido paso a paso.","Stack moderno: Java 21, Spring Boot 4, Spring AI 2.x, PostgreSQL, Docker Compose, Chroma y AWS.","LLMs: Google Gemini, Ollama y portabilidad entre proveedores.","Prompt Engineering: PromptTemplate, Few-shot, Context Engineering, Structured Outputs y archivos .st.","Tool Calling: Integración de funciones, APIs y bases de datos desde el modelo.","Memoria y RAG: JdbcChatMemory, embeddings, vector stores, DocumentReader, TextSplitter y QuestionAnswerAdvisor.","Agents: Chain Workflow, Routing Workflow, Orchestrator-Workers, Human-in-the-Loop y Progress Notifications.","MCP: Resources, Prompts, Tools e integración mediante Model Context Protocol.","Testing: Integración de herramientas MCP y pruebas sobre modelos no deterministas.","Producción: Docker multi-stage, AWS ECR, EC2, RDS, CloudWatch y monitoreo.","Y mucho más...","Comprenderás cómo integrar modelos de IA dentro del ecosistema Spring utilizando Spring AI.","Desarrollarás agentes inteligentes con memoria, Tool Calling, RAG y MCP.","Aprenderás a construir aplicaciones listas para producción utilizando Docker y AWS.","Tendrás un proyecto completo desplegado que podrás utilizar como parte de tu portafolio profesional."}', 'https://cursos.devtalles.com/courses/spring-AI', '2026-09-24 15:49:29.94579+00', '{"Haber completado un curso de Java y Java Avanzado o dominar la programación funcional en Java.","Tener conocimientos previos de Spring Boot."}', '{}', 'Sección 1: Introducción
- Introducción al curso
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos de LLMs y Spring AI
- Introducción a la sección
- Temas puntuales de la sección
- Panorama del curso
- ¿Qué es un LLM?
- Tokens, prompts y parámetros
- ¿Qué es Spring AI y por qué existe?

Sección 3: Proyecto, configuración y primera llamada
- Introducción a la sección
- Temas puntuales de la sección
- Crear el proyecto
- Conectar Spring AI con Gemini
- Tu primera llamada al LLM
- ¿Qué es y cómo funciona ChatResponse?
- Detrás del .call()
- ChatClient: la forma recomendada
- Exponer el asistente con un endpoint REST
- Streaming: respuestas en tiempo real
- Código fuente

Sección 4: Portabilidad de Modelos
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué importa la portabilidad?
- Instalar y configurar Ollama
- De Gemini a Ollama sin cambiar código
- Selección dinámica de modelo en runtime
- Anatomía de un modelo
- Elegir modelo para producción
- Código fuente

Sección 5: Context Engineering: Prompts, Templates y System Prompt
- Introducción a la sección
- Temas puntuales de la sección
- Context Engineering
- Controller, Service y Dto
- PromptTemplate: La condición
- PromptTemplate: archivos.st
- Few-shot prompting: enseñar con ejemplos
- Chain-of-thought: El razonamiento
- Role prompting y system prompt
- Aplicar las técnicas al asistente médico
- Código fuente

Sección 6: Structured Outputs
- Introducción a la sección
- Temas puntuales de la sección
- Texto libre vs datos estructurados
- Structured Output: Manual
- Structured Output: entity()
- Extraer la resolución de clientes
- Enums, anotaciones Jackson y listas
- Tipos anidados: respuestas complejas
- Structured output con prompt templates
- Structured output como clasificador
- Código fuente

Sección 7: Tools: Funciones, Keycloak y APIs Externas
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Tool Calling y por qué cambia todo?
- Configuración del modelo
- Creación de repositorios y DataLoader
- El servicio que retorna AppointmentInfo
- Tu primera tool: búsqueda de turnos
- Registrar tools como default en el ChatClient
- Múltiples tools: el modelo elige
- Tool chaining: el modelo encadena tools
- ToolContext: datos del servidor en la tool - parte 1
- ToolContext: datos del servidor en la tool - parte 2
- ¿Que es Keycloak y por qué lo necesitamos?
- Keycloak: infraestructura y configuración parte 1
- Keycloak: infraestructura y configuración - parte 2
- Spring Security: JWT - parte 1
- Spring Security: JWT - parte 2
- Spring Security: JWT - parte 3
- API externa: El servicio - parte 1
- API externa: El servicio - parte 2
- API externa: El servicio - parte 3
- Tool de medicamentos: conectar con el modelo
- Tool de escritura: reserva de turno - parte 1
- Tool de escritura: reserva de turno - parte 2
- Tool de escritura: reserva de turno - parte 3
- Ajustes finales- excepciones y streaming
- Código fuente

Sección 8: Memoria, RAG y Advisors
- Introducción a la sección
- Temas puntuales de la sección
- El problema de la memoria y ChatMemory
- Probamos la memoria del chat
- Persistir en memoria con JDBC
- ¿Qué es RAG y por qué lo necesitamos?
- Embeddings y vector stores
- Chroma con Docker
- El problema del VectorStore
- Integrar VectorStore al ChatClient
- Ingestar documentos médicos
- RAG en acción: memoria, documentos y tools
- Custom Advisors
- El crash: conversationId no puede ser nulo
- La trazabilidad- CONVERSATION_ID
- Código fuente

Sección 9: Agentes: de Workflows y Autonomía
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es un agente?
- El Agent Loop: el concepto fundamental
- Chain Workflow: el concepto
- Chain Workflow - parte 1
- Chain Workflow - parte 2
- El bean compartido no sirve para agentes
- Routing Workflow: el concepto
- Routing Workflow: implementación - parte 1
- Routing Workflow: implementación - parte 2
- Orchestrator-workers: el concepto
- Orchestrator Workers: implementación - parte 1
- Orchestrator Workers: implementación - parte 2
- Orchestrator Workers: implementación - parte 3
- Human-in-the-loop: la confirmación - parte 1
- Human-in-the-loop: la confirmación - parte 2
- Human-in-the-loop: cancelación y prueba
- Progress Notifications: informar el progreso
- Agente abierto: el modelo decide
- Código fuente

Sección 10: MCP: Cliente y Servidor
- Introducción a la sección
- Temas puntuales de la sección
- Blindar el ClientResolver
- Ingestión y carga de nuevos documentos
- Probando la carga de documentos
- MCP: ¿Qué es y cómo funciona?
- Conectar MedAssitant a un MCP Server
- Github vía MCP
- MedAssistant como MCP Server: Resources
- Consumir el Resource desde Postman
- MCP Server: Prompts
- Exponer Tools vía MCP
- Engram MCP: persistencia entre sesiones
- STDIO vs HTTP
- Código fuente

Sección 11: AWS: de Localhost a Producción
- Introducción a la sección
- Temas puntuales de la sección
- AWS: Servicios y costos
- Crear cuenta AWS y activar billing alerts
- El profile: aws
- Migración a PGVector
- Refactor del ClientResolver
- Refactor de ingesta, @Profile y test end-to-end
- Dockerizando la app: el Dockerfile
- Test del container local
- ECR: publicar la imagen en un registry privado - parte 1
- ECR: publicar la imagen en un registry privado - parte 2
- RDS: PostgreSQL gestionada en la nube
- EC2, Security Group y Elastic IP - parte 1
- EC2, Security Group y Elastic IP - parte 2
- Preparando EC2: SSH, Docker, swap y IAM Role - parte 1
- Preparando EC2: SSH, Docker, swap y IAM Role - parte 2
- Deploy en producción: docker-compose - parte 1
- Deploy en producción: docker-compose - parte 2
- Aplicar el fix del sslRequired
- Hardening, pausar la infraestructura
- Código fuente

Sección 12: Fin de curso
- Más información sobre nuestros otros cursos
- Fin de curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (24, 'spring-boot', 'Java: Spring Boot - Guía definitiva', 'https://cursos.devtalles.com/courses/spring-boot', 'https://import.cdn.thinkific.com/643563/ueDsP3FS6aHlcy3KlSLL_SPRING5.jpg', 'Portada del curso: Java: Spring Boot - Guía definitiva', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende Spring Boot desde cero: inicia con Spring MVC y Thymeleaf creando un sitio web dinámico con JdbcTemplate y controladores básicos. Luego desarrolla un API REST con seguridad, JPA, relaciones en BD y buenas prácticas MVC.', 2130, 'es', '{}', 'https://cursos.devtalles.com/courses/spring-boot', '2026-09-24 15:49:29.94579+00', '{"Idealmente: conocimientos en Java (nivel inicial y avanzado).","Mínimo indispensable: Java inicial y fundamentos de programación funcional.","De lo contrario, el curso podría resultar muy desafiante.","¿Aún no dominas Java?","Te recomendamos seguir nuestra Ruta de Aprendizaje de Java antes de avanzar a este curso."}', '{}', 'Sección 1: Introducción al curso
- Introducción a la sección
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a Spring boot
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué usar algo como Spring boot?
- Spring boot 3 vs Spring boot 4
- Spring boot: Creando el proyecto
- Spring boot: La estructura del proyecto
- Spring boot: @Controller parte 1
- @Controller VS @RestController
- th: Model & ModelMap & Map
- Bucles y condicionales- th:if & th:each
- ¿Qué es ModelAttribute?
- ModelAttribute parte 2
- Formularios GET + filtros con RequestParams
- PathVariable VS RequestParam
- Cómo gestionar un filtro doble con PathVariable
- Conflicto path y Thymeleaf: El objeto stat
- Aplicando estilos CSS al HTML
- Ejecutando con: mvn spring-boot-run
- Los .properties y @Configuration
- Cadenas especiales: redirect & forward parte 1
- Cadenas especiales: redirect & forward parte 2
- Deploy y ejecución desde terminal
- Código fuente
- Repaso interactivo: Introducción a Spring boot

Sección 3: Introducción a HTML
- Introducción a la sección
- Temas puntuales de la sección
- HTML y CSS Preparando el entorno
- Introducción al lenguaje HTML
- La etiqueta Head
- HTML: El body y las etiquetas de contenido
- HTML: etiquetas básicas primera parte
- HTML: etiquetas básicas segunda parte
- HTML: etiquetas básicas tercera parte
- HTML: Etiquetas de estructura
- Código fuente

Sección 4: Introducción a CSS
- Introducción a la sección
- Temas puntuales de la sección
- CSS: primeros pasos
- CSS: Selectores, especificidad, id VS class
- CSS: padding, margin, width, height
- CSS: box-sizing & :root & span
- Box Model, medidas absolutas y relativas
- Display: block, inline-block, inline & list-item
- CSS: el atributo position parte 1
- CSS: el atributo position parte 2
- Display: FlexBox
- Display: Flexbox parte 2
- CSS: selectores avanzados + hover
- flex-basis & reutilizando clases & box-shadow
- Display: Grid primeros pasos
- Display: Grid parte 2
- Combinando Flex y Grid
- Display: Grid y grid-templates-areas
- object-fit & scale()
- Flex y Grid responsive
- La filosofía ganadora: Mobile First
- Tareas: Mobile first
- Tarea + media query usando and y or
- Código fuente

Sección 5: Spring Boot y Persistencia con JdbcTemplate: La Base del Portfolio
- Introducción a la sección
- Temas puntuales de sección
- Portfolio: La presentación
- Creando el proyecto y modelo de datos
- neon.tech & configurando DB
- Create Table y cargando datos DB
- Repositorio: Personalinfo & RowMapper
- Repositorio: PersonalInfo avanzando en el CRUD
- Repositorio: PersonalInfo queriForObject(...)
- PersonalInfo: Service & RestController
- Postman: Probando el RestController
- Skill: El repositorio parte 1
- Skill: finalizando repositorio y servicio
- Tarea Education: servicio y repositorio
- Tarea Experience: servicio y repositorio
- Test: PersonalInfo
- Test: Education
- Test: Experience
- Test: Skill
- Código fuente de la sección
- Repaso interactivo: Spring Boot y Persistencia con JdbcTemplate: La Base del Portfolio

Sección 6: Validator, Excepciones globales y Transacciones
- Introducción a la sección
- Temas puntuales de la sección
- Request & Métodos & Status code
- ¿Qué es una Api Restful?
- Validator: Validaciones declarativas en el servicio
- Validator: Tarea y @Min & @Email
- Creando excepciones de validaciones personalizadas
- El @ControllerAdvice y las Vistas
- Creando el primer @Controller & form
- Test: @PortfolioController
- Transacciones y principio ACID
- @Transactional en la capa de servicios
- Aplicando robustez a la entidad Skill
- Aplicando robustez a la entidad Education
- Aplicando robustez a la entidad Experience
- Validaciones avanzadas
- Creando el: @RestController y el @Service
- Finalizando validaciones
- Código fuente
- Repaso interactivo: Validator, Excepciones globales y Transacciones

Sección 7: Pruebas unitarias y de integración
- Introducción a la sección
- Temas puntuales de la sección
- Pruebas unitarias y pruebas de integración
- Skill: prueba de integración, el éxito
- Skill: prueba de integración, el fracaso
- Test integración: La Tarea
- Introducción práctica a los test unitarios
- Test unitarios desde: Spring boot - parte 1
- Test unitarios desde: Spring boot - parte 2
- Test unitarios desde: Spring boot - parte 3
- Test unitarios desde: Spring boot - parte 4
- Pruebas Unitarias: conceptos y setup
- Pruebas unitarias: SkillServiceImpl los find
- Pruebas unitarias: SkillServiceImpl el save
- Test: camino de éxito del save del ServiceSkill
- EducationServiceImpl: test unitarios - find
- EducationServiceImpl: test unitarios - save
- Tarea final: PersonalInfoService & ExperienceService
- Código fuente
- Repaso interactivo: Pruebas unitarias y de integración

Sección 8: Portfolio dinámico con Thymeleaf
- Introducción a la sección
- Temas puntuales de la sección
- Thymeleaf y la vista index
- El poder de los Fragments en Thymeleaf
- Fragmento Skills: parte 1
- Fragmento Skills: parte 2
- Fragmento: Education & Experience
- El header & about
- La sección: Contact form
- Código fuente
- Repaso interactivo: Portfolio dinámico con Thymeleaf

Sección 9: Project, DTO, MultipartFile y validaciones
- Introducción a la sección
- Temas puntuales de la sección
- Project: Postgres y la table projects
- Project: El repositorio parte 1
- Project: El repositorio parte 2
- ¿Qué son los DTO?
- ProjectService & ProjectMapper
- ProjectController: listar, guardar y validar
- FileStorageService: guardando imagen
- Injectando el FileStorageService en el ProjectService
- Agregando imagen a la BD y el directorio
- Fragmento: Project
- Maquetación del Form project
- Maquetación de la table del proyecto
- Anclando las secciones
- Mostrar errores en la vista HTML
- Redireccionando al error-page.html
- Código fuente
- Repaso interactivo: Project, DTO, MultipartFile y validaciones

Sección 10: Adaptando el modelo con el pátron DTO - Completando los CRUD
- Introducción a la sección
- Temas puntuales de la sección
- Ajustando detalles de diseño y sintaxis
- Creando el SkillDto y refactorizando
- SkillController y SkillMapper parte 1
- SkillController parte 2
- SkillController: Eliminar Skill parte 3
- HTML: list-skills.html
- HTML: form-skill.html
- Cloudinary & CRUD de Skills
- Refactorizando: Experience & Education
- ExperienceController CRUD
- EducationController CRUD
- Vista HTML & @DateTimeFormat
- PersonalInfo: Dto, Controller y HTML parte 1
- PersonalInfo: Dto, Controller, HTML parte 2
- Menú de navegación: administrador
- Ajustando detalles en la vista
- Código fuente
- Repaso interactivo: Adaptando el modelo con el pátron DTO - Completando los CRUD

Sección 11: Spring Security: Autenticación, Autorización y Protección con CSRF
- Introducción a la sección
- Temas puntuales de la sección
- Spring Security y la dependencia
- ¿Qué es @Component?
- ¿Cuándo utilizar @Component?
- @Component VS @Bean
- @Configuration y SecurityFilterChain
- Autenticación en memoria y protección de rutas
- PasswordEncoder & SQL
- User: DTO, Model y Repository
- UserDetailsServiceImpl y WebSecurityConfig
- Login: Vista HTML y primer inicio de sesión
- Navegación: Login & Admin
- Login: protegiendo ruta y gestionando error
- Logout: Cerrar sesión
- CSRF: Cross-Site Request Forgery
- CSRF: El Token
- Maquetando los buttons
- Cerrar sesión: el mensaje
- Migración del portfolio a Spring boot 4
- Código fuente
- Repaso interactivo: Spring Security: Autenticación, Autorización y Protección con CSRF

Sección 12: API - Arquitectura y CRUD de Eventos
- Introducción a la sección
- Temas puntuales de la sección
- API: Gestión de eventos
- Creando el domain: Event
- JPA & Hibernate: ddl-auto
- JpaRepository: El proxy dinámico
- La capa de servicio: EventService & IEventService
- MapStruct & DTOs
- El controlador: RequestDto, GET & POST
- Validaciones y ResponseEntity
- Manejador de excepciones: @ControllerAdvice
- La búsqueda por ID: ResourceNotFoundException
- Update: @MappingTarget
- @DeleteMapping: La prueba total
- JPA & JdbcTemplate
- Código fuente
- Repaso interactivo: API - Arquitectura y CRUD de Eventos

Sección 13: Implementación de la seguridad con JWT
- Introducción a la sección
- Temas puntuales de la sección
- Integrando Spring Security
- Relación entre tablas @ManyToMany & @JoinTable
- User y Role Repository: JPA Query Methods
- El servicio: UserDetailsServiceImpl
- Creando las primeras configuraciones de seguridad
- En desarrollo usamos: CommandLineRunner
- Autenticación básica: El controlador
- JWT: El secreto
- JWT: Generar Token
- JWT: Configurando el Controller
- JWT: Validando Token & retornando el usuario
- JWT: Implementando el filtro JWT
- JWT: AuthenticationEntryPoint
- JWT: JwtAuthEntryPoint y JwtAuthenticationFilter parte 1
- Analizamos el flujo de Autenticación - parte 2
- RegisterDto, UserMapper y registerUser parte 1
- RegisterDto, UserMapper y registerUser parte 2
- Autorización basada en roles con JWT
- Código fuente
- Repaso interactivo: Implementación de la seguridad con JWT

Sección 14: Optimización de Consultas y Gestión Avanzada de Relaciones JPA
- Introducción a la sección
- Temas puntuales de la sección
- UserMapper: asignación de roles parte 1
- UserMapper: asignación de roles parte 2
- Configurando la consola: de la base datos h2
- Relaciones de entidades: JPA parte 1
- Relaciones de entidades: JPA parte 2
- Relaciones y dominio de entidades parte 3
- Repositorios y DataLoader: Category & Speaker
- Diseño y actualización de Dtos para entidades relacionadas
- Mapper: Category, Speaker Role y Event
- EventMapper y mvn clean install
- Category CRUD parte 1
- Category CRUD parte 2
- Probando CRUD Category
- El problema de las relaciones bidireccionales en JPA
- Speaker CRUD parte 1
- Speaker CRUD parte 2
- Speaker CRUD parte 3
- Ajustando el Event Dtos & Mapper
- EventService: parte 1
- EventService & EventController parte 2
- DataIntegrityViolationException Integridad de datos
- Paginación y filtrado parte 1
- Paginación y filtrado parte 2
- Código fuente
- Repaso interactivo: Optimización de Consultas y Gestión Avanzada de Relaciones JPA

Sección 15: CORS y el problema N + 1
- Introducción a la sección
- Temas puntuales de la sección
- CORS Cross Origin Resource Sharing
- El componente: CorsConfigurationSource
- Probando la configuración de CORS
- Lazy vs Eager: El problema N + 1
- Solución 1: Join Fetch
- Probando: Join Fetch
- ¿Qué función cumple @JsonIgnore?
- Solución 2: @EntityGraph
- Código fuente
- Repaso interactivo: CORS y el problema N + 1

Sección 16: Introducción a los test unitarios y de integración
- Introducción a la sección
- Temas puntuales de la sección
- La pirámide de testing
- Test unitarios: Creando y configurando la clase
- Test unitarios: testeando las búsquedas
- Test unitarios: save() parte 1
- Test unitarios: save() parte 2
- Test unitarios: save() parte 3
- Test unitarios: findAll sin filter name
- Test unitarios: findAll con filter
- Test de integración: primeros pasos
- Test de integración: setUp() y Configuraciones de Seguridad excluidas
- Test integración: findById()
- Test de integración: not Found & findAll parte 1
- Test de integración- findAll & pageable & filter
- Test integración: save()
- Test de integración: update()
- Test de integración: delete()
- Código fuente
- Repaso interactivo: Introducción a los test unitarios y de integración

Sección 17: Camino a Producción: Postgres - OpenAPI - Logger - Docker y render.com
- Introducción a la sección
- Temas puntuales de la sección
- Configuraciones: properties & postgres
- Documentación: OpenAPI (Swagger)
- Documentación y Seguridad
- Probando Swagger: JWT & Authorize
- Profile & SecurityConfig "dev" & "prod"
- Logging Estratégico
- Logger: Trace, Debug, Info, Warm, Error/Fatal
- Logging profesional logback-spring.xml
- Containerización con Docker
- Dockerfile Multi-stage build
- Docker compose
- Migración de la API a Spring boot 4
- render.com producción
- Código fuente
- Repaso interactivo: Camino a Producción: Postgres - OpenAPI - Logger - Docker y render.com

Sección 18: Despedida del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (14, 'spring-boot-microservicios', 'Spring Boot 4: Arquitectura de Microservicios', 'https://cursos.devtalles.com/courses/spring-boot-microservicios', 'https://import.cdn.thinkific.com/643563/eajq3CPwT1ovajpqVu2O_image.png', 'Portada del curso: Spring Boot 4: Arquitectura de Microservicios', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Domina microservicios con Spring Boot 4: arquitectura de capas, MongoDB, Docker, Kubernetes, comunicación entre servicios, resiliencia, seguridad OAuth2, observabilidad y patrones enterprise. Proyecto e-commerce con buenas prácticas de producción.', 1260, 'es', '{}', 'https://cursos.devtalles.com/courses/spring-boot-microservicios', '2026-09-24 15:49:29.94579+00', '{"Conocimientos sólidos de Java y POO: manejo fluido de clases, interfaces, herencia y excepciones.","Experiencia previa con Spring Boot: familiaridad con controladores REST, JPA, validaciones y conceptos básicos de Spring Security.","Docker (no excluyente): comprensión general de qué es un contenedor, cómo ejecutar una imagen y cómo interpretar un archivo docker-compose.yml.","SQL y bases de datos relacionales: conocimiento de tablas, relaciones y consultas básicas."}', '{}', 'Sección 1: Introducción
- Introducción al curso
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- Instalación de Docker
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos de Arquitectura y Ecosistema
- Introducción a la sección
- Temas puntuales de la sección
- ¿Cómo vamos a trabajar en el curso?
- Monolitos, spring modulith y microservicios
- ¿Qué es realmente un microservicio?
- ¿Cuando dar el salto a microservicios?
- Bounded contexts ¿Cómo dividir el código?
- RabbitMQ parte 1
- RabbitMQ parte 2
- HTTP y RabbitMQ
- RabbitMQ- La comunicación asíncrona
- Creando el esqueleto físico
- Spring boot- nuevas características
- Service Discovery (Eureka Server)
- El mapa de ruta
- Código fuente

Sección 3: Product Service - Construcción del Núcleo
- Introducción a la sección
- Temas puntuales de la sección
- Dockerfile: La etapa de construcción
- Dockerfile: El producto final
- docker-compose.yml: MongoDB
- docker-compose.yml: product-service y volumes
- ¿Qué es NoSQL?
- ¿Qué es MongoDB?
- MongoDB Compass: prueba de persistencia
- Product Service: El modelo
- El repositorio y credential=null
- Credenciales de MongoDB parte 1
- Credenciales de MongoDB parte 2
- El servicio: record, DTO y MapStruct parte 1
- El servicio: CRUD parte 2
- El servicio: CRUD parte 3
- El controlador: CRUD completo
- Excepciones personalizadas: ProblemDetail
- Validaciones y Error 400 (Bad request)
- La red de seguridad: Error 500
- El servicio: mensajes en la consola
- Código fuente

Sección 4: Comunicación Síncrona entre Microservicios: Order & Inventory
- Introducción a la sección
- Temas puntuales de la sección
- Infraestructura Global (BD centralizadas)
- Inventory: model y dto
- Inventory: repository, mapper y exception
- Inventory service: el servicio - parte 1
- Inventory service: el servicio - parte 2
- Inventory: el controlador
- Probando configuración inventory-db
- Order service: pom y model
- Order service: dto y mapper
- Order service: El servicio y el repositorio
- Order service: el controlador
- Probando el order service en Postman
- WebFlux: WebClient
- Probando comunicación entre order e inventory
- Descontando stock (HTTP síncrona) parte 1
- Descontando stock: La transacción distribuida
- HTTP Interfaces parte 1
- Interface, WebClient, Factory y Adapter
- Código fuente

Sección 5: Config Server (Centralización)
- Introducción a la sección
- Temas puntuales de la sección
- El servidor de configuraciones
- Conectando Inventory a Config Server local
- Migrando a la nube: GitHub privado & seguridad
- Estandarización: Product y Order service
- Refresh Scope: Product service
- Actuator: Modo venta infinito
- Actuator: El botón de pánico
- Código fuente

Sección 6: Service Discovery & API Gateway
- Introducción a la sección
- Temas puntuales de la sección
- Auditoria de seguridad en Eureka parte 1
- Auditoria de seguridad en Eureka parte 2
- Service Discovery: Configuración y conexión
- API Gateway: parte 1
- API Gateway: parte 2
- Config server: VM Options
- Balanceo de carga
- API Gateway y Config Server
- Comunicación resiliente: Order e Inventory
- Probando comunicación resiliente
- Escalabilidad final product-service
- La lógica del balanceo
- Código fuente

Sección 7: Seguridad con Keycloak
- Introducción a la sección
- Temas puntuales de la sección
- La evolución de la seguridad
- Servidor de identidad (Infraestructura)
- Configuración del Reino (Realm & Clients)
- Blindando el Gateway (Resource server)
- El patrón Token Relay (Propagación)
- Prueba integral de seguridad (Postman)
- Configuraciones permanentes
- Verificación de Identidad (Gmail + KeyCloak)
- Automatización de roles y registros
- Traductor de roles (JWT Converter)
- Configurando rutas y roles
- Historial de pedidos: Lógica de propietario
- Historial de pedidos: Lógica de propietario 2
- SecurityConfig & Github: Probando la seguridad
- Código fuente

Sección 8: Resiliencia y Límites de la Sincronía en Arquitecturas Distribuidas
- Introducción a la sección
- Temas puntuales de la sección
- Cuando los microservicios fallan (Circuit breaker)
- Setup de Resilience4j y seguridad de Actuator
- Introducción a Actuator
- Circuit Breaker: Implementación
- Retry pattern ¿Qué es?
- Retry pattern: En el código
- Retry pattern: La prueba
- Timeout pattern ¿Qué es?
- Timeouts: Configuración
- El problema de la transacción distribuida
- Preparación para eventos
- Código fuente

Sección 9: Arquitectura Orientada a Eventos & Sagas (RabbitMQ)
- Introducción a la sección
- Temas puntuales de la sección
- RabbitMQ parte 1
- RabbitMQ parte 2
- HTTP y RabbitMQ
- Integrando RabbitMQ al Docker compose
- Configuración JSON (Adiós a los bytes)
- Definiendo el evento (El contrato completo)
- Producer (Order Service)
- Ejecución y validación Postman & RabbitMQ
- Configuración RabbitMQ: (Queue & Binding)
- Crear el listener y probar (La escucha).mp4
- Fan-Out Completado (Notification service)
- Integración JavaMailSender - Envío real
- Pase a producción (Gmail y Perfiles)
- Saga Pattern ¿Qué es?
- Order confirmada y Order cancelada
- Limpieza de persistencia vía Docker
- Notificaciones basadas en certezas
- Consistencia eventual y actualización "status" parte 1
- Consistencia eventual y actualización "status" parte 2
- Patrón Saga: método 1 - Consumo competitivo
- Retry pattern: Reintentos automáticos
- Topic Exchange y Direct Exchange
- Dead Letter Queue mensajes fallidos
- Patrón Saga: método 2 - @RabbitHandler
- Código fuente

Sección 10: Resiliencia de Datos y Alto Rendimiento
- Introducción a la sección
- Temas puntuales de la sección
- Virtual Threads: Gateway y Notification
- El problema de la dependencia de disponibilidad
- Outbox: persistencia atómica 1
- Outbox: persistencia atómica 2
- Message relayer: El cartero de mensajes
- Transactional Outbox y Coreografía extrema
- Código fuente

Sección 11: Observabilidad Total en Microservicios con LGTM Stack y OpenTelemetry
- Introducción a la sección
- Temas puntuales de la sección
- OpenTelemetry y la observabilidad moderna
- OpenTelemetry en: Order Service 1
- OpenTelemetry en: Order Service 2
- OpenTelemetry en: Inventory & Api-gateway
- Diagnóstico y Monitoreo de Microservicios
- Prometheus: Las métricas
- Código fuente

Sección 12: De Docker Compose a Kubernetes: Deploy Completo en Producción
- Introducción a la sección
- Temas puntuales de la sección
- Kubernetes: El director de orquesta
- Instalación de laboratorio
- El Dockerfile: Multistage
- La guía de producción
- Conceptos base y PVCs
- Bases de datos y RabbitMQ
- Inyectando imágenes y levantando la infraestructura
- Los deployments de los Microservicios 1
- Los deployments de los Microservicios 2
- El gran cambio: De Eureka a Kubernetes
- Keycloak en Kubernetes 1
- Keycloak en Kubernetes 2
- Microservicios La prueba
- Observabilidad con Grafana
- Código fuente

Sección 13: Fin de curso
- Más información sobre nuestros otros cursos
- Fin de curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (9, 'spring-boot-patrones-arquitectura', 'Spring Boot 4: Patrones de arquitectura', 'https://cursos.devtalles.com/courses/spring-boot-patrones-arquitectura', 'https://import.cdn.thinkific.com/643563/50BIjVSQ6m0KbI6hAzlA_COVER-DEVTALLES2.jpg', 'Portada del curso: Spring Boot 4: Patrones de arquitectura', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Lleva tu nivel de Spring Boot de CRUD a arquitectura profesional. Construye Atlas-Bank: un proyecto que aplica SOLID, patrones GoF, DDD, arquitectura hexagonal, Keycloak, ArchUnit y AI como cliente. Clases cortas y con código real.', 1230, 'es', '{}', 'https://cursos.devtalles.com/courses/spring-boot-patrones-arquitectura', '2026-09-24 15:49:29.94579+00', '{"Conocimiento en Java y Spring Boot"}', '{}', 'Sección 1: Introducción
- Introducción a la sección
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Los cimientos: por qué la arquitectura importa
- Introducción a la sección
- Temas puntuales de la sección
- Los objetivos: Aprendizaje y Proyecto
- El costo del código sin arquitectura
- Setup del proyecto base - parte 1
- Setup del proyecto base - parte 2
- Conectando las capas del proyecto 1
- Conectando las capas del proyecto 2
- Principios SOLID
- Single Responsibility: el servicio que hace todo
- Open Closed: extender sin romper
- Liskov: herencia que no miente
- Interface segregation: interfaces que no estorban
- Dependency inversion: depender de abstracciones
- Inyección de dependencia: Qué es y cómo funciona
- Package-by-layer vs Package-by-feature
- Checkpoint del proyecto
- Código fuente

Sección 3: Arquitectura en capas con criterio
- Introducción a la sección
- Temas puntuales de la sección
- Anatomía de un monolito bien hecho
- DTOs: separación entre lo que se expone y lo que se persiste
- DTOs: request, response y @Data
- Mapeo de DTOs: MapStruct 1
- Mapeo de DTOs: MapStruct 2
- ProblemDetail: errores con estándar RFC 7807
- @RestControllerAdvice centralizado
- Bean validation en DTOs
- Validaciones custom de petición - parte 1
- Validaciones custom de petición - parte 2
- Código fuente

Sección 4: Seguridad con Keycloak
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué seguridad en un proyecto de arquitectura?
- Mapeo JPA: @Table, @Column y referencia por Id
- Docker: repasando conceptos
- Docker compose: La opción
- Keycloak con Docker compose - parte 1
- Keycloak con Docker compose - parte 2
- Spring boot como Resource Server
- SecurityFilterChain: protección basada en rol 1
- SecurityFilterChain protección basada en rol 2
- Probando la seguridad: USER y ADMIN
- Seguridad como infraestructura, no como dominio
- Código fuente

Sección 5: Patrones que organizan la lógica
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué patrones de diseño?
- Strategy en Spring: Inyección de colecciones
- Strategy en el proyecto: Hands-on
- Template Method: parte 1
- Template Method: parte 2
- Template Method: parte 3
- Factory Method: Creación desacoplada
- Factory Method: ventaja y limitación
- Observer: Eventos de aplicación
- Observer en Spring: ApplicationEventPublisher
- Decorador: Enriquecer sin modificar 1
- Decorator: Enriquecer sin modificar 2
- Spring AOP: el decorador que ya estás usando
- Código fuente

Sección 6: Patrones que Conectan las Piezas
- Introducción a la sección
- Temas puntuales de la sección
- Refactorizando: enums
- Adapter: integrar lo que no encaja - parte 1
- Adapter: intregrar lo que no encaja - parte 2
- Adapter: integrar lo que no encaja - parte 3
- Facade: simplificar subsistemas complejos 1
- Facade: simplificar subsistemas complejos 2
- Chain of responsability: Procesamiento en cadena
- Proxy: control de acceso transparente
- Proxy en Spring: de manual a @Cacheable
- State: comportamiento que cambia con el estado 1
- State: comportamiento que cambia con el estado 2
- State patterm: La integración al servicio
- Builder: construcción paso a paso
- Código fuente

Sección 7: Domain-Driven Design Táctico
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es DDD y por qué importa?
- Entidades: identidad que persiste
- Value Objects: igualdad por valor - pt1
- Value Objects: igualdad por valor - pt2
- Value Objects en el proyecto - pt1
- Value Objects en el proyecto - pt2
- Aggregates: qué son y por qué existen
- Aggregates en el proyecto
- Aggregates: relaciones entre raices
- Domain services: Lógica entre entidades
- Application Services: Orquestación
- Domain Events y AbstractAggregateRoot
- Repository como abstracción del dominio
- Modelo rico en el proyecto
- Tarea: Email como Value Object
- ¿Qué hace que algo sea un Value Object?
- Código fuente

Sección 8: Arquitectura Hexagonal: Migración
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es la Arquitectura Hexagonal?
- Puertos de entrada
- Puertos de salida
- Adaptadores de entrada: REST como adaptador
- Adaptadores de salida: JPA como adaptador
- Adaptadores de salida: APIs externas
- Estructura + separación del dominio (Account) - Partet 1
- Estructura + separación del dominio (Account)- Partet 2
- Estructura + separación del dominio (Account) - Parte 3
- Refactoring Account: application + infrastructure
- Refactoring Transaction: dominio
- Refactoring Transaction: separación JPA y eventos - Parte 1
- Refactoring Transaction: separación JPA y eventos - Parte 2
- Refactoring Transaction: separación JPA y eventos - Parte 3
- Refactoring Transaction: separación JPA y eventos parte 4
- Limpieza final: Customer, shared y verificación
- Limpieza final: El dominio acoplado con Spring
- Completando los casos de uso pt1
- Completando los casos de uso pt2
- Código fuente

Sección 9: Arquitectura Hexagonal: Desde cero
- Introducción a la sección
- Temas puntuales de la sección
- El dominio primero
- Puertos: qué ofrece y qué necesita
- Primer flujo completo: crear tarea - pt1
- Primer flujo completo: crear tarea - pt2
- El flujo de hexagonal explicado paso a paso
- Repetir el flujo: listar y buscar
- Gestión de errores: @RestControllerAdvice
- Repetir el flujo: completar y reabrir
- Gestión de errores: IllegalStateException
- Intercambiabilidad: cambiar adaptador sin tocar el dominio
- ¿Cuándo vale la pena hexagonal?
- Código fuente

Sección 10: CQRS Liviano
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es CQRS?
- Commands: objetos de escritura
- Queries y Read Models
- CQRS en el proyecto: integrar y verificar
- Account: creamos CreateAccountCommand
- Commands y Queries: cómo funcionan
- CQRS: trade-offs y cuándo aplicarlo
- Código fuente

Sección 11: ArchUnit y Testing de Dominio Puro
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es el testing arquitectónico?
- ArchUnit: primera regla de dependencia
- Reglas de Hexagonal con ArchUnit
- Tests: Spring Security
- Reglas de naming
- Detección de ciclos
- Testing del dominio Parte 1
- Testing del dominio Parte 2
- Testing Money
- Testing Email
- Código fuente

Sección 12: AI y Arquitectura
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué la AI con un curso de arquitectura?
- Instalación de OpenCode
- Conectar OpenRouter
- Build y Plan Parte 1
- Build y Plan Parte 2
- Custom agents Parte 1
- Custom agents Parte 2
- MCP: conectar herramientas externas
- AI agent: como adaptador de entrada
- Tool use: cómo el agente ejecuta acciones
- Conectando el agente Parte 1
- Conectando el agente Parte 2
- Conectado al agente Parte 3
- La AI genera y la AI consume
- Arquitectura lista para la AI
- Código fuente

Sección 13: Fin de curso
- Más información sobre nuestros otros cursos
- Fin de curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (19, 'springboot-mvc-hexagonal', 'Spring Boot: De MVC a Hexagonal', 'https://cursos.devtalles.com/courses/springboot-mvc-hexagonal', 'https://import.cdn.thinkific.com/643563/onRaVfSdR56WUL2jXpQz_COVER-DEVTALLES-MINI-CURSO-SPRING-BOOT.jpg', 'Portada del curso: Spring Boot: De MVC a Hexagonal', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Programa intensivo de Diseño de Software con Spring Boot. Aprenderás a crear apps modulares y resilientes con Arquitectura Hexagonal. Usaremos una migración de JPA a MongoDB para mostrar el acoplamiento y aplicar Inversión de Dependencias.', 510, 'es', '{}', 'https://cursos.devtalles.com/courses/springboot-mvc-hexagonal', '2026-09-24 15:49:29.94579+00', '{"Este no es un curso introductorio a Java ni a Spring Boot. Está pensado para desarrolladores que ya cuentan con experiencia previa en desarrollo backend y desean profundizar en arquitectura de software y diseño de proyectos.","Para aprovechar el curso, es importante que tengas:","Conocimientos básicos de Java","Bases sólidas de Programación Orientada a Objetos","Uso básico de programación funcional (lambdas, streams, Optional)","Experiencia previa construyendo APIs REST","Familiaridad con controladores, servicios, DTOs y persistencia","No es obligatorio que sea con Spring Boot; puede ser con Node.js, NestJS u otro framework backend","Conocimientos generales de bases de datos","No es necesario ser experto, pero sí entender qué significa persistir información","¿Aún no dominas Java?","Te recomendamos seguir nuestra Ruta de Aprendizaje de Java antes de avanzar a este curso."}', '{}', 'Sección 1: Introducción al curso
- Introducción a la sección
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: El Modelo MVC Backend
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a la arquitectura de software y filosofía del curso
- MVC: Dos mundos diferentes
- Representaciones: interna y externa, el modelo
- API: primer flujo completo
- Inversión de dependencia
- Creando un DTO de respuesta
- Comprendiendo H2 y configurando BD
- Las relaciones en las bases de datos (JPA)
- Ajustando repositorio, servicio y poblando BD
- HabitRequestDTO & el problema N + 1
- RequestDTO, ResponseEntity & ResponseDTO
- Validación e integración con la lógica de negocio & RequestDTO
- ¿Qué es MVC backend?
- ¿Qué es MVC backend? parte 2
- DTO vs Entity
- Lógica de negocio VS lógica de infraestructura
- Identificando lógica de infraestructura y negocio
- Código fuente

Sección 3: Migrando a MongoDB - El problema del acoplamiento
- Introducción a la sección
- Temas puntuales de la sección
- SQL VS NoSQL
- ¿Qué es NoSQL?
- ¿Qué es MongoDB?
- MongoDB: El cluster
- El problema: Alto acoplamiento
- MongoDB: El modelo & ObjectId
- MongoDB: El repository & MongoTemplate
- El servicio & DataSeeder
- Completamos la migración a MongoDB
- La defensa de MVC
- MVC: desde la arquitectura de capas
- ¿Qué es un cluster? & MongoDB Compass
- Código fuente

Sección 4: La arquitectura hexagonal - Construyendo la resiliencia
- Introducción a la sección
- Temas puntuales de la sección
- Creando el proyecto y sus capas principales
- Arquitectura Hexagonal: El domain
- Completando el Domain: puerto de entrada y salida
- Manejo global de excepciones
- El servicio: La lógica de negocio pura
- El adaptador de salida (Conectando JPA)
- El adaptador de entrada (La puerta web)
- Cableado y prueba de fuego (Primer run)
- Completando con la entidad: LogEntryEntity
- Completando el flujo del: findAll()
- findById & El enfoque estricto vs el pragmático
- Analizando el flujo de la arquitectura hexagonal
- El aislamiento del controlador/servicio & servicio/adaptador
- Migrando la BD de: JPA a MongoDB
- Creamos HabitMongoAdapter y la conexión BD
- El dominio es el rey, un cambio que lo confirma
- Testeabilidad extrema - parte 1
- Testeabilidad extrema - parte 2
- ¿Qué es la arquitectura hexagonal? - parte 1
- ¿Qué es la arquitectura hexagonal? - parte 2
- Código fuente

Sección 5: Introducción a los Microservicios
- Introducción a la sección
- Temas puntuales de la sección
- De monolito modular a sistema distribuido
- Creando el proyecto y configurando BD
- Model, controller, repository y service
- Finalizando Gamification y prueba en Postman
- El cliente Feign y la comunicación parte 1
- El cliente Feign y la comunicación parte 2
- Manejo de fallos y @PrePersist
- Código fuente

Sección 6: Fin de curso
- Más información sobre nuestros otros cursos
- Fin de curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (53, 'sql-con-postgres', 'SQL de cero: Tu guía práctica con PostgreSQL', 'https://cursos.devtalles.com/courses/sql-con-postgres', 'https://import.cdn.thinkific.com/643563/k6V4tlGTXmUQS8CGxGID_SQL.jpg', 'Portada del curso: SQL de cero: Tu guía práctica con PostgreSQL', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'El objetivo es aprender sobre bases de datos relacionales partiendo desde cero, pasando por queries, triggers, procedimientos almacenados hasta optimizaciones.', 960, 'es', '{"Fundamentos de SQL: Sentencias DDL, DML, DQL y TCL, tipos de datos y consultas.","Modelado de bases de datos: Diagramas entidad-relación, llaves, relaciones e índices.","Consultas avanzadas: JOINs, subqueries, CTE, funciones agregadas, JSON y arreglos.","Programación en PostgreSQL: Funciones, procedimientos almacenados, triggers y extensiones.","Entorno de trabajo: Docker y Neon para ejecutar PostgreSQL.","SQL: Consultas, inserciones, actualizaciones, eliminaciones y transacciones.","Diseño de bases de datos: Diagramas entidad-relación, llaves y relaciones.","Consultas avanzadas: JOINs, subqueries, CTE, funciones de fecha, JSON y arreglos.","Optimización: Índices, constraints, checks y actualizaciones en cascada.","Programación: Funciones personalizadas, procedimientos almacenados y triggers.","Y mucho más...","Serás capaz de diseñar y desarrollar bases de datos relacionales utilizando PostgreSQL.","Dominarás SQL desde los conceptos básicos hasta funcionalidades avanzadas.","Aprenderás a modelar información, optimizar consultas y automatizar procesos dentro de la base de datos.","Obtendrás conocimientos aplicables a la mayoría de motores de bases de datos relacionales que utilizan SQL."}', 'https://cursos.devtalles.com/courses/sql-con-postgres', '2026-09-24 15:49:29.94579+00', '{"Tener conocimiento de programación estructurada será útil en la parte de PL/pgSQL.","Conocimiento de Docker será útil, pero no es necesario.","Poder realizar instalaciones en el equipo es necesario."}', '{}', 'Sección 1: Introducción al curso
- Introducción al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones generales
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Preparar ambiente de pruebas
- Introducción a la sección
- Temas puntuales de la sección
- Docker - Ambiente recomendado
- Conectarnos TablePlus
- Conectarnos - PgAdmin
- Opcional - Serverless Postgres - Neon.tech
- No recomendado - Instalación física en equipo
- Código fuente

Sección 3: Generalidades y primeros pasos
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las bases de datos
- Levantar base de datos
- Mi primera tabla
- Insertar registros
- Actualizar registros
- Seleccionar registros
- Cláusula where
- Eliminar registros
- Drop vs Truncate table
- Tarea de lo aprendido hasta el momento
- Solución de la tarea
- Operadores de strings y funciones
- Intermedio - Substring y Position
- Tarea - First y Last Name - Columnas
- Código fuente de la sección

Sección 4: Funciones agregadas - agrupaciones y ordenamiento
- Introducción a la sección
- Temas puntuales de la sección
- Preparar base de datos
- Tarea para entrar en calor
- Operador BETWEEN
- Funciones agregadas - MAX MIN COUNT ROUND AVG
- GROUP BY
- Exposición - Terminología y estructura
- HAVING
- Distinct
- Group By con otras funciones
- SubQueries
- Tarea - Aggregation
- Solución de la tarea
- Código fuente de la sección

Sección 5: Intermedio - Relaciones, Llaves y Constraints
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las relaciones
- Introducción a las llaves
- Preparación de base de datos y tablas
- Añadir llave primaria - manualmente
- Constraint - Check
- Check con múltiples posibilidades strings
- Alter table - Drop Constraint
- Índices de base de datos
- Creando índices
- Tarea - Llaves y checks
- Unique Index - Problemas de vida real
- Creando llaves foráneas
- Llave foránea con countrylanguage
- ON DELETE - CASCADE
- Código fuente de la sección

Sección 6: Intermedio - Separación de data en otras tablas
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de base de datos
- Tabla de continentes
- Relación, checks y respaldo de Country
- Actualización masiva
- Cambio de tipo y llave foránea
- Tarea - Language Table
- Solución a la tarea
- Código fuente de la sección

Sección 7: Joins - Uniones
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de la base de datos
- Cláusula - UNION
- Union de tablas - Where
- INNER JOIN
- Alterar secuencias - Insertar nuevo continente
- FULL OUTER JOIN
- RIGHT OUTER JOIN - Exclusive
- Aggregations + Joins
- Count Union - Tarea
- Tarea - País con más ciudades
- Multiples Joins con agrupaciones
- Cuarta relación en el query
- Tarea - Idioma más hablado por países de Europa
- Solución de la tarea
- Código fuente de la sección

Sección 8: Queries - Fechas, intervalos y funciones sobre fechas
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de la base de datos
- Funciones básicas de fechas
- Consultas sobre fechas
- Intérvalos
- Diferencia entre fechas y actualizaciones
- Cláusula CASE - THEN
- Código fuente de la sección

Sección 9: Generación de llaves primarias
- Introducción a la sección
- Temas puntuales de la sección
- SERIAL vs IDENTITY
- Llave primaria compuesta
- UUIDs
- Secuencias
- Código fuente de la sección

Sección 10: Diseño de bases de datos - Medium
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a los diagramas entidad-relación
- Software para crear diagramas
- Medium Database
- Tabla de "users"
- Tabla de "posts"
- Tabla de "claps"
- Tabla de "comments"
- Tabla de "user_lists"
- Preguntemos consultas posibles
- Indices necesarios
- Creación de base de datos en Postgres
- Código fuente de la sección

Sección 11: Ejercicios con base de datos de medium - Intro Funciones
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de la base de datos
- Tarea medium - Queries
- Solución de la tarea - Medium Queries
- Solución de queries avanzados
- Solución con funciones de base de datos
- Código fuente de la sección

Sección 12: Diseño de bases de datos - Más ejercicios
- Introducción a la sección
- Temas puntuales de la sección
- Exposición sobre diseños
- Diseños de BD y buenas prácticas - Parte 2
- Diseño - Warehouse DB
- Diseño de tabla "merchant"
- Diseño de ordenes de compra
- Tarea - Twitter tweets y followers
- Solución - Twitter
- Idea Airbnb

Sección 13: Vistas, Vistas materializadas y Common Table Expression
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de la base de datos
- Vistas
- Vistas materializadas
- Cambiar nombre de vistas y vistas materializadas
- Common Table Expressions - CTE
- Multiples CTEs
- CTE Recursivo
- CTE Recursivo - Números ascendentes
- CTE Recursivo - Tabla de multiplicar
- Preparación de la tabla - Employees
- CTE Recursivo - Estructura organizacional
- CTE Recursivo - Estructura organizacional con límite
- Tarea - Mostrar nombres de los jefes
- Ejemplo sin recursividad - Preparación
- Resolución de la tarea
- Ejemplo sin recursividad
- Código fuente de la sección

Sección 14: Funciones personalizadas
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de la base de datos
- Creando nuestra primera función
- Problema - Determinar un posible aumento
- Función - max_raise
- Multiples queries y variables
- IF, THEN, ELSE, END IF
- Rowtype
- Código fuente de la sección

Sección 15: Stored Procedures
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de la base de datos
- Función que regresa una tabla
- Procedimientos almacenados
- Procedimiento de aumento salarial
- Creación del procedimiento
- Código fuente de la sección

Sección 16: Triggers + Funciones + Procedimientos
- Introducción a la sección
- Temas puntuales de la sección
- Encriptar y verificar contraseña
- Procedimiento almacenado - user_login
- Resolución de la tarea
- Triggers
- Trigger When
- Código fuente de la sección

Sección 17: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (44, 'vue-cero-a-experto', 'Vue.js: De cero a experto - edición 2024', 'https://cursos.devtalles.com/courses/vue-cero-a-experto', 'https://import.cdn.thinkific.com/643563/fGtdD0wpSv2VEXdrM6vn_VUE-COMPOSITION-API.jpg', 'Portada del curso: Vue.js: De cero a experto - edición 2024', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Nueva entrega renovada del curso que se enfoca plenamente en el Composition Api, TypeScript y Vitest para crear aplicaciones modernas.', 2250, 'es', '{"Fundamentos de Vue: Componentes, reactividad, directivas, eventos, comunicación entre componentes y manejo del estado.","Composition API y Script Setup: La forma moderna de desarrollar aplicaciones con Vue, creando código más limpio, reutilizable y mantenible.","Gestión de estado con Pinia: Actions, State, Getters, módulos y organización de aplicaciones escalables.","Consumo de APIs: Uso de Fetch API, Axios, interceptores y manejo de peticiones HTTP.","Routing y navegación: Vue Router, layouts, Lazy Loading, guards globales, por ruta y asíncronos.","Testing: Pruebas unitarias y de integración utilizando mocks, spies y herramientas modernas.","Aplicaciones modernas: Desarrollo de interfaces dinámicas utilizando componentes reutilizables y Composition API.","Autenticación y seguridad: Implementación de flujos de autenticación, protección de rutas y manejo de sesiones.","Formularios y carga de archivos: Validación de formularios, imágenes y manejo eficiente de archivos.","Arquitectura profesional: Organización de proyectos pequeños, medianos y de gran escala siguiendo buenas prácticas.","Despliegue a producción: Configuración de entornos de Development, Test y Production para publicar aplicaciones listas para el mundo real.","Vue progresivo y arquitectura basada en componentes.","Directivas, eventos y modificadores.","Composition API y Script Setup.","Options API (para comprender su funcionamiento).","Pinia: State, Actions, Getters y módulos.","Axios, Fetch API e interceptores.","Autenticación y Vue Router.","Lazy Loading y diferentes estructuras con Layouts.","Pruebas unitarias y de integración con mocks y spies.","Composable Functions.","Tailwind CSS.","Comunicación entre componentes.","Carga y validación de imágenes.","Despliegue de aplicaciones a producción.","Y muchos temas más.","Serás capaz de desarrollar aplicaciones profesionales utilizando Vue.js con confianza.","Dominarás las herramientas y patrones modernos que utilizan equipos de desarrollo en proyectos reales.","Aprenderás a implementar pruebas automáticas que aumentan la calidad y mantenibilidad de tus aplicaciones.","Tendrás la experiencia necesaria para estructurar proyectos de cualquier tamaño siguiendo buenas prácticas."}', 'https://cursos.devtalles.com/courses/vue-cero-a-experto', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de programación básica","Conocimiento de JavaScript básico","Poder realizar instalaciones en el equipo","El curso se puede seguir en Window, Linux o Mac OSx","Conocimiento de TypeScript es opcional pero recomendado"}', '{}', 'Sección 1: Introducción al curso
- Introducción al curso
- ¿Cómo realizar preguntas?
- ¿Cómo funcionará el curso?
- Instalaciones necesarias

Sección 2: Reforzamiento de JavaScript / TypeScript
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Bases de JS/TS
- Let vs Var vs Const
- Object Literals
- Arrays
- Functions
- Functions - Segunda parte
- Desestructuración de objetos
- Desestructuración de Arreglos
- Importaciones y exportaciones
- Tipado de datos
- Promesas
- Argumentos a las promesas
- Fetch API
- Interfaces de TypeScript
- Axios
- Async - Await
- Código fuente de la sección

Sección 3: Introducción a Vue.js
- Introducción a la sección
- Temas puntuales de la sección
- Breve introducción sobre Vue.js
- Composition vs Options Api
- Hola Mundo
- Estado del componente - Variables reactivas
- Separar HTML y eventos
- v-for - Iterar elementos
- v-if vs v-show
- Eventos y propiedades computadas
- v-model
- Código fuente de la sección

Sección 4: Vue + Vite - Single-File Components
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Indecision App
- Explicación de archivos y directorios
- Trabajando con SFC - Single File Components
- Estado y eventos
- Nuestro primer componente
- Define Props - Recibir Properties
- Componente tradicional
- Separar lógica del SFC
- Integrar estilos de terceros
- Crear y desplegar aplicación
- Composable Functions
- Reutilizar lógica del contador
- Código fuente de la sección

Sección 5: Indecision App - Continuación
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Continuación de la sección
- Estructura y diseño del chat
- Diseño de mensajes
- Comunicación entre componentes
- Emitir eventos - DefineEmits
- Pensemos en composables
- Nota de actualización
- Realizar petición HTTP
- Referencias a elementos HTML
- Código fuente de la sección

Sección 6: Introducción a las pruebas unitarias y de integración
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las pruebas
- Configuración de Vitest
- Tarea - Pruebas sobre sumatoria de arreglo
- Pruebas sobre componentes de Vue
- Configuraciones de TypeScript
- Pruebas sobre renderizado del componente
- Disparar eventos - trigger
- Probar composables - useCounter
- Pruebas en el componente ChatBubble
- Pruebas en el componente MessageBox
- Probar emisiones
- Probar modificadores de eventos
- Pruebas en el componente ChatMessages
- Probar que el scroll se dispare
- Pruebas en el componente IndecisionView
- Pruebas en composable - useChat
- Mock del Fetch API
- Cobertura del testing
- Código fuente de la sección

Sección 7: Pokemon Game
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Inicio de proyecto - PokemonGame
- Estructura de la aplicación
- Enumeraciones y tipado de datos
- Propiedades computadas y orden aleatorio
- Determinar el pokemon correcto
- Componente PokemonPicture
- Mostrar las posibles opciones
- Determinar si la persona gana o pierde
- Bloquear opciones
- Nuevo juego
- Alias para paths
- Código fuente de la sección

Sección 8: Testing - Pokemon Game
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Empecemos por lo atómico - Axios y Tipos
- Pruebas en PokemonPicture
- Pruebas en PokemonOptions
- Pruebas con disabled y estilos
- usePokemonGame - Pruebas y problemas
- Flush Promises
- Axios Mock Adapter
- Pruebas en funciones del composable
- Evaluar la función checkAnswer
- Mock default export - Canvas Confetti
- Pruebas en PokemonGame - Mock de código propio
- Pruebas en PokemonGame - Componentes
- Pruebas en PokemonGame - Últimas pruebas
- Código fuente de la sección

Sección 9: Vue Router - SPA - Single Page Applications
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - Vue Router
- Preparación de la estructura y archivos
- Instalación de Vue Router
- Re-utilización de estructura HTML
- Tailwind Components
- Rutas hijas y padres
- Auth Layout
- Página 404
- Argumentos por URL
- Procesar argumentos por URL
- useRouter - Composable
- Proteger Rutas
- Ciclo de vida de los componentes
- Keep Alive - Activar y Desactivar
- Router Link Active
- Código fuente de la sección

Sección 10: Vue Router - Testing
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- Pruebas en App y LandingLayout
- Pruebas en PokemonPage - Stubs
- Pruebas con Guards - isAuthenticated
- Espías en LocalStorage
- Pruebas en el router - Parte 1
- Pruebas en el router - Parte 2 - Argumentos
- Código fuente de la sección

Sección 11: Pinia - Slots y DaisyUI
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la aplicación
- Inicio de sección - ProjectsApp
- Librería de componentes DaisyUI
- Estructura de los componentes
- Estructura de projects view
- Botón Flotante con Slots
- Modals sin slots
- Funcionalidad del modal
- Named Slots - Slots con nombre
- Código fuente de la sección

Sección 12: Pinia - Gestor de estado
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto - Instalación de Pinia
- Projects Store
- Usando el Store
- Colocar foco en el modal
- Store to LocalStorage
- Menú lateral
- Project View - Pantalla para ver el proyecto
- Redireccionar si no existe el proyecto
- Tarea: Agregar tareas al proyecto
- Resolución de la tarea
- Completar tareas y progreso
- Código fuente de la sección

Sección 13: Slots y Pinia Testing
- Introducción a la sección
- Temas puntuales de la sección
- Configuraciones iniciales
- Pruebas en el Main.ts
- Pruebas en FabButton - Clases
- Pruebas en FabButton - Slots
- Pruebas en CustomModal - Slots y Atributos
- Pruebas en Store de Pinia
- Store - Add Project y LocalStorage
- Agregar Tarea y Cambiar completado
- Store $Patch
- SideMenu - Pinia Test Utils
- Projects View
- ProjectView - Mock sobre store
- Código fuente de la sección

Sección 14: Administración de productos - Estructura inicial y Backend
- Inicio de sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - AdminShop
- ShopLayout - Diseño de la tienda
- Levantar nuestro backend
- Variables de entorno - Axios
- Obtener productos paginados
- TanStack Query - useQuery
- Obtener el url de las imágenes
- Mostrar productos en pantalla
- Solución de la tarea
- Componente para la paginación
- Funcionalidad de la paginación
- Carga adelantada y Scroll
- Código fuente de la sección

Sección 15: Autenticación y Autorización
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Login Action - Autenticación
- Pinia - AuthStore
- Realizar proceso de autenticación
- Terminar pantalla de login
- Tarea - Registro de usuarios
- Registro de usuarios
- Interceptores de Axios
- Subscripción de estado y Redirecciones
- Guard - No Autenticado
- Cerrar sesión
- Nota de actualización
- Resolución de tarea - IsAdminGuard
- Pantalla de carga
- Código fuente de la sección

Sección 16: Formularios y Mantenimiento de Productos
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Pantalla de productos
- usePagination - Composable
- Pantalla de Producto
- Cargar información del producto
- Formularios - Ref y Reactive - El problema
- Formularios en Vue - VeeValidate
- Mostrar los errores en pantalla
- Custom input y v-model
- Custom TextArea y Posteo del formulario
- Selectores y Arreglos
- Inicializar formulario con valores del producto
- Indicador visual de tallas seleccionadas
- Metadata del formulario
- Errores en español
- Código fuente de la sección

Sección 17: Carga de archivos y posteos
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Acción - UpdateProduct
- useMutation - Actualizar producto
- Crear un nuevo producto
- Evitar duplicidad de código
- File selector - Mostrar imágenes antes de cargarlas
- Postman - Carga de imagen
- Cargar imágenes al guardar producto
- Código fuente de la sección

Sección 18: Desplegar aplicación final
- Introducción a la sección
- Temas puntuales de la sección
- Levantar aplicación - Backend y Frontend
- Generar aplicación de distribución
- Subir backend a GitHub
- Aprovisionar base de datos - NeonTech
- Desplegar backend a Railway
- Cambios y actualizaciones en el despliegue
- Resolución de la tarea

Sección 19: Testing - Admin Shop
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Diferentes envs por ambiente
- Probar que componentes existan - ShopLayout.test
- Pruebas con interceptores de Axios
- Configuración global de Yup
- Prepara información falsa
- getProductImageAction y getProductsAction
- getProductById - Obtener un producto
- Pruebas a la hora de crear un producto
- Pruebas a la hora de actualizar un producto
- Pruebas cargando archivos
- SEED - Asegurar pruebas flexibles
- Pruebas en ProductsView - TanStack
- Mock TanStack
- ProductView - Preparación para pruebas
- Debe de mostrar un producto en pantalla
- Debe de postear el formulario
- Código fuente de la sección

Sección 20: Bonus: Quasar
- Introducción a la sección
- Temas puntuales de la sección
- Enlaces oficiales
- Instalación y creación de una app con Quasar
- Explicación de los archivos del proyecto
- Explicación del directorio SRC
- Cambiar la iconografía de la aplicación
- Crear páginas y rutas
- Navegación dinámica
- Typography
- Crear definición de enlaces en archivo independiente
- Controlar el menú lateral desde Vuex
- useUI - Composable Function
- Propiedades computadas - Set y Get
- Sistema de Filas y Columnas
- Cambiar tamaño dependiendo de la pantalla
- Flexbox
- Dialogs
- Inputs y Formularios
- Valor del formulario y validaciones personalizadas
- Notificaciones
- Código fuente

Sección 21: MapasApp - Mapbox + Rutas
- Introducción a la sección
- Temas puntuales de la sección
- Nota Importante
- Demostración del proyecto
- Inicio de proyecto - MapasApp
- Preparación inicial del proyecto
- Configurar Vuex con TypeScript
- Primer módulo de Vuex - Places
- Action - getInitialLocation
- Composable - usePlacesStore
- Preparar el espacio para colocar el mapa
- Loading y referencia al contenedor del mapa
- Mostrar mapa de Mapbox
- Mostrar mapa tan pronto tenemos la ubicación del usuario
- Popups y Markers
- Segundo módulo de Vuex - Map
- Establecer mapa en el Store
- Botón para mover a la ubicación central
- SearchResults - Diseño de componente
- Implementar un debounce manualmente
- Mapbox SearchAPI e interfaces
- Realizar petición Http para obtener los lugares
- Almacenar los lugares en el Store
- Mostrar los lugares en el componente de resultados
- Activar lugar y mover la cámara
- Colocar marcadores en todos los lugares encontrados
- Obtener ruta entre dos puntos
- Obtener información de la ruta
- Mostrar la ruta en el mapa
- Borrar la polyline
- Almacenar la distancia y duración
- Mostrar la distancia y duración en pantalla
- Desplegar la aplicación en la web
- Código fuente de la sección

Sección 22: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (125, 'react-cero-experto', 'React: De cero a experto - Fernando Herrera', 'https://cursos.devtalles.com/courses/react-cero-experto', 'https://import.cdn.thinkific.com/643563/yXgRDd8CRcyhf8cZdGP2_LEGACY-REACT-HOOKS-Y-MERN.jpg', 'Portada del curso: React: De cero a experto - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso tiene por objetivo llevarte de cero conocimiento de React hasta un nivel competitivo en el ambiente laboral de hoy en día. Este curso está construido 100% en Hooks y functional components.', 3300, 'es', '{}', 'https://cursos.devtalles.com/courses/react-cero-experto', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias y recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a React y conceptos generales
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es React?
- Primeros pasos en React
- Introducción a Babel

Sección 3: Introducción a JavaScript moderno
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Bases de JavaScript
- Variables y constantes
- Template String
- Objetos literales
- Arreglos
- Funciones
- Desestructuración de Objetos
- Desestructuración de Arreglos
- Import, export y funciones comunes de arreglos
- Múltiples exportaciones y exportaciones por defecto
- Promesas
- Fetch API
- Async - Await
- Operador condicional ternario
- Nota sobre JavaScript
- Código fuente de la sección

Sección 4: Primeros pasos en React
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son los componentes?
- Primera aplicación de React
- Estructura de directorios - CRA
- Estructura de directorios - Vite
- Hola Mundo en React
- Nuestro primer Componente
- Tarea - Crear un nuevo componente
- Retornar elementos en el Componente - Fragment
- Impresión de variables en el HTML
- Colocar estilos de CSS
- Comunicación entre componentes - Props
- PropTypes
- DefaultProps
- Tarea - Componente CounterApp
- Evento click (Eventos en general)
- useState - Hook
- handleSubtract y handleReset
- Código fuente de la sección

Sección 5: Pruebas unitarias y de integración - Probando las secciones anteriores
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las pruebas unitarias y de integración
- Inicio de la sección - Pruebas sobre lo aprendido anteriormente
- Mi primera prueba y configuraciones iniciales
- Jest - Expect - toBe
- Nota de Actualización - Extensión de archivos
- Pruebas en el archivo 02-template-string.js
- toEqual
- Pruebas en el archivo 07-deses-arr.js
- Pruebas en 08-imp-exp.js - Arreglos
- Pruebas con tareas asíncronas
- Pruebas con async-await
- Evaluar el Catch en el async-await
- Pruebas sobre componentes de React
- Pruebas en FirstApp - Componentes de React
- Probar FirstApp
- getByTestId y otras props
- Screen - Testing Library
- Pruebas básicas del CounterApp
- Simular eventos - Click
- Código fuente de la sección

Sección 6: GifExpertApp - Aplicación
- Introducción a la sección
- Temas puntuales de la sección
- Resultado al final de la sección
- Inicio de proyecto - GifExpertApp
- GifExpertApp - Component
- Creando una lista de categorias
- Agregar una nueva categoría
- Componente AddCategory
- Comunicación entre componentes
- Emitir un evento al padre
- Validar que sean únicos los nombres
- GifGrid - Nuevo componente
- Fetch API - Obtener las imágenes deseadas
- useEffect
- Demostración de producción rápido
- Mostrar los títulos de las imágenes
- className - Clases de css
- Custom Hook - useFetchGifs
- Mostrar mensaje de carga
- Archivos de barril
- Código fuente de la sección

Sección 7: Generando el build de producción y despliegues
- Introducción a la sección
- Temas puntuales de la sección
- Desplegar en Netlify
- Preparación del proyecto - Github Pages
- Subir a GitHub
- Desplegando aplicación en Github Pages
- Actualizar Github pages

Sección 8: Testing - Probando la aplicación de GifExpert
- Introducción a la sección
- Temas puntuales de la sección
- Configurar el ambiente de pruebas
- Implementando PropTypes
- Resolución de la tarea
- Pruebas del componente - GifGridItem
- Pruebas en el helper getGifs
- Pruebas del componente - AddCategory
- Simular un submit del formulario
- Jest Functions
- Pruebas del componente GifGrid - Mock customHook
- Hacer un mock completo de un Custom Hook
- Pruebas sobre customHooks
- Pruebas de tarea
- Código fuente de la sección

Sección 9: Profundizando Hooks - Generales
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - HooksApp
- useState
- useCounter - CustomHook
- Exponer métodos del Hook
- useEffect - SimpleForm
- Dependencias del useEffect
- useEffect unmount - Cleanup
- useEffect - Precauciones
- Formulario con custom Hook
- Tarea - Implementar funcionalidad de Reset
- useFetch - CustomHook
- Parametrizar y consumir nuestro custom Hook
- useFetch + useCounter
- Incorporar caché
- useRef - Primer uso
- useLayoutEffect
- Memo - Método de React
- useMemo
- useCallback
- useCallback con argumentos
- Tarea Memorize
- Código fuente de la sección

Sección 10: Profundizando Hooks - useReducer
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al concepto de un reducer
- Continuación del Proyecto - HookApp
- Idea general de un reducer - Vía código
- useReducer - Todo List
- Creando el cascarón de la lista de TODOs
- Tarea: Crear componentes y emitir eventos
- Resolución de la tarea - TodoApp
- Agregar un nuevo TODO
- Guardar y Leer TODOs en LocalStorage
- Borrar un TODO
- Toggle Todo - Marcar como completado o pendiente un TODO
- Tarea - useTodo
- Resolución de la tarea - useTodos
- Código fuente de la sección

Sección 11: Profundizando Hooks - useContext
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al Context
- Preparación de nuestra aplicación con rutas
- Configurar Router en React
- Link
- NavLink
- CreateContext y ContextProvider
- useContext
- Código fuente de la sección

Sección 12: Pruebas unitarias y de integración - Hooks
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Pruebas sobre Hooks
- Pruebas sobre useCounter - CustomHook
- Ejecutar funciones del customHook dentro de las pruebas
- Pruebas sobre useForm - CustomHook
- Pruebas con múltiples hooks simultáneos
- Evaluar respuesta del useFetch
- Pruebas sobre el Reducer
- Resolución de la tarea
- Pruebas en el componente TodoItem
- Pruebas en los eventos del TodoItem
- Pruebas en el TodoApp
- Pruebas con useContext
- Pruebas de funciones del context
- Pruebas generales en nuestro AppRouter
- Código fuente de la sección

Sección 13: Bonus: Repositorio de Custom Hooks
- Introducción a la sección
- Temas puntuales de la sección
- Repositorio con customHooks
- Mejorando la estructura y ayuda de los Hooks
- Código fuente de la sección

Sección 14: HeroesApp - Single Page Application (SPA)
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo al final de la sección
- Inicio de proyecto - HeroesApp
- Nota de Actualización - React Router Docs
- Creando un primer Router
- Colocar clase de la ruta activa
- Creando un segundo Router
- Navigate push / replace - useNavigate
- Lista de Heroes
- Tarjetas con la información del Héroe
- Tarjeta del Héroe - parte 2
- Leer argumentos por URL
- Estilo del componente HeroScreen
- Nota: useMemo
- Animaciones en nuestro componente
- Diseño de la pantalla de búsqueda
- SearchComponent
- Mostrar listado de héroes
- Mostrar mensajes condicionales
- Nota de actualización - Error imágenes producción
- Código fuente de la sección

Sección 15: Protección de rutas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo al final de la sección
- Continuación de proyecto - Protección de Rutas
- Context y Reducer de mi aplicación
- Login de un usuario
- Mantener el usuario activo
- Logout del usuario
- Rutas privadas
- Rutas públicas
- Recordar la última página visitada
- Código fuente de la sección

Sección 16: Pruebas de nuestra aplicación de Heroes
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de la sección - Pruebas en HeroApp
- Pruebas en el authReducer
- Pruebas sobre los Types
- Pruebas en el PublicRoute
- Pruebas en el PublicRoute - Parte 2
- Pruebas en el PrivateRoute
- Pruebas en el AppRouter
- Pruebas en el NavBar
- Solución de la tarea
- Pruebas en el SearchScreen
- Pruebas con los queryParameters
- Tarea - requireActual
- Resumen de las pruebas realizadas
- Código fuente de la sección

Sección 17: JournalApp - MaterialUI - Estructura y Diseño
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - JournalApp
- Configuración de Rutas principales y secundarias
- Nota importante
- Instalación de Material UI
- Configuración de MUI con Vite
- LoginPage - Diseño sin Layout
- LoginPage - Diseño - Segunda Parte
- AuthLayout
- RegisterPage - Diseño
- JournalLayout y JournalPage
- NavBar
- SideBar
- NothingSelectedView - No hay nada seleccionado
- NoteView
- ImageList - Galería de imágenes
- Boton Flotante
- Código fuente de la sección

Sección 18: Redux - ¿Qué es y conceptos? + React Redux
- Introducción a la sección
- Temas puntuales de la sección
- Explicación visual del patrón Redux
- Redux, React Redux y RTK Query
- Inicio de proyecto - Redux-Tool
- ConfigureStore y Slices
- Usar valores del store y despachar acciones
- Tarea - decrement e incrementBy
- Snippet y Gists de Slice
- pokemonSlice
- Thunks
- Axios
- Mostrar los pokemons paginadamente
- RTK Query
- Consumir el API mediante el custom hook
- Obtener un Todo por ID
- Código fuente de la sección

Sección 19: Introducción a Redux y autenticación en Firebase
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Configurando Redux en nuestra aplicación
- Configurar el AuthSlice
- Manejo del formulario de login
- Configuración inicial de Firebase
- Google SignIn - Firebase
- Disparar acción de autenticación
- Formulario de registro de usuarios
- Manejo de errores del formulario
- Validar desde nuestro custom hook
- Mostrar errores en pantalla
- Crear usuario con email y password
- Actualizar el displayName y autenticar el usuario
- Mostrar el mensaje de error de autenticación
- Realizar el login de usuario con correo y contraseña
- Resolución de la tarea - Login de usuario
- Checking Authentication
- Mantener el estado de la autenticación al recargar
- Custom Hook para autenticación
- Logout de Firebase
- Animaciones para la aplicación
- Código fuente de la sección

Sección 20: JournalApp - Redux - CRUD en Firestore y subida de archivos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - JournalApp
- JournalSlice
- Preparar la base de datos - CloudFirestore
- Crear una nueva nota
- Activar la nota creada
- Cargar notas de Firestore
- Mostrar las notas en el menú lateral
- Activar una nota
- Activar una nota para su edición
- Actualizar la nota actual
- Resolución de la tarea
- SweetAlert 2
- Cloudinary.com - Backend para subir imágenes
- Seleccionar archivos desde React
- Subir imagen a Cloudinary
- Múltiples peticiones de forma simultánea
- Mostrar las imagenes cargadas
- Corregir un posible error
- Limpiar notas al cerrar sesión
- Borrar una nota
- Nota deploy en Vercel
- Código fuente de la sección

Sección 21: Pruebas con Redux, Firebase, Firestore y autenticación
- Introducción a la sección
- Temas puntuales de la sección
- Configuración de Testing en Vite
- Continuación de proyecto - JournalTesting
- Configuración del testing
- Pruebas de carga de archivos
- Cloudinary SDK - Delete image
- Pruebas con los Slices de Redux Toolkit
- Pruebas faltantes con el authSlice
- Pruebas sobre Thunks
- Thunks - checkingCredentials correcto e incorrecto
- Thunks - startLoginWithEmailPassword
- Pruebas en Journal Thunks
- Crear base de datos de testing
- Prueba completa sobre inserción
- Variables de entorno
- Variables de entorno Testing y Development
- Configurar variables de entorno de Firebase
- Pruebas en el LoginPage
- Botón de Google debe de llamar startGoogleSignIn
- Mocks de useDispatch
- Disparar el submit del formulario
- Dispatch con valores específicos
- Código fuente de la sección

Sección 22: MERN Calendar - Estructura y Diseño
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - MERN-Calendar
- Rutas de la aplicación
- LoginScreen y Navbar
- React Big Calendar
- Configuraciones adicionales al calendario
- Personalizar el cuadro de evento
- Escuchar eventos del calendario
- Creando un modal sobre el calendario
- Contenido del Modal
- Datepicker en español
- Obtener la información del formulario del evento
- Validaciones del formulario
- Instalación y configuración de Redux
- Mostrar y ocultar modal en base al Store
- CalendarSlice
- Cargar un evento en el modal
- Preparar la creación de un nuevo evento
- Añadir un nuevo evento
- Editar el evento activo
- Eliminar evento
- Redux - serializableCheck
- Código fuente de la sección

Sección 23: CalendarApp - Backend - Node, Express, Mongo
- Introducción a la sección
- Temas puntuales de la sección
- Objetivo al final de la sección
- Inicio de proyecto - CalendarApp Node Backend
- Configurando Express
- Variables de entorno y carpeta pública
- Creando las rutas relacionadas a usuarios
- Endpoints de remover, crear y login
- Recuperar información de un posteo
- Express Validator
- Custom Middlewares
- Configuración de base de datos
- Conectar Node a Mongo Atlas
- Crear un usuario en nuestra Base de Datos
- Validaciones del usuario
- Encriptar la contraseña
- Login de usuario
- Generar un Json Web Token
- Revalidar JWT
- Configurar CORS
- Código fuente de la sección

Sección 24: Backend - Eventos del calendario - CRUD
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - Calendar Backend
- Resolución de la tarea - CRUD
- Modelo Evento
- Validar campos necesarios
- Grabar el evento en la base de datos
- Obtener el listado de los Eventos
- Actualizar un Evento
- Eliminar Eventos
- Código fuente de la sección

Sección 25: Despliegue del backend a la nube
- Introducción a la sección
- Temas puntuales de la sección
- Subir proyecto a GitHub
- Pruebas antes de desplegar
- Desplegar a Railway
- Código fuente de la sección

Sección 26: MERN - Calendario + Backend
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Calendar + Backend
- Creando variables de entorno
- AuthSlice
- useForm - Login y Registro
- Axios - Configurar cliente para peticiones HTTP
- Realizar login de usuario
- Despachar acciones respectivas
- Mostrar error en la autenticación
- Creación de un nuevo usuario
- Mantener el estado de la autenticación
- Cambiar el URL después de una autenticación
- Logout y nombre de usuario
- Código fuente de la sección

Sección 27: MERN CRUD - Eventos del calendario
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Calendar CRUD de Eventos
- Creando un nuevo Evento en el calendario
- Mostrar eventos de la base de datos
- Cargar los eventos al store
- Actualizar el evento
- Cambiar el color de los eventos según usuario
- Eliminar un evento
- Limpiar información del calendario
- Código fuente de la sección

Sección 28: Fin el MERN - Desplegarlo a producción
- Introducción a la sección
- Temas puntuales de la sección
- Levantar proyectos localmente
- Desplegar backend y frontend a la nube
- Código fuente de la sección

Sección 29: Pruebas unitarias y de integración - MERN
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de pruebas - CalendarApp
- Pruebas con la configuración de Axios
- Pruebas en uiSlice
- Pruebas en authSlice
- Probando estados y acciones del authSlice
- Calendar Fixtures
- Pruebas en el calendarSlice
- Tarea - onDeleteEvent y onLogoutCalendar
- Pruebas en FabDelete - incompleta
- Pruebas en el useUiStore
- Probando funciones conectadas al store
- Pruebas faltantes del useUiStore
- Inicio de pruebas en useAuthStore
- startLogin debe de realizar el login correctamente
- startLogin debe de fallar la autenticación
- startRegister debe de crear un usuario
- startRegister debe de fallar la creación
- checkAuthToken debe de fallar si no hay token
- Pruebas en el componente FabDelete
- Pruebas restantes del FabDelete
- Pruebas en el AppRouter
- Debe de mostrar el login en caso de no estar autenticado
- Pruebas con componentes de terceros
- Código fuente de la sección

Sección 30: React 19+: Hooks y Apis nuevas
- Introducción
- Temas puntuales
- Inicio de proyecto - PlanetsApp
- use - Nueva API
- ErrorBoundary
- useActionState - Nuevo Hook
- Crear planeta usando useActionState
- useFormStatus - Estado del formulario padre
- useOptimistic - Cambios antes de completar acción
- useOptimistic - Manejo de errores
- Código fuente

Sección 31: Fin del curso
- Presentaciones utilizadas
- Más información para seguir aprendiendo
- Youtube playlist de React + TypeScript
- ¿Quiéres seguir aprendiendo más de React?
- Más información sobre nuestros otros cursos
- Despedida del curso

Sección 32: Archivado - Heroes App - Router Versión 5
- Demostración del objetivo final de la sección
- Inicio de proyecto - HeroesApp
- Creando un primer Router
- Creando un segundo Router
- History push / replace
- Lista de Heroes
- Tarjetas con la información del Héroe
- Leer argumentos por URL
- Estilo del componente HeroScreen
- Nota useMemo
- Animaciones en nuestro componente
- SearchComponent
- Aplicar filtro de Heroes
- Aplicar filtro en base al QueryString
- Código fuente de la sección

Sección 33: Archivado - Rutas Protegidas - Router Versión 5
- Demostración del objetivo al final de la sección
- Inicio de proyecto - Protección de Rutas
- Context y Reducer de mi aplicación
- Login de un usuario
- Logout del usuario
- Rutas privadas
- Rutas públicas
- Recordar la última página visitada
- Código fuente de la sección

Sección 34: Archivado - Pruebas con Router V5
- Inicio de la sección - Pruebas en HeroApp
- Pruebas en el authReducer
- Pruebas en el PrivateRoute
- Probar que el localStorage sea llamado con argumentos
- Probar que el PrivateRoute no muestre el componente
- Pruebas en el componente AppRouter
- Pruebas en el componente DashboardRoutes
- Pruebas en el componente Navbar
- Pruebas en el componente HeroScreen
- Simular segmentos del URL en nuestras pruebas
- Pruebas en el componente LoginScreen
- Pruebas en el componente SearchScreen
- Pruebas faltantes del componente SearchScreen
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (17, 'tailwindcss-para-desarrolladores', 'TailwindCSS: Para desarrolladores de software', 'https://cursos.devtalles.com/courses/tailwindcss-para-desarrolladores', 'https://import.cdn.thinkific.com/643563/8w7MKPqvQtaLpLNVTgq6_TAILWIND1.jpg', 'Portada del curso: TailwindCSS: Para desarrolladores de software', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a usar Tailwind CSS orientado a desarrolladores, para crear diseños responsivos y modernos, evitando usar JavaScript para esto.', 240, 'es', '{}', 'https://cursos.devtalles.com/courses/tailwindcss-para-desarrolladores', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico sobre CSS, si se conoce sobre MediaQueries mucho mejor."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones Necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: TailwindCSS - Primeros pasos
- Introducción
- Temas puntuales
- ¿Qué es TailwindCSS?
- ¿Cómo funciona Tailwind?
- Tema, base, componentes y utilidades
- Creando un componente
- Flexbox Row
- Flexbox Column
- Grid
- TailwindCSS - Documentación

Sección 3: TailwindCSS localmente + Recomendaciones oficiales
- Introducción
- Temas puntuales de la sección
- Inicio de proyecto - TailwindCSS localmente
- Prettier - Configuraciones necesarias
- .gitIgnore - Configuraciones de Git
- Live Server - Probar y desarrollar
- Ejercicios con pseudo clases
- Código fuente

Sección 4: Pseudo-classes
- Introducción
- Temas puntuales
- Continuación de proyecto
- Ejercicio - Listas
- Ejercicio - Tablas
- Tablas responsivas
- Ejercicio - Formularios
- Elementos hermanos - Peer
- Ejemplo - Has()
- Ejemplo - Grupos
- Ejemplo - Hermanos
- Ejemplo - Grupos anidados
- Ejemplo - Grupos implícitos
- Ejemplo - Diferenciando peers
- Código fuente

Sección 5: Tema y configuraciones
- Introducción
- Temas puntuales
- Continuación de proyecto
- Ejemplo - Diseño responsivo
- Ejemplo - Tema light y Dark
- Cambiar tema manualmente
- Ejercicio - Variables de color
- Ejercicio - Fuentes personalizadas
- Código fuente
- Repaso interactivo: TailwindCSS
- Ejercicios - TailwindCSS

Sección 6: Despedida
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (64, 'tanstack-query', 'TanStack Query - Fernando Herrera', 'https://cursos.devtalles.com/courses/tanstack-query', 'https://import.cdn.thinkific.com/643563/flpkTdo2TwGhr9wfvr33_COVER.jpg', 'Portada del curso: TanStack Query - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'TanStack Query es una librería indispensable para mejorar la experiencia de usuario en nuestras aplicaciones de React. Este curso te enseñará a utilizarlo y sacarle provecho a muchas de sus funcionalidades principales.', 360, 'es', '{}', 'https://cursos.devtalles.com/courses/tanstack-query', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de React y TypeScript"}', '{}', 'Sección 1 - Introducción al curso
- Introducción al curso
- ¿Cómo hacer preguntas?
- ¿Cómo funcionará el curso?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2 - ¿Por qué TanStack Query?
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Número criptográfico aleatorio atmosférico
- Número aleatorio criptográfico atmosférico
- TanStack - Query - Instalación
- useQuery
- DevTools
- Manejo de errores
- Custom Hook - useRandom
- Código fuente

Seccion 3 - TanStack Query - IssuesApp
- Introducción a la sección
- Temas puntuales de la sección
- Instalación y explicación del proyecto
- Instalación - TanStack Query
- Label Issues - Facebook/React
- Axios y Tipo de dato Label
- useLabels + useQuery
- initialData y placeholderData
- Código fuente

Seccion 4 - Issues
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Autenticación en GitHub
- Cargar Issues de GitHub
- Mostrar issues en pantalla
- Cargar issue por número
- Cargar comentarios del Issue
- Código fuente

Sección 5 - Optimizaciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- QueryClient - prefetchQuery
- QueryClient - setQueryData
- Código fuente

Sección 6 - Objetos complejos como cache name
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Manejar el estado de Open, Closed y All
- Filtrar issues - Open y Closed
- Filtrar issues - Labels
- Actualizar la fecha de creación
- Código fuente

Sección 7 - Paginaciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Estructura HTML necesaria
- Paginación - Next y Prev
- Preparación para el infinite scroll
- Infinite Scroll
- Código fuente

Sección 8 - Preparación y reforzamiento
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto
- Levantar el backend
- Configurar TanStack Query
- Acciones e interfaces
- useQuery - Listado de productos
- Mostrar los productos
- Artículos de Hombre y Mujer
- Producto por ID
- Scroll To Top
- Prefetch de productos
- Código fuente de la sección

Sección 9 - Mutaciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- React Hook Form - Formulario
- Terminar formulario
- useMutation - Mutaciones
- Pensemos en custom hooks
- invalidateQueries
- Evitar invalidar el query
- Optimistic Updates
- Optimistic Success
- Optimistic Error
- Código fuente de la sección

Sección 10: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (70, 'typescript-guia-completa', 'TypeScript: Guía Completa - Fernando Herrera', 'https://cursos.devtalles.com/courses/typescript-guia-completa', 'https://import.cdn.thinkific.com/643563/0jbP7pcMSAWjijc04uhG_TYPESCRIPT-NEW.jpg', 'Portada del curso: TypeScript: Guía Completa - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este curso es ideal para cualquier persona que desee entrar a trabajar con TypeScript sin importar si es Angular, React, Vue, React Native, NativeScript, Nestjs, ionic, Node o cualquier framework o librería que use TypeScript.', 510, 'es', '{"Fundamentos de TypeScript: Tipos, interfaces, clases, funciones y programación orientada a objetos.","Buenas prácticas: Tipado estático, modularización y código mantenible.","Preparación para frameworks: Bases sólidas para Angular, React, Vue, NestJS, Node.js y otras tecnologías.","Desarrollo moderno: Herramientas y características utilizadas en proyectos profesionales.","Dominarás los fundamentos y las características más importantes de TypeScript.","Escribirás código más seguro, legible y fácil de mantener.","Obtendrás una base sólida para trabajar con cualquier framework que utilice TypeScript.","Estarás preparado para desarrollar aplicaciones modernas siguiendo las mejores prácticas de la industria."}', 'https://cursos.devtalles.com/courses/typescript-guia-completa', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de JavaScript: variables, ciclos y funciones","Conocimiento básico de programación estructurada es recomendado","Ganas de aprender un nuevo lenguaje basado en tipos","Posibilidad de instalar programas como administrador en su equipo"}', '{}', 'Sección 1: Introducción a TypeScript
- Introducción a TypeScript
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a TypeScript
- Introducción a la sección
- Instalación de TypeScript
- Hola Mundo en TypeScript
- TSConfig.json
- Modo observador - Watch mode

Sección 3: Tipos básicos
- ¿Qué veremos en esta sección?
- Introducción a los tipos de datos
- Más información sobre los tipos de datos
- Inferir tipos y modo estricto
- Booleans - Booleanos
- Numbers - Números
- Strings - Cadenas de caracteres
- Tipo Any
- Arrays - Arreglos
- Tuples - Tuplas
- Enum - Enumeraciones
- Void - Vacío
- Never - Nunca
- Null y Undefined
- Ejercicio práctico #1.
- Tarea y Resolución del Ejercicio #1
- Quiz 1: Exámen teórico #1

Sección 4: Funciones y objetos
- ¿Qué veremos en esta sección?
- Funciones básicas
- Parámetros obligatorios de las funciones
- Parámetros opcionales de las funciones
- Parámetros por defecto
- Parametros REST
- Tipo Función
- Tarea y Resolución del ejercicio práctico #2
- Quiz 2: Examen teórico #2

Sección 5: Objetos y tipos personalizados en TypeScript
- ¿Qué veremos en esta sección?
- Objetos básicos
- ¿Cómo crear objetos con tipos específicos?
- Métodos dentro de los objetos
- Problema con la definición en línea
- Tipos personalizados
- Multiples tipos permitidos
- Ejercicio práctico #3
- Tarea y Resolución del ejercicio práctico #3
- Quiz 3: Examen teórico #3
- Código fuente de la sección

Sección 6: Depuración de Errores y el archivo tsconfig.json
- ¿Qué veremos en esta sección?
- ¿Qué es el archivo tsconfig y para qué nos puede servir?
- ¿Es posible la depuración del código de TypeScript?
- Remover los comentarios de los archivos de JavaScript
- Incluir y excluir carpetas y/o archivos
- outFile - Archivo de salida

Sección 7: Características de ES6 o JavaScript2015 disponibles a través TypeScript
- ¿Qué veremos en esta sección?
- Variables LET
- Desestructuración de Objetos
- Desestructuración de Arreglos
- Ciclo - For of
- Clases en ES6
- Quiz 4: Examen teórico #4
- Código fuente de la sección

Sección 8: Clases en TypeScript
- ¿Qué veremos en esta sección?
- Definición de una clase básica en TypeScript
- Forma corta de asignar propiedades
- Métodos públicos y privados
- Herencia, super y extends
- Gets y Sets
- Clases Abstractas
- Constructores privados
- Código fuente de la sección

Sección 9: Interfaces
- ¿Qué veremos en esta sección?
- Interfaz básica
- Estructuras complejas
- Métodos en la interfaz
- Interfaces en las clases
- Interfaces para las funciones
- Ejercicio práctico #5: Implementación de interfaces
- Tarea y Resolución del ejercicio práctico #5
- Quiz 5: Examen teórico #5
- Código fuente de la sección

Sección 10: NameSpaces
- ¿Qué veremos en esta sección?
- Creando un Namespace
- Inicio de proyecto - Módulos y Webpack
- Imports y Exports
- Export default y exportación con alias
- Tarea - Resolver errores en TypeScript
- Código fuente de la sección

Sección 11: Genéricos - Generics
- ¿Qué veremos en esta sección?
- Introducción a los Genéricos
- Funciones Genéricas
- Ejemplo de función genérica en acción
- Agrupar exportaciones
- Ejemplo aplicado de genéricos
- Mapear respuestas http
- Quicktype.io extensión
- Código fuente de la sección

Sección 12: Decoradores
- ¿Qué veremos en esta sección?
- Introducción a los decoradores
- Decoradores de clases
- Decoradores de fabrica - Factory decorators
- Ejemplo de un decorador - Bloquear prototipo
- Decoradores de métodos
- Decoradores de propiedades
- Código fuente de la sección

Sección 13: Usando librerías que no están escritas en TypeScript ( Como jQuery )
- ¿Qué veremos en esta sección?
- Inicio de proyecto - Express API
- Creando un Rest API con Express
- Trabajar con TypeScript en lugar de JavaScript

Sección 14: Final del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (11, 'vibe-coding', 'Vibe Coding: De forma responsable', 'https://cursos.devtalles.com/courses/vibe-coding', 'https://import.cdn.thinkific.com/643563/QerNZaF2SpWnZLFLnxvR_VIBE%20CODING%20COVER%20DEVTALLES.png', 'Portada del curso: Vibe Coding: De forma responsable', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Crearás aplicaciones reales usando IA como desarrollador, pero con criterio profesional. Aprenderás autenticación, carga de archivos, integración con Supabase y buenas prácticas y seguridad para llevar tus proyectos a producción con confianza.', 270, 'es', '{}', 'https://cursos.devtalles.com/courses/vibe-coding', '2026-09-24 15:49:29.94579+00', '{"Opcional - Tener conocimientos básicos de programación y comprensión general de cómo funciona una aplicación web.","Poder realizar instalaciones en el equipo"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Nota de actualización
- Instalaciones
- Instalación y configuración de Git
- Antigravity Chrome Extension
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Iniciando en Vibe Coding
- Introducción
- Temas puntuales
- Demostración
- Vibe coding - ¿Es peligroso?
- Generar plantilla inicial - Google Stitch
- Creación de proyecto - Luxu-Estate
- Configuraciones y guías iniciales
- Implementar la pantalla de inicio
- Realizar cambios iniciales
- Añadir propiedades y unir ramas
- Supabase - PostgreSQL y más
- Base de datos y paginación
- Tarea - Propiedades a resaltar
- Código fuente

Sección 3: Funcionalidades, investigaciones y multi-idioma
- Introducción
- Temas puntuales
- Demostración
- Continuación de proyecto
- Investigación adicional
- Página de propiedad
- Ramas, commits y cambios
- Filtros y búsquedas
- Ajustes de funcionalidades
- Guardar cambios y unir ramas
- Aplicación multi-idioma
- Cambio de idioma en otras pantallas
- Código fuente
- Repaso interactivo: Buenas prácticas y flujo de trabajo seguro

Sección 4: Autenticación y autorización
- Introducción
- Temas puntuales
- Demostración
- Continuación de proyecto
- Autenticación con redes sociales
- Cerrar sesión y detalles estéticos
- Google SignIn
- Dashboard y sistema de roles
- Verificación de rol
- Diseño del panel administrativo
- Tarea - Ajustes de diseño
- Código fuente

Sección 5: Crear propiedades y carga de archivos
- Introducción
- Temas puntuales
- Demostración
- Continuación de proyecto
- Pantalla para editar y crear propiedades
- Ajustes adicionales en la propiedad
- Ocultar en lugar de borrar propiedades
- Buscador de propiedades
- Subir cambios a GitHub
- Desplegar aplicación - Vercel
- Login en producción
- Código fuente
- Repaso interactivo: Autenticación, Gestión y Despliegue

Sección 6: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (66, 'visual-studio-code', 'Visual Studio Code:Velocidad en codificar - Fernando Herrera', 'https://cursos.devtalles.com/courses/visual-studio-code', 'https://import.cdn.thinkific.com/643563/ozPWxfNjQBKugksdaogB_VSCODE.jpg', 'Portada del curso: Visual Studio Code:Velocidad en codificar - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este curso se enfoca en 2 áreas principales: Aumentar tu velocidad de desarrollo y conocer más sobre VSCode.', 120, 'es', '{"Productividad: Técnicas para aumentar tu velocidad al escribir y modificar código.","VS Code: Funciones, atajos y herramientas que muchos desarrolladores pasan por alto.","Flujo de trabajo: Trucos para editar múltiples líneas, navegar más rápido y trabajar de forma más eficiente.","Editarás código considerablemente más rápido utilizando los atajos adecuados.","Conocerás funciones de Visual Studio Code que mejorarán tu productividad diaria.","Optimizarás tu flujo de trabajo sin importar el lenguaje o framework que utilices."}', 'https://cursos.devtalles.com/courses/visual-studio-code', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de VSCode es recomendado pero no obligatorio"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias y configuración
- Mis recomendaciones iniciales
- Extensiones recomendadas
- Sincronizar configuraciones de VSCode
- Configurar el comando "Code"
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Ediciones y tips básicos
- Introducción a la sección
- Atajos del teclado
- Movimiento de líneas - Primera parte
- Movimiento de líneas - Segunda parte
- Comentar código
- Comentar código y partes del código
- Creación rápida de archivos
- Ir y ojear definiciones
- Borrar líneas
- Deshacer y Rehacer
- Zen mode
- Terminal integrada
- Emmet wrap
- Manejo de tabs
- Tabulaciones
- Creación rápida de carpetas y archivos

Sección 3: Multi Cursores y edición rápida
- Introducción a la sección
- Clonar líneas - Copy line down
- Crear cursores arriba y abajo
- Multi cursor - Copy
- Multi cursor para formato
- Multi cursor - Lowercase y Uppercase
- Múltiples cursores en posiciones específicas
- Siguiente ocurrencia
- Creación de un arreglo de días

Sección 4: Definiciones y Snippets
- Introducción a la sección
- Definiciones en un archivo
- Ir a una línea
- Markdown view - live-preview
- Replace Symbol
- Snippets básicos
- Snippet personalizado - Tarea

Sección 5: Extensiones
- Introducción a la sección
- Paste JSON as Code
- TODO Highlight
- CodeSnap
- Themes
- Live Server
- Color Highlight
- Settings.json

Sección 6: Cierre del curso
- Más información sobre nuestros otros cursos
- Fin del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (63, 'legacy-vue-options-api', 'Vue.js: De cero a experto - Fernando Herrera', 'https://cursos.devtalles.com/courses/vue-js', 'https://import.cdn.thinkific.com/643563/7Xfyuy5mSxKwKBzXHYEr_COVER-DEVTALLES-legacy-vue-option-api.jpg', 'Portada del curso: Vue.js: De cero a experto - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Curso completo sobre Vue.js que parte de cero conocimiento sobre este framework hasta llevarte a un nivel profesional competitivo.', 2580, 'es', '{}', 'https://cursos.devtalles.com/courses/vue-js', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de HTML, CSS y JavaScript:","Ideal para quienes ya han trabajado con la web, aunque sea a nivel básico.","Muchas ganas de aprender Vue.js de manera estructurada:","El curso empieza desde cero, pero avanza a un nivel profesional.","Tener Node.js y un editor de código (como VSCode) instalado:","Necesario para trabajar con Vue CLI y herramientas modernas de desarrollo.","Conexión a internet para descargar dependencias y probar APIs externas:","Parte del contenido depende de peticiones HTTP, Firebase, y servicios como Mapbox."}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas y obligatorias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Reforzamiento de JavaScript
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Bases de JavaScript
- Let vs Var vs Const
- Template literals
- Object literal
- Arrays
- Functions
- Functions - Segunda Parte
- Desestructuración de objetos
- Desestructuración de Arreglos
- Importaciones y exportaciones
- Exportar funciones - Tarea
- Promesas
- Argumentos a las promesas
- Fetch API
- Axios
- Async - Await
- Async - Await - Aplicado
- Ternarios y null check
- Código fuente de la sección

Sección 3: Introducción a Vue.js
- Introducción a la sección
- Temas puntuales de la sección
- Breve introducción sobre Vue.js
- Puntos interesantes de Vue.js
- Hola Mundo - Vue.js
- Representación declarativa
- Estado del componente - Data
- Introducción a los eventos
- Directiva v-for
- Indices y desestructuración dentro de v-for
- Directiva v-model
- Modificadores de eventos
- Directivas v-if y v-show
- Recapitulación de la sección
- Código fuente de la sección

Sección 4: Vue CLI - Primera aplicación real
- Introducción a la sección
- Temas puntuales de la sección
- Bonus: Atajos de Vue.js
- Inicio de proyecto - FundamentosApp
- Estructura de directorios generada por defecto
- Estructura básica del directorio SRC
- Mi primer componente
- Estado del componente y Vue DevTools
- Propiedades computadas - Computed Properties
- Incrementar y Decrementar
- Properties - Props
- Diferentes formas de definir las props
- Validación de los props
- Código fuente

Sección 5: IndecisionApp - Continuación
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final
- Continuación de proyecto - FundamentosApp
- Indecision Component
- Watch - Observar cambios en una propiedad reactiva
- Realizar petición HTTP a un backend
- Pulir detalles de nuestra aplicación
- Código fuente de la sección

Sección 6: Introducción a las pruebas unitarias y de integración
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las pruebas unitarias y de integración
- Mi primera prueba
- Expect
- Snapshot
- Verificar valor en una etiqueta HTML
- FindAll vs Find
- Simular eventos
- Optimización de código
- Leer props desde pruebas
- Enviar Props y evaluarlas
- Pruebas iniciales en el Indecision component
- Definir las pruebas a realizar
- Spy y Mocks
- Spy con la instancia de Vue
- Tarea: Probar que el getAnswer fue llamado
- Pruebas sobre Fetch Api
- Simular un fallo en el API
- Código fuente de la sección

Sección 7: Pokemon Game
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo al final de la sección
- Inicio de proyecto - Pokémon Game
- Estructura del proyecto y componentes
- Diseño de los componentes
- Funcionalidad de PokemonPicture
- Lógica de los nombres de los pokémons
- Obtener nombres de los 4 pokémons
- Mostrar las opciones posibles
- Seleccionar un pokémon aleatoriamente
- Emit - Emitir eventos
- Resultado y reinicio de juego
- Desplegar nuestro juego en producción
- Código fuente de la sección

Sección 8: Pokemon Game - Unit Test
- Introducción a la sección
- Temas puntuales de la sección
- Pruebas con Axios
- Pruebas en helpers
- getPokemonNames y getPokemonOptions
- Nota de actualización
- Pruebas en PokemonPicture
- PokemonPicture - Segunda Parte
- Pruebas en PokemonOptions
- Pruebas con emisiones
- Pruebas en PokemonPage
- Snapshot con data y stubs
- Tarea: Pruebas de que los componentes existan
- Pruebas las propiedades reactivas del componente
- Código fuente de la sección

Sección 9: Vue Router y Ciclo de vida de los componentes - Options Api
- Introducción a la sección
- Temas puntuales de la sección
- Concepto de SPA
- Inicio de proyecto - Rutas y Ciclo de Vida
- Creación de páginas necesarias
- Configuración manual del Vue Router
- No page found
- LazyLoad de páginas
- Navegar entre páginas - RouterLink
- RouterLink Active
- Lifecycle Hooks - Ciclo de vida de un componente
- Disparar métodos del ciclo de vida
- Segmentos del URL y QuueryParameters
- Recibir Props por URL
- Petición HTTP y redirecciones
- Redirección desde el router
- RouterLink Personalizado
- Multiples Router-View - Rutas Hijas
- Segundo Layout
- Arreglar nuestro NavBar personalizado
- Guard - Protección de rutas ( Global )
- Guard global asíncrono
- Guard específico para rutas
- Código fuente de la sección

Sección 10: Introducción a Vuex
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a Vuex
- Inicio de proyecto - Bases Vuex
- Instalación manual de Vuex
- Leer el state reactivo
- Mutations
- Actions
- mapActions
- Bloquear botón mientras una acción trabaja
- Getters
- Modules
- Actions, Getters, Mutations, State desde un módulo
- Separar módulo en archivos independientes
- Código fuente de la sección

Sección 11: Journal App - Options Api + Vuex
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Journal
- Usar SASS en nuestro proyecto
- Cambiar los colores por defecto del bootstrap
- Estructura modular
- Estructura del DaybookLayout
- Componentes EntryList y Entry
- Componente NoEntrySelected
- EntryView
- Mini tarea - Fab Icon
- Instalar Vuex y crear un módulo reutilizable
- Journal - Vuex Module
- Entradas ficticias y punto de restauración
- mapGetters - getEntriesByTerm
- EntryComponent - Información al componente
- GetEntryById - Obtener una entrada por el id
- Mostrar entrada en pantalla o redireccionar al usuario
- Cargar entrada cuando cambia el url
- Configurar RestAPI en Firebase
- Resumen de la sección
- Código fuente de la sección

Sección 12: CRUD - Vuex
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección anterior
- Cargar entradas desde el backend
- Realizar el commit de una mutación
- Tarea - Mostrar un loading mientras cargamos las entradas
- FAB - Emitir acción
- CRUD - Actualizar entrada
- Preparar el camino para la inserción de registros
- CRUD - Crear una nueva entrada
- CRUD - Borrar una entrada
- Mostrar mensajes de confirmación y espera
- Seleccionar y mostrar una imagen local
- Referencias locales
- Cloudinary
- Subir archivo desde JavaScript
- Código fuente de la sección

Sección 13: Testing Vuex
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - JournalApp - Testing
- Pruebas en el AboutComponent
- Primeras pruebas con el router
- Tarea - Pruebas en el FAB Component
- Daybook Router
- Comprobar que las rutas carguen los componentes esperados
- Probar función de mapeo de ruta
- Pruebas con carga de archivos
- Borrar archivos subidos en las pruebas
- Vuex - Probar el estado inicial del Journal
- Mutation - setEntries
- Mutation - updateEntry
- Mutation - addEntry y deleteEntry
- Getters - getEntriesByTerm y getEntryById
- Actions - loadEntries
- Actions - updateEntry
- Actions - createEntry y deleteEntry
- Pruebas en el componente Entry
- Solución de la tarea - EntryComponent
- Pruebas en el componente EntryList
- EntryList - Segunda parte de pruebas
- Pruebas en el EntryView Component
- Pruebas con el método de borrar y salir
- Escuchar el dispatch en un método
- Código fuente de la sección

Sección 14: Composition API - Bases
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al Composition API
- Ejemplo del Composition API
- Bonus - Guía de atajos Composition API
- Inicio de proyecto - Bases CompositionAPI
- Counter usando composition API
- Mi primer composable - useCounter
- Vue DevTools - Composition API
- Ref vs Reactive
- Composition API - Lifecyle Hooks
- Router keep-alive
- Peticiones http
- Mostrar los usuarios y conectar la paginación
- Tarea - Creación de un nuevo composable
- Uso del router dentro del setup
- Leer parametros y segmentos de URL desde el setup
- Composable usePokemon
- Watch - Observar cambios en objetos reactivos
- Bloquear la salida de una ruta
- Código fuente de la sección

Sección 15: Vuex con el composition API
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Diseño del State
- Vuex Getters - Composition API
- Tarea - Crear y usar getters
- Diseño de la lista de tareas
- Getters como función
- Commit Mutations - Composition API
- Composable - useTodo
- Introducción a los Slots
- Slots y NamedSlots
- Funcionalidad básica de nuestro modal
- Scoped Slots
- Tarea - Crear nueva tarea usando el modal
- Scoped Slots aplicado
- Código fuente de la sección

Sección 16: Autenticación - Vuex - Composition API
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Diseño del Layout de autenticación
- Rutas de Login y Register
- Vuex - Auth Module
- Manejo del formulario y useAuth composable
- Obtener token de acceso de Firebase
- Actualizar el displayName del usuario
- Mutation - LoginUser
- Mensaje de error o navegación
- Actions - Login de usuario
- Actualizar el displayName de Firebase
- Comprobar el estado del idToken
- Recargar el estado de la autenticación
- AuthGuard
- Logout y nombre de usuario conectado
- Interceptores
- Código fuente de la sección

Sección 17: Composition API Testing
- Introducción a la sección
- Temas puntuales de la sección
- Testing autenticado
- Pruebas en Vuex Crear MockStore
- AuthModule - Vuex Module
- Mutations - loginUser
- Mutations - logout
- Getters - username currentState
- Actions - createUser - Error usuario ya existe
- Action - createUser - Crea el usuario en Firebase
- Action - checkAuthentication - POSITIVA
- Action - checkAuthentication - NEGATIVA
- Pruebas en composable functions
- Probar una petición fallida de creación de usuario
- Login exitoso y login fallido
- Pruebas en el logout
- Pruebas en propiedades computadas del composable function
- Pruebas en el Navbar
- Pruebas con el Router en composition API
- Mantener pruebas con ambos routers
- Pruebas en el login component
- Formulario incorrecto, retorna error de autenticación
- Formulario con credenciales correctas
- Código fuente de la sección

Sección 18: Bonus: Quasar
- Introducción a la sección
- Temas puntuales de la sección
- Enlaces oficiales
- Instalación y creación de una app con Quasar
- Explicación de los archivos del proyecto
- Explicación del directorio SRC
- Cambiar la iconografía de la aplicación
- Crear páginas y rutas
- Navegación dinámica
- Typography
- Crear definición de enlaces en archivo independiente
- Controlar el menú lateral desde Vuex
- useUI - Composable Function
- Propiedades computadas - Set y Get
- Sistema de Filas y Columnas
- Cambiar tamaño dependiendo de la pantalla
- Flexbox
- Dialogs
- Inputs y Formularios
- Valor del formulario y validaciones personalizadas
- Notificaciones
- Código fuente

Sección 19: MapasApp - Mapbox + Rutas + TypeScript + Composition API
- Introducción a la sección
- Temas puntuales de la sección
- Nota Importante
- Demostración del proyecto
- Inicio de proyecto - MapasApp
- Preparación inicial del proyecto
- Configurar Vuex con TypeScript
- Primer módulo de Vuex - Places
- Action - getInitialLocation
- Composable - usePlacesStore
- Preparar el espacio para colocar el mapa
- Loading y referencia al contenedor del mapa
- Mostrar mapa de Mapbox
- Mostrar mapa tan pronto tenemos la ubicación del usuario
- Popups y Markers
- Segundo módulo de Vuex - Map
- Establecer mapa en el Store
- Botón para mover a la ubicación central
- SearchResults - Diseño de componente
- Implementar un debounce manualmente
- Mapbox SearchAPI e interfaces
- Realizar petición Http para obtener los lugares
- Almacenar los lugares en el Store
- Mostrar los lugares en el componente de resultados
- Activar lugar y mover la cámara
- Colocar marcadores en todos los lugares encontrados
- Obtener ruta entre dos puntos
- Obtener información de la ruta
- Mostrar la ruta en el mapa
- Borrar la polyline
- Almacenar la distancia y duración
- Mostrar la distancia y duración en pantalla
- Desplegar la aplicación en la web
- Código fuente de la sección

Sección 20: Cierre del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (48, 'zustand-react', 'Zustand: Gestor de estado para React', 'https://cursos.devtalles.com/courses/zustand-gestor-de-estado-para-react', 'https://import.cdn.thinkific.com/643563/OqBxBndxTD6gtxlKMoWV_ZUSTAND.jpg', 'Portada del curso: Zustand: Gestor de estado para React', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este gestor de estado a punta a ser un reemplazo directo a Redux, Redux Toolkit y el mismo Context API de React, ofreciendo funcionalidades similares a Redux sin tener que construir tanto código base para hacerlo funcionar.', 360, 'es', '{"Fundamentos de Zustand: Comprenderás cómo funciona el gestor de estado y cuándo utilizarlo como reemplazo de Redux o Context API.","TypeScript y tipado estricto: Crearás stores completamente tipadas para desarrollar aplicaciones más seguras y mantenibles.","Arquitectura escalable: Implementarás patrones modernos como Slices, Custom Hooks y organización profesional del estado.","Persistencia y personalización: Configurarás almacenamiento local, remoto y middlewares personalizados para adaptar Zustand a cualquier necesidad.","Zustand como gestor de estado: Comparativa y reemplazo de Redux, Redux Toolkit y Context API.","Uso fuera de React: Implementación de Zustand más allá del ciclo de vida de los componentes.","TypeScript: Tipado estricto aplicado a stores y acciones.","Middlewares: Persist, Immer, DevTools, middlewares personalizados y loggers.","Persistencia: LocalStorage, SessionStorage personalizada y almacenamiento remoto utilizando Firebase.","Manejo avanzado del estado: Produce States, suscripciones de Stores y patrón Slices.","Custom Hooks: Creación de hooks reutilizables para consumir el estado de manera eficiente.","Autenticación: Manejo de sesiones, Axios Interceptors y protección de rutas.","Casos prácticos: Eventos Drag & Drop y desarrollo sobre un dashboard administrativo listo para utilizar.","Y mucho más...","Serás capaz de implementar Zustand en aplicaciones React de cualquier tamaño utilizando las mejores prácticas.","Aprenderás a reemplazar Redux o Context API cuando sea conveniente, reduciendo significativamente la cantidad de código necesario.","Dominarás la persistencia de datos, la autenticación y la organización profesional del estado utilizando TypeScript.","Contarás con una base sólida para desarrollar aplicaciones escalables con un gestor de estado moderno y altamente eficiente."}', 'https://cursos.devtalles.com/courses/zustand-gestor-de-estado-para-react', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de React con Hooks es necesario","Saber realizar peticiones HTTP con Fetch API o Axios","Saber TypeScript es opcional pero recomendado","No es necesario saber Tailwind, React Router, Dom o Docker"}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- Descarga e instalación de proyecto inicial
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Bases de Zustand
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Nuestro primer store
- Consumir nuestro store
- Resolución de la tarea
- Objetos anidados en el store
- Métodos con objetos anidados
- Propiedades computadas
- Código fuente de la sección

Sección 3: Middlewares de Zustand
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Crear un segundo store
- Persist Middleware
- StateCreator Interface
- Custom Storage - SessionStorage
- Implementar SessionStorage
- Aprovisionar base de datos en Firebase
- Firebase CustomStorage
- Persist Middleware - Consideraciones
- Redux DevTools
- Custom Middleware - Logger
- Código fuente de la sección

Sección 4: Tareas - Drag & Drop - Inmutabilidad con Immer
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- TaskStore e interfaces
- Obtener tareas por estado
- Mostrar las tareas apropiadamente
- Arrastrar tareas
- Eventos onDragOver, onDragLeave y onDrop
- ClassNames - Paquete para unir clases de css
- Cambiar la clase onDragOver
- Cambiar el estado de la tarea
- Combinar métodos de store
- Agregar una nueva tarea
- SweetAlert2 - Pedir el titulo de la tarea
- immer - Produce
- immer - Middleware
- Persist - Middleware
- Custom Hook - useTaskHook
- Código fuente de la sección
- Nota sobre DevTools

Sección 5: Zustand Slices
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Store y Slice
- Consumir Store en WeddingPage
- GuestSlice - Tarea
- DateSlice - Fecha y Hora
- Mostrar fecha y hora del Store
- Cambiar la fecha con el selector
- Cambiar la hora del evento
- Consideraciones con objetos personalizados
- ConfirmSlice - Tarea
- Código fuente de la sección

Sección 6: Peticiones HTTP - Zustand fuera de React
- Introducción a la sección
- Temas puntuales de la sección
- Continuación y preparación de proyecto
- useAuthStore - Store e interfaces
- Axios y Servicio de autenticación
- Conectar Login con Zustand
- Revisar estado de la autenticación
- Navegación y protección de ruta
- Redireccionar al Dashboard si estamos autenticados
- Cerrar sesión - Logout
- Acceder a rutas privadas
- Suscripciones y cambios de estado
- Código fuente de la sección

Sección 7: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (111, 'angular-avanzado', 'Angular Avanzado: bases a siguiente nivel - Fernando Herrera', 'https://cursos.devtalles.com/courses/angular-avanzado', 'https://import.cdn.thinkific.com/643563/lWDfXjbwSyaUZOw4z657_COVER-DEVTALLES.jpg', 'Portada del curso: Angular Avanzado: bases a siguiente nivel - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso es totalmente práctico, aprenderemos haciendo una aplicación completa desde cero, que va desde el Front-End hasta el Backend, trabajando con MongoDB, JWT y Google SignIn.', 1920, 'es', '{}', 'https://cursos.devtalles.com/courses/angular-avanzado', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción al curso - Bienvenida
- ¿Cómo funcionará el curso?
- Instalaciones necesarias para seguir el curso
- Nota de actualización - ¡Importante!
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Dominando la creación automática del Angular CLI
- Introducción a la sección
- Temas puntuales que tocaremos en la sección
- Nota de actualización
- Uso de la ayuda del AngularCLI
- Control de la generación de componentes
- Paths, servicios y guards
- Documentación del Angular CLI
- Material de tarea
- Tarea práctica - Errores en proyecto

Sección 3: Estructuración de nuestro proyecto
- Introducción a la sección
- Temas puntuales que tocaremos en la sección
- Inicio de proyecto - AdminPro
- Breve descripción del proyecto que haremos juntos
- Primeros componentes e inicio de la estructura del proyecto
- Agregar las librerías externas necesarias
- Header, SiderBar, Breadcrumbs y contenedor principal
- Implementando las rutas principales
- Implementar rutas secundarias
- Separando el login del template
- Tarea práctica #2 - Register template
- Resolución de la tarea práctica #2 - Register template
- Aceleración de las animaciones
- Página 404
- Respaldo de nuestro trabajo en GitHub
- Crear release de producción en GitHub
- Código fuente

Sección 4: Módulos
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Creando nuestro primer módulo
- Tarea práctica #3 - Creación de un módulo personalizado
- Resolución de la tarea práctica #3 - Creación de un módulo personalizado
- Rutas hijas - ForChild( )
- AuthRoutingModule
- Colocando nuestras rutas a partir de un path específico
- Guardar los cambios en GitHub y crear un TAG de producción
- Código de la sección

Sección 5: NOTA: Base para la mayoría de los ejercicios
- Introducción de la sección
- Usar un backup de Github para continuar el proyecto
- Clonar un proyecto en Github

Sección 6: @inputs y @Outputs
- Introducción a la sección
- Temas puntuales de la sección
- ¿Para qué nos puede servir la comunicación entre componentes?
- Nuestro componente del ProgressBar
- Uso de atributos personalizados
- Crear componente incrementador
- @Input - Componente incrementador
- @Output - Componente incrementador
- Color de los botones de forma condicional
- Pulir detalles de nuestro incrementador component
- Material para la siguiente clase
- Gráficas en Angular
- Tarea de Inputs y Outputs
- Solución a la tarea de Input y Output
- Guardar nuestros cambios en GitHub - Input y Output
- Código de la sección

Sección 7: Servicios básicos, temas, rutas básicas y persistencia de los ajustes
- Introducción a la sección
- Temas puntuales de la sección
- Material de la sección
- Diseño inicial de la página account-settings
- Cambiar el CSS principal de forma dinámica
- Agregando clases de CSS sin usar ngClass
- Servicio Settings
- RouterLink - Mover a una ruta en particular
- Servicio para controlar el Sidebar - Menú lateral
- Uso de Scripts de archivos importados en el index.html en TypeScript
- Guardar nuestros cambios en GitHub - Sección 7
- Código de la sección

Sección 8: Observables y Promesas
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las promesas y observables
- Reforzamiento sobre Promesas
- Funciones que retornan promesas
- Componente Rxjs y arreglo en el menú
- Crear un observable manualmente
- Método Retry de un observable
- Funciones que retornen observables
- Operador map de los observables
- Operador filter
- Más información sobre operadores del RXJS
- Llamar el unsubscribe
- Breadcrumbs usando observables y parámetros de rutas
- Optimizaciones del Breadcrumbs
- Guardar cambios en GitHub - Sección 8
- Código de la sección

Sección 9: Backend - Node - Express - Mongo - Instalaciones y configuraciones básicas
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del backend server
- Iniciando nuestro servidor de Express
- Errores HTTP - PDF
- Primera ruta
- Nota: Enlaces a MongoDB Altas
- Nota: Error conexión MongoDB (Network Access)
- Mongo Altas - Configuración de BD
- Estableciendo conexión entre Mongo y Node
- Variables de entorno
- Configurar CORS
- Realizar un backup en GitHub de nuestro Backend-Server
- Código de la sección

Sección 10: HospitalAPP - Backend Server - Funciones de Usuarios
- Introducción a la sección
- Temas puntuales que cubrimos en la sección
- Panorama general de nuestro backend
- Creando el modelo de usuarios
- Creando las rutas de los servicios del usuario
- POST - Crear usuario
- Terminar el GET de los usuarios
- Validar que el correo electrónico sea único
- Validar campos obligatorios
- Middleware personalizado - ValidarCampos
- Encriptar la contraseña usando método de una sola vía
- PUT - Actualizar un registro de usuario
- Nota: Optimizaciones
- Delete - Borrar un usuario
- Login de usuario
- Generación de un JWT
- Revisión del Token - Middleware
- Fin de la sección 10 - Backup a GitHub
- Código fuente de la sección

Sección 11: Médicos y Hospitales - CRUD - Búsquedas - subida de Imágenes
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Inicio - CRUD de Médicos y Hospitales
- CRUD y modelo de Médicos
- Crear Hospitales
- Crear médicos
- Validar MongoID
- Get - populate
- Paginar los resultados de las búsquedas
- Ruta y controlador para buscar
- Búsqueda general en todas las colecciones de forma simultánea
- Búsqueda por colección específica
- Subir archivos al servidor
- Subir archivos al servidor - parte 2
- Asignar la imagen a un hospital, usuario o médico
- Terminar la actualización de las imágenes
- * Notas y recursos para la siguiente clase
- Crear una ruta para obtener imágenes
- Guardar en GitHub los cambios y avances de la sección
- Código fuente de la sección

Sección 12: Backend - Autenticación con Google Sign
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Página oficial para implementar un login de Google
- Crear ID de la aplicación y un ID secreto - Google Developer
- Crear una aplicación rápida para probar el Google Sign-in
- Validar token de Google en nuestro backend
- Crear un registro en nuestra colección de usuarios
- Bonus: Documentación de los servicios de forma automática
- Subir nuestros cambios a GitHub - Sección 12
- Código fuente de la sección

Sección 13: Médicos y Hospitales - CRUD
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - Backend Server
- Actualizar Hospital
- Eliminar Hospital
- Tarea: Actualizar y Eliminar Médicos
- Guardar cambios en Github - Sección 13
- Código fuente de la sección

Sección 14: Implementar el login y registro de usuarios en el FrontEnd
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Iniciando MongoDB, el backend server y nuestro proyecto de Angular
- Creando un modelo de usuario
- Formulario de Registro - Reactive Forms
- Validaciones del formulario
- Validar las contraseñas iguales
- * Posible error con el SweetAlert
- Usuario Service - Crear usuarios
- SweetAlert 2
- Login de usuario - normal
- Guardar información en el LocalStorage
- Función del recuérdame
- Documentación de Google Sign-In - Identity
- Obtener el Token de una autenticación, Google Sign-In
- Usar el Token de Google para autenticarnos
- Proteger rutas de mi aplicación
- Logout
- Optimización del init de Google
- Guardar cambios en GitHub
- Código fuente de la sección

Sección 15: Perfil del usuario, pipes y subida de fotografía
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Continuación de proyecto - AdminPro Frontend y Backend
- Centralizar la información del usuario conectado
- Mostrar imagen del perfil del usuario
- Optimizaciones del email
- Crear el componente del perfil del usuario
- Actualizar el perfil del usuario
- Actualizar el perfil del usuario - continuación
- Servicio de carga de imágenes
- Vista previa de la imagen seleccionada
- Mensajes al usuario
- Bloquear usuario de Google
- Guardar cambios en Github
- Código fuente de la sección

Sección 16: Mantenimiento de Usuarios y modal de carga de imágenes
- Introducción a la sección
- Temas puntuales que cubriremos aquí
- Continuación del proyecto - AdminPro
- Crear el componente de usuarios
- Cargar los usuarios de forma paginada
- Paginar los usuarios
- Detalles estéticos de nuestra página
- Mensaje de carga de información
- Búsqueda de usuarios
- Pulir la búsqueda de usuarios
- Borrando usuarios
- Frontend - No borrarme a mi mismo
- Actualizar el rol del usuario
- Modal para la carga de imágenes
- Control del modal y carga de imágenes
- Cargar imágenes usando el modal
- Actualizar la imagen del usuario desde el modal
- Guardar cambios en GitHub
- Código fuente de la sección

Sección 17: Médicos y Hospitales
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Diseño de la pantalla de hospitales
- Modelo y Servicio de Hospitales
- Mostrar los hospitales en el HTML
- Pipes para mostrar las imágenes
- CRUD de Hospitales
- Funcionamiento del mantenimiento de Hospitales
- Búsqueda de hospitales
- Componente de Médico, Médicos y Servicio de Médicos
- Servicio de Médicos - CRUD
- Buscar médicos y redirección al componente de médico
- Borrar médicos
- Componente de Médico - Estructura HTML
- Preparar el formulario de creación de médicos
- Mostrar información del hospital seleccionado
- Crear médico en base de datos
- Cargar un médico seleccionado
- Actualizar un médico
- Cargar imagen del Hospital al editar
- Guardar cambios GitHub
- Código fuente de la sección

Sección 18: Buscador, servicios del menú y AdminGuard
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Continuación de proyecto - Búsqueda Global
- Componente para búsquedas globales
- Mostrar la información de la búsqueda
- Menú del lado del servidor
- Cargar el menú
- Admin Guard
- Validar el ADMIN_ROLE en nuestro backend
- Validar si es el mismo usuario o un admin
- Guardar cambios en GitHub
- Código fuente de la sección

Sección 19: Optimizaciones, Lazy Load y despliegues
- Introducción a la sección
- Temas puntuales de la sección
- LazyLoad
- Desplegar nuestro Backend Server
- Nota de actualización - ng build
- Angular - Generar el build de distribución
- Backend - Servir una SPA
- Subir los cambios a Github
- Código fuente

Sección 20: Bonus - Interceptors
- Temas puntuales de la sección
- Inicio de proyecto - Interceptores
- Peticiones HTTP tradicionales
- RXJS map, throwError y catchError
- Interceptores
- Interceptor - Añadir headers y manejo de errores
- Código fuente de la sección

Sección 21: Pruebas automáticas - Unitarias - Integración
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Introducción a las pruebas automáticas
- Tipos de pruebas
- Inicio del proyecto de pruebas

Sección 22: Pruebas Unitarias
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Generalidades de las pruebas
- Probando Strings
- Comprobar que el resultando CONTENGA algo
- Probando números
- Probando booleanos
- Probando arreglos
- Probando clases
- BeforeEach - BeforeAll - AfterAll - After Each
- Observar el porcentaje de cobertura de nuestra aplicación - code-coverage
- Código fuente de la sección

Sección 23: Pruebas unitarias intermedias / avanzadas
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Saltar pruebas
- Event Emitter
- Formularios
- Validaciones de formularios
- Material para la siguiente clase: Espías
- Explicación del contenido de los archivos adjuntos
- Espías
- Confirmar que un método sea llamado
- Espías: returnValue
- Probar errores en los observables
- Simular confirmaciones de usuario
- Código fuente de la sección

Sección 24: Pruebas de integración
- Introducción a la sección
- Temas puntuales de la sección
- Configuraciones de las pruebas de integración
- Comprobar que el componente se creara correctamente
- Servicios en el TestingModule - Uso de servicios
- Archivos SPEC generados automáticamente usando AngularCLI
- Material de pruebas de integración - Incrementador
- Realizar pruebas en el HTML del componente
- Revisar el valor de un input físicamente
- Confirmar que elementos HTML tengan los eventos deseados
- Verificar cambios en un elemento html tras eventos
- Separar las pruebas unitarias de las pruebas de integración
- Código fuente de la sección

Sección 25: Pruebas de integración intermedias y avanzadas
- Introducción a la sección
- Temas puntuales que aprenderemos en esta sección
- Probando la existencia de una ruta en particular
- Pruebas de un router-outlet
- Confirmar que exista un router-outlet
- Confirmar que exista un routerLink hacia el componente de médicos
- Errores por selectores desconocidos
- Preparando un componente que recibe parámetros y navega
- Reemplazar servicios de Angular por servicios falsos
- Comprobar parámetros enviados a un observable
- Código fuente de la sección

Sección 26: Bonus: Angular, Firestore, Firebase functions, deployment y más
- Introducción a la sección
- Demostración del programa que haremos al final de la sección
- Instalaciones necesarias
- Inicio de proyecto - Game of the Year
- Creación de páginas y componentes
- Configuración del gráfico inicial
- Cambiar valores de la gráfica de forma aleatoria
- Firebase y Firestore - Nuestra base de datos
- Cloud Functions - Hola Mundo
- Firebase: Credenciales para trabajar local y remotamente
- Cloud Function: GET - Obtener colecciones
- Servidor Express dentro de Firebase Cloud Functions
- Post: Incrementar en 1 el voto del juego
- Firebase deploy: Subir las nuevas funciones
- Angular: HTTP GET - Obtener y mostrar los juegos
- Mostrar los juegos en el HTML
- Angular: Votar por el juego del año
- Manejo de errores en la petición
- Angularfire - Obtener información en tiempo real
- Gráfica en tiempo real
- Desplegar la aplicación de Angular a Firebase Hosting
- Código fuente de la sección

Sección 27: Fin del curso
- Más sobre mis cursos
- Más información sobre nuestros otros cursos', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (112, 'angular-cero-experto', 'Angular: De cero a experto - Fernando Herrera', 'https://cursos.devtalles.com/courses/angular-cero-experto', 'https://import.cdn.thinkific.com/643563/j8MRHwUSQOKuXsN3wjg0_LEGACY-ANGULAR.jpg', 'Portada del curso: Angular: De cero a experto - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso te ayudará a aprender Angular (la última versión) a profundidad mediante ejercicios y tareas que tú mismo harás. Partiendo de cero conocimiento de TypeScript hasta crear un sistema robusto de autenticación, uso de mapas, consumo de servicios y mucho más.', 2640, 'es', '{}', 'https://cursos.devtalles.com/courses/angular-cero-experto', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción al curso
- Curso Legacy
- Introducción
- ¿Cómo funciona el curso?
- Instalaciones necesarias y recomendadas
- Importante: Cursos Legacy
- Nota de actualización - Versión de node recomendada
- Instalar AngularCLI
- Nota de actualización - ¡Importante!
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Conceptos generales para empezar con Angular y TypeScript
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es TypeScript? y ¿Por qué Angular usa TypeScript?
- 10 Mitos y realidades de Angular

Sección 3: Base de TypeScript - Sección recomendada
- Introducción a la sección
- Temas puntuales de la sección
- Nota antes de empezar
- Inicio de proyecto - Introducción a TypeScript
- Tipos básicos y conceptos generales
- Objetos, arreglos e interfaces
- Funciones básicas
- Funciones con objetos como argumentos
- Tarea sobre objetos e interfaces
- Desestructuración de Objetos
- Desestructuración de Arreglos
- Desestructuración de argumentos
- Importaciones y exportaciones
- Clases básicas
- Constructor de una clase
- Extender una clase
- Genéricos
- Decoradores de clases
- Encadenamiento opcional
- Código fuente de la sección

Sección 4: Introducción a Angular
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a Angular
- Nota de actualización
- Crear un proyecto de Angular
- Explicación de cada archivo del proyecto
- Explicación de los archivos dentro del SRC
- App Component
- Contador App
- Métodos en el componente
- Tarea con el contador
- Crear un componente manualmente
- Componente de Heroe y separación de directorios
- Cambios en el template del componente
- Concepto de one way data binding - enlazado en una sola vía
- Crear componente de forma automática
- Directiva *ngFor
- Directiva *ngIf
- Ng-Template y el ngIf-else
- Módulos
- Módulos - segunda parte
- Bonus: Hacer respaldo de nuestro proyecto en GitHub
- Código fuente de la sección

Sección 5: Expandiendo nuestras bases
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto
- Módulo DBZ (Dragon Ball Z)
- Diseño de la pantalla a trabajar
- FormsModule
- ngModel
- Mostrar listado de personajes
- Crear componentes hijos
- @Input
- Tarea con inputs y módulos
- @Outputs y EventEmitter
- Bonus: Depuración de aplicación
- Servicios
- Centralizar el acceso de los personajes en el servicio
- Métodos en el servicio
- Código fuente de la sección

Sección 6: Despliegues rápidos a producción
- Introducción a la sección
- Temas puntuales de la sección
- Nota de actualización
- Generar build de producción
- Desplegando en Netlify

Sección 7: GifsApp - Aplicación para buscar imágenes
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - GifsApp
- Diseño inicial de nuestra aplicación de Gifs
- Módulo Shared
- GifsModule y sus componentes
- @ViewChild - Obtener referencias a objetos del HTML
- GifsService
- Controlar el historial de búsquedas
- Giphy Api Key - Giphy Developers
- Realizar una petición HTTP
- Mostrar los resultados en pantalla
- Colocando un tipado a las peticiones http
- LocalStorage
- Cargar imágenes automáticamente
- Obtener imágenes desde el sidebar
- HttpParams
- Animate.style CSS
- Código fuente de la sección

Sección 8: SPA - PaisesApp
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - PaisesApp
- Estructura y explicación de la aplicación de países
- Creando los módulos y los componentes básicos
- Estructura HTML de nuestra aplicación
- RouterModule - Rutas en nuestra aplicación
- RouterLink
- Componente Sidebar
- Componente para buscar por país
- Nota de actualización:
- Servicio para buscar países
- Manejo de errores
- Tipado de la petición de RestCountries
- Llenar la tabla de países
- Componente Input y Tabla
- Funcionalidades del componente PaisInputComponent
- DebounceTime - en el input
- Por Capital
- Ver país de forma independiente
- RxJs - SwitchMap
- Terminar la pantalla de ver país
- Fin de la pantalla de ver país
- Código fuente de la sección

Sección 9: Continuación aplicación de Países - Sugerencias, debounce y más
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - PaísesApp
- ngClass, class y [class.]
- Clases de CSS condicionales
- Mostrar países por región
- Nota de actualización
- Optimizar las peticiones HTTP
- Animaciones de CSS
- Mostrar sugerencias al escribir - autocomplete
- Código fuente de la sección

Sección 10: Pipes de Angular
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Inicio de proyecto - PipesApp
- Introducción a los Pipes de Angular
- Instalar PrimeNg
- Prime Button y estilo global
- Cards y botones con íconos
- PrimeNg module
- PrimeNg - MenuBar
- Rutas de nuestra aplicación
- Cambiar las rutas utilizando el MenuBar
- Nota de actualización - PrimeFlex
- PrimeFlex
- UpperCase, LowerCase y TitleCase Pipes
- Date Pipe
- Cambiar el idioma por defecto
- Timezone y otros idiomas
- DecimalPipe
- CurrencyPipe y PercentPipe
- PrimeNg - Fieldset
- I18nSelectPipe
- I18nPluralPipe
- Tarea sobre i18nPipes y Primeng
- SlicePipe
- KeyValuePipe
- JsonPipe
- AsyncPipe
- Código fuente de la sección

Sección 11: Pipes personalizados
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - PipesApp
- Pipe personalizado - mayusculasPipe
- Valor y argumentos a los pipes personalizados
- PrimeTable y PrimeToolbar
- Llenar un PrimeTable con data
- Tarea pipe personalizado - VuelaPipe
- Ordenar héroes por nombre - OrdenarPipe
- Parametrizar nuestro pipe personalizado
- Primeng - Sortable Table
- Código fuente de la sección

Sección 12: HeroesApp - Rutas hijas y Lazyload
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - HeroesApp
- Módulos y componentes iniciales
- Rutas principales - Root
- Rutas hijas y LazyLoad - AuthRoutes
- Tarea - Rutas Hijas de Héroes
- Resolución de la tarea - Rujas Hijas de Héroes
- Mostrar Rutas Hijas - Segundo RouterOutlet
- Código fuente de la sección

Sección 13: HeroesApp - Angular Material & Angular Flex-Layout
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación del proyecto - HeroesApp
- Material Sidenav, Toolbar e iconos
- Material Navlist
- Heroes Backend - json-server
- Heroes Service - Traer información de los héroes
- Interfaz Héroe
- Material Card - Flex Layout
- Flex Layout - Diferentes resoluciones
- Tarea - HeroeTarjetaComponent
- Tarea - PipeImagen
- Tarea - Ruta Héroe y Editar Héroe
- Pantalla de Héroe
- Diseño de la pantalla de Héroe
- Variables de entorno
- Material Autocomplete
- Autocomplete - Segunda Parte
- Tarea - Autocomplete cuando no encontró nada
- Resumen de la sección
- Código fuente de la sección

Sección 14: HeroesApp - CRUD (Continuación con Angular Material)
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación del proyecto - HeroesApp
- Diseño de la pantalla para agregar héroes
- Insertar en base de datos
- Editar héroes
- Excepciones en nuestro ImagenPipe
- Eliminar registros
- Pipes Puros e Impuros
- Material Snackbar
- Material Dialog
- Información desde y hacia el dialogo
- Adecuar los textos de la pantalla de agregar
- Código fuente de la sección

Sección 15: Protección de Rutas
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - HeroesApp
- Pantalla de Login Básico
- AuthService - Servicio para mantener el estado de la autenticación
- Mostrar la información del usuario activo
- Angular Guards - CanLoad
- CanActivate
- Mantener la sesión del usuario
- Código fuente de la sección

Sección 16: Formularios - Template y Lazyload
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de la sección - Formularios
- Creación de módulos necesarios
- Componentes y LazyLoad de formularios
- SideMenu
- Template: Diseño del formulario básico
- Template: FormsModule
- Template: Mostrar mensajes de error
- ViewChild
- Template: Validar número igual mayor a 0
- Directivas personalizadas - CustomMin - Opcional
- Template: Limpiar el formulario
- Template: Formularios dinámicos y arreglos
- Agregar elementos de forma dinámica
- Eliminar elemento creado de forma dinámica
- Agregar juegos favoritos
- Template: Radio, Check y Switches
- Template: Validando Radios, Checks y Switches
- Código fuente de la sección

Sección 17: Formularios Reactivos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Formularios
- Primeros pasos en formularios reactivos
- FormBuilder
- Validaciones básicas - Forms Validator
- Mostrar mensajes de error
- Submit del formulario
- Tarea: Validar un nuevo campo
- FormArray
- Agregar controles al FormArray
- Eliminar elementos de un FormArray
- Formularios Reactivos: Switches
- Actualizar el valor de la persona
- Documentación de formularios reactivos en Angular
- Código fuente de la sección

Sección 18: Formularios: Validaciones manuales y asíncronas
- Inicio de sección
- Temas puntuales de la sección
- Continuación de proyecto
- Resolución de la tarea - Ruta y LazyLoad
- Diseño de la pantalla de registro
- Validar contra una expresión regular
- Evaluar un email
- Validaciones personalizadas
- Separar la lógica de validaciones del componente
- Validar contraseñas iguales
- Preparaciones para Validaciones Asíncronas
- Validaciones asíncronas
- Estado del formulario
- Errores personalizados
- Mensaje de error personalizado
- Código fuente de la sección

Sección 19: Formularios Reactivos - Multiples selectores anidados
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Inicio de proyecto - Selectores
- Estructura de directorios para esta aplicación
- Formulario reactivo - primer selector
- Selector de regiones
- Segundo selector anidado
- Limpiar país cuando el primer selector cambia
- Tercer selector anidado - Fronteras
- Llenar tercer selector - Fronteras
- Mejorar la experiencia de usuario
- Cambiar códigos de fronteras por los nombres de los países
- Código fuente de la sección

Sección 20: LifeCycle Hooks
- Introducción a la sección
- Temas de la sección
- Inicio de proyecto - LifeCycle
- Implementar todos los hooks del ciclo de vida
- Explicación sobre los ciclos de vida
- ngOnChanges
- ngOnDestroy
- Más información sobre el ciclo de vida
- Código fuente de la sección

Sección 21: Mapas en Angular
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de sección - MapasApp
- Creando los componentes necesarios y rutas
- Menú de la aplicación
- Mostrar un mapa en pantalla completa
- Punto central, zoom y accessToken de forma global
- Página Zoom-Range - Diseño y tarea
- Controlar el objeto del mapa - ZoomIn y ZoomOut
- Controlar el nivel del Zoom
- Crear EventListeners del mapa
- Restringir el Zoom y uso del Range
- Obtener las coordenadas centrales del mapa
- Marcadores en el mapa
- Añadir marcadores de forma dinámica
- Mantener el arreglo de marcadores y colores
- FlyTo
- Guardar y leer del LocalStorage
- Nota de actualización
- Borrar y actualizar marcadores
- Lista de propiedades - Diseño y estructura de la data
- Componente MiniMapa
- Código fuente de la sección

Sección 22: Gráficas en Angular
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - GraficasApp
- Estructura del proyecto
- Rutas y LazyLoad
- Menú de la aplicación
- Gráfica de barra
- Personalizando la gráfica
- Componente personalizado para mostrar gráficos
- Añadir flexibilidad a nuestro componente personalizado
- Gráfica de Dona
- Gráfica de Dona mediante petición Http
- Mostrar la información en la gráfica
- Cambiar la información mediante RXJS
- Código fuente de la sección

Sección 23: Directivas personalizadas de Angular
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - DirectivasApp
- Estructura de la aplicación
- Formulario reactivo tradicional
- Directiva personalizada - ErrorMsg
- Directive Input - Cambiar el color del host
- Cambiar el mensaje de la etiqueta
- Reaccionar a los cambios en tiempo real
- Input setters
- Resolución del problema
- Mostrar y Ocultar si tiene error el campo
- Directivas estructurales personalizadas
- Código fuente de la sección

Sección 24: Auth Backend - MEAN
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - Auth MEAN
- Npm - Nodemon
- Instalaciones necesarias para el backend
- Configurar servidor de Express
- Crear las rutas de nuestra aplicación
- Separar el controlador de la ruta
- Configurar CORS y body de las peticiones
- Variables de entorno de Node
- Servir una página HTTP desde Express
- Validar campos obligatorios
- Tarea: Validar campos
- Custom Middleware - ValidarCampos
- Configurar base de datos - MongoDB
- Conectar MongoDB Atlas - Compass y Node
- Crear modelo de base de datos
- Crear usuario en base de datos
- Hash de la contraseña
- Generar JsonWebToken
- Login de usuario
- Renovar y validar el JWT
- Solución a la tarea - Generar JWT
- Código fuente de la sección

Sección 25: AuthApp - MEAN
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - Auth MEAN
- Estructura del proyecto - AuthApp
- Rutas y LazyLoad
- Diseño de la pantalla de Registro y Login
- Pantalla protegida
- Login de usuario desde Angular
- Almacenar la información del usuario
- Mensajes de error visuales
- Mantener el usuario activo tras recargar el navegador web
- ValidarToken - Guard
- Logout
- Tarea: Registro de usuarios
- Resolución de la tarea
- Tarea: Mantener el email del usuario
- Resolución de la tarea - Email
- Código fuente de la sección

Sección 26: Desplegar backend y frontend a producción
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - AuthApp
- Desplegar aplicación de Angular en Node
- Desplegar aplicación de Node a Heroku
- Configurar ambiente de producción
- Revisar logs de Heroku

Sección 27: Bonus: Mapas - Marcadores y Direcciones con Mapbox
- Temas puntuales de la sección
- Demostración del objetivo final
- Inicio de proyecto - MapasApp
- Configuraciones iniciales del proyecto
- Obtener la geolocalización del usuario
- Mostrar un mensaje de carga
- Mostrar un mapa de Mapbox
- Marcadores y Popups
- Boton flotante y Logo de Angular
- Servicio para controlar el mapa
- Diseño de componentes de búsqueda y detalles
- Debounce Manual
- Realizar petición HTTP para obtener lugares
- Custom Http Client - PlacesApiClient
- Mostrar los resultados de la búsqueda
- Agregar marcadores en los lugares encontrados
- Ajustar el mapa para mostrar todos los marcadores encontrados
- Obtener la ruta entre dos puntos
- Obtener la distancia y duración del recorrido
- Dibujar la polyline
- Ocultar el menu de lugares
- Desplegar la aplicación de mapas
- Código fuente de la sección

Sección 28: Fin del curso
- Documentos complementarios sobre Angular
- Más sobre mis cursos
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (113, 'codex', 'Codex: agentes, skills, MCP y Spec-Driven Development', 'https://cursos.devtalles.com/courses/codex', 'https://import.cdn.thinkific.com/643563/8LTIQYbaRdCgulN394T7_COVER-DEVTALLES-CODEX.jpg', 'Portada del curso: Codex: agentes, skills, MCP y Spec-Driven Development', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Aprende a desarrollar con Codex CLI construyendo door-list, una aplicación de eventos con check-in por QR. Dominarás agentes, skills, MCP, sandbox y aprobaciones, y la re-construirás con Spec-Driven Development y Spec Kit.', 300, 'es', '{}', 'https://cursos.devtalles.com/courses/codex', '2026-09-24 15:49:29.94579+00', '{"Disponible al finalizar la construcción de este curso."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas

Sección 2: De cero a la primera pantalla
- Introducción
- Temas puntuales
- ¿Qué modelo elegimos?
- Landing del evento
- Revisión del proyecto
- Comandos útiles
- Primer checkpoint
- Código de la sección

Sección 3: El evento y sus tipos de entrada
- Introducción
- Temas puntuales
- Ajustando los permisos
- Modo plan pedir antes de ejecutar
- Migración a Supabase
- Migración a Supabase - Parte 2
- Nivel de confianza a medida
- CRUD de eventos y aforo por tipo de entrada
- CRUD de eventos y aforo por tipo de entrada - Parte 2
- Probando la aplicación
- Código de la sección

Sección 4: Registro público y emisión de la entrada
- Introducción
- Temas puntuales
- Formulario de registro
- Prueba de funcionalidad y migración
- Emisión de entrada al realizar el registro
- Configurar Resend
- Enviar email con la entrada
- Reorganizar rutas landing pública y panel de organizador
- Prueba completa funcionamiento
- Código de la sección

Sección 5: El proyecto ya es grande
- Introducción
- Temas puntuales
- Codex olvida convenciones
- Escribiendo el archivo AGENTS.md
- Revisando el archivo AGENTS.md
- Plan para refactorizar
- Realizando los cambios
- Probando aplicación después de los cambios
- Código de la sección

Sección 6: Panel del organizador y Skill
- Introducción
- Temas puntuales
- Cada feature en su rama
- La lista de registros y el conteo de aforo
- Pruebas de funcionalidad dashboard de eventos
- Introducción a Skills
- Skill que impone el estilo de UI
- Skill que impone el estilo de UI - Parte 2
- Ejecutando el Skill sobre el panel
- Gráfica de registros por día
- Cerrando la rama: commits y merge a main
- Cerrando la rama: commits y merge a main - Parte 2
- Exportar la lista de asistentes (Tarea)
- Código de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (114, 'flutter-avanzado', 'Flutter Avanzado: Lleva tu conocimiento al siguiente nivel', 'https://cursos.devtalles.com/courses/flutter-avanzado', 'https://import.cdn.thinkific.com/643563/txry7kQ0TCViYkwWhMCH_LEGACY-FLUTTER-AVANZADO.jpg', 'Portada del curso: Flutter Avanzado: Lleva tu conocimiento al siguiente nivel', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este es un curso cargado de información importante que nos ayudará a crear mejores aplicaciones con este increíble SDK de Google', 2070, 'es', '{}', 'https://cursos.devtalles.com/courses/flutter-avanzado', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: BandNameApp - Socket.io - Aplicación en tiempo real
- Introducción a la sección
- Temas puntuales de la sección
- Demostración al final de lo que nos espera a continuación
- Inicio de proyecto - BandNamesApp
- Crear un modelo para el manejo de Bandas
- Interfaz básica de nuestro HomePage
- InputDialog y CupertinoDialog - Añadir a la lista
- Borrar una banda - Dismissible
- Realizar respaldo de nuestro proyecto a Github
- Código fuente de la sección

Sección 3: BandNames - Socket Server - Express - Backend
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - BandNames Socket Server
- Crear un directorio público
- Variables de entorno y Scripts
- Socket.io - Configuración inicial
- Emitir y Escuchar eventos
- Archivo independiente de la configuración de sockets
- Realizar respaldo de nuestro backend a Github
- Código fuente de la sección

Sección 4: BandNames Flutter + Socket Backend
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - BandNames
- Socket Service - Conectar nuestra App con el Socket Server
- Mostrar el Status del Servidor de Sockets
- Escuchar eventos del servidor de sockets
- Emitir evento de sockets desde Flutter
- Indicador visual si hay conexión con el Socket Server
- Backend: Lógica para el manejo de las votaciones
- Socket: Emitir bandas registradas
- Flutter: Escuchar evento ''active-bands''
- Socket: Votar por una Banda
- Socket: Agregar una nueva Banda
- Socket: Borrar Banda
- Pequeñas optimizaciones
- Gráfica en tiempo real
- Respaldo de nuestra aplicación a Github
- Código fuente de la sección

Sección 5: Desplegar Socket Server en la nube
- Introducción a la sección
- Temas puntuales de la sección
- Desplegar SocketServer en la nube
- Correr la aplicación en múltiples dispositivos

Sección 6: RealTime Chat - Socket.io - Mongo - Express - JWT - Login y Registro
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de la aplicación - RealTime Chat
- Diseño del LoginPage
- CustomInputField
- Argumentos a nuestro CustomInput
- Botón Azul
- SingleChildScrollView
- Registro y Navegar entre las pantallas
- Respaldo de nuestra aplicación a Github
- Código de la sección

Sección 7: Continuación de RealTime Chat - Usuarios y Mensajes
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de nuestra aplicación
- Pull to refresh
- ChatPage - Inicio
- Caja de texto de nuestro chat
- Detalles de nuestro ChatPage
- Mensajes de burbujas
- Animaciones de los mensajes
- Limpieza al cerrar el ChatPage
- Respaldo de la sección a GitHub
- Código fuente de la sección

Sección 8: ChatApp - Backend
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de sección - ChatApp Backend
- MongoAtlas - Base de datos en la nube
- Conectar Node con Mongo Atlas
- Crear nuestro primer Rest endpoint - Crear Usuario
- Express Validator
- Middleware personalizado - ValidarCampos
- Crear usuario en base de datos
- Validar que no exista el email
- Encriptar la contraseña
- Generar JWT
- Login de Usuario
- Renovar el JWT
- Generar un nuevo JWT y retornar información del usuario
- Respaldo de nuestra aplicación a Github
- Código fuente de la sección

Sección 9: ChatApp - Autenticando contra nuestro backend
- Introducción a la sección
- Temas puntuales de la sección
- Nota de actualización
- Continuación de proyectos - Backend y FrontEnd - Autenticación
- Petición HTTP.POST al login
- Mapear respuesta de un login
- Bloquear botón mientras se realiza la autenticación
- Mostrar alerta si las credenciales no son correctas
- Guardar JWT en el Storage (Keychain IOS, KeyStore Android)
- Pantalla de Registro
- Mantener la pantalla de usuarios si tenemos un token válido
- Logout de nuestra aplicación
- Respaldo de nuestra aplicación a Github
- Código fuente de la sección

Sección 10: Socket.io en nuestra aplicación de Chat
- Introducción a la sección
- Temas puntuales de la sección
- Nota importante
- Continuación de proyectos
- Conectar al Socket Server después de un inicio de sesión
- Tarea - Cambiar ícono cuando hay conexión con el Socket Server
- Autenticando el cliente conectado por sockets
- Actualizar base de datos cuando un usuario se conecta
- Servicio para retornar los usuarios
- Mostrar lista de usuarios en nuestra App
- Usuario seleccionado para el chat
- Teoría sobre el envío de mensajes privados
- Emitir un mensaje del chat al servidor
- Escuchar mensajes del servidor en Flutter
- Backend - Modelo de Mensajes
- Guardar Mensaje en Base de Datos
- Backend - Servicio para obtener los mensajes de chat
- Cargar historial de chat en Flutter
- Respaldo del código a GitHub
- Código fuente de la sección

Sección 11: Manejadores de Estado - Singleton
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Manejar Estado
- Diseño de ambas pantallas
- Preparar repositorio y ramas
- Singleton
- Singleton - Establecer el usuario
- Singleton - Re-dibujar Widgets cuando hay cambios en el servicio
- Singleton - Varios listeners
- Código fuente de la sección

Sección 12: Provider - Como manejador de estado
- Introducción a la sección
- Temas puntuales de la sección
- Nota de actualización
- Continuación de proyecto - EstadosApp
- Provider - Configuración inicial
- Provider - Establecer información del usuario
- Provider - Cambiar edad mediante un método
- Provider - Manejo de las profesiones
- Guardar cambios en Git y cambiar ramas
- Código fuente de la sección

Sección 13: Cubit - Manejador de estado
- Introducción a la sección
- Temas puntuales de la sección
- Nota de actualización
- Introducción al Cubit
- Continuación de proyecto - Cubit
- Creando nuestro primer Cubit
- Cambiando el UI en base al estado del cubit
- Cambiar a un nuevo estado
- Mostrar información del usuario
- Cambiar la edad del usuario dentro del Cubit
- Añadir profesión
- Código fuente de la sección

Sección 14: Patrón BLoC
- Inicio de la sección
- Temas puntuales de la sección
- Nota de actualización
- Continuación del proyecto - BLoC
- Configurando el BLoC
- Configurando el BLoC - Segunda Parte
- Mostrar Widgets condicionalmente basados en el estado del BLoC
- Disparar eventos - Asignar un usuario al estado
- Mostrar información del usuario
- Copiar el estado anterior
- Añadir una nueva profesión al State
- Borrar el usuario
- Código fuente de la sección

Sección 15: GetX
- Enlaces y materiales de esta sección
- Continuación de proyecto
- Navegación con GetX
- Gestor de estado - GetxController
- Utilizar el usuario y cambiar la edad
- Manejo de las profesiones del usuario
- Otras funcionalidades de GetX
- Código fuente de la sección

Sección 16: Bonus: Calculadora con GetX
- Nota antes de empezar
- Bonus: Calculadora utilizando GetX
- Código fuente de la calculadora

Sección 17: RutasApp - GoogleMaps + Mapbox Places
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio proyecto mapas_app
- Pantallas y estructura de directorios
- Pantalla de permiso de GPS
- GPS Bloc
- GPS Bloc - Eventos, Bloc y Estado
- GPS Bloc Eventos y nuevo estado
- Geolocator - Android
- Permisos en IOS
- Cambiar el estado basado en el estado del servicio
- Permission_handler - Android e IOS
- Solicitar acceso al GPS
- Revisar privilegios previamente otorgados
- Código fuente de la sección

Sección 18: Mi ubicación y mapas
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - Location Bloc
- Android Emulator - Simular recorrido
- Seguir la ubicación del usuario
- Limpiar subscripciones
- Cambiar estado del bloc
- Mostrar las coordenadas
- Configurar Api Key de Google
- Configurar GoogleMaps - Android
- Configurar GoogleMaps - IOS
- Diseño de la pantalla del mapa
- Bloc para controlar el mapa
- Obtener el controlador del mapa
- Cambiar estilo del mapa
- Mover el mapa a la ubicación central del usuario
- Snackbar personalizado
- Código fuente de la sección

Sección 19: Trazar ruta dentro del mapa
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto
- Seguir al usuario con el mapa
- Botón para seguir al usuario
- Resolución de la tarea - Eventos del mapa
- Polylines - Trazando el camino recorrido
- Mostrar la polyline en el mapa
- Mostrar/Ocultar Polylines
- Cierre de la sección
- Código fuente de la sección

Sección 20: Direcciones hasta un punto específico
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto e introducción al API
- Diseño de la barra de búsqueda
- SearchDelegate - Buscador de lugares
- Terminar de construir nuestro SearchDelegate
- Modelo SearchResult - Retorno del SearchDelegate
- Diseño: Marcador central y opciones
- Finalizar diseño del marcador manual
- SearchBloc - Bloc para controlar las búsquedas
- Mostrar y ocultar elementos del UI basado en la búsqueda manual
- Ocultar marcador manual
- Animación adicional
- Direcciones de navegación - Mapbox API
- TrafficService con Dio - Servicio para disparar peticiones HTTP
- Saber el punto central del mapa
- Dio Interceptors
- Mapear la respuesta de Mapbox
- Decodificar geometry
- Dibujar la ruta en el mapa
- Mostrar mensaje de espera
- Código fuente de la sección

Sección 21: Direcciones en el mapa
- Inicio de sección
- Temas puntuales de la sección
- Continuación de la sección - RutasApp
- Consumir el servicio de GeoCoding de Mapbox
- Modelos y serializar respuesta
- Obtener los resultados del MapboxPlaces
- Almacenar los resultados en el SearchState
- Mostrar los resultados en el SearchDelegate
- Trazar ruta destino
- Historial de búsquedas
- Resolución de la tarea
- Código fuente de la sección

Sección 22: Marcadores en el Mapa
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - RutasApp
- Colocar marcadores en el inicio de la ruta
- Tarea: Marcador de fin de la ruta
- InfoWindow de marcadores
- Mostrar duración del viaje y distancia
- Reverse Geocoding - Información de coordenadas
- Imagen del marcador desde Assets y desde Network
- Marcador basado en una imagen por URL
- Custom Marker basado en un Widget - Diseño
- Sombra y rectángulo del custom marker
- Textos en el CustomPainter
- Información del destino
- Marcador del destino
- CustomPainter hacia imagen y BitmapDescriptor
- Tarea - Colocar el marcador del destino
- Código fuente de la sección

Sección 23: Pagos con Stripe, tarjetas de crédito, GooglePay y ApplePay
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - StripeApp
- Diseño de la pantalla Home
- Monto a pagar y botón de pago
- Pantalla de tarjeta seleccionada
- Pantalla de pago completo y alertas
- Código fuente de la sección

Sección 24: StripeApi y Estado de nuestra aplicación - BLoC
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - Configuración del BLoC
- Tarea: Activar y desactivar tarjeta
- Resolución: Activar y desactivar tarjeta
- Explicación de la lógica de cobros a seguir
- Paquetes adicionales para usar Stripe
- StripeService - Métodos globales que necesitaremos
- Crear método de pago con una nueva tarjeta
- Crear un intento de pago - PaymentIntent
- Realizar cobro/pago - Confirmar intento
- Pagar con una tarjeta existente
- ApplePay y GooglePay
- GooglePay retoques finales
- Código fuente de la sección

Sección 25: Pub.dev - Crear tu propio paquete
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - CustomTransitionPackage
- Diseño básico de mi aplicación de transiciones
- Route Transitions
- FadeIn Transition
- Replacement o Push
- Crear nuestro primer paquete para Pub.dev
- Subir el paquete a Pub.dev
- Utilizar nuestro paquete en nuestra app de Flutter
- Actualizando el paquete
- Crear un ejemplo en Pub.dev
- Marcar como obsoleto o deprecared alguna característica
- Nota final
- Código fuente de la sección

Sección 26: Autenticación con Google - Backend y Frontend
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - AuthApp
- Diseño básico de la aplicación
- Configuración de Google SignIn
- Agregar y configurar la aplicación de Android
- SignIn y SignOut de Google - Android
- Agregar y configurar la aplicación de IOS
- Obtener el ID Token de la sesión
- Código fuente de la sección

Sección 27: Google Sign-in - Backend para validar el ID Token
- Introducción a la sección
- Temas puntuales de la sección
- Continuación y nuevo proyecto - Auth Backend Server
- Ruta y controlador de la autenticación de Google
- Validar ID Token en nuestro backend
- Desplegar backend server en Heroku
- Obtener respuesta de autenticación de nuestro backend
- Código fuente de la sección

Sección 28: Apple Sign-in
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto y recursos
- Implementar botón de Apple Sign-in y Servicio de autenticación
- Configuraciones en el portal de developers de Apple
- Identificadores necesarios para nuestro backend
- Configurar nuestro backend para aceptar las peticiones de Apple Sign-in
- Desplegar y configurar URLs de retorno
- Iniciar sesión en nuestro servidor
- Apple Sign-in en Android

Sección 29: Cierre del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (126, 'React-con-Socket-io', 'React: Aplicaciones en tiempo real con Socket-io', 'https://cursos.devtalles.com/courses/React-con-Socket-io', 'https://import.cdn.thinkific.com/643563/dVBO1HUrTzKEzo3Om03j_LEGACY-REACT-CON-SOCKET-IO.jpg', 'Portada del curso: React: Aplicaciones en tiempo real con Socket-io', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'React: Aplicaciones en tiempo real con Socket-io, es un curso enfocado en el manejo de ambas tecnologías para crear aplicaciones que interactúen entre si de manera simultánea e instantánea.', 960, 'es', '{}', 'https://cursos.devtalles.com/courses/React-con-Socket-io', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias
- Instalar nodemon
- Configurar Git y Github
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a los WebSockets y a Socket.io
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a los conceptos generales
- Mi primer Socket Server
- FrontEnd - MiniChat
- Enviar y recibir eventos
- Emitir del cliente al servidor
- Estructura HTML de nuestro mini-chat
- Enviar y recibir mensajes desde y hacia el servidor
- Backend basado en clases
- Configurar sockets en la clase Server
- Crear variables de entorno
- Desplegar nuestro backend server en Heroku
- Probar el socket server en producción
- Habilitar CORS
- Respaldo a Github
- Código fuente de la sección

Sección 3: BandNames App - Backend Server
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio del proyecto - BandNames socket server
- Modelos para manejar nuestras bandas
- Eventos de Sockets
- Crear aplicación de React y los primeros componentes
- Configurar socket.io en React
- Mostrar las bandas actuales
- Editar nombres en la tabla
- Incrementar votos
- Borrar banda
- Cambiar nombre de la banda
- Agregar una nueva banda
- Código fuente de la sección

Sección 4: useSocket, SocketProvider, SocketContext y optimizaciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - BandNames
- useSocket - CustomHook
- Problema del useSocket
- SocketContext y SocketProvider
- Uso del ContextAPI para estado de la conexión
- Context para trabajar con sockets
- Agregar Banda mediante el Context
- Gráfica en tiempo real
- Conectar gráfica con la data del servidor
- Código fuente de la sección

Sección 5: TicketApp - Aplicación de colas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del resultado final de la App
- Inicio de proyecto
- Crear componentes necesarios
- Router entre pantallas
- Pantalla de Ingresar
- Pantalla de Escritorio
- Pantalla para crear un ticket
- Pantalla de Cola de tickets
- UI Context y customHook para ocultar el menú
- Mantener el Agente y Escritorio
- Código fuente de la sección

Sección 6: TicketApp + SocketServer
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - TicketApp
- Clases para el manejo de los Tickets
- Conectar la aplicación de React con nuestro socket server
- Obtener un nuevo ticket
- Asignar un ticket para trabajar
- Actualizar la cola de tickets en tiempo real
- Crear servicio REST para obtener los tickets actuales
- Consumir el servicio REST con los últimos tickets
- Código fuente de la sección

Sección 7: Mapas en tiempo real
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - MapasApp
- Mostrar el mapa
- Mantener la referencia de latitud, longitud y zoom del mapa
- useRef en lugar de useState
- CustomHook - useMapbox
- Agregar Marcadores
- Extraer callback para agregar marcadores
- Obtener coordenadas al mover un marcador
- RXJS - Subject - Emitir eventos
- RXJS - Emitir movimientos de marcador
- Código fuente de la sección

Sección 8: MapasApp + Sockets
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - MapasApp
- Modelos necesarios en el backend
- Conectar React con nuestro Socket Server
- Socket: Nuevo Marcador y Marcadores Activos
- Mostrar marcadores existentes en el backend
- Mostrar nuevos marcadores en tiempo real
- Actualizar marcadores en tiempo real
- Código fuente de la sección

Sección 9: Chat - Introducción
- Introducción a la sección
- Demostración del objetivo de la sección
- Explicación del proyecto y materiales descargables

Sección 10: Chat - Backend
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - ChatBackend
- Preparando la base de datos - MongoAtlas
- Conectar nuestro backend con MongoDB Atlas
- Modelos necesarios - Usuario y Mensaje
- Definición de rutas de autenticación
- Controladores de nuestros API Endpoints
- Express Validator
- Middleware personalizado - ValidarCampos
- Crear usuario en base de datos
- Encriptar la contraseña
- Generar JsonWebToken
- Login de usuario
- Verificar el JWT
- Revalidar el JWT
- Bonus: Guardar Token en Postman
- Obtener todos los mensajes de chat
- Definición de los eventos de sockets necesarios
- Código fuente de la sección

Sección 11: Diseño y estructura en React - ChatApp
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - ChatApp - React
- Páginas y rutas
- Rutas secundarias
- Diseño de Login y Registro
- Diseño del Chat y sus componentes
- Diseño del Chat - Segunda Parte
- Pantalla de selección de Chat
- Código fuente de la sección

Sección 12: Autenticación de Chat
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Backend + Frontend
- AuthProvider - AuthContext
- Pantalla de Login
- Bloquear botón y funcionalidad de recordar usuario
- Login - Petición Http
- Almacenar token y mensajes de error
- Deshabilitar el botón si el formulario no está completo
- Tarea: Pantalla de registro
- Verificar estado de la autenticación
- Rutas privadas y públicas
- Cerrar sesión
- Nota: Cambiar avatar y resumen
- Inicio de autenticación de sockets
- Conectar y desconectar sockets manualmente
- Identificar persona conectada - Backend
- Actualizar base de datos en base a la conexión del usuario
- Código fuente de la sección

Sección 13: Mensajería uno a uno
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - ChatApp
- Chat Context, Provider y Reducer
- Obtener todos los usuarios del chat
- Acción de cargar usuarios
- Mostrar listado de los usuarios
- Activar una sala de chat
- Enviar un mensaje - Parte 1
- Enviar un mensaje - Parte 2
- Grabar chat en base de datos
- Escuchar mensajes personales
- Mostrar los mensajes enviados y recibidos
- Fecha y hora de envío del mensaje
- Cargar el historial del Chat
- Scroll cuando llegan mensajes
- Borrar el ChatState cuando cerramos sesión
- Código fuente de la sección

Sección 14: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (115, 'flutter-Intermedio', 'Flutter Intermedio: Diseños profesionales y animaciones', 'https://cursos.devtalles.com/courses/flutter-Intermedio', 'https://import.cdn.thinkific.com/643563/WFox0um0SWqPahhHvvsg_LEGACY-FLUTTER-INTERMEDIO.jpg', 'Portada del curso: Flutter Intermedio: Diseños profesionales y animaciones', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso tiene por objetivo enseñarte a crear animaciones personalizadas y diseños atractivos para tus aplicaciones móviles y aplicaciones para tabletas.', 900, 'es', '{}', 'https://cursos.devtalles.com/courses/flutter-Intermedio', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- ¿Cómo funcionará el curso?
- Instalación de Flutter en Windows
- Instalación de Flutter OSX
- OSX - “idevice_id” Fix
- Configurar Android físico para pruebas
- Visual Studio Code en Windows y OSX
- Crear aplicación inicial para las próximas secciones
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Backgrounds - Custom Painter
- Temas puntuales de la sección
- Demostración de la sección - CustomPainter
- Header Cuadrado
- Header Circular
- Problema con los diagonales
- Presentación sobre el customPainter
- Header Diagonal
- Header Triángulo
- Header Pico
- Header Curvo
- Header Waves
- Código fuente de la sección
- Bonus: CustomPainter con Gradiente

Sección 3: Animaciones personalizadas
- Temas puntuales de la sección
- Demostración de la sección
- Preparando la pantalla para animar
- Animation y AnimationController
- AnimateBuilder y la rotación
- Animation Listener y Animation Status
- Curves
- Multiples animaciones simultáneas
- Animar en intervalos de tiempo
- Mover el cuadrado
- Escalar el cuadrado
- Determinar el estado de una animación
- Tarea: FadeOut
- Inicio de un nuevo reto
- Reto y solución
- Código fuente de la sección

Sección 4: ProgressBar circular - Animated Custom Painter
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Preparación del espacio para trabajar
- CustomPainter - Círculos y Arcos
- Cambiando el valor dinámicamente
- Animando el arco
- Crear una página para usar el CircularProgress
- Creando nuestro widget personalizado
- Dibujar el circulo y el arco inicial
- Animando mi RadialProgress Widget
- Añadiendo personalización a nuestro RadialProgress
- Jugando con nuestro RadialProgress
- Ultimo retoque del RadialProgress
- Código fuente de la sección
- Bonus: Circular Progress con Gradiente

Sección 5: Slideshow
- Temas puntuales de la sección
- Resultado de la sección
- Inicio del espacio para trabajar
- Mostrando SVGs en pantalla
- PageView - Creando un Slideshow
- Diseño de los puntos indicadores
- PageViewController - Escuchar cambios de páginas
- Provider - Compartir la página actual
- ChangeNotifierProvider - Instanciar nuestra clase
- Cambio de color con animación
- Widget Slideshow - inicio de optimizaciones
- Enviando Widgets a nuestro Slideshow
- Mostrando puntos dependiendo de la cantidad de slides
- Añadiendo personalización a nuestro Slideshow
- Configuraciones usando provider
- Tarea: bulletPrimario, bulletSecundario
- Colocando dos slideshows
- Importante: Corrección de error en el provider
- Código fuente de la sección

Sección 6: Pinterest layout y menu
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Nota de actualización
- Inicio de proyecto - Pinterest
- Pinterest Menú
- Diseño de nuestro menú
- Diseño del botón del menú
- Activar opción del menú
- Colocar nuestro menú sobre el grid
- Mostrar y ocultar el menú con el Scroll
- Cambiar la opacidad del menú
- Personalización a nuestro menú
- Argumento de menu items
- Código fuente de la sección

Sección 7: Emergency Layout
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - Emergency
- IconHeader
- Iconos y textos de mi IconHeader
- Parametrizando nuestro IconHeader
- Creando los botones
- Información dentro del botón
- Parametrizando nuestro botón
- BotónGordo y nuestro IconHeader
- Android physics y botón menú
- Animate_do y emular en dos dispositivos al mismo tiempo
- Código fuente de la sección

Sección 8: Sliver List App
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de la aplicación - SliverListApp
- Diseño básico de la aplicación
- Lista de items en base a un arreglo
- CustomScrollView y Slivers
- SliverPersistentHeaderDelegate
- Botón personalizado flotante
- Código fuente de la sección

Sección 9: Animaciones con Animate_do
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - Animate_do_app
- Diseño de la página 1
- Animaciones básicas - Animate_do
- Twitter IOS intro page
- Disparar animaciones manualmente
- Diseño de página con menú
- Cambiar número de notificaciones usando Provider
- Animaciones con Provider
- Unir todas las pantallas de mi aplicación
- Código fuente de la sección

Sección 10: Temas para nuestra aplicación
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de la sección - Temas
- Rutas de nuestra aplicación
- Provider - ThemeChanger
- Dark y Light Themes
- Usando colores del tema seleccionado
- Aplicando temas en otras pantallas
- Tema en la página de los Slivers
- Creando un diseño personalizado
- Código fuente de la sección

Sección 11: Diseño landscape, portrait y tablets
- Temas puntuales de la sección
- Demostración del final de la sección
- Orientation Builder
- Layout tableta y teléfono
- Diseño de dos columnas - Tablet
- Nota de actualización
- Navegar en diseño de dos columnas
- SlideshowPage - Cambiando Columnas por Rows
- EmergencyPage
- PinterestPage
- Código fuente de la sección

Sección 12: Aplicación de zapatos
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Pantalla inicial, customAppBar y exportaciones
- Inicio de proyecto - Shoes
- Zapato y fondo
- Sombra de nuestro zapato
- Tallas de los zapatos
- Talla seleccionada del zapato
- Descripción del Zapato
- Botón flotante
- Inicio de la segunda página
- Monto y comprar ahora
- Botones circulares de selección de color
- Opciones finales
- Navegación y Hero Animation
- Provider y selección de la talla
- Cambiar color del zapato
- Cambiar colores del Statusbar
- Código fuente de la sección

Sección 13: MusicPlayer
- Temas puntuales de la sección
- Nota de Actualización
- Demostración del objetivo final de la sección
- Material de la sección
- Inicio del proyecto - MusicPlayer
- Custom AppBar
- Imagen del disco
- Progreso de la canción
- Título y botón de Play
- Lyrics - ListWheelScrollView
- Fondo con gradiente
- Icono animado
- Nota de actualización
- Animación del disco
- Determinar la duración de la canción
- Reproducir música
- Código fuente de la sección

Sección 14: PageTransitions - Transiciones entre pantallas
- Temas puntuales de la sección
- Inicio de sección - TransicionesApp
- SlideTransition
- ScaleTransition
- RotationTransition
- FadeTransition
- Código fuente de la sección

Sección 15: Fin del curso
- Más sobre mis cursos
- Más información sobre nuestros otros cursos', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (124, 'PWA', 'PWA - Aplicaciones Web Progresivas - Fernando Herrera', 'https://cursos.devtalles.com/courses/PWA', 'https://import.cdn.thinkific.com/643563/tgqmXHGnQDOQaAzbiWQe_LEGACY-PWA.jpg', 'Portada del curso: PWA - Aplicaciones Web Progresivas - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Las PWAs son el siguiente paso en las aplicaciones web tradicionales, nos permiten poder utilizar nuestra aplicación web inclusive si no tenemos conexión con el servidor e inclusive nos permite recibir notificaciones push.', 870, 'es', '{}', 'https://cursos.devtalles.com/courses/PWA', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias para seguir el curso
- Instalar Git y configuración básica
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos de las aplicaciones web progresivas
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son las aplicaciones web progresivas?
- ¿Por qué construir una PWA?
- Conceptos clave de las PWA
- Material de la sección

Sección 3: Reforzamiento Promesas, Fetch API y HttpServer
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del proyecto y recomendación
- Promesas 101: Problemática
- Resolución del problema usando promesas
- Manejo de errores en las promesas
- Promise All
- Promise Race
- Material adicional sobre promesas
- Origenes del Fetch - XMLHttpRequest
- Fetch API
- Fetch POST / PUT
- Fetch Blob
- Response.clone()
- Manejo de respuestas y errores
- Leer archivos HTML
- Actualización menor
- Tarea: Reforzamiento sobre las promesas y fetch
- Documentaciones adicionales
- Código fuente de la sección

Sección 4: Service Worker y Fetch Event
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al Service Worker
- Inicio del proyecto - Service Worker básico
- Instalación del Service Worker
- Service Worker - Fetch Event
- Formas válidas para realizar peticiones desde el evento Fetch
- Modificando la respuesta de la petición Fetch
- Tarea - Interceptar y modificar peticiones
- Manejo de errores en el Fetch Event
- Nota: Manejo de errores en el Fetch
- Código fuente de la sección
- Cuestionario 1: Examen sobre Service Workers

Sección 5: Ciclo de vida de un Service Worker y los listeners más comunes
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del proyecto - Ciclo de Vida y Listeners
- Service Worker: Install
- Service Worker: Activate
- event.waitUntil( );
- Service Worker: Fetch
- Service Worker: Sync
- Service Worker: Push
- Código fuente de la sección
- Cuestionario 2: Examen sobre listeners y ciclo de vida de un Service Worker

Sección 6: Estrategias de Cache y Offline Mode
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del proyecto y respuesta offline básica
- Respuesta offline HTML String
- Introducción al cache storage
- Guardar el APP SHELL a la hora de instalar SW
- Estrategia: Cache Only
- Estrategia: Cache with network fallback
- Cache dinámico - Optimizaciones
- Limitar el cache dinámico
- Estrategia: Network with cache fallback
- Estrategia: Cache with network update
- Estrategia: Cache y Network Race
- Navegación offline con página personalizada de error
- Mostrar la página offline si no existe la petición en cache
- Borrando versiones viejas del cache
- Cuestionario 3: Examen sobre el cache
- Código fuente de la sección
- Documentaciones adicionales

Sección 7: Despliegues a dispositivos
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del proyecto - Twittor
- Repaso: Configurar SW
- Repaso: Cache con Network Fallback
- El archivo Manifest.json
- Depurar y correr en un dispositivo real
- Desplegar aplicación en GitHub Pages
- Instalando nuestra PWA en el dispositivo móvil - Android
- Mejorando la apariencia en IOS
- Removiendo el Notch de los iPhones
- Notas de Android
- Audits - Lighthouse
- Generadores automáticos del Manifes.json
- Código fuente de la sección

Sección 8: IndexedDB - Reforzamiento de base de datos local
- Introducción a la sección
- Temas puntuales de la sección
- Inicios en indexedDB
- Manejo de errores e inserción de registros
- Código fuente del indexedDB
- PouchDB - Empezando
- Leer registros de la base de datos
- Editar y Borrar TODOS
- Tarea: Transformar nuestra TODO APP en una PWA
- Tarea: Entrenamiento sobre PouchDB
- Resolución de la tarea - PouchDB
- Código fuente de la sección

Sección 9: Sincronización sin conexión - Offline Synchronization
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del proyecto y backend server
- API REST - Get Mensajes
- Consumir servicio REST - Mostrar mensajes en pantalla
- Network with cache fallback - Para las peticiones a nuestra API
- API REST - Post Mensaje
- Envío de la petición POST
- Interceptar un POST y almacenar en indexedDB
- Registrar tarea asíncrona y SYNC del SW
- Disparar posteos cuando hay conexión a internet
- Front-End: Detectar cambios de conexión a internet
- Código fuente de la sección

Sección 10: Notifications - Push Notifications - Push Server
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al envío de Push Notifications
- Inicio del proyecto - Push Notifications
- Permisos para notificaciones
- Detalle estético - Mostrar y ocultar botón de las notificaciones
- Definir los servicios REST necesarios - PUSH - SUBSCRIBE - KEY
- Generar la llave pública y privada
- Retornando nuestro KEY de forma segura
- Generar la suscripción
- Enviar la suscripción al servidor - POST
- Guardar suscripciones en el backend para que sean persistentes
- Cancelar la suscripción - Front-End
- Configurar web-push
- Opciones de una notificación
- Más opciones de las notificaciones
- Redireccionando desde la notificación
- Borrar suscripciones que ya no son válidas
- Código fuente de la sección

Sección 11: Recursos Nativos
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del proyecto - Recursos Nativos
- Nota de actualización
- Uso de la Geolocalización
- POST con las coordenadas y el mapa
- Mostrar video de la cámara
- Nota: Camara posterior
- Tomar Foto y apagar cámara
- Mostrar la fotografía como un mensaje
- Share API
- Código fuente de la sección

Sección 12: Bonus: @angular/pwa
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Angular PWA
- Rutas de nuestra aplicación
- Servicio y manejo de información - Agregar interfaz y URL
- Página del país
- Documentación de @angular/pwa
- ng add @angular/pwa
- Configuraciones en el archivo ngsw-config.json
- Código fuente de la sección

Sección 13: Cierre del curso
- Promociones especiales para alumnos
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (116, 'go-microservicios', 'Go: aplicado a microservicios', 'https://cursos.devtalles.com/courses/go-microservicios', 'https://import.cdn.thinkific.com/643563/s2qOoLdwTUe3klo21bGY_COVER-DEVTALLES-GOLANG-MICROSERVICIOS.jpg', 'Portada del curso: Go: aplicado a microservicios', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Aprende a transformar un proyecto monolítico en uno de microservicios a partir de un proyecto existente. Aprenderás a como funciona un sistema distribuido, gRPC, API Gateway, Service Recovery, Arquitectura Event Driven, resiliencia, seguridad y más.', 390, 'es', '{}', 'https://cursos.devtalles.com/courses/go-microservicios', '2026-09-24 15:49:29.94579+00', '{"Disponible al finalizar la construcción de este curso."}', '{}', 'Sección 1: Bienvenida al curso
- Bienvenida al curso
- ¿Cómo hacer preguntas?
- Conocimientos previos para aprovechar el curso

Sección 2: Introducción e instalaciones necesarias
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir en está sección?
- Instalaciones recomendadas
- Instalar Go en MacOS
- Instalar Go en Windows
- Instalar Go en Linux
- Descargar proyecto monolítico
- Consideraciones e instalaciones para Windows
- Consideraciones e instalaciones para Linux
- Consideraciones e instalaciones para MacOS
- Preparar el entorno
- Estado inicial Devboard
- Arquitectura Devboard distribuido
- Recorrido completo de una petición distribuida
- Código fuente de la sección

Sección 3: De monolito a sistema distribuido (Teoría)
- Introducción a la sección
- Temas puntuales de la sección
- Microservicios
- Repaso de conceptos
- Analizando Devboard
- Analizando Devboard - parte 2
- Domain-Driven Design
- Database Ownership
- Database Ownership - parte 2
- Strangler Pattern
- Código fuente de la sección

Sección 4: Microservicio - Identity Service
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir en esta sección?
- Estructura y Go Module
- Go Workspace
- Identity Service - Config
- Identity Service - Server y options
- Identity Service - Main
- Identity Service - Probando server
- Identity Service - Domain e infraestructura
- Acceso propio a PostgreSQL
- Generando código para User con sqlc
- Identity Service - User Repository
- Identity Service - Actualizando Config
- Identity Service - Agregar dependencias del módulo
- Identity Service - Migrando Usecases
- Identity Service - Migrando Handlers
- Identity Service - Migrando Middlewares
- Identity Service - Actualizando main
- Identity Service - Agregando rutas
- Identity Service - Middleware y Makefile
- Código fuente de la sección

Sección 5: Microservicio - Identity Service - Base de datos
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué vamos a construir en esta sección?
- Cutover del monolito
- Infraestructura, dependencias y comprobaciones
- Registrando usuario desde Identity Service
- Refresh y access token
- Creando base de datos para Identity Service
- Migraciones para Identity Service
- Makefile - Identity Service
- Aplicando migraciones de identity
- Data migration
- Retirando Foreign Keys hacia Identity
- Aplicando migraciones monolito
- Probando identity service
- Nuevos servicios, nuevos problemas
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (117, 'kafka-springboot-event-driven', 'Kafka y SpringBoot: Arquitectura Event-Driven', 'https://cursos.devtalles.com/courses/kafka-springboot-event-driven', 'https://import.cdn.thinkific.com/643563/xyGHvSJ3Q4aHtENeJk7H_COVER-DEVTALLES-KAFKA.jpg', 'Portada del curso: Kafka y SpringBoot: Arquitectura Event-Driven', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Aprende Apache Kafka con Spring Boot 4 y Java 21 construyendo un backend real que evoluciona de monolito modular a microservicios, con criterio de arquitectura y Spec-Driven Development. Un proyecto que crece y se resuelve clase a clase.', 810, 'es', '{}', 'https://cursos.devtalles.com/courses/kafka-springboot-event-driven', '2026-09-24 15:49:29.94579+00', '{"Disponible al finalizar la construcción de este curso."}', '{}', 'Sección 1: Introducción
- Introducción al curso
- ¿Cómo hacer preguntas?
- Instalaciones necesarias

Sección 2: Cimientos: Spec-Driven Development y arquitectura con criterio
- Introducción a la sección
- Temas puntuales
- Bienvenida: el sistema, el arco y el método
- Monolito modular o microservicios: cómo elegir
- Del vibe-coding al Spec-Driven-Development
- SDD: GitHub Spec Kit y Opencode - parte 1
- SDD: GitHub Spec Kit y Opencode - parte 2
- Anatomía de un spec
- La constitución del proyecto
- El spec de la primera feature
- Un prompt pobre vs un prompt rico - parte 1
- Un prompt pobre vs un prompt rico - parte 2
- ¿Cómo se construye un buen prompt?
- speckit plan: revisión del resultado
- speckit tasks e implement
- Interfaces: cuándo suman y cuándo sobran
- Cuándo todo el pipeline y cuándo directo: el criterio
- El spec como documento vivo
- Del plan al código: plan, converge y implement
- Antipatrones del spec: cómo no escribirlo
- SDD: más allá de Spec Kit
- La pregunta abierta
- Código fuente

Seccíon 3: Kafka: fundamentos y el primer evento real
- Introducción a la sección
- Temas puntuales
- ¿Qué problema resuelve Kafka?
- Topics, particiones y el log
- Offsets y consumer groups
- Kafka por dentro: Brokers, cluster y el controller
- Kafka con Docker Compose - parte 1
- Kafka con Docker Compose - parte 2
- ¿Por qué Kafka entre módulos del mismo proceso?
- El contrato de un evento: ReservationCreated
- Kafka: dependencia y configuración base
- El producer: reservations publica
- El consumer: tables escucha y asigna la mesa - parte 1
- El consumer: tables escucha y asigna la mesa - parte 2
- Código fuente

Sección 4: El ciclo de vida de la reserva, por eventos
- Introducción a la sección
- Temas puntuales
- tables responde: publica TableAssigned
- reservations: de PENDING a CONFIRMED
- Probamos la reserva confirmada y testing
- El "no" de negocio - parte 1
- El "no" de negocio - parte 2
- notifications: un listener, dos finales - parte 1
- notifications: un listener, dos finales - parte 2
- Garantías de entrega: qué te asegura Kafka
- Perfiles: dev, test, prod
- El ciclo completo de punta a punta
- Código fuente

Sección 5: Cuándo Kafka, cuándo no: diseñar con criterio
- Introducción a la sección
- Temas puntuales
- Monolito modular: fronteras, no carpetas
- Spring Modulith: verificar las fronteras
- ¿Qué es doméstico y qué cruza la frontera?
- Eventos in-process: otra forma de desacoplar - parte 1
- Eventos in-process: otra forma de desacoplar - parte 2
- El default sano: cuándo Kafka es sobre-ingeniería
- Kafka vs RabbitMQ
- El mapa del sistema
- Código fuente

Sección 6: Patrones Avanzados de Mensajería
- Introducción a la sección
- Temas puntuales
- Garantías del productor: qué te da Kafka de fábrica - parte 1
- Garantías del productor: qué te da Kafka de fábrica - parte 2
- Transactional Outbox - parte 1
- Transactional Outbox - parte 2
- Outbox en reservations - parte 1
- Outbox en reservations - parte 2
- El relay: de la tabla outbox a Kafka
- Outbox: la prueba
- El consumidor idempotente
- Reintentos y backoff
- Dead Letter Topics
- Reprocesar el Dead Letter Topic
- DLT: Post y prueba
- Un reprocesador para todos los DLT
- DLT genérico: Controlador y prueba
- Errores pasajeros y errores permanentes
- Descartar el poison pill: directo al DLT
- Reprocesar sin reinyectar los permanentes
- Request-Reply: el patrón y las piezas
- Request-Reply: prueba y código
- Código fuente

Sección 7: Diseño Event-Driven: eventos que duran
- Introducción a la sección
- Temas puntuales
- ¿Qué es el diseño event-driven? parte 1
- ¿Qué es el diseño event-driven? parte 2
- Comando vs evento
- Diseñar un evento: nombre y granularidad
- Diseñar un evento: listerner, controller y email
- La forma de un evento: su rol y cuánto carga
- Agregar un campo sin romper el contrato
- Cuando el cambio rompe: versionar - parte 1
- Cuando el cambio rompe: versionar - parte 2
- Event Sourcing: la reserva son sus hechos - parte 1
- Event Sourcing: la reserva son sus hechos - parte 2
- Event Sourcing: la reserva son sus hechos - parte 3
- El service sin tabla: load, decidir y append - parte 1
- El service sin tabla- load, decidir y append - parte 2
- CQRS: El concepto
- CQRS: La implementación
- CQRS: El controlador
- Código fuente', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (118, 'legacy-react-cero-a-experto', 'Legacy - React: De cero a experto - Fernando Herrera', 'https://cursos.devtalles.com/courses/legacy-react-cero-a-experto', 'https://import.cdn.thinkific.com/643563/XBa7pWMT41InOa9UaB0Q_LEGACY-REACT.jpg', 'Portada del curso: Legacy - React: De cero a experto - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso tiene por objetivo llevarte de cero conocimiento de React hasta un nivel competitivo en el ambiente laboral de hoy en día. Este curso está construido 100% en Hooks y functional components.', 2910, 'es', '{}', 'https://cursos.devtalles.com/courses/legacy-react-cero-a-experto', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción al curso
- ¿Cómo funcionará el curso?
- Instalaciones necesarias y recomendadas
- Importante: Cursos Legacy
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a React y conceptos generales
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es React?
- Primeros pasos en React
- Introducción a Babel

Sección 3: Introducción a JavaScript moderno
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Bases de JavaScript
- Variables y constantes
- Template String
- Objetos lilterales
- Arreglos
- Funciones
- Desestructuación de Objetos
- Desestructuación de Arreglos
- Import, export y funciones comunes de arreglos
- Múltiples exportaciones y exportaciones por defecto
- Promesas
- Fetch API
- Async - Await
- Operador condicional ternario
- Nota sobre JavaScript
- Código fuente de la sección

Sección 4: Primeros pasos en React
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son los componentes?
- Primera aplicación de React
- Estructura de directorios - CRA
- Contenido de la carpeta SRC
- Hola Mundo en React
- Nuestro primer Componente
- Retornar elementos en el Componente - Fragment
- Impresión de variables en el HTML
- Comunicación entre componentes - Props
- PropTypes
- DefaultProps
- Tarea - Componente CounterApp
- Evento click (Eventos en general)
- useState - Hook
- handleSubtract y handleReset
- Actualización a React 18
- Código fuente de la sección

Sección 5: Pruebas unitarias y de integración - Probando las secciones anteriores
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a las pruebas unitarias y de integración
- Inicio de la sección - Pruebas sobre lo aprendido anteriormente
- Mi primera prueba y configuraciones iniciales
- Jest - Expect - toBe
- Pruebas en el archivo 02-template-string.js
- toEqual
- Pruebas en el archivo 07-deses-arr.js
- Pruebas en 08-imp-exp.js - Arreglos
- Pruebas con tareas asíncronas
- Pruebas con async-await
- Pruebas sobre componentes de React
- Nota de actualización
- Enzyme - Testing unit
- Revisar elementos dentro del componente
- Pruebas básicas del CounterApp
- Simular eventos - Click
- Pruebas con el botón de reset
- Código fuente de la sección

Sección 6: GifExpertApp - Aplicación
- Introducción a la sección
- Temas puntuales de la sección
- Resultado al final de la sección
- Inicio de proyecto - GifExpertApp
- GifExpertApp - Component
- Creando una lista de categorias
- Componente AddCategory
- Comunicación entre componentes
- Fetch API - Obtener las imágenes deseadas
- useEffect
- Mostrar los títulos de las imágenes
- className - Clases de css
- Helpers - getGifs
- Custom Hook - useFetchGifs
- useFetchGifs - obtener imágenes y bandera de carga
- Animaciones por CSS en nuestra aplicación
- Código fuente de la sección

Sección 7: Generando el build de producción y despliegues
- Introducción a la sección
- Temas puntuales de la sección
- Preparación del proyecto - Github Pages
- Desplegando aplicación en Github Pages

Sección 8: Testing - Probando la aplicación de GifExpert
- Introducción a la sección
- Temas puntuales de la sección
- Configurar el ambiente de pruebas
- Implementando PropTypes
- Pruebas del componente - GifGridItem
- Pruebas en el helper getGifs
- Pruebas del componente - AddCategory
- Simular cambios en un input
- Simular un submit del formulario
- Jest Functions
- Pruebas del componente GifGrid - Mock customHook
- Hacer un mock completo de un Custom Hook
- Pruebas del componente GifExpertApp
- Pruebas sobre customHooks
- customHook - waitForNextUpdate
- Código fuente de la sección

Sección 9: Profundizando Hooks - Generales
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - HooksApp
- useState
- useCounter - CustomHook
- useEffect - SimpleForm
- useEffect unmount - Cleanup
- useEffect - Precauciones
- Formulario con custom Hook
- useFetch - CustomHook
- useFetch + useCounter
- useRef - Primer uso
- useRef - Caso de uso real
- useLayoutEffect
- Memo - Método de React
- useMemo
- useCallback
- Tarea Memorize
- Código fuente de la sección

Sección 10: Profundizando Hooks - useReducer
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al concepto de un reducer
- Idea general de un reducer - Vía código
- useReducer - Todo List
- Creando el cascarón de la lista de TODOs
- Agregar un nuevo TODO
- Guardar y Leer TODOs en LocalStorage
- Borrar un TODO
- Toggle Todo - Marcar como completado o pendiente un TODO
- Optimización #1 - Listado de TODOs
- Optimización #2 - Agregar TODO
- Código fuente de la sección

Sección 11: Profundizando Hooks - useContext
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al Context
- Preparación de nuestra aplicación con rutas
- Configurar Router en React
- Link
- CreateContext y ContextProvider
- useContext
- Código fuente de la sección

Sección 12: Pruebas unitarias y de integración - Hooks
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Pruebas sobre Hooks
- Pruebas sobre useCounter - CustomHook
- Ejecutar funciones del customHook dentro de las pruebas
- Pruebas sobre useForm - CustomHook
- Pruebas sobre useFetch - CustomHook
- Pruebas con múltiples hooks simultáneos
- Tarea - Interacciones con el useState
- Pruebas sobre el Reducer
- Pruebas restantes de mi Reducer
- Pruebas en el componente TodoItem
- Pruebas en el TodoList
- Pruebas con el TodoAdd
- Pruebas en el TodoApp
- Pruebas con useContext
- Pruebas de funciones del context
- Pruebas generales en nuestro AppRouter
- Código fuente de la sección

Sección 13: Bonus: Repositorio de Custom Hooks
- Introducción a la sección
- Temas puntuales de la sección
- Repositorio con customHooks
- Mejorando la estructura y ayuda de los Hooks
- Código fuente de la sección

Sección 14: HeroesApp - Single Page Application (SPA)
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo al final de la sección
- Inicio de proyecto - HeroesApp
- Creando un primer Router
- Colocar clase de la ruta activa
- Creando un segundo Router
- Navigate push / replace - useNavigate
- Lista de Heroes
- Tarjetas con la información del Héroe
- Leer argumentos por URL
- Estilo del componente HeroScreen
- Nota: useMemo
- Animaciones en nuestro componente
- SearchComponent
- Mostrar listado de héroes
- Aplicar filtro de Héroes - QueryString
- Mostrar mensajes condicionales
- Código fuente de la sección

Sección 15: Protección de rutas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo al final de la sección
- Continuación de proyecto - Protección de Rutas
- Context y Reducer de mi aplicación
- Proveer estado global de la aplicación
- Login de un usuario
- Logout del usuario
- Rutas privadas
- Rutas públicas
- Recordar la última página visitada
- Código fuente de la sección

Sección 16: Pruebas de nuestra aplicación de Heroes
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de la sección - Pruebas en HeroApp
- Pruebas en el authReducer
- Pruebas en el AppRouter
- Pruebas AppRouter - Usuario autenticado
- Pruebas en el DashboardRoutes
- Probar rutas dentro del DashboardRoutes
- Pruebas en el SearchScreen
- Pruebas con los queryParameters
- Tarea - requireActual
- Tarea - Pruebas en el Navbar
- Solución - Pruebas en el Navbar
- Tarea - Pruebas en el LoginComponent
- Solución - Pruebas en el LoginComponent
- Pruebas en el HeroScreen
- Pruebas adicionales en el HeroScreen
- Pruebas en el PrivateRoute
- Código fuente de la sección

Sección 17: JournalApp - SASS - Estructura y Diseño
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio del proyecto - JournalApp
- Implementando rutas principales y rutas hijas
- Sass Partials
- Estilos del AuthRouter
- Estilos del LoginScreen
- Estilos en el RegisterScreen
- Sidebar
- Sidebar - JournalEntries
- Componente cuando no hay nada seleccionado
- NoteAppBar
- Estructura y diseño del HomeScreen
- Código fuente de la sección

Sección 18: Redux - ¿Qué es y conceptos? + React Redux
- Introducción a la sección
- Temas puntuales de la sección
- Explicación visual del patrón Redux

Sección 19: Introducción a Redux y autenticación en Firebase
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Configurando Redux en nuestra aplicación
- Redux DevTools
- Primer dispatch de una acción a nuestro Store
- Configuración inicial de Firebase
- Thunk - Acciones asíncronas
- Configurar Firebase y Google Sign-in
- Formulario de registro de usuarios
- Manejo de errores del formulario
- uiReducer y Acciones
- useSelector - Obtener información del State
- Crear usuario con correo y contraseña
- Realizar el login de usuario con correo y contraseña
- Tarea Loading state
- Mantener el estado de la autenticación al recargar
- Mostrar un loading global en la aplicación
- Logout de Firebase
- Protección de rutas
- Mensajes de error
- Código fuente de la sección

Sección 20: JournalApp - Redux - CRUD en Firestore y subida de archivos
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación del proyecto - JournalApp
- NotesReducer
- Crear una nueva nota
- Activar la nota creada
- Cargar notas de Firestore
- Optimización de la petición de carga de notas
- Mostrar las notas en el menú lateral
- Activar una nota
- Cambiar la nota activa al cambiar la selección
- Actualizar la nota actual
- Actualizar panel lateral y mensajes de grabación
- Cloudinary.com - Backend para subir imágenes
- Subir imagen a Cloudinary
- Actualizar el url de la nota activa
- Borrar una nota
- Purgar las notas en un logout
- Animaciones en nuestra aplicación
- Código fuente de la sección

Sección 21: Pruebas con Redux, Firebase, Firestore y autenticación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - JournalApp - Testing
- Pruebas de carga de archivos
- Cloudinary SDK - Delete image
- Pruebas con el authReducer
- Pruebas en acciones síncronas - uiActions
- Pruebas de acciones asíncronas - startNewNote
- Crear base de datos de testing
- Variables de entorno
- Pruebas en startLoadingNotes y startSaveNote
- Prueba en la acción de subir archivo
- Pruebas en las acciones de Auth
- Acciones startLogout y startLoginEmailPassword
- Pruebas en el LoginScreen
- Evaluar el login y el Google login
- Pruebas en el RegisterScreen
- Probando que el mensaje de error exista
- Pruebas en el AppRouter
- Pruebas en el Sidebar
- Pruebas en el NoteScreen
- Pruebas con JournalEntry
- Código fuente de la sección

Sección 22: MERN Calendar - Estructura y Diseño
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - MERN-Calendar
- LoginScreen y Navbar
- React Big Calendar
- Configuraciones adicionales al calendario
- Personalizar el cuadro de evento
- Creando un modal sobre el calendario
- Contenido del EventModal
- Obtener la información del formulario del evento
- Validaciones del formulario
- Instalación y configuración de Redux
- Mostrar y ocultar modal en base al Store
- CalendarReducer y primeras acciones con los eventos
- Añadir un nuevo evento
- Mostrar eventos en el calendario
- Editar el evento activo
- Eliminar evento
- Código fuente de la sección

Sección 23: CalendarApp - Backend - Node, Express, Mongo
- Introducción a la sección
- Temas puntuales de la sección
- Objetivo al final de la sección
- Inicio de proyecto - CalendarApp Node Backend
- Configurando Express
- Variables de entorno y carpeta pública
- Creando las rutas relacionadas a usuarios
- Endpoints de remover, crear y login
- Recuperar información de un posteo
- Express Validator
- Custom Middlewares
- Configuración de base de datos
- Conectar Node a Mongo Atlas
- Crear un usuario en nuestra Base de Datos
- Validaciones del usuario
- Encriptar la contraseña
- Login de usuario
- Generar un Json Web Token
- Revalidar JWT
- Configurar CORS
- Código fuente de la sección

Sección 24: Backend - Eventos del calendario - CRUD
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - Calendar Backend
- Resolución de la tarea - CRUD
- Modelo Evento
- Validar campos necesarios
- Grabar el evento en la base de datos
- Obtener el listado de los Eventos
- Actualizar un Evento
- Eliminar Eventos
- Código fuente de la sección

Sección 25: Despliegue del backend en Heroku
- Introducción a la sección
- Temas puntuales de la sección
- Despliegues en Heroku
- Montar la aplicación en Heroku

Sección 26: MERN - Calendario + Backend
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Calendar + Backend
- Creando variables de entorno
- AuthReducer
- Disparar la acción de inicio del login de usuario
- Realizar la petición HTTP para autenticarnos
- Creación de un nuevo usuario
- Mantener el estado de la autenticación
- Añadir el UID y el Name del usuario en el Backend
- Protección de nuestras rutas
- Logout y nombre de usuario
- Código fuente de la sección

Sección 27: MERN CRUD - Eventos del calendario
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Calendar CRUD de Eventos
- Creando un nuevo Evento en el calendario
- Mostrar eventos de la base de datos
- Convertir Strings a objetos tipo Date
- Actualizar el evento
- Eliminar un evento
- Código fuente de la sección

Sección 28: Fin el MERN - Desplegarlo a producción
- Introducción a la sección
- Temas puntuales de la sección
- Generar versión de producción y desplegarla en Heroku

Sección 29: Pruebas unitarias y de integración - MERN
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de las pruebas
- Pruebas en nuestro helper del Fetch
- Pruebas con el helper FechConToken
- Pruebas en las acciones de Auth
- Pruebas con un login incorrecto
- Pruebas con el registro de usuarios
- Pruebas con la acción checking
- Pruebas con el uiReducer
- Pruebas en el authReducer
- Pruebas en el componente DeleteEventFab
- Prueba disparando la acción eventStartDelete
- Pruebas en el componente AppRouter
- Mostrar ruta pública o privada si se está autenticado o no
- Pruebas en el componente LoginScreen
- Pruebas cuando las contraseñas no son iguales
- Pruebas en CalendarScreen
- Interacciones con el componente Calendar
- Pruebas con el Modal y DateTimePicker
- Disparar acciones dentro del Modal
- Debe de llamar la creación de un nuevo evento
- Código fuente de la sección

Sección 30: Fin del curso
- Presentaciones utilizadas
- Más información para seguir aprendiendo
- Youtube playlist de React + TypeScript
- ¿Quiéres seguir aprendiendo más de React?
- Más información sobre nuestros otros cursos
- Despedida del curso

Sección 31: Archivado - Heroes App - Router Versión 5
- Demostración del objetivo final de la sección
- Inicio de proyecto - HeroesApp
- Creando un primer Router
- Creando un segundo Router
- History push / replace
- Lista de Heroes
- Tarjetas con la información del Héroe
- Leer argumentos por URL
- Estilo del componente HeroScreen
- Nota useMemo
- Animaciones en nuestro componente
- SearchComponent
- Aplicar filtro de Heroes
- Aplicar filtro en base al QueryString
- Código fuente de la sección

Sección 32: Archivado - Rutas Protegidas - Router Versión 5
- Demostración del objetivo al final de la sección
- Inicio de proyecto - Protección de Rutas
- Context y Reducer de mi aplicación
- Login de un usuario
- Logout del usuario
- Rutas privadas
- Rutas públicas
- Recordar la última página visitada
- Código fuente de la sección

Sección 33: Archivado - Pruebas con Router V5
- Inicio de la sección - Pruebas en HeroApp
- Pruebas en el authReducer
- Pruebas en el PrivateRoute
- Probar que el localStorage sea llamado con argumentos
- Probar que el PrivateRoute no muestre el componente
- Pruebas en el componente AppRouter
- Pruebas en el componente DashboardRoutes
- Pruebas en el componente Navbar
- Pruebas en el componente HeroScreen
- Simular segmentos del URL en nuestras pruebas
- Pruebas en el componente LoginScreen
- Pruebas en el componente SearchScreen
- Pruebas faltantes del componente SearchScreen
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (119, 'legacy-react-native', 'React Native: Aplicaciones IOS y Android - Fernando Herrera', 'https://cursos.devtalles.com/courses/legacy-react-native', 'https://import.cdn.thinkific.com/643563/85PloWQXC6mLTygWEoLg_LEGACY-NATIVE.jpg', 'Portada del curso: React Native: Aplicaciones IOS y Android - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Curso completo de React Native que te dará las bases sólidas sobre este framework, con más de 42 horas de contenido en video y despliegues en la Google PlayStore y Apple AppStore incluído en el curso.', 2610, 'es', '{}', 'https://cursos.devtalles.com/courses/legacy-react-native', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción
- ¿Cómo funcionará el curso?
- Instalaciones necesarias y recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Reforzamiento de las bases - Conocimiento requerido para continuar
- Introducción a la sección
- Temas puntuales de la sección
- ¿Por qué TypeScript?
- Inicio de proyecto - Introducción React con TypeScript
- Nota de actualización
- Preparar proyecto y nuestros primeros Functional Components en TS
- Tipos Básicos - TypeScript
- Objetos literales e interfaces
- Funciones, retorno y argumentos
- Hook - useState
- Custom Hook - useCounter
- Componente Login - Antesala al useReducer
- Hook - useReducer
- AuthReducer
- Login y Logout
- Peticiones HTTP - Axios
- Establecer el tipo de las respuestas HTTP
- Mostrar usuarios en pantalla
- Crear una pequeña paginación
- Custom Hook - useUsuarios
- Siguientes y Anteriores registros - Paginación
- Formularios
- Custom Hook - useForm < Genericos >
- Código fuente de la sección

Sección 3: Instalación y configuración de ReactNative con emuladores y dispositivos físicos
- Introducción a la sección
- Temas puntuales de la sección
- Diferencia entre EXPO CLI y ReactNative CLI
- Windows: Instalaciones necesarias
- Windows: Crear un dispositivo virtual
- Windows: Crear proyecto de React Native
- Android físico - Habilitar USB Debugging
- Windows: Correr aplicación en dispositivo físico
- Mac OSX: Instalaciones necesarias - Android
- Mac OSX: Emulador de Android
- Mac OSX: Instalaciones necesarias para IOS
- Mac OSX: Crear proyecto de React Native
- Mac OSX: Android Físico USB Debugging
- Mac OSX: Correr App en Android físico
- Mac OSX: Correr en simulador de IOS
- Mac OSX: Correr en un iPhone físico

Sección 4: Mi primera App en React Native - CounterApp
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - MiPrimeraApp
- Deshabilitar Prettier
- Hola Mundo
- Crear pantallas independientes
- Crear un contador
- Tip: ¿Cómo ver los ejemplos de la documentación?
- TouchableOpacity
- StyleSheet
- Botón personalizado flotante
- Componente personalizado: FAB - Floating Action Button
- Enviar funciones y propiedades opcionales
- Estilo condicional
- Código específico para plataforma
- Resumen de lo aprendido hasta el momento
- Código fuente de la sección

Sección 5: Flex, Position y Box Object Model
- Introducción a la sección
- Temas puntuales de la sección
- Box Object Model - Fundamentos del diseño en React Native
- Continuación de proyecto - Diseños y Flexbox
- Padding, Margin, Border, Width y Height
- Height, Width porcentual y dimensiones de la pantalla
- Position - Fundamentos del diseño en React Native
- Posición relativa
- Posición absoluta
- Flexbox - Fundamentos del diseño en React Native
- Flex
- Flex Direction
- Justify Content
- Align Items
- Align Self
- Flex Wrap
- Preparar nuevo componente para la tarea
- Tarea sobre diseños
- Resolución de la tarea de diseños
- Código fuente de la sección

Sección 6: Aplicación - Calculadora de IOS
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - Calculadora
- Diseño inicial y pantalla de Calculadora
- Textos y mi primer botón
- Botón de calculadora y sus filas
- Terminar todos los botones y el estilo de la calculadora
- Construir el número base
- Consideraciones para armar el número
- Tarea - Botón de borrar última entrada
- Botones de operaciones aritméticas
- Realizar el cálculo
- Custom Hook: useCalculadora
- Código fuente de la sección

Sección 7: NavegaciónApp - Todos los tipos de navegación
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - NavegacionApp
- Explicación sobre el sistema de navegación
- React Navigation - Pre-requisitos
- React Navigation - Stack
- Navegar a otras pantallas
- Estilizando el Stack Navigator
- Enviar argumentos entre pantallas
- Diferentes formas de colocar el tipo de dato de los argumentos
- React Navigation - Drawer
- Nota de actualización
- Configurar Drawer básico
- Toggle Drawer - Mostar / Ocultar
- Drawer personalizado
- Navegar desde el MenuLateral personalizado
- useSafeAreaInserts
- Código fuente de la sección

Sección 8: Tabs, MaterialTabs y Material Top Scrollable Tabs
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto
- Explicación sobre el Bottom Tab Navigator
- Crear el BottomTabNavigator
- Personalizando el BottomTabNavigator
- Preparar el espacio para el ícono
- Material Bottom Tab Navigator
- Material Top Tab Navigator
- Personalizando el Material Top Tab Navigator
- Iconos en nuestra aplicación - Instalaciones
- Instalación de íconos en IOS
- Colocando íconos en todo lugar
- Código fuente de la sección

Sección 9: Context y estado global de la aplicación
- Introducción a la sección
- Temas puntuales de la sección
- Introducción sobre el Context y estado global de la aplicación
- Continuación de proyecto - NavegacionApp
- Crear nuestro primer Context en TypeScript
- Consumir el context - AuthState
- Reducer - useReducer
- Disparar acciones
- Disparar el SignIn desde otra pantalla
- TouchableIcon - Custom Component
- Cambiar el ícono favorito - AuthState
- Borrar información del AuthState
- Cambiar el username
- Código fuente de la sección

Sección 10: Aplicación de Películas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo al final de la sección
- Inicio de proyecto - PeliculasApp
- Navegación entre pantallas
- Obtener películas en cartelera
- Tipado de TheMovieDB
- useMovies
- Mostar el poster de la película
- Carousel de tarjetas
- FlatList de Películas
- Componente HorizontalSlider
- Películas populares, mejor calificadas y próximas a salir
- Múltiples peticiones de forma simultánea
- Navegar a la pantalla de detalles
- Diseño inicial de la pantalla de detalles
- Sombra e íconos de nuestra aplicación
- useMovieDetails - CustomHook
- Cargar información de los actores
- Detalles de la película
- Detalles de la película - Parte 2
- Componente para mostrar actores
- Lista de actores
- Botón para regresar
- Código fuente de la sección

Sección 11: Bonus: Gradiente animado - ContextAPI
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - PeliculasApp
- Ejercicio para comprender el FadeIn
- FadeOut
- Fondo con gradiente
- Fix: Interface de MovieDB
- Obtener los colores de las imágenes
- Helper: Obtener colores
- Crear un contexto para comunicar el cambio de color
- Usar los colores del context
- Lógica para cambiar y animar el gradiente
- Explicación del cambio de gradiente
- Código fuente de la sección

Sección 12: Componentes de ReactNative
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - RNComponents
- Crear Stack e instalar iconos
- Componente - FlatList
- FlatList Separator y Header
- FlatListItem y navegación
- Nota de actualización
- Animated API
- FadeIn y FadeOut
- Easing - Bounce
- useAnimation
- Animated ValueXY
- Componente - Switch
- Header re-utilizable
- CustomSwitch
- Uso de multiples switches
- Componente - Alert
- Componente - Alert Prompt
- Prompt IOS y Android
- Componente - TextInput
- Multiples TextInputs en pantalla
- Componente - keyboardavoidingview
- useForm - Tarea
- Pull to refresh
- Personalizando el Refresh Control
- Componente - SectionList
- Header y Footer de un SectionList
- Componente - Modal
- Personalizar el modal
- InfiniteScroll
- InfiniteScroll con imágenes
- Animated Image
- Enviar estilo desde el padre
- Cierre de sección
- Código fuente de la sección

Sección 13: Temas y Slideshow de pantalla completa
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - ComponentsApp
- Snap Carousel
- Paginación de Slides - ( Puntos indicativos )
- Botón en el último Slide
- Solución de la tarea con los slides
- Theme Light y Dark - Generalidades
- Pantalla para cambiar el tema de la aplicación
- ThemeContext
- ThemeReducer
- Consumir el ThemeContext
- Cambiar entre Light y Dark
- Tarea - Usar el tema en toda la aplicación
- Resolución de la tarea - Segunda Parte
- Cambio de tema basado en el Sistema Operativo
- Código fuente de la sección

Sección 14: Pokedex
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - Pokedex
- Stack Navigator e íconos
- Diseño básico del HomeScreen
- Obtener lista de Pokemons en un custom hook
- Colocar el tipo de dato que retorna la petición HTTP
- Mapear resultado a un arreglo de SimplePokemon
- Mostrar pokemons - InfiniteScroll
- FadeInImage y useAnimation
- PokemonCard - Componente
- Terminando el PokemonCard
- Colocar el color de fondo de la tarjeta basado en el pokemon
- Problema con la actualización de estado
- Navegar a la pantalla de detalle
- Pantalla del Pokemon
- Información completa del Pokemon
- Información adicional del Pokemon
- Peso y Sprites del Pokemon
- Stats y pie de la pantalla
- Código fuente de la sección

Sección 15: Debouncer y Búsquedas
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - Pokedex
- Implementar Tabs en nuestra aplicación
- SearchComponent - Diseño
- Pre-cargar la información para buscar por nombre
- Optimizaciones de estilo
- useDebounceValue - CustomHook
- Filtrando Pokemons basados en el término de búsqueda
- Buscar por ID
- Detalles estéticos de la pantalla de búsqueda
- Código fuente de la sección

Sección 16: RutasApp - Permisos - Aplicación con mapas - Google y Apple Maps
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - RutasApp
- Rutas y StackNavigator
- Android: Configuración inicial de permisos de GPS
- IOS: Configuración inicial de permisos de GPS
- Solicitar y revisar permisos - Check y Request Permission
- Permission Provider - ContextAPI
- Uso del PermissionContext
- Revisar el permiso de GPS al regresar a la aplicación
- Detectar qué pantalla mostrar al inicio de forma automática
- Abrir ajustes de localización si el permiso está bloqueado por el usuario
- Botón estilizado
- Código fuente de la sección

Sección 17: RutasApp - Aplicación con mapas - Google y Apple Maps
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Continuación de proyecto - MapasApp
- Configuración de GoogleMaps
- Android: Configuración de GoogleMaps
- IOS: Configuración de GoogleMaps
- Fix: Loading infinito en ocasiones
- React Native Maps - RequireCycle Warning
- Marcadores y componente Mapa re-utilizable
- MapView - Mostrar la ubicación del usuario
- Obtener las coordenadas del usuario
- CustomHook - useLocation
- FabIcon - Componente personalizado
- Mover la cámara a las coordenadas del usuario
- Darle seguimiento al usuario (Mover cámara constantemente)
- Dejar de seguir y limpiar el watch
- Trazar la ruta del usuario
- Mostrar y ocultar las polylines
- Evitar llamadas al cambio de State cuando el componente esta desmontado
- Código fuente de la sección

Sección 18: Autenticación y Productos - Backend
- Introducción a la sección
- Temas puntuales de la sección
- Descargas y configuraciones básicas
- Levantando el backend
- Probando el backend y grabaciones
- Desplegando nuestro backend en Heroku

Sección 19: Autenticación - ProductosApp
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - ProductosApp
- Diseño del login
- Diseño del login - Parte 2
- Formulario y navegación
- Diseño de la pantalla de registro
- AuthContext
- AuthReducer
- Conectar AuthContext con el authReducer
- Levantar el backend y probarlo
- HTTP - Login y obtener el token
- Dispatch de la acción de Signup
- Manejar errores de login
- Async Storage - Guardar Token
- Validar el token
- Loading Screen y revalidar el token
- Logout
- Registro de usuarios
- Código fuente de la sección

Sección 20: Productos, galería y cámara
- Introducción a la sección
- Temas puntuales de la sección
- Objetivo al final de la sección
- Continuación de proyecto
- ProductosContext
- ProductsNavigator
- ProductsScreen - Diseño y data
- Navegar a la pantalla de Producto
- Diseño de la pantalla de producto
- React Native - Picker
- Llenar el selector con categorías
- Formulario del producto
- Mostrar imagen y la categoría del producto
- Prepararnos para la grabación o actualización
- Crear producto y actualizar producto - Llamar el backend
- Pull to refresh
- Código fuente de la sección

Sección 21: Cámara, galería y carga de imágenes al backend
- Introducción a la sección
- Temas puntuales de la sección
- Objetivo al final de la sección
- Continuación de proyecto - Cámara y galería de imágenes
- Abrir la cámara y tomar una fotografía
- Probar cámara en dispositivo físico
- Subir imagen a nuestro backend
- Subir fotografía desde la galería
- Código fuente de la sección

Sección 22: Despliegues en Google Play Store y Apple App Store
- Introducción a la sección
- Temas puntuales de la sección
- Preparación de proyecto
- Android: ícono y nombre de la aplicación
- IOS: ícono y nombre de la aplicación
- Android: SplashScreen
- Android: Personalizar el SplashScreen
- IOS: SplashScreen
- Generar Android App Bundle - AAB - APK
- Cambiar identificador único de Android
- Generar un nuevo AAB - Actualización de llave o actualización de app
- Subir AAB a la PlayStore
- Configuraciones adicionales en la Google PlayStore
- IOS: Identificador único y portal de developer de Apple
- Generar identificador y preparar el espacio en la AppStore Connect
- Testflight - Probar la aplicación

Sección 23: Despedida del curso
- Presentaciones utilizadas
- Información adicional sobre React Native
- Más información sobre nuestros otros cursos
- Fin y cierre del curso
- Bloopers', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (120, 'mas-DevTalles', '+ DevTalles con Fernando Herrera', 'https://cursos.devtalles.com/courses/mas-DevTalles', 'https://import.cdn.thinkific.com/643563/FJftjLsKQLaPN7U8QKpq__devtalles.jpg', 'Portada del curso: + DevTalles con Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso es exclusivo para sesiones en vídeo con Fernando Herrera. Durante las mismas podrás realizar preguntas relacionadas al contenido de sus cursos. Todas las sesiones quedarán grabadas. Esperamos tu participación.', 2430, 'es', '{}', 'https://cursos.devtalles.com/courses/mas-DevTalles', '2026-09-24 15:49:29.94579+00', '{"Requisitos Previos
Introducción a +DevTalles
Configuración de tu Zona Horaria
¡Únete a Nuestra Comunidad de DevTalles en Discord!","Introducción a +DevTalles","Configuración de tu Zona Horaria","¡Únete a Nuestra Comunidad de DevTalles en Discord!","Marzo 2025
+DevTalles - Q&A marzo 2025","+DevTalles - Q&A marzo 2025","Enero 2025
+DevTalles - Q&A","+DevTalles - Q&A","Diciembre 2024
Clase en vivo: Angular - Zoneless y resources","Clase en vivo: Angular - Zoneless y resources","Noviembre 2024
Clase en vivo: Patrones de diseño","Clase en vivo: Patrones de diseño","Octubre 2024
Clase en vivo: React Native Expo - Uso de recursos nativos y permisos","Clase en vivo: React Native Expo - Uso de recursos nativos y permisos","Septiembre 2024
Clase en vivo: Aplicación de noticias con Expo","Clase en vivo: Aplicación de noticias con Expo","Agosto 2024
Clase en vivo: Iniciando React Native con Expo","Clase en vivo: Iniciando React Native con Expo","Julio 2024
Clase en vivo: Angular SSR","Clase en vivo: Angular SSR","Junio 2024
Clase en vivo: Astro - Framework y características especiales","Clase en vivo: Astro - Framework y características especiales","Mayo 2024
Clase en vivo: Reportería con Node + NestJS","Clase en vivo: Reportería con Node + NestJS","Abril 2024
Clase en vivo: GetX - Funcionalidades","Clase en vivo: GetX - Funcionalidades","Marzo 2024
Clase en vivo: Autenticación y acciones con Auth0","Clase en vivo: Autenticación y acciones con Auth0","Febrero 2024
Clase en vivo: Pros y Cons de los Microservicios","Clase en vivo: Pros y Cons de los Microservicios","Enero 2024
Clase en vivo: Introducción al Testing","Clase en vivo: Introducción al Testing","Noviembre 2023
Clase en vivo: Websockets con NestJS","Clase en vivo: Websockets con NestJS","Octubre 2023
Clase en vivo: NestJS - Introducción al framework","Clase en vivo: NestJS - Introducción al framework","Septiembre 2023
Clase en Vivo: Bun.sh - Desarrollando aplicaciones","Clase en Vivo: Bun.sh - Desarrollando aplicaciones","Agosto 2023
Clase en Vivo - Trabajando Node con TypeScript","Clase en Vivo - Trabajando Node con TypeScript","Julio 2023
Clase en Vivo - Postgres Common Table Expressions","Clase en Vivo - Postgres Common Table Expressions","Junio 2023
Clase en Vivo - Resolución y Q&A de Tarea de Codificación
Tarea de codificación - Cuentas regresivas
Clase en Vivo - Next: Server Components y Server Actions","Clase en Vivo - Resolución y Q&A de Tarea de Codificación","Tarea de codificación - Cuentas regresivas","Clase en Vivo - Next: Server Components y Server Actions","Mayo 2023
Colaboración - Conceptos de Programación Funcional
Clase en Vivo - ¿Cómo iniciarse en el Frontend Development?","Colaboración - Conceptos de Programación Funcional","Clase en Vivo - ¿Cómo iniciarse en el Frontend Development?","Abril 2023
Clase en Vivo - Angular: Señales, Efectos y Señales computadas
Clase en Vivo - Angular: Signals, Standalone y Mapeo","Clase en Vivo - Angular: Señales, Efectos y Señales computadas","Clase en Vivo - Angular: Signals, Standalone y Mapeo","Marzo 2023
Flutter: Trivia de Preguntas
Clase en Vivo - Flutter: BLoC Weather App y Packages","Flutter: Trivia de Preguntas","Clase en Vivo - Flutter: BLoC Weather App y Packages","Febrero 2023
Clase en Vivo - Flutter: Videos verticales estilo TikTok
Clase en Vivo - Flutter: Domain Driven Design - Parte 1
Clase en Vivo - Flutter: Domain Driven Design - Parte 2","Clase en Vivo - Flutter: Videos verticales estilo TikTok","Clase en Vivo - Flutter: Domain Driven Design - Parte 1","Clase en Vivo - Flutter: Domain Driven Design - Parte 2","Enero 2023
Clase en Vivo: Dockerizar aplicaciones de Angular, React y Vue
Reacción a Evento: Flutter Forward - Parte 1
Reacción a Evento: Flutter Forward - Parte 2
Extra: Colaboración - El futuro de la formación 2023","Clase en Vivo: Dockerizar aplicaciones de Angular, React y Vue","Reacción a Evento: Flutter Forward - Parte 1","Reacción a Evento: Flutter Forward - Parte 2","Extra: Colaboración - El futuro de la formación 2023","Diciembre 2022
Clase en Vivo: Cierre de año - Ronda de Preguntas y Respuestas
Clase en Vivo: React Hook Form","Clase en Vivo: Cierre de año - Ronda de Preguntas y Respuestas","Clase en Vivo: React Hook Form","Noviembre 2022
Clase en Vivo: Introducción e importancia a los principios S.O.L.I.D
Clase en Vivo: Git-Github: Trabajo en equipo y resolución de problemas","Clase en Vivo: Introducción e importancia a los principios S.O.L.I.D","Clase en Vivo: Git-Github: Trabajo en equipo y resolución de problemas","Octubre 2022
Clase en Vivo: Angular-React-Vue - Estado global sin dependencias
Clase en Vivo: GraphQL - Base de datos, Entidades y Queries","Clase en Vivo: Angular-React-Vue - Estado global sin dependencias","Clase en Vivo: GraphQL - Base de datos, Entidades y Queries","Septiembre 2022 - Piloto
Clase en Vivo: NestJS - Introducción Rest y GraphQL","Clase en Vivo: NestJS - Introducción Rest y GraphQL"}', '{}', 'Requisitos Previos
- Introducción a +DevTalles
- Configuración de tu Zona Horaria
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Marzo 2025
- +DevTalles - Q&A marzo 2025

Enero 2025
- +DevTalles - Q&A

Diciembre 2024
- Clase en vivo: Angular - Zoneless y resources

Noviembre 2024
- Clase en vivo: Patrones de diseño

Octubre 2024
- Clase en vivo: React Native Expo - Uso de recursos nativos y permisos

Septiembre 2024
- Clase en vivo: Aplicación de noticias con Expo

Agosto 2024
- Clase en vivo: Iniciando React Native con Expo

Julio 2024
- Clase en vivo: Angular SSR

Junio 2024
- Clase en vivo: Astro - Framework y características especiales

Mayo 2024
- Clase en vivo: Reportería con Node + NestJS

Abril 2024
- Clase en vivo: GetX - Funcionalidades

Marzo 2024
- Clase en vivo: Autenticación y acciones con Auth0

Febrero 2024
- Clase en vivo: Pros y Cons de los Microservicios

Enero 2024
- Clase en vivo: Introducción al Testing

Noviembre 2023
- Clase en vivo: Websockets con NestJS

Octubre 2023
- Clase en vivo: NestJS - Introducción al framework

Septiembre 2023
- Clase en Vivo: Bun.sh - Desarrollando aplicaciones

Agosto 2023
- Clase en Vivo - Trabajando Node con TypeScript

Julio 2023
- Clase en Vivo - Postgres Common Table Expressions

Junio 2023
- Clase en Vivo - Resolución y Q&A de Tarea de Codificación
- Tarea de codificación - Cuentas regresivas
- Clase en Vivo - Next: Server Components y Server Actions

Mayo 2023
- Colaboración - Conceptos de Programación Funcional
- Clase en Vivo - ¿Cómo iniciarse en el Frontend Development?

Abril 2023
- Clase en Vivo - Angular: Señales, Efectos y Señales computadas
- Clase en Vivo - Angular: Signals, Standalone y Mapeo

Marzo 2023
- Flutter: Trivia de Preguntas
- Clase en Vivo - Flutter: BLoC Weather App y Packages

Febrero 2023
- Clase en Vivo - Flutter: Videos verticales estilo TikTok
- Clase en Vivo - Flutter: Domain Driven Design - Parte 1
- Clase en Vivo - Flutter: Domain Driven Design - Parte 2

Enero 2023
- Clase en Vivo: Dockerizar aplicaciones de Angular, React y Vue
- Reacción a Evento: Flutter Forward - Parte 1
- Reacción a Evento: Flutter Forward - Parte 2
- Extra: Colaboración - El futuro de la formación 2023

Diciembre 2022
- Clase en Vivo: Cierre de año - Ronda de Preguntas y Respuestas
- Clase en Vivo: React Hook Form

Noviembre 2022
- Clase en Vivo: Introducción e importancia a los principios S.O.L.I.D
- Clase en Vivo: Git-Github: Trabajo en equipo y resolución de problemas

Octubre 2022
- Clase en Vivo: Angular-React-Vue - Estado global sin dependencias
- Clase en Vivo: GraphQL - Base de datos, Entidades y Queries

Septiembre 2022 - Piloto
- Clase en Vivo: NestJS - Introducción Rest y GraphQL', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (121, 'nextpagesrouter', 'Next.js: El framework de React - Fernando Herrera', 'https://cursos.devtalles.com/courses/nextpagesrouter', 'https://import.cdn.thinkific.com/643563/1dZj9X1AQU2Ezz1yZF25_COVER-DEVTALLES.jpg', 'Portada del curso: Next.js: El framework de React - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso tiene por objetivo enseñarte Next.js de forma completa con muchas tareas y ejercicios. Al final del curso no solo aprenderás Next.js, si no que también habrás desarrollado una tienda electrónica con cobros, mantenimientos, carga, optimizaciones para SEO, desplegarla y tenerla en tu portafolio de proyectos.', 2760, 'es', '{}', 'https://cursos.devtalles.com/courses/nextpagesrouter', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción
- ¿Cómo funcionará el curso?
- Instalaciones recomendadas
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Introducción a Next.js
- Introducción a la sección
- Temas puntuales de la sección
- Exposición introductoria a Next.js
- Recomendaciones antes de empezar este curso
- Nota Importante
- Creando mi primer proyecto en Next.js
- Mi primera página
- Estructura de directorios en un proyecto
- Next/Head
- Tip: Static Generation vs Server-side Rendering
- Nota de actualización - Link Next 13+
- Next/Link
- Componentes personalizados
- Barra de navegación personalizada
- Custom ActiveLink
- Layouts
- Resolución de tarea sobre Layouts
- Multiples Layouts anidados
- Tarea - Resumen de la sección
- Resumen de la sección
- Código fuente de la sección

Sección 3: TypeScript - Despliegues y Docker
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - Demo Inicial
- Migrar proyecto de JavaScript a TypeScript
- Archivos de JavaScript a TypeScript
- Migrando _app.jsx a _app.tsx
- Desplegando nuestra aplicación
- Desplegando en Vercel
- Generando imagen de Docker
- Levantar la imagen de Docker
- Código fuente de la sección

Sección 4: Static Generated App - Pokemon Static
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de sección - PokemonStatic
- Eliminando todo lo innecesario de mi proyecto
- NextUI - React UI Library
- Next.js _document
- Implementando el tema Dark
- Layout principal
- Creando una barra de navegación
- Next - GetStaticProps
- Cargar de forma estática los Pokemons
- Colocar el tipo de respuesta de Axios
- Tarea - Mostrar nombre y número del pokémon
- Mostrar tarjetas de Pokémons
- Componente para las tarjetas
- Recibir argumentos por URL y navegación
- Next - getStaticPaths
- Generando las 151 páginas de Pokémons
- Diseño de la página de Pokémon
- Tarea - Navegación y página de favoritos
- Resumen de la sección
- Código fuente de la sección

Sección 5: Pokemon Static - Continuación
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Guardar en LocalStorage
- Grabar en localStorage un arreglo de Pokémons
- Leer y verificar si existe en favoritos
- Pantalla de Favoritos
- Construir el listado de Pokémons favoritos
- Tarea - Mejorar la lectura de nuestra página
- Librerías externas - Canvas-Confetti
- Tarea - Pokémon por nombre
- Resolución de la Tarea - Pokémon por nombre
- Optimizar la data necesaria del pokémon
- Centralizar la lectura de la data del pokémon
- Open Graph Meta Tags
- Desplegando en Vercel
- Actualizando sitio web en Vercel
- Código fuente de la sección

Sección 6: Incremental Static Regeneration (ISR) e Incremental Static Generation (ISG)
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Incremental Static Regeneration (ISR)
- Incremental Static Generation (ISG)
- Tarea - ISG por nombre de Pokémon
- Código fuente de la sección

Sección 7: OpenJira - Ejercicio con MaterialUI
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del resultado final
- Inicio de proyecto - OpenJira
- Instalación de Material-UI
- Creando temas en Material-UI
- Layout y Navbar
- Resolución de la tarea
- Implementar un Sidebar
- UI Context
- Context Provider
- Pulir nuestro snippet
- uiReducer + Snippet
- Pulir el snippet del reducer
- Usar el UI Context en nuestra aplicación
- Resolución de la tarea - Sidebar
- Código fuente de la sección

Sección 8: OpenJira - Manejo de entradas
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - OpenJira
- Diseño de la pantalla principal - index.tsx
- EntriesContext - Contexto de las entradas
- Interface Entry
- EntryList y EntryCard - Componentes para mostrar entradas
- Mostrar tarjetas basado en el estado de la entrada
- Agregar entradas
- Trabajar con nuestro formulario y estado
- Insertar entrada en el estado global
- Tarea - isAdding
- Habilitar Drag and Drop - Manualmente
- Cambiar aspecto visual cuando hacemos drag
- Cambiar el estado del Entry
- Cierre de la sección
- Código fuente de la sección

Sección 9: OpenJira - Next.js API
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Docker-compose - Crear imagen de base de datos
- Next.js - Restful API
- Conectarnos a MongoDB con Mongoose
- Variables de entorno en Next.js
- Conectarnos a MongoDB desde el Restful API
- Creando un esquema de Mongoose
- Llenando la base de datos
- Endpoint - Obtener todas las entradas
- Leer las entradas desde el Backend
- Crear una nueva entrada - Backend
- Crear entrada desde el Frontend
- Actualizar una entrada en particular - Backend
- Terminar nuestro endpoint de actualización
- Actualizar entrada desde el Frontend
- Obtener entrada por ID
- Middlewares - Breaking changes
- Next.js Middleware
- Middleware - Verificar que sea un MongoID
- Nota de actualización
- ARCHIVADO - Next.js _Middlewares
- ARCHIVADO - Middleware - Verifica el ID de Mongo
- ARCHIVADO - Middleware a sólo para ciertas rutas
- Cierre de la sección

Sección 10: Server Side Props - Fin de OpenJira
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección - FinOpenJira
- Pantalla para editar una entrada
- Pantalla de editar y agregar - Segunda Parte
- Manejo del formulario
- Validaciones del formulario
- SSR - getServerSideProps
- Navegar y cargar la entrada mediante SSR
- Cargar información de la entrada
- Guardar información de la entrada
- Calcular tiempo desde la publicación
- Código fuente de la sección

Sección 11: Cookies - CookieMaster App
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Cookie Master
- Instalación de MaterialUI
- Layout y Páginas adicionales
- Página para cambiar el tema
- LocalStorage vs Cookies
- Leer las cookies
- Leer cookies desde el Restful API
- Cambiar el tema basado en la cookie
- Generar la página con el tema solicitado
- Establecer el theme usando la cookie - Frontend
- Código fuente de la sección

Sección 12: Teslo-shop - Tienda en Next.js
- Inicio de sección
- Temas puntuales de la sección
- Demostración de la sección
- Inicio de proyecto - TesloShop
- Nota informativa
- Instalación y configuración de Material UI
- Nota de actualización - Next13 Link
- Estructura de directorios y ShopLayout
- Navbar
- Página 404 personalizada
- Home Page - Temporal
- SideMenu - Menú lateral
- Componente para mostrar productos
- Terminar el Product Card
- Pantalla de producto
- Slideshow de las imágenes
- Contador para agregar al carrito
- Selector de tallas
- Página de carrito de compras vacío
- Página de carrito de compras
- Mostrar productos del carrito de compras
- Resumen de la Orden
- Formulario de dirección
- Resumen de la orden
- Página de pago
- Historial de ordenes
- AuthLayout
- Página de registro
- Código fuente de la sección

Sección 13: Teslo Store - Database y RestFul
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto - Teslo Store
- Preparar la base de datos local
- Mongoose y Modelo de Producto
- Llenar base de datos y Conexión a Mongo
- REST - Obtener todos los productos
- REST - Aplicar filtros a la consulta
- REST - Obtener producto por Slug
- REST - Búsqueda de productos
- Cierre de la sección
- Código fuente de la sección

Sección 14: SWR - React Hooks for Data Fetching
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección -TesloShop
- SWR - React Hooks for Data Fetching
- Custom Hooks y configuración Global SWR
- Mostrar una pantalla de carga
- Mostrar textos cuando la imagen está cargada
- Pantalla de productos de hombres, mujeres y niños
- Mostrar en el menú la página activa
- UI Context
- Tarea - Mostrar y navegar
- Pantalla de un producto
- getServerSideProps - Producto
- Resolver el inconveniente de llaves duplicadas
- GetStaticPaths y GetStaticProps
- Resolución de la tarea - GetStaticPaths y GetStaticProps
- Página de búsquedas
- Realizar la búsqueda mediante SSR
- Mejorar la experiencia de usuario en la búsqueda
- Solución a la tarea
- Mostrar y ocultar texto de búsqueda (Desktop)
- Código fuente de la sección

Sección 15: Carrito de compras
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Cart Context e interfaces
- Producto no disponible
- Validar que seleccione una talla
- Contador de productos
- Resolución de la tarea
- Tarea - Agregar al carrito
- Soluciones a la tarea
- Solución final
- Almacenar el carrito en cookies
- Mostrar productos del carrito de compras
- Actualizar cantidad desde el carrito
- Remover productos del carrito de compras
- Calcular montos a pagar
- Colocar montos en pantalla
- Código fuente de la sección

Sección 16: Autenticación personalizada mediante JWT - Json Web Token
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Modelo de Usuario
- Insertar usuarios de prueba
- REST - Login
- Crear JWT - JsonWebToken
- REST - Registro de un usuario
- Validar correo electrónico
- Validar y renovar JWT
- Formulario de Login - React Hook Form
- Validaciones del formulario
- Realizar validación contra el backend
- Mostrar mensaje de error en pantalla
- Pantalla de registro
- AuthContext
- Disparar acciones de Login
- Disparar acciones de Registro
- Recuperar el estado de autenticación del usuario
- Código fuente de la sección

Sección 17: Estilos condicionales Admin - Cliente
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de proyecto
- Estilo condicional en el menú lateral
- Logout y redirección a la última página vista
- Mantener el query parameter después de crear un usuario
- Mostrar página de carrito vacío
- Verificar autenticación Server Side
- Middleware de autenticación
- Datos de la dirección
- Resolución de la tarea - Dirección
- Recargar la dirección de la persona
- Actualizar dirección del contexto
- Mostrar la dirección en pantalla
- Código fuente de la sección

Sección 18: Next Auth
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Instalación de NextAuth
- Configuración de NextAuth + GitHub
- Obtener información de la session
- Proveedor - Credenciales
- NextAuth Callbacks
- Verificar correo y contraseña - Credentials
- NextAuth - Signout
- Crear usuario basado en OAuth
- NextAuth - Login Personalizado
- Especificar la duración de la sesión
- Proveedores en nuestro login
- Next 13 - Middleware con Next Auth
- Asegurarnos que tenemos una dirección
- Código fuente de la sección
- Archivado - NextJs Middlewares con Next Auth

Sección 19: Manejo y creación de órdenes
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Modelo e Interfaz de Órdenes
- Order Model
- Rest - Crear una orden
- Crear una nueva orden - Body
- Nota de actualización
- Crear orden - Backend
- Crear orden - Backend Parte 2
- Breve resumen del proceso anterior
- Prevenir doble posteo y detalles finales del resumen
- Orden incorrecta y limpiar estado
- Obtener una orden por ID
- Mostrar orden en pantalla
- Solución de la tarea - Valores de la orden
- Historial de ordenes
- Solución de la tarea
- Código fuente de la sección

Sección 20: Pagos con PayPal y tarjeta de crédito
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de sección
- Modificaciones adicionales en la orden
- Paypal developer dashboard
- Botones de Paypal
- Verificar pago desde el Backend
- Paypal OAuth Token
- Confirmar orden pagada mediante PayPal
- Actualizar la pantalla de pagos
- Mejorar la experiencia del usuario
- Código fuente de la sección

Sección 21: Panel de administración
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la aplicación
- Admin Dashboard
- Página principal del Dashboard Administrativo
- Tarea - Rest API - Información estadística
- Resolución de la tarea
- Mostrar estadísticas en el dashboard
- Middlewares para validar autenticación
- REST - Mantenimiento de usuarios
- Mostrar listado con todos los usuarios
- Cambiar el rol del usuario
- Mostrar cambio en tiempo real
- REST - Obtener todas las ordenes
- Mostrar todas las órdenes
- Ver detalle de la orden
- Corregir la interfaz
- Código fuente de la sección

Sección 22: Mantenimiento de productos
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- REST - GetProductos
- Listado de productos
- Diseño de página de producto administrativo
- Conectar los campos con React Hook Form
- Llenar radio buttons
- Trabajar los check de tallas
- Sugerir un SLUG automático
- Manejo de las etiquetas de producto
- REST - Actualizar Producto
- Actualizar Producto
- REST - Crear Producto
- Crear Producto
- Preparar selección de archivos
- REST - Subir archivo
- NO HACER - Almacenar imágenes el file system
- Preparar claves de Cloudinary
- Subir imagen a Cloudinary
- Actualizar imagen del producto
- Mostrar imágenes de FileSystem y Cloudinary
- Revisar los lugares donde tenemos nuestras imágenes
- Código fuente de la sección

Sección 23: Desplegar Teslo Shop en producción
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Continuación de la sección
- Preparar base de datos
- Desplegar aplicación en Heroku
- Desplegar en Heroku - Parte 2
- Arreglar redirecciones de autenticación

Sección 24: Cierre del curso
- Nota de actualización: Next.JS 13
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (122, 'node-cero-experto', 'Node: De cero a experto - Fernando Herrera', 'https://cursos.devtalles.com/courses/node-cero-experto', 'https://import.cdn.thinkific.com/643563/Yq9AJoWsRBaj5mUMRJtJ_LEGACY-NODE.jpg', 'Portada del curso: Node: De cero a experto - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Este curso te enseñará Node de manera práctica, aprendiendo mediante ejercicios y tareas, aplicaciones reales y diferentes formas de programar en Node. Al terminarlo, podrás agregarlo con seguridad a tu currículo y desenvolverte con confianza en Node.', 1740, 'es', '{}', 'https://cursos.devtalles.com/courses/node-cero-experto', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Introducción
- Curso Legacy
- Introducción
- ¿Cómo funciona el curso?
- Instalaciones necesarias
- Importante: Cursos Legacy
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos de Node
- Introducción a la sección
- Temas puntuales de la sección
- Preguntas comunes sobre Node
- Blocking vs Non Blocking I/O
- Hola Mundo en Node
- Ciclo de eventos de Node - Ejemplos
- Ciclo de vida de un proceso en Node
- Nodemon
- Código fuente de la sección

Sección 3: Reforzamiento de los temas necesarios para seguir el curso
- Introducción a la sección
- Temas puntuales de la sección
- Const vs Let vs Var
- Templates literales
- Destructuración de objetos
- Funciones de Flecha
- Callbacks
- Problemas comunes con los callbacks
- Callback Hell
- Promesas
- Promesas en cadena
- Async - Await
- Código fuente de la sección

Sección 4: Bases de node
- Introducción a la sección
- Temas puntuales de la sección
- Inicio del proyecto - Sección 4
- Requerir paquetes - require
- Importar archivos de nuestro proyecto
- Recibir información desde línea de comando
- package.json - init - install - uninstall
- Yargs
- Configuraciones de Yargs
- Configuración de Yargs independiente
- Colores de la consola
- Tarea - Tabla hasta X
- Git - Preparar repositorio
- Respaldo del proyecto con en GitHub
- Código fuente de la sección

Sección 5: Aplicación de consola interactiva - Tareas por hacer
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - Tareas por hacer
- stdin - stdout - Readline
- Repetir el menú de forma infinita
- Nota para la siguiente clase
- Construir el menú interactivo - Inquirer
- Opciones del menú interactivo
- Lógica para el manejo de las tareas por hacer
- Crear y listar tareas
- Transformar objeto a un arreglo - Detalles estéticos
- Guardar tareas en un archivo de texto
- Leer nuestra base de datos
- Tarea - Cargar tareas
- Listar tareas
- Tareas completadas y pendientes - opciones del menú
- Listado para borrar
- Confirmar y borrar tarea
- Múltiples selecciones
- Marcar como completadas o pendientes las tareas
- Código fuente de la sección

Sección 6: Aplicación de Clima - GeoLocation + OpenWeatherMaps
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de proyecto - ClimaApp
- Menú de la aplicación
- Modelo para controlar la aplicación
- Enlaces para la siguiente clase
- Realizar peticiones HTTP desde Node
- Mapbox Search API y Token de acceso
- Crear instancias de Axios
- Variables de entorno
- Listar los países de forma interactiva
- OpenWeather - Información del clima
- Obtener información del clima del lugar seleccionado
- Resolución de la tarea del clima
- Persistencia en las búsquedas
- Leer del archivo JSON
- Resolución de la tarea - Leer archivo y capitalizar
- Código fuente de la sección

Sección 7: Webserver - HTTP - EXPRESS - HBS
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - WebServer
- Request y Response
- Introducción a EXPRESS
- Servir contenido estático
- Servir un sitio web completo
- Handlebars
- Argumentos desde el controlador
- Usando parciales con HBS
- Preparar Webserver para subirlo a un hosting
- Desplegar Aplicación en Railway.app
- Desplegando aplicaciones de Angular y React
- Desplegar nuevos cambios en Railway
- Consideraciones con Railway
- Código fuente de la sección
- Nota de actualización
- Archivado - Heroku - Subiendo nuestra aplicación a producción
- Archivado - Subir los cambios a Heroku

Sección 8: REST Server - Configuraciones iniciales
- Introducción a la sección
- Iniciando el proyecto - RESTServer
- Express basado en clases
- Peticiones HTTP - GET - PUT - POST - DELETE
- Códigos de respuestas HTTP
- Usando códigos de respuesta HTTP en Express
- CORS - Middleware
- Separar las rutas y el controlador de la clase
- Obtener datos de un POST
- Parámetros de segmento y query
- Respaldo del RESTServer a GitHub
- Subir el RESTServer a Railway
- Pro Tip: Ambiente de producción y desarrollo en Postman
- Código fuente de la sección
- Nota de actualización
- Archivado - Subir el RESTServer a Heroku

Sección 9: Alcances del RESTServer y mantenimiento de la colección de usuarios
- Introducción a la sección
- Temas puntuales de la sección
- Alcances del proyecto - RESTServer
- Configuración de MongoDB - MongoAtlas
- MongoDB Compass - Prueba de conexión
- Mongoose - Conectarnos a la base de datos
- Modelo de Usuario
- POST: Creando un usuario en la colección
- BcryptJS - Encriptando la contraseña
- Validar campos obligatorios - Email
- Validar todos los campos necesarios
- Validar rol contra base de datos
- Centralizar la validación del rol
- Tarea - Custom validation - EmailExiste
- PUT: Actualizar información del usuario
- Validaciones adicionales en el PUT
- GET: Obtener todos los usuarios de forma paginada
- Retornar número total de registros en una colección
- Delete: Borrando un usuario de la base de datos
- Desplegar RESTServer en Railway
- Variables de entorno personalizadas Heroku
- Código fuente de la sección
- Archivado - Desplegar RESTServer en Heroku

Sección 10: Autenticación de usuario - JWT
- Introducción a la sección
- Temas puntuales de la sección
- Introducción a los Tokens
- Código para leer el payload y fecha de expiración de un Token - NO USAR
- Información importante sobre los JWT
- Crear ruta autenticación - Auth - Login
- Login de usuario
- Generar un JWT
- Cambiar visualmente _id por uid en Mongoose
- Proteger rutas mediante uso de Token - Middlewares
- Obtener la información del usuario autenticado
- Middleware: Verificar Rol de administrador
- Middleware: Tiene rol
- Optimizar importaciones en Node
- Nuevo despliegue a Railway
- Código fuente de la sección
- Archivado - Desplegar en Heroku

Sección 11: Google Sign In - Front y BackEnd
- Introducción a la sección
- Temas puntuales de la sección
- Link para comenzar la integración con Google Sign-in
- Generar API Key y API Secret de Google
- Usuario de Google - Frontend
- Ruta para manejar autenticación de Google
- Validar Token de Google - Backend
- Crear un usuario personalizado con las credenciales de Google
- Logout - Google Identity
- Nuevo despliegue a Railway
- Pro Tip: Generar la documentación automática de nuestros servicios
- Código fuente de la sección
- Archivado - Publicar a Heroku - Google SignIn

Sección 12: Categorías y Productos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto - Rest Server
- CRUD y rutas de Categorías
- Modelo Categoria
- Crear una categoria
- Tarea - CRUD de Categorías
- Resolución de la tarea - Crud categorías
- Resolución de la tarea - Crud categorías - Parte 2
- Modelo de producto y rutas
- Resolución de la tarea - CRUD y Rutas de Productos
- Ruta para realizar búsquedas
- Búsquedas en base de datos
- Buscar por otros argumentos
- Buscar en otras colecciones
- Nuevo despliegue a Railway
- Código fuente de la sección
- Archivado - Desplegar en Heroku

Sección 13: Carga de Archivos y protección de los mismos
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto - RestServer
- Subir archivos
- Validar la extensión
- Ubicar y cambiar nombre
- Helper - SubirArchivo
- Crear carpetas de destino
- Ruta para actualizar imágenes de Usuarios y Productos
- Actualizar imagen de usuario
- Resolución de la tarea - Desestructurar de undefined
- Borrar archivos del servidor
- Servicio para mostrar las imágenes
- Mostrar imagen de relleno
- Cloudinary - Servicio para imágenes y videos
- Carga de imágenes a Cloudinary
- Borrar imágenes de Cloudinary
- Nuevo despliegue a Railway
- Código fuente de la sección
- Archivado - Desplegar en Heroku

Sección 14: Sockets - Fundamentos de los sockets
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué son los sockets y para qué nos pueden servir?
- Inicio del proyecto - Fundamentos sobre Web Sockets
- Instalación de socket.io
- Configuración de socket.io - Front-End
- Mensajes de conexión y desconexión - Cliente
- Emitir desde el cliente - Escuchar en el servidor
- Emitir desde el servidor - Escuchar en el cliente
- Retroalimentación de emisiones del cliente hacia el servidor
- Broadcast - Ordenar nuestro código
- Tarea - Nueva App en Railway
- Código fuente de la sección
- Archivado - Sockets a Heroku

Sección 15: Sockets - Aplicación de Cola
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Aplicación de Colas
- Clase para centralizar la lógica de los tickets
- Modelo - Siguiente y atender nuevo ticket
- Socket: Siguiente Ticket
- Preparar pantalla de escritorio
- Socket: Atender un ticket
- Mostrar cola de tickets en pantalla
- Tarea - Tickets pendientes por atender
- Reproducir audio cuando se asigna un ticket
- Código fuente de la sección

Sección 16: Sockets con autenticación
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - SocketChat
- Configurar Socket.io
- Diseño del login y su funcionamiento
- Validar el JWT - Servicio
- Validar Token - Frontend
- Validar socket con JWT - Backend
- HTML y JS que usaremos
- Modelo para el manejo de usuarios conectados y mensajes
- Listado de usuarios conectados
- Mostar en el HTML los usuarios conectados
- Envío de mensajes a toda la sala de chat
- Historial de mensajes en el HTML
- Mensajes privados
- Código fuente de la sección

Sección 17: Bonus: Node + TypeScript + MySQL
- Temas puntuales de la sección
- Inicio de proyecto - ts-rest-server
- Crear el servidor de express y sus middlewares
- Nodemon y TSC --watch
- Rutas de mi aplicación
- Middlewares necesarios
- MySQL - Instalaciones y conexión
- Tabla de Usuarios
- Sequelize
- Modelo de Usuario
- Obtener Usuarios
- Crear y actualizar usuarios
- Eliminar registros
- Código fuente de la sección

Sección 18: Despedida del curso
- Más información sobre nuestros otros cursos
- Cierre del curso

Sección 19: Socket Chat
- Temas puntuales de la sección
- Inicio del proyecto - Socket Chat
- Clase para controlar los usuarios del chat
- Front-End: Conectar un usuario
- Desconectar usuarios
- Enviando un mensaje a todo el grupo
- Enviar un mensaje a un usuario en específico
- Salas de Chat
- Mensajes y notificaciones a las salas de chat
- Respaldo a GitHub de nuestra aplicación de Chat
- Diseño de nuestra sala de chat
- Renderizar usuarios
- Obtener el ID del usuario conectado
- Enviar y renderizar mensajes
- Mejorar la forma de renderizar mensajes
- Propuestas para ejercicios del chat
- Subir cambios a GitHub - SocketChat
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (123, 'patrones-diseno-agentico', 'Patrones de diseño agéntico: Respuestas efectivas a desafíos', 'https://cursos.devtalles.com/courses/patrones-diseno-agentico', 'https://import.cdn.thinkific.com/643563/mDz0zDr2Q6k0W6NNK5qY_COVER-DEVTALLES-PATRONES-AGENTICOS.jpg', 'Portada del curso: Patrones de diseño agéntico: Respuestas efectivas a desafíos', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Aprende a construir agentes de IA en TypeScript aplicando los patrones que usa la industria —ReAct, Planning, Reflection, multi-agente, guardrails — construyéndolos a mano y midiendo en cada paso su coste real en tokens, latencia y dólares.', 540, 'es', '{}', 'https://cursos.devtalles.com/courses/patrones-diseno-agentico', '2026-09-24 15:49:29.94579+00', '{"Saber programar y manejarte con async/await.","Node.js instalado y tu editor favorito.","No necesitas experiencia previa con agentes ni con IA."}', '{}', 'Sección 1: Introducción
- Introducción
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas

Sección 2: Patrones de diseño agénticos
- Introducción
- ¿Qué son patrones de diseño agénticos?

Sección 3: Preparación de proyecto
- Introducción
- Temas puntuales
- Proyecto - Agentic Design Patterns
- Archivos y directorios del proyecto
- Proveedor: Groq
- Proveedor: Anthropic
- Proveedor: OpenAI
- Proveedor: Google
- Proveedor: Ollama

Seccíon 4: Patrón - Tool use
- Introducción
- Temas puntuales
- Problema que enfrenta el modelo
- Crear herramienta - findCourses
- Uso de herramientas personalizadas
- Crear herramienta - calculateTotal
- Código fuente
- Repaso interactivo: Tool use

Sección 5: Patrón: Planning - Planeación
- Introducción
- Temas puntuales
- Código inicial
- One shot prompt - Esperando lo mejor
- Construcción del plan
- Ejecutar paso por paso
- Sintetizar pasos anteriores
- Comparativa de resultados
- Código fuente
- Repaso interactivo: Planning - Planeación

Sección 6: Patrón: Reflection - Reflexión
- Introducción
- Temas puntuales
- Preparación de ejercicio
- Sin reflexión
- Reflexión ingenua
- Reflexión con rúbrica
- Utilizar la crítica para mejorar el resultado
- Evaluaciones y critica mejorada
- Código fuente
- Repaso interactivo: Reflection - Reflexión

Sección 7: Patrón de diseño: ReAct
- Introducción
- Temas puntuales
- Preparación de ejercicio
- Respuestas sin reAct
- Respuesta con reAct
- Tarea - Problema de ReAct
- Solución a la tarea
- Código fuente
- Repaso interactivo: Patrón de diseño - ReAct

Sección 8: Patrón: Encadenamiento de prompts - Prompt Chaining
- Introducción
- Temas puntuales
- Preparación de ejercicio
- One shot prompt - Sin cadenas
- Prompt Chaining - Con puertas (Gates)
- Ejecución, comparación y degradación de resultados
- Prompt Chaining sin límite
- Prompt Chaining con modelo fuerte
- Código fuente
- Repaso interactivo: Encadenamiento de prompts - Prompt Chaining

Sección 9: Patrón: Planificar y ejecutar - Plan and Execute
- Introducción
- Temas puntuales
- Preparación de ejercicio
- Patrón ReAct simplificado
- Planificar y ejecutar - Planificar primero
- Ejecutar plan
- No usar - Plan y Ejecutar
- Código fuente
- Repaso interactivo: Planificar y ejecutar - Plan and Execute

Sección 10: Patrón: Code Act
- Introducción
- Temas puntuales
- Preparación del ejercicio
- Explicación del código
- Tarea imposible - Tool Use
- CodeAct - Tool de código
- Ejecutar código del AI
- Código fuente
- Repaso interactivo: Code Act

Sección 11: Patrón: Enrutamiento - Router & Specialist
- Introducción
- Temas puntuales
- Preparación del ejercicio
- Tarea - Agente "Todólogo"
- Solución a la tarea - "Todólogo"
- Crear enrutador
- Crear especialistas
- Código fuente
- Repaso interactivo: Enrutamiento - Router & Specialist

Sección 12: Patrón: Orquestador y trabajadores
- Introducción
- Temas puntuales
- Preparación de ejercicio
- Creación de trabajadores
- Implementar patrón router
- Herramienta de delegación
- Configurar orquestador
- Código fuente
- Repaso interactivo: Orquestador y trabajadores

Sección 13: Patrón: Paralelización - Parallelization
- Introducción
- Temas puntuales
- Preparación de ejercicio
- Implementar un agente único
- Implementar la planeación
- Workers e integración
- Detonar agentes en paralelo
- Código fuente

Sección 14: Patrón: Humano en el ciclo - Human in the loop
- Introducción
- Temas puntuales
- Preparación de ejercicio
- Explicación del código
- Función de revisión de solicitud
- Implementar - Human in the loop
- Implementar la decisión humana
- Código fuente

Sección 15: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (23, 'fastapi', 'FastAPI: Crea APIs eficientes con Python', 'https://cursos.devtalles.com/courses/fastapi', 'https://import.cdn.thinkific.com/643563/7yccvWpWRC669uDvMnqd_FASTAPICOVER-DEVTALLES.jpg', 'Portada del curso: FastAPI: Crea APIs eficientes con Python', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende a crear APIss modernas, seguras y rápidas con Python, Pydantic, JWT, WebSockets, Webhooks Bases de datos, subida de archivos, tests, despliegue, tareas asíncronas, seguridad, proyectos reales y mucho más.', 2160, 'es', '{"Fundamentos y Tipado: Introducción a FastAPI, tipado estricto y validaciones robustas con Pydantic.","Validación Avanzada: Control estricto de parámetros de ruta (Path) y parámetros de consulta (Query params).","Persistencia de Datos: Conexión y manipulación de bases de datos relacionales con SQLAlchemy y SQLModel.","Migraciones de Datos: Gestión del ciclo de vida de la base de datos con Alembic y persistencia real en PostgreSQL.","Arquitectura Profesional: Modularización del código, routers y el poderoso sistema de Inyección de Dependencias de FastAPI.","Seguridad y Control: Implementación de autenticación segura mediante tokens JWT y desarrollo de Middlewares personalizados.","Rendimiento: Manejo y optimización de funciones síncronas y asíncronas (async/await).","Despliegue (Deploy): Configuración y puesta en producción de tu API final en Render.","¡Y cuestionarios teóricos al final de cada sección para consolidar lo aprendido!","Enfrentar con solvencia proyectos backend del mundo real utilizando Python.","Postular con confianza a ofertas de empleo que requieran el dominio de FastAPI en su stack técnico.","Diseñar, estructurar y desplegar de forma autónoma tus propios MVPs, sistemas de e-commerce o plataformas distribuidas."}', 'https://cursos.devtalles.com/courses/fastapi', '2026-09-24 15:49:29.94579+00', '{"Python básico","SQL Básico","Control de versiones con Git"}', '{}', 'Sección 1: Introducción al curso
- Introducción
- Prerequisitos del curso
- ¿Cómo aprovechar el curso al máximo?
- Temas y contenido del curso
- ¿Cómo hacer preguntas?
- Charla casual antes del curso
- Instalaciones recomendadas
- Instalar Python en Windows
- Instalar Python en MacOS
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Fundamentos de Python
- Introducción a la sección
- Temas puntuales de la sección
- Variables
- Tipos de datos
- Condicionales
- Operadores lógicos
- Listas
- Diccionarios
- Tuplas
- Sets
- Ciclo For
- Ciclo While
- Funciones
- Args y Kwargs
- Funciones de orden superior (HOF)
- Decoradores
- Clases y objetos
- Atributos y métodos
- Classmethods y staticmethods
- Programación Orientada a Objetos parte 1
- Programación Orientada a Objetos parte 2
- Programación Orientada a Objetos parte 3
- Manejo de errores
- Módulos y paquetes
- Librerías
- Manejo de archivos
- Código fuente de la sección

Sección 3: Introducción a FastAPI y primeros pasos
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es FastAPI y por qué aprenderlo?
- Documentación y enlaces importantes
- Instalar FastAPI
- Nuestro primer endpoint (GET)
- Get con datos
- Query params
- Path parameters
- Ejercicio práctico - Query Params
- Métodos HTTP y códigos de estatus
- Método POST
- Probando endpoints con CURL y POSTMAN
- Método PUT y HttpException
- Método DELETE
- Documentación automática
- Código fuente de la sección
- Quiz 1: Cuestionario sobre la sección

Sección 4: Tipado, validaciones y Pydantic
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Pydantic y por qué lo usa FastAPI?
- Creando modelos básicos con Pydantic
- Probando modelos base creados
- Validaciones automáticas con Pydantic
- Campos opcionales y valores por defecto
- Field y validaciones avanzadas
- Validaciones personalizadas
- Modelo de respuesta (parte 1)
- Modelo de respuesta (parte 2)
- Solución al ejercicio modelo de respuesta
- Métodos anidados
- Solución al ejercicio métodos anidados
- Código fuente de la sección
- Cuestionario - Sección 4

Sección 5: Validación de parámetros y queries
- Introducción a la sección
- Temas puntuales de la sección
- Correcciones y mejoras de nuestro código
- Repaso PathParams y QueryParams
- Validaciones de Path parameters
- Validaciones de Query parameters
- Paginación y orden con QueryParams (parte 1)
- Paginación y orden con QueryParams (parte 2)
- Endpoint con metadatos
- Ejercicio práctico - Endpoint con metadatos
- Solución al ejercicio práctico (parte 1)
- Solución al ejercicio práctico (parte 2)
- Multiples valores en QueryParams con Listas
- QueryParam deprecated
- Código fuente de la sección
- Quiz 3: Cuestionario - Sección 5

Sección 6: Bases de datos relacionales con FastAPI (SQLAlchemy)
- Introducción a la sección
- Temas puntuales de la sección
- Bases de datos relacionales con FastAPI
- Configurando proyecto para conectar base de datos
- Modelo declarativo y conexión a la base de datos
- Modelo Post
- Crear un Post con base de datos
- Crear un Post - Pruebas
- Listar posts con base de datos
- Listar posts - Pruebas
- Obtener un post con base de datos
- Ejercicio práctico - PUT y DELETE
- Editar un Post con base de datos
- Eliminar un Post con base de datos
- Manejo de errores
- Relación uno a muchos (author)
- Relación muchos a muchos (tags)
- Validación con ModelConfig
- Crear un post con author y tags
- Agregando datos a la tabla intermedia
- Filtrar por tags
- Instalar PostgreSQL
- Conectar FastAPI con PostgreSQL
- Código fuente de la sección
- Cuestionario - Sección 6

Sección 7: Arquitectura y modularización del proyecto
- Introducción a la sección
- Temas puntuales de la sección
- Estructura de archivos
- Arquitectura de capas
- Archivo para base de datos
- Archivos para modelos
- Archivo para validaciones (Schemas - DTO)
- PostRepository - Obtener post por ID
- PostRepository - Búsquedas (Search)
- Ejercicio - PostRepository - Lista de tags
- PostRepository - Ensure author y tags
- PostRepository - Crear post
- Ejercicio práctico - Post Repository put y delete
- Router - Listar posts
- Router - Tags y obtener por post ID
- Router - Crear posts
- Ejercicio práctico - Router - Actualizar y eliminar post
- Montar router en main.py
- Probando endpoints con arquitectura de capas
- Código fuente de la sección
- Cuestionario - Sección 7

Sección 8: Dependencias, seguridad y JWT
- Introducción a la sección
- Temas puntuales de la sección
- Dependencias
- Introducción a la seguridad en APIs
- Oauth2passwordBearer
- Crear token JWT
- Decodificar token JWT
- Auth Schemas
- Auth Router
- Montar y probar Auth
- Protegiendo rutas
- Cambiando implementación de Author
- Control de errores
- Checkpoint del curso
- Código fuente de la sección
- Cuestionario - Sección 8

Sección 9: Funciones síncronas y asíncronas
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al asíncronismo
- Probando función síncrona y asíncrona
- Errores comunes
- Funciones asíncronas y síncronas en nuestro proyecto
- Código fuente de la sección
- Quiz 7: Cuestionario - Sección 9

Sección 10: Manejo de archivos
- Introducción a la sección
- Temas puntuales de la sección
- Introducción al manejo de archivos
- File (Bytes) y UploadFile
- Guardar archivos en el disco local
- Servir archivos estáticos
- Agregar servicio para guardar archivo
- Modificar modelo y schemas para guardar imagen
- Modificar Router para aceptar archivos
- Probando ruta para aceptar y guardar archivo
- Limite de tamaño y chunks (parte 1)
- Limite de tamaño y chunks (parte 2)
- Código fuente de la sección
- Cuestionario - Sección 10

Sección 11: Proyecto - Tags
- Introducción a la sección
- Temas Puntuales
- Configurar autoimports
- Corregir creación de tags al crear un post
- Tag Schemas
- Endpoint crear tags
- Listado de tags parte 1 (Inicios)
- Listado de tags parte 2 (Servicio de paginación)
- Listado de tags parte 3 (Repository)
- Listado de tags parte 4 (Router)
- Endpoint Update Delete (Repository)
- Endpoint Update Delete (Router)
- Endpoint Tag más popular
- Código fuente de la sección
- Cuestionario - Sección 11

Sección 12: Proyecto - Users
- Introducción a la sección
- Temas Puntuales
- User model
- User schemas
- Security - Tokens
- Security - Hash Password
- Security - Require role
- User Repository
- User - Router - Register & Login
- User - Router - SetRole
- User - Probando endpoints de registro y login
- Token por formulario Swagger
- Probando permisos por roles
- Código fuente de la sección
- Cuestionario - Sección 12

Sección 13: Proyecto - Categorías
- Introducción a la sección
- Temas puntuales de la sección
- Agregar modelo Category
- Relación post con categorías
- Corrección de post repository para crear base de datos
- Category Schemas
- Category Repository
- Category Router
- Agregando category router al main
- Probando endpoints de categoría
- Cambiando schemas, repository y router del post
- Probando endpoints de post con categorías
- Código fuente de la sección
- Cuestionario - Sección 13

Sección 14: Proyecto - Seeds y slug para Post
- Introducción a la sección
- Temas puntuales de la sección
- Estructura de seeds y datos
- Servicio de hash, validaciones y contextmanager
- Seeds para usuarios
- Seeds para categorías
- Seeds para etiquetas
- Archivo run seeds
- Archivos de inicio y probando seeds
- Agregando slug y utils para slugify
- Modificando repository y router para agregar slug
- Probando endpoint de post y agregar persistencia de autenticación
- Código fuente de la sección
- Cuestionario - Sección 14

Sección 15: Middlewares
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es un Middleware?
- Creando Middleware
- Middleware - Cálculo de tiempo de procesos
- Middleware - Logging de peticiones
- Middleware - Generando Request ID
- Middleware - Bloqueador de IPs
- Creando Frontend para probar CORS middleware
- Middleware - CORS
- Código fuente de la sección
- Cuestionario - Sección 15

Sección 16: SQLModel - Modelos y Schemas - Devinote
- Introducción a la sección
- Temas puntuales de la sección
- SQLAlchemy vs SQLModel
- Estructura del proyecto Devinote
- Creando nuevo proyecto
- Creando versionamiento (git)
- Instalando paquetes necesarios
- Instalando paquetes en diferentes entorno virtuale
- Archivo de configuración y variables de entorno
- Configuración para base de datos
- Modelo - Usuario
- Modelo - Notas
- Modelo - Etiquetas
- Modelo - Compartir
- Repositorio - Usuario
- Repositorio - Notas
- Repositorio - Etiquetas
- Repositorio - Compartir nota
- Repositorio - Compartir etiqueta
- Repositorio - Compartir notas - Complemento
- Repositorio - Compartir - Lista de ids de notas y etiquetas
- Repositorio - Etiquetas - Funciones de pertenencia
- Repositorio - Notas - Complemento
- Código fuente de la sección
- Cuestionario - Sección 16

Sección 17: SQLModel - Servicios y rutas - Devinote
- Introducción a la sección
- Temas puntuales de la sección
- Archivo de configuraciones
- Servicio - Autenticación
- Servicio - Notas - Permisos
- Servicio - Notas - Lista de notas
- Servicio - Notas - Crear nota
- Servicio - Notas - Actualizar nota
- Servicio - Notas - Borrar nota
- Servicio - Etiquetas
- Servicio - Compartir notas
- Servicio - Compartir etiquetas
- Dependencias de base de datos
- Dependencias de usuario para rutas
- Rutas - Autenticación
- Rutas - Notas
- Rutas - Etiquetas
- Rutas - Compartir
- Rutas - Compartir etiquetas
- Configurando main.py
- Corrigiendo errores
- Comprobando creación de base de datos
- Error con Scalars()
- Swagger - Probando endpoints autenticación y etiquetas
- Swagger - Probando endpoints notas
- Swagger - Probando endpoints de compartir
- Swagger - Probando endpoints de dejar de compartir
- Código fuente de la sección
- Cuestionario - Sección 17

Sección 18: Migraciones con Alembic y PostgreSQL
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Alembic?
- Instalar e inicializar Alembic
- Configurando Alembic
- Cambios en el proyecto antes de migraciones
- Aplicando migración con Alembic
- Cambios futuros con Alembic
- Código fuente de la sección
- Cuestionario - Sección 18

Sección 19: Desplegando aplicación con Render
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Render?
- Adaptando nuestro proyecto para deploy
- Crear base de datos en Render
- Crear web service en Render
- Probando aplicación desplegada (parte 1)
- Probando aplicación desplegada (parte 2)
- Código fuente de la sección
- Cuestionario - Sección 19

Sección 20: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso

Bonus - WebSockets
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es un Websocket?
- Websocket Echo
- Websocket - Connection Manager
- Websocket - Ruta para el chat
- Websocket - Cliente para el chat
- Código fuente de la sección

Bonus - Webhooks
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es un Webhook?
- Webhook - Creando DB y modelo
- Webhook - Verificar firma
- Webhook - Ruta para Github
- Webhook - Función main
- Crear tunel con ngrok
- Configurando webhook para Github
- Configurando webhook para Discord
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (37, 'angular-moderno', 'Angular: De cero a experto edición 2025', 'https://cursos.devtalles.com/courses/angular-moderno', 'https://import.cdn.thinkific.com/643563/LeaTjvBRI6cldshD59jw_angular-de-cero.jpg', 'Portada del curso: Angular: De cero a experto edición 2025', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Aprende Angular en profundidad con el nuevo paradigma Zoneless basado en señales. Comienza desde cero y realiza ejercicios prácticos para dominar lo necesario y crear aplicaciones con este framework.', 2010, 'es', '{}', 'https://cursos.devtalles.com/courses/angular-moderno', '2026-09-24 15:49:29.94579+00', '{"Saber JavaScript básico","Conocimiento básico de programación","No es necesario saber TypeScript pero ayudaría","No es necesario conocimiento alguno de Angular u otras versiones"}', '{}', 'Sección 1 - Introducción
- Introducción al curso
- ¿Cómo funciona el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Hoja de atajos - Recomendaciones
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Conceptos generales - TypeScript y Angular
- Introducción
- ¿Qué es TypeScript? ¿Por qué Angular lo usa?
- 10 Mitos y realidades de Angular

Sección 3: Bases de TypeScript - Recomendado
- Introducción
- Temas puntuales
- Inicio de proyecto - Bases de TypeScript
- Tipos básicos y conceptos generales
- Objetos, arreglos e interfaces
- Funciones básicas
- Funciones con objetos como argumentos
- Tarea sobre objetos e interfaces
- Desestructuración de Objetos
- Desestructuración de Arreglos
- Desestructuración de Argumentos
- Resolución de la tarea - Desestructuración
- Importaciones y exportaciones
- Clases básicas
- Constructor de una clase
- Extender una clase
- Priorizar composición sobre herencia
- Genéricos
- Decoradores
- Encadenamiento opcional
- Código fuente

Sección 4: Angular
- Introducción
- Temas puntuales
- Introducción a Angular
- Primer proyecto en Angular
- Explicación de archivos y directorios
- Explicación del directorio SRC
- Counter Page - Componente
- Tarea - Separar template de la lógica
- Señales
- Zoneless Angular
- Tarea - Reforzar lo aprendido hasta el momento
- Solución a la tarea
- Señales computadas - Readonly Signals
- Resumen de lo aprendido
- Código fuente de la sección

Sección 5 - Expandir bases
- Introducción
- Temas puntuales
- Continuación de proyecto
- RouterLink
- RouterLink Active
- Tarea - Preparación de página
- @for - Realizar iteraciones de elementos
- ngClass - Clases de CSS de forma condicional
- @if - Mostrar elementos de forma condicional
- Inputs - Agregar personaje
- Solución a la tarea
- Preparación de una nueva página
- Función input - Comunicación entre componentes
- Tarea - Signal Inputs y creación de componentes
- Output - Emitir valores
- Servicios en Angular
- Efectos y LocalStorage
- LinkedSignal - Cargar del LocalStorage
- Despliegues y HashRouter
- Código fuente

Sección 6 - GifsApp - Pensemos en componentes
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - GifsApp
- Pensemos en componentes
- Rutas Hijas
- Componentes para el menú lateral
- RouterLinks - Desde componentes hijos
- Angular Environments y Path Alias
- Mostrar imágenes de relleno
- Tarea - input de imágenes
- Código fuente

Sección 7 - Aplicación de Gifs
- Introducción
- Temas puntuales
- Demostración
- Continuación de aplicación
- Giphy API - Servicio de Gifs
- GifService - Interfaces
- Petición HTTP GET
- Mostrar Gifs en pantalla
- Diseño de pantalla - Buscador de Gifs
- Mostrar resultados de búsqueda
- Historial y Caché de búsqueda
- Argumentos dinámicos por URL
- Mostrar historial de búsqueda
- LocalStorage - Mantener el historial
- Código fuente

Sección 8 - Gifs Intermedio/Avanzado
- Introducción
- Temas puntuales
- Demostración
- Continuación de aplicación
- Diseño Masonry
- viewChild - Tomar referencias del template
- Determinar fin de scroll
- Cargar siguiente página de Gifs
- Preservar posición del scroll
- Depuración de aplicación
- Código fuente

Sección 9 - Country SPA
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto - CountryApp
- Rutas y estructura de carpetas
- Layout Components
- DaisyUI - Componentes
- Menú superior e íconos
- Inputs y Tablas
- Solución a la tarea
- Guía de estilos - Resumen
- Código fuente

Sección 10 - Country SPA - Funcionalidad
- Introducción
- Temas puntuales
- Demostración
- Continuación de aplicación
- CountryService - Interfaces
- Country Interface y Mapeo de datos
- Solución de la tarea - CountryMapper
- Nombre del país en español
- Decimal Pipe
- Manejo de excepciones
- Reactividad con Resources
- Tarea - Buscar países
- RxResource
- Mostrar diferentes estados al usuario
- Información de un país
- Detalles del país
- Resolución de la tarea
- Código fuente

Sección 11 - CountryApp - Intermedio/Avanzado
- Introducción
- Temas puntuales
- Demostración
- Continuación
- Debounce - Búsquedas automáticas
- Caché de resultados
- Tarea - Caché de países
- Tarea - Países por region
- Resolución de la tarea
- Preservar resultados - ActivatedRoute
- Cambiar queryParams vía código
- Validar parámetros de query
- Código fuente

Sección 12 - Pipes
- Introducción
- Temas puntuales
- Demostración
- Inicio de proyecto
- Lectura de rutas dinámicamente
- UpperCase, LowerCase y TitleCase Pipes
- Decimal, Percent y Currency Pipes
- Date Pipe
- Cambiar de idiomas
- Cambiar locale dinámicamente
- Content Projection
- I18nSelectPipe
- I18nPluralPipe
- SlicePipe
- JsonPipe
- KeyValuePipe
- AsyncPipe
- AsyncPipe con Observables
- Código fuente

Sección 13 - Pipes personalizados
- Introducción
- Demostración
- Temas puntuales
- Continuación
- Pipe personalizado - ToggleCase
- Preparación de proyecto
- Pipe Personalizado - CanFlyPipe y HeroColor
- Pipe personalizado - HeroTextColor
- Pipe personalizado - HeroSortBy
- Pipe personalizado - HeroFilterPipe
- Código fuente

Sección 14 - Formularios Reactivos
- Introducción
- Temas puntuales
- Demostración
- Inicio de aplicación - FormulariosApp
- Rutas padre y template HTML
- ReactiveForms - FormGroup y FormControl
- Form Builder
- Validaciones de campos incluidos
- Mostrar errores en pantalla
- Mejorar re-utilización y experiencia de usuario
- Reutilización de lógica entre formularios
- Formularios dinámicos con arreglos
- Agregar y eliminar controles de formularios
- Múltiples eventos desde el mismo campo
- Código fuente

Sección 15 - Formularios Reactivos
- Introducción
- Temas puntuales
- Demostración
- Continuación de aplicación
- Switches, Checks y Radio buttons
- Tarea - Formulario de registro básico
- Validación contra expresiones regulares
- Validación personalizada - Campos iguales
- Validaciones asíncronas
- Validación personalizada - Síncrona
- Preparación de ejercicio
- Primer selector controlado - Continentes
- Suscribirse a los cambios del formulario
- Llenar tercer selector
- Terminar el tercer selector
- Código fuente

Sección 16 - LifeCycle Hooks
- Introducción
- Demostración
- Temas puntuales
- Inicio de proyecto - LifeCycle
- Ciclo de vida de los componentes
- Ciclo de vida - Segunda Parte
- Zoneless Angular
- OnChanges
- Código fuente

Sección 17 - Mapas
- Introducción
- Demostración
- Temas puntuales
- Inicio de aplicación - MapsApp
- Título en el Navbar - Observable - Señal
- Variables de entorno .env - MapboxKey
- Crear environments mediante un script
- Mapa a pantalla completa
- Controlar mapa - Zoom
- Controlar mapa - Obtener Posición central
- Controles propios de Mapbox
- Marcadores en el mapa
- Marcadores dinámicos
- Mostrar listado de Marcadores
- Eliminar marcadores
- Varios mapas en pantalla
- Solución de la tarea - MiniMap
- Tailwind - Responsive design
- Construir y desplegar
- Código fuente

Sección 18 - TesloShop Aplicación administrativa
- Introducción
- Demostración
- Temas puntuales
- Inicio de proyecto - TesloShop
- Páginas y rutas
- Fuentes personalizadas - Navbar
- Tarjetas de producto y FadeIn animation
- TypeScript - Path Alias
- Levantar backend - TesloShop
- Traer listado de productos
- Variables de entorno y parametrización
- Mostrar productos en pantalla
- Solución a la tarea - Mostrar Productos
- ProductImage Pipe - Pipe Personalizado
- Pantalla de producto
- Carousel de imágenes
- Página de productos por género
- Código fuente

Sección 19 - Paginación (Opcional)
- Introducción
- Demostración
- Temas puntuales
- Continuación
- Paginación local
- Paginación local - Funcionalidad
- Paginación con RxResource
- Servicio de paginación
- Caché de productos
- Caché de producto
- Código fuente

Sección 20 - Autenticación y autorización
- Introducción
- Demostración
- Temas puntuales
- Continuación
- Rutas y páginas de autenticación
- Formulario reactivo de autenticación
- AuthService - Controlar autenticación
- AuthService - Parte 2
- Manejo de excepciones
- Revisar autenticación previa
- Refactorización y principio DRY
- Mostrar usuario autenticado y cerrar sesión
- Interceptores en Angular
- Auth Interceptor
- Guards - notAuthenticatedGuard
- Tarea - Pantalla de Registro
- Código fuente

Sección 21 - Panel administrativo
- Introducción
- Demostración
- Temas puntuales
- Continuación
- Diseño del panel administrativo
- Autorización - IsAdminGuard
- Listado de productos
- Mostrar productos paginados
- Página de producto por ID
- Estructura del formulario de producto
- Formulario de producto
- Botones de selección
- Mostrar errores del formulario
- Preparar la data para actualizar
- Actualizar producto
- Actualizar caché
- Crear producto
- Mejorar experiencia de usuario
- Código fuente

Sección 22 - Carga de archivos y despliegues
- Introducción
- Demostración
- Temas puntuales
- Continuación
- Seleccionar imágenes y mostrarlas
- Solución de la tarea - Imágenes temporales
- Swiper - Dot fix
- Subir imágenes - Servicio
- Actualizar imágenes del producto
- Plan de despliegue
- Aprovisionar Base de datos
- Desplegar Backend - GitHub - Render
- Preparar aplicación de Angular
- Desplegar aplicación de Angular
- Código fuente de la sección

Sección 23 - Angular 19+ - Nuevas características
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Nota útil
- Inicio de proyecto - MyDashboard
- Cambios en la estructura del proyecto
- Tailwind en Angular
- Creación de archivos y directorios
- Configuración de rutas
- Configuración del dashboard - Tailwind
- @for - @if - Nueva sintaxis
- Configurar alias de importaciones en TypeScript
- Control Flow - @If
- Control Flow - @Switch
- Control Flow - @For
- Required @Input
- ChangeDetection - OnPush
- Defer Blocks
- Defer Triggers
- Defer Triggers - Interacciones
- Defer Triggers - Interacciones - Parte 2
- ViewTransitions API
- Hero Animation - View Transitions
- Servicios con señales
- Peticiones HTTP - importProvidersFrom
- De observable a Señal - toSignal
- Tarea - Computed Signals
- Código fuente de la sección

Sección 24: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (62, 'nest', 'Nest: Desarrollo backend escalable Node - Fernando Herrera', 'https://cursos.devtalles.com/courses/nest', 'https://import.cdn.thinkific.com/643563/T6It7zuNQPWizrBJvbaX_NEST-NEW.jpg', 'Portada del curso: Nest: Desarrollo backend escalable Node - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'El curso está pensado para ayudarlos a empezar en Nest como para mejorar sus habilidades en este framework tan poderoso, adicionalmente cuenta con un cheat-sheet personalizado por mi para ayudarlos en el aprendizaje que pueden imprimir y compartir.', 1470, 'es', '{"Fundamentos de NestJS: Módulos, controladores, servicios, decoradores e inyección de dependencias.","Desarrollo Backend: APIs REST, autenticación, autorización, WebSockets y manejo de archivos.","Bases de datos: PostgreSQL, MongoDB, TypeORM y Mongoose.","Arquitectura profesional: Docker, principios SOLID, documentación automática y despliegues.","Core Building Blocks: Services, Controllers, Providers, Modules, Decorators, Guards, Gateways, Interceptors y Exception Filters.","Backend moderno: APIs REST, JWT, autenticación, autorización por roles y ciclo de vida de una petición.","Bases de datos: PostgreSQL, MongoDB, TypeORM, Mongoose, transacciones y Repository Pattern.","Validaciones: DTOs, Pipes, Class Transformer y validaciones de solicitudes.","Infraestructura: Docker, Docker Compose, CORS y despliegues a producción.","Buenas prácticas: Principios SOLID, TypeScript, genéricos, interfaces y estructuras recomendadas por el equipo de Nest.","Documentación: Generación automática y semiautomática de APIs.","Y mucho más...","Serás capaz de desarrollar aplicaciones backend profesionales utilizando NestJS y TypeScript.","Aprenderás a construir APIs escalables con autenticación, bases de datos y despliegues en producción.","Dominarás la arquitectura y las herramientas más utilizadas dentro del ecosistema NestJS.","Tendrás una base sólida para participar en proyectos profesionales desarrollados con este framework."}', 'https://cursos.devtalles.com/courses/nest', '2026-09-24 15:49:29.94579+00', '{"Conocimiento de JavaScript es necesario","Bases de TypeScript son recomendadas","Tener una idea general de Node es recomendado","Tener una idea de programación orientada a objetos es recomendada pero no necesaria"}', '{}', 'Sección 1: Introducción al curso
- Video introductorio
- Introducción
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones recomendadas
- Material adicional - Guía de Atajos
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Breve introducción a TypeScript y conocimientos generales necesarios
- Introducción a la sección
- Temas puntuales de la sección
- Preparación del proyecto
- Tipos y bases sobre módulos
- Tipos de datos - continuación
- Objetos e interfaces
- Tipos en arreglos
- Clases y forma abreviada
- Getters, métodos y THIS
- Métodos asíncronos
- Colocar tipo de dato a respuestas http (genéricos)
- Inyección de dependencias
- Genéricos + Sustitución de Liskov
- Resolver el principio de sustitución
- Decoradores
- Decorador de método - @Deprecated
- Resumen de lo aprendido
- Código fuente de la sección

Sección 3: Primeros pasos en Nest
- Introducción a la sección
- Temas puntuales de la sección
- ¿Qué es Nest? y ¿Por qué usarlo?
- Instalar Nest CLI - Command Line Interface
- Generar nuestro primer proyecto - CarDealership
- Explicación de cada archivo y directorio
- Módulos
- Controladores
- Desactivar Prettier
- Obtener un carro por ID
- Servicios
- Inyección de dependencias
- Pipes
- Exception Filters
- Post, Patch y Delete
- Código fuente de la sección

Sección 4: DTOs y Validación de información
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Interfaces y UUID
- Pipe - ParseUUIDPipe
- DTO - Data Transfer Object
- ValidationPipe - Class Validator y Class Transformer
- Pipes Globales - A nivel de Aplicación
- Crear el nuevo carro
- Actualizar un carro
- Actualizar el listado de carros
- Borrar un carro
- Resumen de la sección
- Código fuente de la sección

Sección 5: Nest CLI Resource - Brands CRUD
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Nest CLI Resource - Brands
- Crear CRUD completo de Brands
- Crear servicio SEED para cargar datos
- Preparar servicios para insertar SEED
- Inyectar servicios en otros servicios
- Código fuente de la sección

Sección 6: Generar build de producción básico
- Introducción a la sección
- Generar build de producción básico

Sección 7: MongoDB Pokedex
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Pokedex
- Servir contenido estático
- Global Prefix
- Docker - DockerCompose - MongoDB
- README.md
- Conectar Nest con Mongo
- Crear esquemas y Modelos
- POST - Recibir y validar la data
- Crear Pokémon en base de datos
- Responder un error específico
- FindOneBy - Buscar por nombre, MongoId y no
- Actualizar Pokemon en base de datos
- Tarea - Validar valores únicos
- Eliminar un Pokemon
- CustomPipes - ParseMongoIdPipe
- Validar y eliminar en una sola consulta
- Respaldar código fuente en GitHub
- Código fuente de la sección

Sección 8: Seed y Paginación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Crear módulo SEED
- Nota de actualización - Axios
- Realizar petición http desde Nest
- Tarea - Insertar Pokemons por lote
- Resolución - Insertar Pokemons por lote
- Insertar multiples registros simultáneamente
- Crear un custom provider - opcional
- Paginación de Pokemons
- Transform DTOs
- Código fuente de la sección

Sección 9: Variables de entorno - Deployment y Dockerizar la aplicación
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Configuración de variables de entorno
- Configuration Loader
- ConfigurationService
- joi - ValidationSchema
- ENV Template - Readme
- MongoDB - Aprovisionamiento
- Desplegar aplicación en la nube
- Bonus - Docker ¿Dockerizar?
- Bonus: Explicación general del Dockerfile
- Bonus: Definir la construcción de la imagen
- Bonus: Construir la imagen
- Bonus: Conservar la base de datos y analizar imagen
- Actualizar Readme.md
- Código fuente de la sección
- Nota de actualización
- Archivado MongoAtlas - MongoDB en la nube
- Archivado Heroku - Desplegar aplicación en la nube
- Heroku Archivado - Desplegar en Heroku - Parte 2

Sección 10: TypeORM - Postgres
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - TesloShop
- Docker - Instalar y correr Postgres
- Conectar Postgres con Nest
- TypeORM - Entity - Product
- Entidad sin relaciones
- Create Product DTO
- Insertar usando TypeORM
- Manejo de errores
- BeforeInsert y BeforeUpdate
- Get y Delete TypeORM
- Paginar en TypeORM
- Buscar por Slug o UUID
- QueryBuilder
- Update en TypeORM
- BeforeUpdate
- Nueva columna - Tags
- Código fuente de la sección

Sección 11: Relaciones en TypeORM
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Breve explicación de lo que haremos
- ProductImage Entity
- OneToMany y ManyToOne
- Crear imágenes de producto
- Aplanar las imágenes
- Query Runner
- Transacciones
- Eliminación en cascada
- Product Seed
- Insertar de forma masiva
- Renombrar tablas
- Código fuente de la sección

Sección 12: Carga de archivos
- Inicio de sección
- Temas puntuales de la sección
- Continuación de la sección
- Subir un archivo al backend
- Validar archivos
- Guardar imagen en filesystem
- Renombrar el archivo subido
- Servir archivos de manera controlada
- Retornar el secureUrl
- Otras formas de desplegar archivos
- Colocar imágenes en el directorio estático
- Código fuente de la sección

Sección 13: Autenticación de autorización
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Entidad de Usuarios
- Crear usuario
- Encriptar la contraseña
- Login de usuario
- Nest Authentication - Passport
- Módulos Asíncronos
- JwtStrategy
- JwtStrategy - Parte 2
- Generar un JWT
- Private Route - General
- Tarea: Cambiar email por id en el Payload
- Custom Property Decorator - GetUser
- Tarea - Custom Decorators
- Custom Guard y Custom Decorator
- Verificar rol del usuario
- Custom Decorator - RoleProtected
- Composición de Decoradores
- Auth en otros módulos
- Usuario que creó el producto
- Insertar userId en los productos
- SEED de usuarios, productos e imágenes
- Encriptar contraseña de los usuarios del SEED
- Check AuthStatus
- Código fuente de la sección

Sección 14: Documentación - OpenAPI
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Documentación mediante Postman
- Nestjs swagger - OpenAPI Specification
- Tags, ApiProperty y ApiResponse
- Expandir el ApiProperty
- Documentar DTOs
- Tarea - Documentación
- Código fuente de la sección

Sección 15: Websockets
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Websocket Gateways
- Server - Escuchar conexiones y desconexiones
- Cliente - Vite Vanilla TypeScript
- Server - Mantener identificados los clientes
- Cliente - Detectar conexión y desconexión
- Cliente - Clientes conectados
- Emitir Cliente - Escuchar Servidor
- Formas de emitir desde el servidor
- Preparar cliente para enviar JWT
- Validar JWT del Handshake
- Enlazar Socket con Usuario
- Desconectar usuarios duplicados
- Código fuente de la sección

Sección 16: Desplegar toda la aplicación a producción
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Postgres en la nube
- Desplegar aplicación a Render
- Desplegar Vite App - Frontend
- Código fuente de la sección

Sección 17: Despedida del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (69, 'legacy-git-github', 'GIT+GitHub: De cero - Fernando Herrera', 'https://cursos.devtalles.com/courses/git-github-control-versiones', 'https://import.cdn.thinkific.com/643563/cO9RGLb7QXysw8c0hpJ8_devtalles-legacy-github.jpg', 'Portada del curso: GIT+GitHub: De cero - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este curso te ayudará a no volver a perder un trabajo por culpa de fallas técnicas o bien por un descuido. Al finalizar el curso, sabrás Git, GitHub, Markdown, uso de repositorios, Wikis, Issues, milestones, proyectos, trabajo en equipo y mucho más.', 690, 'es', '{}', 'https://cursos.devtalles.com/courses/git-github-control-versiones', '2026-09-24 15:49:29.94579+00', '{}', '{}', 'Sección 1: Inicio del curso del curso
- Objetivos del curso
- ¿Cómo funcionará el curso?
- Instalaciones necesarias para el curso
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Git - Fundamentos
- Introducción a los fundamentos de Git
- ¿Por qué nos interesa saber Git o un sistema de control de versiones?
- Primeros comandos de git
- Nuestro primer repositorio
- Nota - CRLF
- ¿Qué hace git por nosotros en estos momentos?
- Exposición sobre los comandos usados hasta el momento
- Cambiar nombre de la rama Master a Main
- Demostración de la creación, puesta en escena y commits
- Bonus - VSCode add y commits
- Diferentes formas de agregar archivos al escenario
- Diferentes formas de añadir al Stage
- Creando Alias para nuestros comandos
- Cuestionario 1: Examen teórico

Sección 3: Un poco más allá de los fundamentos de GIT
- Introducción a la sección
- Cambios en los archivos
- Actualizar mensaje del commit y revertir commits
- Posible error/warning que tienen algunos
- Preparando un repositorio para viajes en el tiempo
- Viajes en el tiempo, resets y reflog
- Cambiar el nombre y eliminar archivos mediante git
- Cambiar el nombre y eliminar archivos fuera de git
- Ignorando archivos que no deseamos
- Tarea práctica #1 - Fundamentos de Git

Sección 4: Ramas, uniones, conflictos y tags
- Introducción a la sección de ramas
- Introducción Ramas, uniones y conflictos
- Merge: Fast-Forward
- Merge: Union automática
- Merge: Uniones con conflictos
- Tags - Etiquetas
- Creando etiquetas - Tags
- Cuestionario 2: Examen teórico

Sección 5: Git Stash y Git Rebase - Para realizar cambios de emergencia
- Introducción a la sección - Stash
- Introducción al stash
- Git Stash
- Conflictos con el stash
- Stash avanzado
- Introducción al git rebase
- Rebase - Actualizando una rama
- Rebase - Squash
- Rebase - Reword
- Rebase - edit
- Cuestionario 3: Examen teórico

Sección 6: Inicios en GitHub, Git Remote, Push & Pull
- Introducción a la sección de GitHub, Remote - Push & Pull
- Introducción GitHub Remote - Push & Pull
- Documentaciones útiles
- Creando una cuenta en GitHub
- Push a GitHub
- Push de los Tags de nuestro repositorio
- Creando - Release tags
- Actualizar el perfil de GitHub
- Pull de los últimos cambios en el repositorio de GitHub
- Warning - Pulling without reconcile strategy
- Clonar un repositorio
- Subir cambios locales al remoto
- Git Pull Rebase
- Git pull - Ejercicio

Sección 7: GitHub - Básico
- Introducción a GitHub
- Introducción a la interfaz de GitHub
- Markdown y GitHub Markdown
- Documentación sobre el Markdown de GitHub
- Buscando archivos en GitHub
- Raw, Blame, History, Edit and Delete
- Creando un nuevo archivo en GitHub
- Git Fetch
- Comentarios en los commits
- Comprender el flujo de Github
- Bonus - No hacer esto

Sección 8: GitHub - Avanzado
- Introducción a la sección - GitHub Avanzado
- Fork, Clone Y Colaboraciones
- Cloning y Fork
- Pull Request
- Pull Request - Parte 2
- Actualizando nuestro Fork - Teoría
- Actualizando nuestro Fork - Práctica
- Introducción a los flujos de trabajo
- Tarea - Preparemos un nuevo repositorio para reforzar lo aprendido
- Resolución de la tarea
- Feature Branch - Flujo de trabajo mediante pull request
- Bonus: Actualizar un Alias
- Feature Branch - Revisando el trabajo de otros compañeros
- Limpiar ramas que ya no son necesarias
- Rama de producción - GitHub
- Recuperar una rama de producción

Sección 9: GitHub Issues, MileStones y Colaboradores
- Introducción a la sección - Issues
- GitHub Issues
- Cerrar un issue
- Cerrar issue mediante un commit
- Issue Templates
- Labels - Etiquetas
- Milestones - Un punto importante
- Agregando colaboradores a un repositorio

Sección 10: Wikis, Proyectos y GitHub Pages
- Introducción a la sección de Wikis y Proyectos
- Nota de actualización - Wikis
- Wiki
- Agregando referencias entre páginas en la wiki
- Proyectos de GitHub
- GitHub Pages - Para tu usuario u Organización
- GitHub Pages - Para tu proyecto o repositorio
- Insights

Sección 11: Organizaciones y Equipos
- Introducción al tema de las organizaciones
- Creando una organización
- Transfiriendo el dominio de un repositorio a una organización
- Teams - Equipos de trabajo
- Repositorios y privilegios a los equipos de nuestra organización
- Más información sobre los miembros de la organización

Sección 12: Gist
- Introducción a la sección de Gist
- Creando un Gist
- Usando plugins de Gist con tokens personales
- Otros detalles de los Gist

Sección 13: Fin del curso
- Más información sobre nuestros otros cursos
- Conclusiones del curso y despedida', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (58, 'angular-clasico', 'Angular: De cero a experto - Fernando Herrera', 'https://cursos.devtalles.com/courses/angular', 'https://import.cdn.thinkific.com/643563/a51yLvxNTUiTs5FbiBsx_COVER-DEVTALLES2.jpeg', 'Portada del curso: Angular: De cero a experto - Fernando Herrera', NULL, '[]', true, '2026-09-23', '2026-09-15 05:33:44.419786+00', '2026-09-24 15:47:08.091899+00', 'Este curso te ayudará a aprender Angular v2023 a profundidad mediante ejercicios y tareas que tú mismo harás. Partiendo de cero conocimiento de TypeScript hasta crear un sistema robusto de autenticación, uso de mapas, consumo de servicios y mucho más.', 2730, 'es', '{"Fundamentos: TypeScript y Angular desde cero.","Angular moderno: Signals, formularios reactivos, directivas, lazy loading y nuevas APIs.","Desarrollo Full Stack: Autenticación con NestJS, consumo de APIs y despliegues en producción.","Herramientas profesionales: Angular Material, PrimeNG, Mapbox y manejo de estado.","Dominarás Angular para desarrollar aplicaciones modernas y escalables.","Aprenderás las mejores prácticas utilizadas en proyectos profesionales.","Contarás con los conocimientos necesarios para desarrollar aplicaciones listas para producción."}', 'https://cursos.devtalles.com/courses/angular', '2026-09-24 15:49:29.94579+00', '{"Conocimientos básicos de programación en JavaScript o TypeScript:","No necesitas ser experto, pero debes entender funciones, objetos y estructuras básicas.","Conocimientos iniciales de HTML y CSS:","Saber estructurar páginas web y aplicar estilos básicos.","Entorno de desarrollo listo (Node.js, Angular CLI, VSCode):","Debes poder ejecutar proyectos localmente y manejar la terminal.","El curso es extenso, por lo que es ideal para personas comprometidas con su aprendizaje."}', '{}', 'Sección 1: Introducción
- Nota importante sobre la versión de este curso
- Introducción al curso
- ¿Cómo funcionará el curso?
- ¿Cómo hacer preguntas?
- Instalaciones necesarias y recomendadas
- Hoja de atajos - Recomendaciones
- Nota de actualización - ¡Importante!
- Nueva sintaxis en Angular
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Conceptos generales antes de empezar
- Introducción a la sección
- ¿Qué es TypeScript? y ¿Por qué Angular usa TypeScript?
- 10 Mitos y realidades de Angular

Sección 3: Bases de TypeScript - Recomendado
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - TypeScript
- Tipos básicos y conceptos generales
- Objetos, arreglos e interfaces
- Funciones básicas
- Funciones con objetos como argumentos
- Tarea sobre objetos e interfaces
- Desestructuración de Objetos
- Desestructuración de Arreglos
- Desestructuración de argumentos
- Resolución de la tarea - Desestructuración
- Importaciones y exportaciones
- Clases básicas
- Constructor de una clase
- Extender una clase
- Priorizar composición sobre herencia
- Genéricos
- Decoradores
- Encadenamiento opcional
- Código fuente de la sección

Sección 4: Angular
- Introducción a la sección
- Temas puntuales de la sección
- Exposición sobre Angular
- Nota de actualización
- Nuestro primer proyecto en Angular
- Explicación de cada archivo del proyecto
- Explicación de cada archivo - Parte 2
- App Component
- Contador
- Contador Component
- Funcionalidad del contador
- Componente Hero y directorios
- Interpolación, estructura HTML y estilos
- One way data binding - enlazado en una sola vía
- Tarea - Cambiar nombre y edad
- Directiva *ngIf
- Directiva *ngFor
- Ng-template y el ngIf-else
- Módulos en Angular
- Tarea sobre módulos
- Bonus: Hacer respaldo de nuestro proyecto en GitHub
- Código fuente de la sección

Sección 5: Expandir Bases de Angular
- Introducción a la sección
- Temas puntuales de la sección
- Continuación del proyecto
- Módulo DBZ (Dragon Ball Z)
- Resolución de la tarea - DBZ Module
- Diseño de la pantalla a trabajar
- Pensemos en componentes pequeños
- Resolución de la tarea - AddCharacter
- @Input() - Recibir del padre
- Expandiendo el *ngFor
- ngClass - Clases basado en condiciones
- FormsModule y ngModel
- @Output() - Emitir eventos al padre
- Formas de depurar la app
- Añadir personaje al listado
- Solución de la tarea - Flujo completo
- Servicios
- Paquetes externos - UUID
- Resolución de la tarea
- Servicio Privado
- Código fuente de la sección

Sección 6: Despliegues a producción
- Introducción a la sección
- Temas puntuales de la sección
- Generar build de producción
- HttpServer Local y Netlify
- GitHub Pages
- Package.json Scripts
- Código fuente de la sección

Sección 7 - GifsApp
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Nota de actualización
- Inicio de proyecto - GifsApp
- Diseño y estructura inicial del proyecto
- Diseño de Gifs Components
- Resolución de la tarea - CardList
- @ViewChild - Referencia al HTML
- GifsService
- Validaciones al servicio
- Giphy Api Key - Giphy Developers
- Realizar una petición HTTP
- Colocar un tipo de dato a una respuesta HTTP
- Mostrar los Gifs en pantalla
- Mostrar la imagen del Gif
- Resolución de la tarea
- LocalStorage - Persistencia local
- Leer del LocalStorage
- Código fuente de la sección

Sección 8 - Image Loader
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Pensemos en componentes
- Solución de la tarea
- Lazy Image - Parte 1
- Lazy Image - Parte 2
- Animaciones de CSS
- Código fuente de la sección

Sección 9 - Country SPA
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Nota de actualización
- Inicio de proyecto - CountryApp
- Router Module y Páginas - SPA
- RouterLink y RouterLinkOptions
- Resolución de la tarea
- Countries Routing Module
- LazyLoad - Carga perezosa
- Estructura de páginas y SearchBox Component
- Funcionamiento del SearchBox
- Countries Service - Restcountries
- Mostrar los países en pantalla
- CountryTable Component
- CatchError - Manejo de errores en observables
- Tarea - País y Región
- Argumentos por URL - Página de País
- switchMap - Refactorización
- Mostrar información del país
- Navegar hacia la página de país
- Código fuente de la sección

Sección 10 - Mejoras y funcionalidades extra
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Refactorizaciones en nuestro servicio
- LoadingComponent - Mostrar un indicador de carga
- Mostar y ocultar el LoadingSpinner
- Debounce - Peticiones cuando el usuario deja de escribir
- Limpieza de suscripciones
- Buscar por region - Optimización
- Mantener la data entre pantallas
- Mantener la data entre pantallas - Parte 2
- Resolución de la tarea
- LocalStorage del Store
- Código fuente de la sección

Sección 11 - PipesApp - PrimeNG
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Nota de actualización
- Inicio de proyecto - PipesApp
- Introducción a los Pipes de Angular
- Instalar PrimeNG
- PrimeNG - Menú superior
- PrimeNG - MenuBar
- Módulos y Rutas de mi aplicación
- Navegar usando el MenuBar
- UpperCase, LowerCase y TitleCase Pipes
- PrimeFlex
- DatePipe
- Cambiar idioma global y manualmente
- Decimal, Currency y Percent Pipes
- PrimeNG - FieldSet
- I18nSelectPipe
- I18nPluralPipe
- SlicePipe
- KeyValuePipe
- AsyncPipe
- Código fuente de la sección

Sección 12 - Pipes Personalizados
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- ToogleCasePipe - Piper Personalizado
- Valores y argumentos personalizados al Pipe
- Argumentos dinámicos a pipes personalizados
- PrimeNG - Table
- Tarea- CanFly Pipe
- sortBy - Pipe personalizado
- Ordenar tabla por Nombre, Vuela y Color
- Código fuente de la sección

Sección 13 - Rutas hijas y LazyLoading
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Inicio de proyecto - HeroesApp
- Creación de componentes - Pages
- Ruta hijas y LazyLoad
- Paths de las rutas faltantes
- Código fuente de la sección

Sección 14 - Angular Material
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo de la sección
- Continuación del proyecto - HeroesApp
- Instalación de Angular Material y PrimeFlex
- Diseño de Login y Auth Layout
- Material Sidenav, Toolbar e iconos
- Heroes Backend - json-server
- Variables de entorno - Angular 15+
- HeroesService - Traer información de los héroes
- Mostrar listado de Héroes
- HeroImage Pipe
- Obtener Héroe por URL
- Página del Héroe
- Angular Material - Autocomplete
- Angular Material - Autocomplete Parte 2
- Agregar Héroe - HTML
- Código fuente de la sección

Sección 15 - CRUD Heroes
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final
- Continuación de la sección
- HerosService - CRUD Endpoints
- HeroForm - ReactiveForms introducción
- Conectar el formulario con el template
- Getters dentro del componente
- Actualizar y crear héroes
- Establecer el valor del formulario
- Snackbars y redirección
- Material Dialogs
- Eliminar registro
- Código fuente de la sección

Sección 16 - Protección de Rutas
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la aplicación
- AuthService - Servicio de Autenticación
- Autenticar y mostrar usuario activo
- Mantener la sesión del usuario
- Guards de Angular
- Implementar la funcionalidad del Guard
- PublicGuard - Tarea
- Código fuente de la sección

Sección 17 - Formularios Reactivos
- Introducción a la sección
- Temas puntuales de la sección
- Nota Importante
- Inicio de proyecto - FormsApp
- Estructura HTML de las páginas
- Rutas de nuestra aplicación
- Barra de navegación
- Primeros pasos en formularios reactivos
- Forms Validator - Validador incluído en Angular
- Re-establecer y establecer valor al formulario
- Mostrar errores de validación en pantalla
- Métodos de ayuda para los errores
- Formularios dinámicos
- Validaciones Dinámicas
- Eliminar elementos de un FormArray
- Insertar elementos al FormArray
- Documentación - Formularios Reactivos
- Código fuente de la sección

Sección 18 - Validaciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto y tarea
- Solución de la tarea
- Formulario de Registro
- Validator Functions
- Validaciones de Email y Patrones
- Validator Service
- Validadores asíncronos
- Elaborar el validador de correo
- Verificar que dos campos sean iguales
- Código fuente de la sección

Sección 19 - Formularios Reactivos - Multiples selectores anidados
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - Selectores
- Estructura de directorios para esta aplicación
- Solución de la tarea
- Formulario reactivo - primer selector
- Servicio e interfaces
- Selector de regiones
- Segundo selector anidado - Países
- Obtener países por region
- Convertir los países y mostrarlos en pantalla
- Limpiar país cuando el primer selector cambia
- Tercer selector anidado - Fronteras
- Información de las fronteras
- Código fuente de la sección

Sección 20 - LifeCycle Hooks
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - LifeCycle
- Implementar todos los Lifecycle Hooks
- ngOnChanges
- ngOnDestroy
- Más información sobre el ciclo de vida
- Código fuente de la sección

Sección 21 - Mapas en Angular
- Introducción a la sección
- Temas puntuales de la sección
- Demostración del objetivo final de la sección
- Inicio de sección - MapasApp
- Crear los componentes y rutas
- Menú de la aplicación
- Archivo ENV y MapboxKey
- Crear env automáticamente
- Mostrar un mapa en pantalla completa
- ViewChild - ElementRef
- Diseño - ZoomIn y ZoomOut
- Controlar el nivel del Zoom
- Obtener las coordenadas centrales del mapa
- Marcadores en el mapa
- Añadir marcadores de forma dinámica
- Mantener el arreglo de marcadores y colores
- FlyTo
- Guardar y leer del LocalStorage
- Actualizar storage - Cuando se mueven los marcadores
- Lista de Casas - Diseño y estructura
- Componente MiniMapa
- Código fuente de la sección

Sección 22 - Standalone Components
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección - MapsApp
- Standalone - Como Página
- Standalone - Como componente reutilizable
- Standalone - en módulos tradicionales
- Componente tradicional a un Standalone
- Código fuente de la sección

Sección 23 - Directivas personalizadas
- Introducción a la sección
- Temas puntuales de la sección
- Nota de actualización
- Inicio de proyecto -Directivas + Signals
- Estructura de la aplicación
- Formulario reactivo tradicional
- Custom Label - Directiva personalizada
- Directive Input - Cambiar el color del host
- Cambiar el mensaje de la etiqueta
- Solución de la tarea
- Código fuente de la sección

Sección 24 - Signals en Angular - Angular 16+
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Menú lateral
- Nuestra primera señal - Signal
- Counter Signal
- Información de usuario
- Señales - Información del usuario
- Manejo de errores y propiedades computadas
- Estructura de pantalla
- Mutaciones - Actualizar parte del estado
- Efectos con señales
- Código fuente de la sección

Sección 25 - Auth MEAN - Nest Backend
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de backend - NestBackend
- Configurar MongoDB - Docker
- Creando un CRUD completo - Nest
- Conectar Nest con MongoDB
- Variables de entorno
- Crear modelo y esquema
- DTO - Data Transfer Object
- Crear un registro de base de datos
- Encriptar la contraseña
- Login - Verificar correo y contraseña
- Generar JWT
- Registro de usuario e interfaces
- Solución de la tarea
- Proteger rutas con autenticación
- Validar JWT y obtener usuario
- Tarea - Generar un nuevo JWT
- Código fuente de la sección

Sección 26 - AuthApp - Backend + Angular App
- Introducción a la sección
- Temas puntuales de la sección
- Material de clase
- Inicio de aplicación - AuthApp
- Estructura del proyecto
- Diseño de la pantalla de Login - HTML
- Formulario de inicio de sesión
- AuthService
- Tipos e interfaces
- Post - Login
- Manejo de errores
- Function Guards
- Implementar lógica del Functional Guard
- Servicio para verificar el Token de acceso
- No te repitas a ti mismo - DRY
- Reaccionar al cambio de autenticación
- isNotAuthenticated Guard
- Logout
- Código fuente de la sección

Sección 27 - Despliegues a producción - Backend y Frontend
- Introducción a la sección
- Temas puntuales de la sección
- Levantar proyecto - DeveloperMode
- Enlaces a consultar
- Aprovisionar MongoDB
- Configuraciones del backend
- Desplegar Backend a Railway
- Probar backend desde Postman
- Desplegar aplicación de Angular
- Código fuente de la sección

Sección 28: Angular 18+ - Nuevas características
- Introducción a la sección
- Temas puntuales de la sección
- Demostración de la sección
- Nota útil
- Inicio de proyecto - MyDashboard
- Cambios en la estructura del proyecto
- Tailwind en Angular
- Creación de archivos y directorios
- Configuración de rutas
- Configuración del dashboard - Tailwind
- @for - @if - Nueva sintaxis
- Configurar alias de importaciones en TypeScript
- Control Flow - @If
- Control Flow - @Switch
- Control Flow - @For
- Required @Input
- ChangeDetection - OnPush
- Defer Blocks
- Defer Triggers
- Defer Triggers - Interacciones
- Defer Triggers - Interacciones - Parte 2
- ViewTransitions API
- Hero Animation - View Transitions
- Servicios con señales
- Peticiones HTTP - importProvidersFrom
- De observable a Señal - toSignal
- Tarea - Computed Signals
- Código fuente de la sección

Sección 29: Nuevos Inputs, Outputs y Angular Material 3
- Introducción
- Temas puntuales de la sección
- Actualización de un proyecto de Angular
- Preparar página para Input y Output
- Añadir productos dinámicamente
- Funciones Input y Output
- Angular Material 3 - Instalación
- Usar componentes de Angular Material
- Material Bottom Sheet
- Cambiar tema de Angular Material
- Funciones en el router
- Código fuente de la sección

Sección 30: Fin del curso
- Documentos complementarios sobre Angular
- Más información sobre nuestros otros cursos
- Despedida

Sección 31: Bonus: Mapas - Marcadores y Direcciones con Mapbox
- Temas puntuales de la sección
- Demostración del objetivo final
- Nota de actualización
- Inicio de proyecto - MapasApp
- Configuraciones iniciales del proyecto
- Obtener la geolocalización del usuario
- Mostrar un mensaje de carga
- Mostrar un mapa de Mapbox
- Marcadores y Popups
- Boton flotante y Logo de Angular
- Servicio para controlar el mapa
- Diseño de componentes de búsqueda y detalles
- Debounce Manual
- Realizar petición HTTP para obtener lugares
- Custom Http Client - PlacesApiClient
- Mostrar los resultados de la búsqueda
- Agregar marcadores en los lugares encontrados
- Ajustar el mapa para mostrar todos los marcadores encontrados
- Obtener la ruta entre dos puntos
- Obtener la distancia y duración del recorrido
- Dibujar la polyline
- Ocultar el menu de lugares
- Desplegar la aplicación de mapas
- Código fuente de la sección', '{}', 'public-page-playwright-v1');
INSERT INTO public.courses OVERRIDING SYSTEM VALUE VALUES (129, 'Vue-intermedio', 'Vue.js - Intermedio: Lleva tus bases al siguiente nivel', 'https://cursos.devtalles.com/courses/Vue-intermedio', 'https://import.cdn.thinkific.com/643563/Mecj0WPdQyOMPKxtYqG1_vue_ts2.jpg', 'Portada del curso: Vue.js - Intermedio: Lleva tus bases al siguiente nivel', NULL, '[]', true, '2026-09-23', '2026-09-24 15:47:08.091899+00', '2026-09-24 15:47:08.091899+00', 'Lleva tus bases de Vue.js al siguiente nivel siguiendo recomendaciones actuales recomendadas por el equipo de Vue.js. Aquí aprenderás a trabajar con TypeScript, Pinia, TanStack Query, Script Setup y el composition API.', 810, 'es', '{"Vue moderno: Script Setup, Composition API y TypeScript.","Manejo de estado: Pinia y Vue Query para estado global y estado asíncrono.","Desarrollo profesional: Vue Router, Axios, Quasar y reutilización de componentes.","Buenas prácticas: Tipado estricto, manejo de errores y optimización del rendimiento.","Vue 3: Script Setup y Composition API.","Vue Query: Queries, Mutations, caché, QueryClient, Prefetch y manejo manual de caché.","Pinia: Options Store y Setup Store.","Quasar: Sistema de estilos, temas, Boot Files e íconos.","Vue Router: Rutas simples, anidadas y Lazy Loading.","Integraciones: Axios, GitHub API y Vue DevTools.","Arquitectura: TypeScript, interfaces, componentes reutilizables, modales y loaders.","Y mucho más...","Dominarás el desarrollo moderno con Vue 3 utilizando Script Setup y Composition API.","Aprenderás a combinar Pinia y Vue Query para crear aplicaciones rápidas y escalables.","Desarrollarás componentes reutilizables con TypeScript y una arquitectura fácil de mantener.","Mejorarás la experiencia de usuario mediante un manejo eficiente del estado y las peticiones HTTP."}', 'https://cursos.devtalles.com/courses/Vue-intermedio', '2026-09-24 15:49:29.94579+00', '{"Conocimiento básico de Vue es recomendado (options api o composition api)","Conocimiento básico de TypeScript es recomendado"}', '{}', 'Sección 1: Introducción al curso
- Introducción al curso
- ¿Cómo hacer preguntas?
- Instalaciones necesarias y recomendadas
- Hojas de atajos - Vue y Vue-TS
- ¡Únete a Nuestra Comunidad de DevTalles en Discord!

Sección 2: Vue.js + Composition API + TypeScript - Primeros Pasos
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto
- Explicación de la estructura de directorios
- Limpieza del proyecto
- Counter - Script Setup
- Funcionalidad del counter
- Consideraciones del Script Setup
- Estructura de directorios recomendada
- Router principal y re-dirección
- RouterView, NavLink y NavBar
- defineProps - Script Setup
- Tipos específicos de datos en Props
- Rutas Hijas
- NavBar secundario
- Configuración de las rutas hijas
- Código fuente de la sección

Sección 3: Técnicas para peticiones HTTP
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Realizar petición HTTP básica
- Colocar el tipo de dato de la respuesta
- Obtener listado de Pokemons
- Vue Suspense
- Suspense Loading State
- Composable functions - useCharacters con estado local
- Composable functions - useCharacters con estado global
- Vue TanStack Query
- useQuery
- Composable + useQuery
- Pasar props padre hijo
- Código fuente de la sección

Sección 4: Gestor de estado reactivo propio de Vue
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- State Management Nativo de Vue
- Initial State
- Llamar métodos del Store
- Conectar Store con VueQuery
- Manejo de errores
- Crear pantalla de Pokémon por ID
- Obtener información por ID
- Solución de la tarea
- Código fuente de la sección

Sección 5: Pensemos en composables
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Remover opciones del menú
- Artículo para la próxima clase
- Pre-fetch - Vue Query
- Invalidar Queries
- Data inicial
- Investigaciones adicionales
- Código fuente de la sección

Sección 6: Pinia - Gestor de estado - Introducción
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - PiniaApp
- Limpieza y configuración inicial
- Instalar Pinia - Primer Store
- Counter Options Store
- Finalizar el counter options store
- Counter Setup Store
- Consumo del CounterSetupStore
- Código fuente de la sección

Sección 7: Pinia - Paginación y Mantenimiento
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Estructura del ejercicio - Clientes
- JSON Server
- Clients Store e interfaz
- Estructura de los componentes que usaremos
- Obtener los primeros 10 clientes - TanStack Axios
- Patrón adaptador con composables
- Diseño del componente de paginación
- Cambiar Current Page
- Cargar clientes basados en la página actual
- Jugar con useQuery
- Loading Modal
- Optimizaciones de nuestro código
- Resolución de la tarea
- Código fuente de la sección

Sección 8: Mutaciones y queries
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Cargar información del cliente por id
- Mutation - TanStack
- Notificar al usuario de lo que está sucediendo
- Invalidar data - TanStack
- Manejo de errores
- Solución a la tarea
- Código fuente de la sección

Sección 9: Quasar - Vue Query - TS - Pinia
- Introducción a la sección
- Temas puntuales de la sección
- Inicio de proyecto - IssuesApp
- Archivos y directorios de un proyecto de Quasar
- Estructura inicial del proyecto
- Listado de issues - estructura
- Filter Selector
- Issue List e Issue Card
- Issue Page - Mostrar un issue de forma individual
- IssuesStore - Pinia
- VueQuery + ENVs + Quasar
- Obtener los labels de GitHub
- Solución de la tarea
- Labels seleccionados
- Fin de la sección
- Código fuente de la sección

Sección 10: Filtros, relaciones y caché
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de la sección
- Cargar 10 issues
- Mostrar los issues en pantalla
- Fechas y Markdown
- Issue Page
- Comentarios del issue
- Token de autenticación - GitHub
- Aplicar filtros
- Desacoplar los composables
- Precargar peticiones antes de tiempo
- Establecer un valor en caché manualmente
- Código fuente de la sección

Sección 11: Mutaciones
- Introducción a la sección
- Temas puntuales de la sección
- Continuación de proyecto
- Crear repositorio en GitHub
- Botones flotantes
- Solución de la tarea
- Diálogos de Quasar
- Markdown Editor
- Props del diálogo
- Preparación para la creación de issues
- Grabación del issue
- Después de inserción
- Código fuente de la sección

Sección 12: Fin del curso
- Más información sobre nuestros otros cursos
- Despedida del curso', '{}', 'public-page-playwright-v1');


--
-- TOC entry 4080 (class 0 OID 17520)
-- Dependencies: 294
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (1, 'Accesibilidad', 'accesibilidad');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (2, 'Agentes de IA', 'agentes-ia');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (3, 'Android', 'android');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (4, 'Angular', 'angular');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (5, 'APIs', 'apis');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (6, 'Arquitectura de software', 'arquitectura-de-software');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (7, 'Arquitectura hexagonal', 'arquitectura-hexagonal');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (8, 'Asistentes de IA', 'asistentes-ia');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (9, 'Astro', 'astro');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (10, 'Autenticación', 'autenticacion');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (11, 'Automatización', 'automatizacion');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (12, 'AWS', 'aws');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (13, 'Blazor', 'blazor');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (14, 'BLoC', 'bloc');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (15, 'Bun', 'bun');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (16, 'Claude API', 'claude-api');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (17, 'Claude Code', 'claude-code');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (18, 'Clean Architecture', 'clean-architecture');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (19, 'Clean Code', 'clean-code');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (20, 'Componentes de UI', 'componentes-ui');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (21, 'Composition API', 'composition-api');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (22, 'Concurrencia', 'concurrencia');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (23, 'Contenedores', 'contenedores');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (24, 'Control de versiones', 'control-de-versiones');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (25, 'C#', 'csharp');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (26, 'CSS', 'css');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (27, 'Dart', 'dart');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (28, 'Django', 'django');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (29, 'Docker', 'docker');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (30, '.NET', 'dotnet');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (31, 'Enrutamiento', 'enrutamiento');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (32, 'Expo', 'expo');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (33, 'FastAPI', 'fastapi');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (34, 'Flutter', 'flutter');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (35, 'Flutter Web', 'flutter-web');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (36, 'Fundamentos de programación', 'fundamentos-de-programacion');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (37, 'Gemini', 'gemini');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (38, 'Gestión de estado', 'gestion-de-estado');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (39, 'Git', 'git');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (40, 'GitHub', 'github');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (41, 'Go', 'go');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (42, 'GraphQL', 'graphql');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (43, 'Ingeniería de prompts', 'ingenieria-de-prompts');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (44, 'Inteligencia artificial', 'inteligencia-artificial');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (45, 'iOS', 'ios');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (46, 'Java', 'java');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (47, 'JavaScript', 'javascript');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (48, 'JWT', 'jwt');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (49, 'Laravel', 'laravel');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (50, 'LLM', 'llm');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (51, 'MCP', 'mcp');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (52, 'Microservicios', 'microservicios');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (53, 'Minimal API', 'minimal-api');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (54, 'MVC', 'mvc');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (55, 'n8n', 'n8n');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (56, 'NestJS', 'nestjs');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (57, 'Next.js', 'nextjs');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (58, 'NgModules', 'ngmodules');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (59, 'Node.js', 'nodejs');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (60, 'Nuxt', 'nuxt');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (61, 'OpenAI', 'openai');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (62, 'OpenCode', 'opencode');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (63, 'Options API', 'options-api');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (64, 'Patrones de diseño', 'patrones-de-diseno');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (65, 'PDF', 'pdf');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (66, 'PHP', 'php');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (67, 'PostgreSQL', 'postgresql');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (68, 'Programación reactiva', 'programacion-reactiva');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (69, 'Pruebas end to end', 'pruebas-e2e');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (70, 'Pruebas unitarias', 'pruebas-unitarias');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (71, 'Python', 'python');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (72, 'Qwik', 'qwik');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (73, 'RAG', 'rag');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (74, 'React', 'react');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (75, 'React Native', 'react-native');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (76, 'React Router', 'react-router');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (77, 'Recursos nativos', 'recursos-nativos');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (78, 'Reportes', 'reportes');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (79, 'Repository Pattern', 'repository-pattern');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (80, 'REST', 'rest');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (81, 'Riverpod', 'riverpod');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (82, 'shadcn/ui', 'shadcn-ui');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (83, 'SOLID', 'solid');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (84, 'Spring AI', 'spring-ai');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (85, 'Spring Boot', 'spring-boot');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (86, 'SQL', 'sql');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (87, 'SQL Server', 'sql-server');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (88, 'Tailwind CSS', 'tailwind-css');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (89, 'TanStack Query', 'tanstack-query');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (90, 'Testing', 'testing');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (91, 'TypeScript', 'typescript');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (92, 'Vibe Coding', 'vibe-coding');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (93, 'Visual Studio Code', 'vscode');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (94, 'Vue.js', 'vue');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (95, 'WebSockets', 'websockets');
INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (96, 'Zustand', 'zustand');


--
-- TOC entry 4096 (class 0 OID 0)
-- Dependencies: 291
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 18, true);


--
-- TOC entry 4097 (class 0 OID 0)
-- Dependencies: 289
-- Name: courses_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_course_id_seq', 129, true);


--
-- TOC entry 4098 (class 0 OID 0)
-- Dependencies: 293
-- Name: tags_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_tag_id_seq', 96, true);


--
-- TOC entry 3911 (class 2606 OID 17518)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 3917 (class 2606 OID 17529)
-- Name: course_categories course_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_categories
    ADD CONSTRAINT course_categories_pkey PRIMARY KEY (course_id, category_id);


--
-- TOC entry 3920 (class 2606 OID 17544)
-- Name: course_tags course_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_tags
    ADD CONSTRAINT course_tags_pkey PRIMARY KEY (course_id, tag_id);


--
-- TOC entry 3905 (class 2606 OID 17509)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- TOC entry 3907 (class 2606 OID 17511)
-- Name: courses courses_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_slug_key UNIQUE (slug);


--
-- TOC entry 3915 (class 2606 OID 17524)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- TOC entry 3912 (class 1259 OID 17555)
-- Name: ix_categories_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_categories_slug ON public.categories USING btree (slug);


--
-- TOC entry 3918 (class 1259 OID 17643)
-- Name: ix_course_categories_category_id_course_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_course_categories_category_id_course_id ON public.course_categories USING btree (category_id, course_id);


--
-- TOC entry 3921 (class 1259 OID 17642)
-- Name: ix_course_tags_tag_id_course_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_course_tags_tag_id_course_id ON public.course_tags USING btree (tag_id, course_id);


--
-- TOC entry 3908 (class 1259 OID 17640)
-- Name: ix_courses_is_active_level; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_courses_is_active_level ON public.courses USING btree (is_active, level);


--
-- TOC entry 3909 (class 1259 OID 17641)
-- Name: ix_courses_title_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_courses_title_trgm ON public.courses USING gin (title public.gin_trgm_ops);


--
-- TOC entry 3913 (class 1259 OID 17558)
-- Name: ix_tags_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_tags_slug ON public.tags USING btree (slug);


--
-- TOC entry 3922 (class 2606 OID 17530)
-- Name: course_categories FK_course_categories_categories_category_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_categories
    ADD CONSTRAINT "FK_course_categories_categories_category_id" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3923 (class 2606 OID 17535)
-- Name: course_categories FK_course_categories_courses_course_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_categories
    ADD CONSTRAINT "FK_course_categories_courses_course_id" FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- TOC entry 3924 (class 2606 OID 17545)
-- Name: course_tags FK_course_tags_courses_course_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_tags
    ADD CONSTRAINT "FK_course_tags_courses_course_id" FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- TOC entry 3925 (class 2606 OID 17550)
-- Name: course_tags FK_course_tags_tags_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_tags
    ADD CONSTRAINT "FK_course_tags_tags_tag_id" FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- TOC entry 4088 (class 0 OID 0)
-- Dependencies: 292
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categories TO anon;
GRANT ALL ON TABLE public.categories TO authenticated;
GRANT ALL ON TABLE public.categories TO service_role;


--
-- TOC entry 4089 (class 0 OID 0)
-- Dependencies: 291
-- Name: SEQUENCE categories_category_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.categories_category_id_seq TO anon;
GRANT ALL ON SEQUENCE public.categories_category_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.categories_category_id_seq TO service_role;


--
-- TOC entry 4090 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE course_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.course_categories TO anon;
GRANT ALL ON TABLE public.course_categories TO authenticated;
GRANT ALL ON TABLE public.course_categories TO service_role;


--
-- TOC entry 4091 (class 0 OID 0)
-- Dependencies: 296
-- Name: TABLE course_tags; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.course_tags TO anon;
GRANT ALL ON TABLE public.course_tags TO authenticated;
GRANT ALL ON TABLE public.course_tags TO service_role;


--
-- TOC entry 4092 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE courses; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.courses TO anon;
GRANT ALL ON TABLE public.courses TO authenticated;
GRANT ALL ON TABLE public.courses TO service_role;


--
-- TOC entry 4093 (class 0 OID 0)
-- Dependencies: 289
-- Name: SEQUENCE courses_course_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.courses_course_id_seq TO anon;
GRANT ALL ON SEQUENCE public.courses_course_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.courses_course_id_seq TO service_role;


--
-- TOC entry 4094 (class 0 OID 0)
-- Dependencies: 294
-- Name: TABLE tags; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tags TO anon;
GRANT ALL ON TABLE public.tags TO authenticated;
GRANT ALL ON TABLE public.tags TO service_role;


--
-- TOC entry 4095 (class 0 OID 0)
-- Dependencies: 293
-- Name: SEQUENCE tags_tag_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.tags_tag_id_seq TO anon;
GRANT ALL ON SEQUENCE public.tags_tag_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.tags_tag_id_seq TO service_role;


-- Completed on 2026-09-26 21:29:15

--
-- PostgreSQL database dump complete
--
