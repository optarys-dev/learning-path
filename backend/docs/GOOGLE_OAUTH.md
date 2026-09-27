# Google y Discord

Ambos proveedores usan Authorization Code en el backend y la misma cookie HttpOnly
CodeQuest.Session. Google usa PKCE y los scopes openid/profile. Los tokens no se
guardan ni se entregan al frontend. La identidad Google es sub; nunca se usa el
nombre o correo para unir cuentas.

## Identidad y datos existentes

UserId es el dueño de preferencias y rutas. user_external_logins tiene clave
primaria (provider, provider_user_id). DiscordId se conserva para compatibilidad,
pero admite null para usuarios Google. La migración AddExternalAuthentication
registra las identidades Discord existentes sin cambiar sus UserId ni relaciones.
Las cookies anteriores se actualizan al identificador interno al validarlas.
El id público Discord de /auth/me también se conserva para las notas locales.

Cada proveedor crea su propia cuenta. No hay vinculación ni unión por correo.
Un bloqueo transaccional PostgreSQL por proveedor/identidad serializa los primeros
logins simultáneos; las restricciones únicas son la protección final.

## Configuración de Google Cloud

1. Abrir [Google Auth Platform](https://console.cloud.google.com/auth/clients) en tu propio proyecto,
   configurar la pantalla de consentimiento y crear un cliente OAuth de tipo aplicación web.
   Obtener **Client ID** y **Client Secret** del cliente creado.
2. Registrar exactamente la URL de retorno del middleware:
   - Desarrollo mediante Vite: http://localhost:5173/auth/google/callback
   - API local directa: http://localhost:5107/auth/google/callback
   - Docker Compose local: http://localhost:8080/auth/google/callback
   - Producción: https://TU_DOMINIO/auth/google/callback
3. Si la aplicación Google está en modo de prueba, agregar las cuentas de prueba.
4. Configurar Google:ClientId y Google:ClientSecret con user-secrets localmente,
   o Google__ClientId y Google__ClientSecret en el gestor de secretos del servidor.
   No poner el secreto en Git, VITE_* ni en el navegador.

Ejecutar desde backend, reemplazando los valores localmente:

```powershell
dotnet user-secrets set "Google:ClientId" "CLIENT_ID"
dotnet user-secrets set "Google:ClientSecret" "CLIENT_SECRET"
```

GET /auth/providers informa si Google está configurado; el frontend muestra el
botón solo cuando ambas credenciales existen. GET /auth/google inicia OAuth.
GET /auth/me devuelve provider y avatarUrl junto al contrato existente.

Vite conserva el host y proxifica /auth hacia la API. El backend calcula el callback
desde ese host. Para un frontend con API absoluta, configurar
VITE_GOOGLE_RETURN_URL=https://FRONTEND/login/callback y registrar el origen exacto
en Cors:AllowedOrigins. returnUrl acepta rutas locales o /login/callback del origen
autorizado; rechaza destinos arbitrarios. Producción usa HTTPS; conservar el host
público en el proxy. Se recomienda servir frontend y API en el mismo origen.

## Migración y activación

Respaldar la base de destino y comprobar el historial EF antes de actualizar.
El SQL está en artifacts/AddExternalAuthentication.sql. La migración permite null
en discord_id, amplía avatar y crea la tabla de identidades; no borra usuarios.

```powershell
dotnet build CodeQuest2026.Server.csproj
dotnet ef migrations has-pending-model-changes --context AppDbContext --no-build
dotnet ef database update AddExternalAuthentication --context AppDbContext --no-build
```

Aplicar la migración antes de desplegar este backend. Fuera de Compose, no se ejecutan
migraciones al arrancar salvo que se active `DatabaseInitialization:Enabled`.
El Compose del proyecto activa esa inicialización. Probar primero en desarrollo/staging: Discord actual,
Google nuevo/repetido, logout, preferencias y rutas, y acceso con otra cuenta.
Para desactivar Google basta retirar sus credenciales y reiniciar; sus datos quedan.
Down rechaza la reversión si hay usuarios Google o avatares que no caben en el
esquema antiguo. Nunca elimina cuentas para hacer posible una reversión.

## Pruebas PostgreSQL aisladas

La suite contiene pruebas de la migración y de ocho logins simultáneos. Usan una
conexión de desarrollo localhost desde user-secrets, o LEARNING_PATH_TEST_POSTGRES
configurado explícitamente para una base de pruebas. Crean un esquema con nombre
aleatorio y lo eliminan al terminar; requieren permiso CREATE SCHEMA. No ejecutan
la migración sobre tablas existentes del proyecto. Sin esa conexión se omiten
explícitamente y no deben contarse como validación de PostgreSQL.

Referencias: https://developers.google.com/identity/openid-connect/openid-connect
y https://learn.microsoft.com/aspnet/core/security/authentication/social/social-without-identity
