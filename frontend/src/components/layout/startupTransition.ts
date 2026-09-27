const minimumVisibleMs = 1100;
const fadeMs = 240;

/** Called after React commits: keep fast loads readable without adding delay to slow ones. */
export function finishStartup() {
  const overlay = document.getElementById('app-startup');
  if (!overlay) return;
  const root = document.getElementById('root');
  const startedAt = Number(document.documentElement.dataset.startupStartedAt);
  const elapsed = Number.isFinite(startedAt) ? Math.max(0, performance.now() - startedAt) : 0;
  let fadeTimer: number | undefined;
  const timer = window.setTimeout(() => {
    overlay.dataset.state = 'leaving';
    const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    fadeTimer = window.setTimeout(() => {
      overlay.remove();
      root?.removeAttribute('inert');
      root?.removeAttribute('aria-busy');
    }, reducedMotion ? 0 : fadeMs);
  }, Math.max(0, minimumVisibleMs - elapsed));

  return () => {
    window.clearTimeout(timer);
    window.clearTimeout(fadeTimer);
    delete overlay.dataset.state;
  };
}
