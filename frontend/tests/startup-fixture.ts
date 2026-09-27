// Keep the exact initial HTML visible until the reviewer allows the real React entry to load.
import initialHtml from '../index.html?raw';

const initialDocument = new DOMParser().parseFromString(initialHtml, 'text/html');
const root = document.getElementById('root')!;
const overlay = initialDocument.getElementById('app-startup')!;
// DOMParser parses noscript children, unlike a live document with JavaScript enabled.
overlay.querySelector('noscript')?.remove();
document.body.prepend(overlay);
root.setAttribute('inert', '');
root.setAttribute('aria-busy', 'true');

const controls = document.createElement('nav');
controls.setAttribute('aria-label', 'Loader fixture controls');
controls.style.cssText = 'position:fixed;z-index:101;bottom:1rem;left:1rem;right:1rem;display:flex;justify-content:center;gap:.5rem;flex-wrap:wrap;';
function button(label: string, action: () => void) {
  const item = document.createElement('button');
  item.textContent = label;
  item.onclick = action;
  controls.append(item);
}
button('Toggle theme', () => { document.documentElement.dataset.theme = document.documentElement.dataset.theme === 'light' ? 'dark' : 'light'; });
button('Toggle language', () => { document.documentElement.lang = document.documentElement.lang === 'es' ? 'en' : 'es'; });
button('Start React', () => {
  controls.remove();
  document.documentElement.dataset.startupStartedAt = String(performance.now());
  // Only the session endpoint is mocked; assets are loaded normally. No team API is accessed.
  const assetFetch = window.fetch.bind(window);
  window.fetch = async (input, options) => {
    const url = new URL(input instanceof Request ? input.url : String(input), location.origin);
    if (url.pathname.startsWith('/auth/')) return Response.json({ detail: 'Anonymous fixture' }, { status: 401 });
    return assetFetch(input, options);
  };
  window.history.replaceState(null, '', '/');
  void import('../src/main');
});
document.body.append(controls);

if (import.meta.hot) import.meta.hot.dispose(() => { controls.remove(); overlay.remove(); });
