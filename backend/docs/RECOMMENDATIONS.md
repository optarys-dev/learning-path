# Recomendaciones de rutas

## Datos disponibles

El catálogo contiene 72 cursos, categorías, tags, nivel y metadatos de aprendizaje.
Los metadatos marcados `inferred-seed-v1` son inferencias editoriales: sus temarios y
prerrequisitos no han sido verificados. `course_embeddings` existe, pero está vacía
hasta generar vectores reales de un mismo modelo. Las preferencias del usuario se
guardan mediante `PUT /users/me/preferences`. Una ruta analizada se guarda mediante
`POST /routes`, que conserva el orden, las razones y una copia de esas preferencias.

## Motor estático v1

`GET /routes/recommendation` previsualiza la ruta usando las preferencias guardadas.
`POST /routes/generate` calcula la misma recomendación y la persiste como una ruta
con `recommendationMethod = static-v1`. Ambos requieren la cookie de Discord y
preferencias previas. Si no hay coincidencias, la vista previa devuelve `courses: []`
y la generación devuelve 409 con `error = no_recommendations`.

El motor examina los cursos activos y compara objetivo e intereses con título,
categorías, tags y habilidades. Da menor peso a descripciones y habilidades si los
metadatos vienen del seed inferido. Descarta cursos cuyo idioma publicado no coincide
con el preferido; un idioma desconocido no se supone incompatible. Reduce la
puntuación de cursos avanzados para usuarios principiantes, selecciona hasta seis
cursos y propone primero los de nivel más básico. La puntuación es una medida
interna de coincidencia, no una probabilidad ni una calificación pedagógica.

Si existe duración publicada y tiempo semanal, la vista previa calcula semanas
estimadas para cada curso. No descarta cursos por duración, porque el usuario puede
repartirlos en varias semanas. No interpreta prerrequisitos inferidos como relaciones
confirmadas entre cursos. Cada curso incluye un motivo visible; el resultado es
reproducible con el mismo catálogo y las mismas preferencias.

## Evolución recomendada

1. Empezar con candidatos deterministas: cursos activos, idioma y nivel cuando esos
   datos estén disponibles; coincidencia de intereses con categorías y tags;
   coincidencia de objetivos y habilidades con los metadatos. Registrar la puntuación
   por factor para poder explicar y depurar cada recomendación.
2. Para búsqueda semántica, generar embeddings reales de los cursos y un embedding
   de la consulta construida con objetivo, intereses y habilidades del usuario.
   Comparar por coseno solo vectores del mismo modelo y dimensiones. Combinar esa
   similitud con las reglas anteriores; el coseno por sí solo no decide el orden
   pedagógico ni satisface restricciones de idioma o tiempo.
3. Construir la ruta en orden de dificultad y dependencias conocidas, evitando cursos
   redundantes y respetando el tiempo semanal. Mientras los prerrequisitos sean texto
   inferido, tratar este orden como sugerencia y no como requisito formal.
4. Verificar temarios y prerrequisitos con fuentes oficiales antes de crear un grafo
   curso a curso. Un grafo sería útil para dependencias comprobadas, pero los datos
   actuales no justifican relaciones duras entre cursos.
5. Usar un LLM, si se incorpora, para explicar o revisar una lista de cursos ya
   seleccionada. Enviarle solo cursos existentes y validar sus identificadores antes
   de guardar la ruta. Versionar el método y medir calidad con casos de perfiles
   reales y revisión humana.

Esta estrategia permite probar una primera recomendación explicable con los datos
actuales y añadir embeddings sin rediseñar el almacenamiento de rutas.

## Recuperación semántica local

El worker Python indexa los cursos con Ollama y genera vectores de preferencias.
La API .NET consulta cursos activos del mismo modelo y dimensión en pgvector con
`GET /routes/recommendation/semantic`. Esta vista previa requiere el worker en
ejecución y no guarda una ruta; `POST /routes/generate` sigue usando `static-v1`.
Instalación y comandos: [Embeddings de cursos](../Infrastructure/DataSource/CourseEmbeddings.md).

GraphRAG de Microsoft indexa texto no estructurado extrayendo entidades y relaciones
con modelos, y ofrece búsquedas sobre el grafo y los textos. En este proyecto el
catálogo es pequeño y estructurado y los prerrequisitos todavía son inferidos; por
eso el motor inicial no usa extracción automática de relaciones. Cuando existan
temarios y prerrequisitos verificados, se podrá evaluar un grafo explícito de
habilidades y dependencias, junto con recuperación semántica y explicación con IA.

Referencias: [indexación de GraphRAG](https://github.com/microsoft/graphrag/blob/main/docs/index/overview.md),
[búsqueda de GraphRAG](https://microsoft.github.io/graphrag/query/overview/).
