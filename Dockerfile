# Build from the solution root: docker build -t codequest:local .
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
USER $APP_UID

FROM node:24-bookworm-slim AS frontend-build
WORKDIR /src/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci
COPY frontend/ ./
ARG VITE_API_BASE_URL=/
RUN VITE_API_BASE_URL=$VITE_API_BASE_URL npm run build

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY backend/CodeQuest2026.Server.csproj backend/
RUN dotnet restore backend/CodeQuest2026.Server.csproj
COPY backend/ backend/
# Copy before publishing so ASP.NET Core includes the client in its static asset manifest.
COPY --from=frontend-build /src/frontend/dist/ backend/wwwroot/
WORKDIR /src/backend

FROM build AS publish
RUN dotnet publish CodeQuest2026.Server.csproj \
    -c $BUILD_CONFIGURATION -o /app/publish --no-restore -p:UseAppHost=false

FROM base AS final
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CodeQuest2026.Server.dll"]
