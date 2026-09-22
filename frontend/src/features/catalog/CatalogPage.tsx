import {
  useCallback,
  useEffect,
  useMemo,
  useState,
} from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import {
  ArrowUpRight,
  BookOpen,
  RefreshCw,
  Search,
  Sparkles,
} from 'lucide-react';

import { apiUrl } from '../../config/api';
import './CatalogPage.css';

type Course = {
  courseId: number;
  slug: string;
  title: string;
  level: string | null;
  imageUrl: string;
  imageAlt: string;
  courseUrl: string;
};

const INITIAL_VISIBLE_COURSES = 12;
const COURSES_INCREMENT = 12;

export function CatalogPage() {
  const { t } = useTranslation();

  const [courses, setCourses] = useState<Course[]>([]);
  const [search, setSearch] = useState('');
  const [visibleCourses, setVisibleCourses] = useState(
    INITIAL_VISIBLE_COURSES,
  );

  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadCourses = useCallback(async () => {
    setIsLoading(true);
    setError(null);

    try {
      const response = await fetch(`${apiUrl}/courses`, {
        headers: {
          Accept: 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data: Course[] = await response.json();

      setCourses(data);
    } catch (loadError) {
      console.error('Error cargando cursos:', loadError);

      setError(
        'No pudimos cargar los cursos en este momento.',
      );
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    document.title = 'Catálogo · CODE QUEST 2026';
  }, []);

  useEffect(() => {
    void loadCourses();
  }, [loadCourses]);

  useEffect(() => {
    setVisibleCourses(INITIAL_VISIBLE_COURSES);
  }, [search]);

  const filteredCourses = useMemo(() => {
    const normalizedSearch = search
      .trim()
      .toLocaleLowerCase();

    if (!normalizedSearch) {
      return courses;
    }

    return courses.filter((course) =>
      course.title
        .toLocaleLowerCase()
        .includes(normalizedSearch),
    );
  }, [courses, search]);

  const displayedCourses = filteredCourses.slice(
    0,
    visibleCourses,
  );

  const hasMore =
    displayedCourses.length < filteredCourses.length;

  if (isLoading) {
    return <CatalogSkeleton />;
  }

  if (error) {
    return (
      <section className="catalog-state">
        <div className="catalog-state__visual">
          <BookOpen size={34} />
        </div>

        <p className="catalog-state__eyebrow">
          CATÁLOGO
        </p>

        <h1>No pudimos abrir el catálogo</h1>

        <p>{error}</p>

        <button
          type="button"
          className="cq-button cq-button--primary"
          onClick={() => void loadCourses()}
        >
          <RefreshCw size={18} />
          Intentar nuevamente
        </button>
      </section>
    );
  }

  return (
    <div className="catalog-page">
      <section className="catalog-hero">
        <div className="catalog-hero__content">
          <span className="catalog-eyebrow">
            <Sparkles size={15} />
            CATÁLOGO DE APRENDIZAJE
          </span>

          <h1>
            Explorá los cursos de{' '}
            <span>DevTalles</span>
          </h1>

          <p className="catalog-hero__description">
            Descubrí los cursos disponibles y explorá
            todo lo que podés aprender. CODE QUEST usa
            este catálogo para construir rutas adaptadas
            a tus objetivos.
          </p>

          <div className="catalog-hero__meta">
            <div className="catalog-count">
              <BookOpen size={18} />

              <div>
                <strong>{courses.length}</strong>
                <span> cursos disponibles</span>
              </div>
            </div>
          </div>
        </div>

        <div
          className="catalog-hero__orbit"
          aria-hidden="true"
        >
          <div className="catalog-hero__planet" />
          <div className="catalog-hero__orbit-line" />
          <div className="catalog-hero__star catalog-hero__star--1" />
          <div className="catalog-hero__star catalog-hero__star--2" />
        </div>
      </section>

      <section
        className="catalog-content"
        aria-labelledby="catalog-results-title"
      >
        <div className="catalog-toolbar">
          <div>
            <p className="catalog-toolbar__eyebrow">
              EXPLORAR
            </p>

            <h2 id="catalog-results-title">
              Cursos disponibles
            </h2>
          </div>

          <label className="catalog-search">
            <Search size={19} />

            <input
              type="search"
              value={search}
              onChange={(event) =>
                setSearch(event.target.value)
              }
              placeholder="Buscar cursos..."
              aria-label="Buscar cursos por nombre"
            />
          </label>
        </div>

        <div
          className="catalog-results-info"
          aria-live="polite"
        >
          {search ? (
            <span>
              {filteredCourses.length}{' '}
              {filteredCourses.length === 1
                ? 'resultado'
                : 'resultados'}{' '}
              para <strong>“{search}”</strong>
            </span>
          ) : (
            <span>
              Mostrando {displayedCourses.length} de{' '}
              {courses.length} cursos
            </span>
          )}
        </div>

        {filteredCourses.length === 0 ? (
          <div className="catalog-empty">
            <div className="catalog-empty__icon">
              <Search size={28} />
            </div>

            <h3>No encontramos ese curso</h3>

            <p>
              Probá buscando otra tecnología, framework
              o lenguaje.
            </p>

            <button
              type="button"
              className="cq-button cq-button--secondary"
              onClick={() => setSearch('')}
            >
              Limpiar búsqueda
            </button>
          </div>
        ) : (
          <>
            <div className="catalog-grid">
              {displayedCourses.map((course) => (
                <CourseCard
                  key={course.courseId}
                  course={course}
                />
              ))}
            </div>

            {hasMore && (
              <div className="catalog-load-more">
                <button
                  type="button"
                  className="cq-button cq-button--secondary"
                  onClick={() =>
                    setVisibleCourses(
                      (current) =>
                        current + COURSES_INCREMENT,
                    )
                  }
                >
                  Mostrar más cursos
                </button>

                <span>
                  {filteredCourses.length -
                    displayedCourses.length}{' '}
                  restantes
                </span>
              </div>
            )}
          </>
        )}
      </section>

      <section className="catalog-cta">
        <div>
          <span className="catalog-cta__eyebrow">
            ¿NO SABÉS POR DÓNDE EMPEZAR?
          </span>

          <h2>
            No necesitás elegir tu camino a ciegas.
          </h2>

          <p>
            Completá tu perfil de aprendizaje y CODE
            QUEST puede ayudarte a organizar estos cursos
            en una ruta pensada para vos.
          </p>
        </div>

        <Link
          to="/learning-profile"
          className="cq-button cq-button--primary"
        >
          Crear mi ruta
          <ArrowUpRight size={18} />
        </Link>
      </section>
    </div>
  );
}

function CourseCard({
  course,
}: {
  course: Course;
}) {
  const [imageFailed, setImageFailed] =
    useState(false);

  return (
    <article className="course-card">
      <div className="course-card__media">
        {!imageFailed ? (
          <img
            src={course.imageUrl}
            alt={course.imageAlt}
            loading="lazy"
            onError={() => setImageFailed(true)}
          />
        ) : (
          <div className="course-card__fallback">
            <BookOpen size={32} />
            <span>DevTalles</span>
          </div>
        )}
      </div>

      <div className="course-card__content">
        <div className="course-card__meta">
          <span>DEVTALLES</span>

          {course.level && (
            <span className="course-card__level">
              {course.level}
            </span>
          )}
        </div>

        <h3>{course.title}</h3>

        <div className="course-card__footer">
          <a
            href={course.courseUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="course-card__link"
          >
            Ver en DevTalles
            <ArrowUpRight size={17} />
          </a>
        </div>
      </div>
    </article>
  );
}

function CatalogSkeleton() {
  return (
    <div className="catalog-page">
      <section className="catalog-hero catalog-hero--loading">
        <div>
          <div className="catalog-skeleton catalog-skeleton--small" />
          <div className="catalog-skeleton catalog-skeleton--title" />
          <div className="catalog-skeleton catalog-skeleton--text" />
        </div>
      </section>

      <section className="catalog-content">
        <div className="catalog-skeleton-grid">
          {Array.from({ length: 8 }).map(
            (_, index) => (
              <div
                className="catalog-card-skeleton"
                key={index}
              >
                <div className="catalog-skeleton catalog-skeleton--image" />

                <div className="catalog-card-skeleton__content">
                  <div className="catalog-skeleton catalog-skeleton--small" />
                  <div className="catalog-skeleton catalog-skeleton--course-title" />
                  <div className="catalog-skeleton catalog-skeleton--button" />
                </div>
              </div>
            ),
          )}
        </div>
      </section>
    </div>
  );
}
