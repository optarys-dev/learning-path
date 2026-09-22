export interface Course {
  courseId: number;
  slug: string;
  title: string;
  level: string | null;
  imageUrl: string;
  imageAlt: string;
  courseUrl: string;
}
