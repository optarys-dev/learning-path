import { useEffect, useRef, type DragEvent, type PointerEvent } from 'react';

const desktopRouteMinWidthRem = 64;

function usesDesktopRouteLayout(element: HTMLElement): boolean {
  const styles = getComputedStyle(element);
  const contentWidth = element.clientWidth
    - Number.parseFloat(styles.paddingLeft)
    - Number.parseFloat(styles.paddingRight);
  const rootFontSize = Number.parseFloat(getComputedStyle(document.documentElement).fontSize);
  return contentWidth >= desktopRouteMinWidthRem * rootFontSize;
}

/** Isolates the DOM drag image, pointer offsets and their cleanup from the course UI. */
export function useCourseDragPreview(onDragStart: (event: DragEvent<HTMLElement>) => void, onDragEnd: () => void) {
  const dragBlocked = useRef(false);
  const dragPreview = useRef<HTMLElement | null>(null);
  const dragGhost = useRef<HTMLCanvasElement | null>(null);
  const dragMoveListener = useRef<((event: globalThis.DragEvent) => void) | null>(null);
  const dragLayoutObserver = useRef<ResizeObserver | null>(null);
  const dragActive = useRef(false);
  const dragOffset = useRef({ x: 0, y: 0 });
  const dragFrame = useRef<number | null>(null);
  useEffect(() => () => {
    if (dragFrame.current !== null) cancelAnimationFrame(dragFrame.current);
    dragLayoutObserver.current?.disconnect();
    if (dragMoveListener.current) document.removeEventListener('dragover', dragMoveListener.current);
    dragGhost.current?.remove();
    dragPreview.current?.remove();
  }, []);

  function handlePointerDown(event: PointerEvent<HTMLElement>) {
    const target = event.target;
    dragBlocked.current = target instanceof Element && Boolean(target.closest(
      'button, a, input, select, textarea, [role="button"], [contenteditable="true"]',
    ));
    const bounds = event.currentTarget.getBoundingClientRect();
    dragOffset.current = {
      x: Math.max(0, Math.min(event.clientX - bounds.left, bounds.width)),
      y: Math.max(0, Math.min(event.clientY - bounds.top, bounds.height)),
    };
  }

  function handleDragStart(event: DragEvent<HTMLElement>) {
    if (dragBlocked.current) {
      event.preventDefault();
      dragBlocked.current = false;
      return;
    }

    const source = event.currentTarget;
    const bounds = source.getBoundingClientRect();
    const sourceStyles = getComputedStyle(source);
    dragPreview.current?.remove();
    const preview = source.cloneNode(true) as HTMLElement;
    preview.removeAttribute('id');
    preview.querySelectorAll('[id]').forEach(element => element.removeAttribute('id'));
    preview.removeAttribute('draggable');
    preview.setAttribute('aria-hidden', 'true');
    preview.classList.add('my-path__drag-preview');
    preview.style.width = `${bounds.width}px`;
    preview.style.minWidth = `${bounds.width}px`;
    preview.style.maxWidth = `${bounds.width}px`;
    preview.style.height = `${bounds.height}px`;
    preview.style.minHeight = `${bounds.height}px`;
    preview.style.maxHeight = `${bounds.height}px`;
    for (const property of [
      'align-items',
      'column-gap',
      'grid-template-areas',
      'grid-template-columns',
      'padding-bottom',
      'padding-left',
      'padding-right',
      'padding-top',
      'row-gap',
    ]) {
      preview.style.setProperty(property, sourceStyles.getPropertyValue(property));
    }
    const sourceVisual = source.querySelector<HTMLElement>('.my-path__course-visual');
    const previewVisual = preview.querySelector<HTMLElement>('.my-path__course-visual');
    if (sourceVisual && previewVisual) {
      const visualBounds = sourceVisual.getBoundingClientRect();
      previewVisual.style.width = `${visualBounds.width}px`;
      previewVisual.style.height = `${visualBounds.height}px`;
    }
    preview.style.setProperty('--my-path-drag-x', `${bounds.left}px`);
    preview.style.setProperty('--my-path-drag-y', `${bounds.top}px`);
    document.body.append(preview);
    dragPreview.current = preview;
    dragActive.current = true;

    onDragStart(event);
    const transparentDragImage = document.createElement('canvas');
    transparentDragImage.width = 1;
    transparentDragImage.height = 1;
    transparentDragImage.style.cssText = 'position:fixed;inset:0 auto auto 0;pointer-events:none;';
    document.body.append(transparentDragImage);
    dragGhost.current = transparentDragImage;
    event.dataTransfer.setDragImage(transparentDragImage, 0, 0);

    const moveListener = (dragEvent: globalThis.DragEvent) => {
      moveDragPreview(dragEvent.clientX, dragEvent.clientY);
    };
    dragMoveListener.current = moveListener;
    document.addEventListener('dragover', moveListener);

    const routePanel = source.closest<HTMLElement>('.my-path__route-panel');
    if (routePanel) {
      const startedInDesktopLayout = usesDesktopRouteLayout(routePanel);
      const observer = new ResizeObserver(() => {
        if (dragActive.current && usesDesktopRouteLayout(routePanel) !== startedInDesktopLayout) {
          handleDragEnd();
        }
      });
      observer.observe(routePanel);
      dragLayoutObserver.current = observer;
    }
  }

  function moveDragPreview(clientX: number, clientY: number) {
    if (!dragPreview.current || (clientX === 0 && clientY === 0)) return;
    if (dragFrame.current !== null) cancelAnimationFrame(dragFrame.current);
    const x = clientX - dragOffset.current.x;
    const y = clientY - dragOffset.current.y;
    dragFrame.current = requestAnimationFrame(() => {
      dragPreview.current?.style.setProperty('--my-path-drag-x', `${x}px`);
      dragPreview.current?.style.setProperty('--my-path-drag-y', `${y}px`);
      dragFrame.current = null;
    });
  }

  function handleDrag(event: DragEvent<HTMLElement>) {
    moveDragPreview(event.clientX, event.clientY);
  }

  function handleDragEnd() {
    const wasActive = dragActive.current;
    dragActive.current = false;
    dragBlocked.current = false;
    if (dragFrame.current !== null) cancelAnimationFrame(dragFrame.current);
    dragFrame.current = null;
    dragLayoutObserver.current?.disconnect();
    dragLayoutObserver.current = null;
    if (dragMoveListener.current) document.removeEventListener('dragover', dragMoveListener.current);
    dragMoveListener.current = null;
    dragGhost.current?.remove();
    dragGhost.current = null;
    dragPreview.current?.remove();
    dragPreview.current = null;
    if (wasActive) onDragEnd();
  }

  return {
    onPointerDownCapture: handlePointerDown,
    onPointerUpCapture: () => { dragBlocked.current = false; },
    onDragStart: handleDragStart,
    onDrag: handleDrag,
    onDragEnd: handleDragEnd,
  };
}
