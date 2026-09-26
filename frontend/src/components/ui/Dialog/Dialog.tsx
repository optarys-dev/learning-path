import { useEffect, useRef, type ReactNode } from 'react';
import { createPortal } from 'react-dom';
import './Dialog.css';

/** Native modal semantics provide focus containment and make the page inert. */
export function Dialog({ children, labelledBy, onClose, dismissible = true }: {
  children: ReactNode;
  labelledBy: string;
  onClose: () => void;
  dismissible?: boolean;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => {
    const dialog = ref.current;
    if (!dialog) return;
    const previousFocus = document.activeElement instanceof HTMLElement ? document.activeElement : null;
    const previousOverflow = document.body.style.overflow;
    dialog.showModal();
    dialog.querySelector<HTMLElement>('[data-dialog-initial-focus]')?.focus();
    document.body.style.overflow = 'hidden';
    return () => {
      dialog.close();
      document.body.style.overflow = previousOverflow;
      if (previousFocus?.isConnected) previousFocus.focus({ preventScroll: true });
    };
  }, []);
  return createPortal(<dialog ref={ref} className="cq-dialog-backdrop route-dialog-backdrop"
    aria-labelledby={labelledBy}
    onKeyDown={event => {
      if (event.key !== 'Tab') return;
      const controls = [...event.currentTarget.querySelectorAll<HTMLElement>('button:not(:disabled), input:not(:disabled), textarea:not(:disabled), select:not(:disabled), a[href], [tabindex="0"]')]
        .filter(control => control.getClientRects().length > 0 && control.tabIndex >= 0);
      const first = controls[0];
      const last = controls.at(-1);
      if (!first || !last) { event.preventDefault(); return; }
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
    }}
    onCancel={event => { event.preventDefault(); if (dismissible) onClose(); }}
    onMouseDown={event => { if (dismissible && event.target === event.currentTarget) onClose(); }}>
    {children}
  </dialog>, document.body);
}
