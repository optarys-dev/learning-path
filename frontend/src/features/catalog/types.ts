export interface CatalogCourse {
  courseId: number;
  slug: string;
  title: string;
  level: string | null;
  imageUrl: string;
  imageAlt: string;
  courseUrl: string;
}

export interface CatalogPageResult {
  items: CatalogCourse[];
  page: number;
  pageSize: number;
  totalCount: number;
  totalPages: number;
  hasPreviousPage: boolean;
  hasNextPage: boolean;
}
