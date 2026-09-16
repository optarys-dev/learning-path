# Inicio de sesión con Discord

El backend usa el flujo Authorization Code y el middleware OAuth de ASP.NET Core.
El middleware atiende el callback, valida `state` y la cookie de correlación,
intercambia el código por un token y consulta `/users/@me` con el scope `identify`.
La sesión de la aplicación dura ocho horas y usa una cookie HttpOnly. Los tokens de
Discord no se guardan ni se envían al frontend. El callback crea o actualiza el usuario en PostgreSQL antes de emitir la cookie de sesión.

## Configuración

La configuración busca primero `Discord:DISCORD_CLIENT_ID`,
`Discord:DISCORD_CLIENT_SECRET` y `Discord:DISCORD_CALLBACK_PATH`. Si una clave de
la sección no existe o está vacía, busca respectivamente `DISCORD_CLIENT_ID`,
`DISCORD_CLIENT_SECRET` y `DISCORD_CALLBACK_PATH` en la raíz de configuración.
Esto permite usar tanto variables con prefijo de sección como variables directas.
No guardar secretos en archivos versionados.

Variables con sección:

```powershell
$env:Discord__DISCORD_CLIENT_ID = 'TU_CLIENT_ID'
$env:Discord__DISCORD_CLIENT_SECRET = 'TU_CLIENT_SECRET'
$env:ASPNETCORE_ENVIRONMENT = 'Development'
$env:Discord__DISCORD_CALLBACK_PATH = '/auth/discord/callback'
$env:Discord__DISCORD_FORCE_HTTPS_CALLBACK = 'true'
dotnet run --launch-profile http
```

Variables directas equivalentes:

```powershell
$env:DISCORD_CLIENT_ID = 'TU_CLIENT_ID'
$env:DISCORD_CLIENT_SECRET = 'TU_CLIENT_SECRET'
$env:DISCORD_CALLBACK_PATH = '/auth/discord/callback'
$env:DISCORD_FORCE_HTTPS_CALLBACK = 'true'
```

Si no se configura el callback se usa `/auth/discord/callback`. Una clave no vacía
dentro de `Discord` tiene prioridad sobre su equivalente directo.

`DISCORD_FORCE_HTTPS_CALLBACK` hace que únicamente `/auth/discord` y el callback
OAuth se procesen con esquema `https` al construir el `redirect_uri`. Su valor por
defecto es `true` en Production y `false` en Development. El servidor puede seguir
escuchando por HTTP dentro del contenedor; la URL pública debe disponer de TLS
(por ejemplo, mediante el proxy HTTPS de la plataforma), ya que esta opción no
instala un certificado ni convierte Kestrel en un servidor HTTPS.

En Discord Developer Portal → aplicación → OAuth2 → Redirects, registrar exactamente:

- HTTP local: `http://localhost:5107/auth/discord/callback`
- Perfil HTTPS: `https://localhost:7281/auth/discord/callback`
- Producción: `https://TU_DOMINIO/auth/discord/callback`

La URL del callback se calcula desde el esquema, host y PathBase de la petición.
En producción se requiere HTTPS. Si hay un proxy que termina TLS, configurar
forwarded headers con proxies de confianza antes de autenticación y redirección
HTTPS para que ASP.NET Core reciba el esquema y host públicos correctos.

## Uso y comprobación

1. Abrir `http://localhost:5107/auth/discord` en el navegador.
2. Autorizar la aplicación. El callback termina en `/auth/me`, que devuelve
   `id`, `username`, `displayName` y el hash `avatar` de Discord.
3. `/auth/me` devuelve HTTP 401 cuando no hay una sesión válida.
4. Un callback sin `state`, con `state` alterado, con código inválido o con una
   autorización cancelada devuelve HTTP 400 sin exponer tokens ni errores internos.

El parámetro opcional `returnUrl` acepta exclusivamente rutas locales al backend,
por ejemplo `/auth/discord?returnUrl=/`. Las URL externas devuelven HTTP 400.
Iniciar siempre desde `/auth/discord`; abrir el callback directamente no crea sesión.

Desde React, navegar al endpoint de inicio usando `window.location.assign`, no `fetch`.
Para consultar la sesión desde el frontend local en otro puerto:

```javascript
const response = await fetch(`${apiBaseUrl}/auth/me`, {
  credentials: 'include',
});
```

Configurar el origen exacto del frontend en `Cors:AllowedOrigins:0` (variable
`Cors__AllowedOrigins__0`). Las cookies usan SameSite=Lax: utilizar el mismo sitio
y esquema para frontend y API; en producción se recomienda servirlos en el mismo
origen. No se incluye integración del botón del frontend en este cambio.

Referencia: [OAuth2 de Discord](https://docs.discord.com/developers/topics/oauth2).
