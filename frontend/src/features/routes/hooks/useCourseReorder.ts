import { useLayoutEffect, useRef, useState, type DragEvent, type RefObject } from 'react';
import { moveCourseTo } from '@/features/routes/model/reorderCourses';

type KeyedCourse = { uiKey: string; title: string };
type DropTarget = { courseKey: string; position: 'before' | 'after' } | null;
const reorderDurationMs = 180;

/** Owns drag preview and FLIP motion; the page owns committing its draft and feedback. */
export function useCourseReorder<T extends KeyedCourse>(courses: T[], elements: RefObject<Map<string, HTMLElement>>,
  onReorder: (courses: T[], moved: T, position: number) => void) {
  const [preview, setPreview] = useState<T[] | null>(null);
  const [dragging, setDragging] = useState<string | null>(null);
  const [dropTarget, setDropTarget] = useState<DropTarget>(null);
  const source = useRef<string | null>(null);
  const previewRef = useRef<T[] | null>(null);
  const lastTarget = useRef<string | null>(null);
  const previousRects = useRef<Map<string, DOMRect> | null>(null);

  useLayoutEffect(() => {
    const previous = previousRects.current;
    previousRects.current = null;
    if (!previous || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    elements.current.forEach((element, key) => {
      const old = previous.get(key);
      if (!old) return;
      const offsetY = old.top - element.getBoundingClientRect().top;
      if (Math.abs(offsetY) < 1) return;
      element.animate([{ transform: 'translateY(' + offsetY + 'px)' }, { transform: 'translateY(0)' }],
        { duration: reorderDurationMs, easing: 'ease-out' });
    });
  }, [preview, elements]);

  function reset() {
    source.current = null; previewRef.current = null; lastTarget.current = null;
    previousRects.current = null;
    setDragging(null); setPreview(null); setDropTarget(null);
  }

  function bindCourse(courseKey: string) {
    return {
      dragging: dragging === courseKey,
      dropPosition: dropTarget?.courseKey === courseKey ? dropTarget.position : null,
      elementRef: (element: HTMLElement | null) => {
        if (element) elements.current.set(courseKey, element);
        else elements.current.delete(courseKey);
      },
      onDragStart: (event: DragEvent<HTMLElement>) => {
        source.current = courseKey; previewRef.current = [...courses]; lastTarget.current = null;
        setPreview(previewRef.current); setDragging(courseKey);
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('text/plain', courseKey);
      },
      onDragOver: (event: DragEvent<HTMLElement>) => {
        if (!source.current) return;
        event.preventDefault(); event.dataTransfer.dropEffect = 'move';
        if (source.current === courseKey || lastTarget.current === courseKey) return;
        const current = previewRef.current ?? courses;
        const next = moveCourseTo(current, source.current, courseKey);
        if (next === current) return;
        const sourceIndex = current.findIndex(course => course.uiKey === source.current);
        const targetIndex = current.findIndex(course => course.uiKey === courseKey);
        setDropTarget({ courseKey, position: sourceIndex < targetIndex ? 'after' : 'before' });
        lastTarget.current = courseKey;
        previousRects.current = new Map([...elements.current].map(([key, element]) => [key, element.getBoundingClientRect()]));
        previewRef.current = next; setPreview(next);
      },
      onDrop: (event: DragEvent<HTMLElement>) => {
        event.preventDefault();
        const key = source.current ?? event.dataTransfer.getData('text/plain');
        const next = previewRef.current;
        if (next && next.some((course, index) => course.uiKey !== courses[index]?.uiKey)) {
          const position = next.findIndex(course => course.uiKey === key);
          if (position >= 0) onReorder(next, next[position], position + 1);
        }
        reset();
      },
      onDragEnd: reset,
    };
  }
  return { displayedCourses: preview ?? courses, bindCourse };
}
