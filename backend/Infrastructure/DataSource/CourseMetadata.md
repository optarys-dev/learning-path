# Metadatos de cursos

Estos campos complementan Title, Level, Topics, Categories y Tags para preparar
recomendaciones semánticas y rutas de aprendizaje.

| Campo | Contenido esperado |
| --- | --- |
| Description | Descripción del contenido y alcance real del curso. |
| Syllabus | Temario en texto, conservando el orden de módulos y lecciones. |
| LearningOutcomes | Objetivos concretos: qué podrá hacer el estudiante al terminar. |
| SkillsTaught | Habilidades que desarrolla el curso; usar nombres consistentes. |
| Prerequisites | Conocimientos o habilidades necesarios antes de empezar. |
| TargetAudience | Perfiles de estudiantes a quienes está dirigido. |
| Language | Código de idioma BCP 47, por ejemplo es o es-NI; null si se desconoce. |
| DurationMinutes | Duración publicada en minutos, positiva; null si se desconoce. |
| MetadataSourceUrl | URL del temario o fuente usada para completar los metadatos. |
| MetadataOrigin | Procedencia; inferred-seed-v1 identifica propuestas sintéticas para pruebas. |
| MetadataVerifiedAt | Fecha UTC de revisión de los metadatos contra esa fuente. |

La migración deja textos y valores opcionales en null y listas vacías para los
cursos existentes. Una lista vacía significa que no se han registrado elementos;
no demuestra que un curso carezca de prerrequisitos. No presentar inferencias como
datos publicados. MetadataVerifiedAt es independiente de
SourceVerifiedAt, que corresponde a la verificación del catálogo original.

Para futuros embeddings, combinar título, descripción, temario, objetivos,
habilidades, prerrequisitos, público, nivel, categorías y tags con etiquetas de
campo y un orden estable. Excluir URLs, fechas, imágenes e identificadores.
Los embeddings y su generación se incorporarán en una etapa posterior.

SkillsTaught y Prerequisites son descripciones por ahora: todavía no representan
relaciones verificadas entre cursos ni un grafo de prerrequisitos.

## Seed inicial para pruebas

SeedCourseLearningMetadata incorpora propuestas editoriales para los 72 cursos
del catálogo inicial, basadas exclusivamente en sus títulos, categorías y tags.
Incluye descripción, un temario sugerido, objetivos, habilidades, conocimientos
previos sugeridos y público. No representa el temario oficial ni requisitos
confirmados por el proveedor. Cada registro usa MetadataOrigin = inferred-seed-v1.

El seed solo actualiza cursos que tengan esos campos vacíos y no tengan fuente,
verificación ni origen de metadatos. Conserva metadatos previamente editados.
No modifica duración, idioma, nivel, Topics ni SourceVerifiedAt. No asigna una
URL de fuente ni MetadataVerifiedAt porque estos contenidos no se verificaron.

La reversión limpia únicamente contenidos que aún coincidan exactamente con el
seed y sigan sin fuente ni verificación; conserva contenidos editados. La columna
MetadataOrigin se elimina al revertir esta migración.

Estos datos permiten probar filtros, serialización y recomendaciones con ejemplos
variados. No sirven como referencia validada para medir la calidad pedagógica de
una ruta: eso requiere verificar temarios y prerrequisitos reales.
