<p align="center">
  <img src="frontend/src/assets/brand/codequest-2026-mission.png" alt="CODE QUEST 2026" width="320" />
</p>

<h1 align="center">Learning Path</h1>

<p align="center">
  <strong>De tener opciones a tener un plan.</strong><br />
  Tu objetivo, los cursos de DevTalles y un camino para seguir aprendiendo.
</p>

<p align="center">
  <a href="https://codequest2026.optarys.com/"><strong>🚀 Explorar la aplicación</strong></a> ·
  <a href="#cómo-recomendamos-tu-ruta">🧠 Cómo recomendamos</a> ·
  <a href="#dentro-del-proyecto">🔎 Ver el código</a>
</p>

---

## 🧭 Tu recorrido, a tu manera

Learning Path te ayuda a decidir **qué aprender y en qué orden**. Puedes recibir una recomendación según tu perfil o construir una ruta manualmente. Tú decides qué conservar y cuándo guardarla.

| | Lo que puedes hacer |
| --- | --- |
| 🧠 **Descubrir** | Explorar el catálogo y recibir una propuesta personalizada. |
| ✍️ **Crear** | Elegir, ordenar y ajustar tus propios cursos. |
| ✅ **Avanzar** | Guardar rutas, marcar cursos completados y añadir notas y prioridades. |
| 🗺️ **Compartir** | Exportar tu recorrido como un mapa en PNG. |

**Discord y Google · Español e inglés · Tema claro y oscuro**

Las clases se estudian en DevTalles. Aquí organizas tu aprendizaje; el progreso se registra por ti y las notas y prioridades son locales al navegador.

## 🧠 Cómo recomendamos tu ruta

Partimos de lo que quieres aprender y buscamos cursos reales del catálogo que te ayuden a conseguirlo.

```mermaid
flowchart TD
    A["Tu objetivo y perfil"] --> B["Buscar cursos relacionados con tu objetivo"]
    B --> C["Elegir cursos y proponer un orden"]
    C --> D["IA opcional: mejorar orden y explicaciones"]
    D --> E["Propuesta editable · tú decides guardar"]
```

1. **Buscamos por significado.** Comparamos tu objetivo, intereses y experiencia con el contenido de los cursos. No hace falta que el título repita exactamente tus palabras.
2. **Elegimos y ordenamos.** Proponemos hasta seis cursos relacionados, considerando sus temas, nivel y requisitos verificados, además de lo que ya sabes. Buscamos variedad sin alejarnos de tu objetivo.
3. **Explicamos por qué.** La IA puede ajustar el orden y explicar el aporte de cada curso. Solo utiliza los cursos que el motor eligió; si falla, conservamos la propuesta original.

> **Ejemplo:** para «web con Python», el motor prioriza fundamentos y cursos del tema. Puede proponer menos de seis para evitar rellenar la ruta con tecnologías ajenas al objetivo. Los requisitos orientan; no bloquean cursos.

La recomendación es una **propuesta que puedes revisar y ajustar**. Tú decides cuándo guardarla.

## 🛠️ Dentro del proyecto

| Experiencia | Aplicación y datos | Recomendación |
| --- | --- | --- |
| React · TypeScript · Vite | ASP.NET Core · EF Core | Python · FastAPI |
| React Router · i18next | PostgreSQL · pgvector | Embeddings locales · Groq |

Cada pieza tiene una responsabilidad: el frontend presenta y edita, la API coordina y persiste, Python genera vectores y el motor elige el recorrido.

<details>
<summary><strong>🔎 Explorar la implementación y sus pruebas</strong></summary>

- [Perfil del usuario](frontend/src/features/questionnaire/model/preferencesMapping.ts) → [embeddings](backend/embedding-worker/embedding_service.py) → [búsqueda](backend/Application/Routes/Queries/GetSemanticRecommendationQuery.cs).
- [Selección y orden](backend/Application/Routes/HybridSemanticRecommendationEngine.cs) → [refinamiento validado](backend/Application/Routes/RouteRefinementService.cs) → [guardado](backend/Application/Routes/Commands/SaveLearningRouteCommand.cs).
- [Pruebas del motor](backend/tests/CodeQuest2026.Server.Tests/HybridSemanticRecommendationEngineTests.cs) · [Pruebas de refinamiento](backend/tests/CodeQuest2026.Server.Tests/GroqRouteRefinerTests.cs) · [Pruebas del frontend](frontend/tests/README.md).
- [Arquitectura](docs/architecture.md) · [Documentación del frontend](frontend/README.md) · [Documentación del backend](backend/README.md).

</details>

---

<p align="center">
  <img src="frontend/src/assets/brand/devi-laptop.svg" alt="Devi aprendiendo" width="90" /><br />
  <strong>Una meta. Un punto de partida. Tu propio recorrido.</strong><br />
  <a href="https://codequest2026.optarys.com/">Conoce Learning Path →</a>
</p>

Código propio bajo [licencia MIT](LICENSE). Las marcas, miniaturas y contenidos de terceros pertenecen a sus respectivos titulares.
