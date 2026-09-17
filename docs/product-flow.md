# Flujo de producto — CODE QUEST

## Recorrido de una persona usuaria

1. Entra a la landing y entiende que CODE QUEST ordena cursos reales de DevTalles según su meta.
2. Inicia sesión con Discord. El backend crea o recupera la sesión y reconoce a la misma persona en visitas posteriores.
3. Completa el cuestionario inicial: meta, experiencia, conocimientos y áreas de interés.
4. Recibe una propuesta con cursos de DevTalles ordenados y el motivo de cada recomendación.
5. Guarda la propuesta como una ruta de aprendizaje.
6. Abre su ruta, consulta cada curso en DevTalles y marca manualmente su avance en CODE QUEST.
7. Vuelve a **Mis rutas** para retomar o crear una nueva ruta.

## Rutas de interfaz previstas

| Ruta | Propósito |
| --- | --- |
| `/` | Landing y explicación del producto. |
| `/login` | Inicio de sesión con Discord. |
| `/assessment` | Cuestionario inicial. |
| `/recommendation/:proposalId` | Propuesta temporal de cursos y motivos. |
| `/paths/:pathId` | Detalle de una ruta guardada y progreso manual. |
| `/my-paths` | Rutas guardadas de la persona usuaria. |

Los cursos se abren en DevTalles. CODE QUEST no aloja contenido, no procesa pagos y no sincroniza automáticamente el progreso con DevTalles.
