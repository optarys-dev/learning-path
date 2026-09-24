/**
 * A deliberately curated route used only by the landing-page illustration.
 *
 * The public catalog remains API-driven. Keeping this sequence local makes the
 * story stable and prevents the first page of the catalog from changing the
 * learning narrative shown on the home page.
 */
export interface FeaturedCourse {
  courseId: number;
  title: string;
  imageUrl: string;
  courseUrl: string;
}

export const featuredCourses: readonly FeaturedCourse[] = [
  {
    courseId: 61,
    title: 'Programación para principiantes: Primeros pasos',
    imageUrl: 'https://import.cdn.thinkific.com/643563/slRm7OvQRZySnHeaaw0w_PROGRAMACION%20PARA%20PRINCIPIANTES.jpg',
    courseUrl: 'https://cursos.devtalles.com/courses/programacion-para-principiantes',
  },
  {
    courseId: 68,
    title: 'JavaScript Moderno: Guía para dominar el lenguaje',
    imageUrl: 'https://import.cdn.thinkific.com/643563/rfX8tJ4ZRHi6L4WFj2sW_JAVASCRIPT.jpg',
    courseUrl: 'https://cursos.devtalles.com/courses/javascript-moderno',
  },
  {
    courseId: 26,
    title: 'React: de cero a experto',
    imageUrl: 'https://import.cdn.thinkific.com/643563/TTTUJiUVTvGC5cy5Z3UW_COVER-DEVTALLES-REACT.jpg',
    courseUrl: 'https://cursos.devtalles.com/courses/react-de-cero',
  },
  {
    courseId: 71,
    title: 'React PRO: Lleva tus bases al siguiente nivel',
    imageUrl: 'https://import.cdn.thinkific.com/643563/sHm63uuSkiPxQqbElhTQ_REACT-PRO-NEW.jpg',
    courseUrl: 'https://cursos.devtalles.com/courses/react-pro',
  },
];
