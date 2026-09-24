import { fileURLToPath, URL } from 'node:url';
import { defineConfig } from 'vite';
import plugin from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [plugin()],

  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },

  server: {
    port: 5173,
    strictPort: true,

    proxy: {
      '/auth': {
        target: 'http://localhost:5107',
        changeOrigin: false,
      },

      '/users': {
        target: 'http://localhost:5107',
        changeOrigin: false,
      },
      '/routes': {
        target: 'http://localhost:5107',
        changeOrigin: false,
      },
      '/health': {
        target: 'http://localhost:5107',
        changeOrigin: false,
      },

      '/courses': {
        target: 'http://localhost:5107',
        changeOrigin: false,
      },

    },
  },
});
