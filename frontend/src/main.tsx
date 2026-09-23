import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import './i18n'
import './index.css'
import App from './App.tsx'
import { AuthSessionProvider } from './features/auth'
import { NotificationProvider } from './components/notifications'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <AuthSessionProvider>
        <NotificationProvider><App /></NotificationProvider>
      </AuthSessionProvider>
    </BrowserRouter>
  </StrictMode>,
)
