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

Combinamos **búsqueda semántica, información del catálogo y refinamiento opcional con IA**.

```mermaid
flowchart TD
    A["Tu objetivo y perfil"] --> B["Embeddings: comparar significado"]
    B --> C["Motor híbrido: seleccionar y ordenar"]
    C --> D["IA opcional: refinar orden y razones"]
    D --> E["Propuesta editable · tú decides guardar"]
```

1. **Entendemos lo que buscas.** Un modelo local convierte objetivo, intereses y experiencia en un vector; PostgreSQL con pgvector lo compara con cursos activos y compatibles.
2. **Construimos el recorrido.** El motor combina **82 % de similitud semántica y 18 % de asociación temática**. Selecciona hasta seis cursos, favoreciendo relevancia y variedad, y propone un orden según nivel y requisitos verificados, considerando tus conocimientos previos.
3. **Explicamos la propuesta.** Groq puede mejorar el orden y las razones usando exclusivamente los cursos seleccionados. Si el refinamiento falla, conservamos la propuesta original.

> **Ejemplo:** para «web con Python», el motor prioriza fundamentos y cursos del tema. Puede proponer menos de seis para evitar rellenar la ruta con tecnologías ajenas al objetivo. Los requisitos orientan; no bloquean cursos.

La recomendación es un **borrador**, no un guardado automático. Al confirmar, persistimos cursos, orden y una copia de las preferencias utilizadas.

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
