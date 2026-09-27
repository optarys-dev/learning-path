import { useEffect, useState } from 'react';
import { getAllCatalogCourses } from '@/features/catalog/api/getCatalogCourses';
import type { CatalogCourse } from '@/features/catalog/types';

const EMPTY_COURSES: CatalogCourse[] = [];

type CatalogState = { status: 'loading' } | { status: 'error' } | { status: 'ready'; courses: CatalogCourse[] };

/** The manual builder and course dialogs share the same loading/retry contract. */
export function useAllCatalogCourses() {
  const [state, setState] = useState<CatalogState>({ status: 'loading' });
  const [revision, setRevision] = useState(0);
  useEffect(() => {
    const controller = new AbortController();
    void getAllCatalogCourses(controller.signal).then(courses => {
      if (!controller.signal.aborted) setState({ status: 'ready', courses });
    }).catch(() => {
      if (!controller.signal.aborted) setState({ status: 'error' });
    });
    return () => controller.abort();
  }, [revision]);
  return { state, courses: state.status === 'ready' ? state.courses : EMPTY_COURSES, retry: () => { setState({ status: 'loading' }); setRevision(value => value + 1); } };
}
