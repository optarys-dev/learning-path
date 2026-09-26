import { useCallback, useEffect, useState } from 'react';
import { getCatalogCourses } from '../api/getCatalogCourses';
import type { CatalogPageResult } from '../types';

export function useCatalogCourses() {
  const [page, setPage] = useState(1);
  const [refreshIndex, setRefreshIndex] = useState(0);
  const requestKey = `${page}:${refreshIndex}`;
  const [result, setResult] = useState<{ key: string; data: CatalogPageResult | null; error: Error | null }>({ key: '', data: null, error: null });

  useEffect(() => {
    const controller = new AbortController();

    void getCatalogCourses(page, controller.signal)
      .then(data => { if (!controller.signal.aborted) setResult({ key: requestKey, data, error: null }); })
      .catch(reason => {
        if (controller.signal.aborted) return;
        setResult({ key: requestKey, data: null, error: reason instanceof Error ? reason : new Error('Unable to load catalog.') });
      });

    return () => controller.abort();
  }, [page, requestKey]);

  const reload = useCallback(() => setRefreshIndex(current => current + 1), []);
  return { data: result.key === requestKey ? result.data : null, error: result.key === requestKey ? result.error : null, isLoading: result.key !== requestKey, page, reload, setPage };
}
