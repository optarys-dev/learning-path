# Categorías del catálogo

`courses.catalog_kinds` guarda un arreglo de texto con seis valores fijos:
`course`, `free`, `mini-course`, `pro-exclusive`, `legacy`, `in-development`.
No hace falta otra tabla: no son categorías administrables y pueden solaparse.
La restricción de PostgreSQL rechaza valores desconocidos. Un arreglo vacío
significa **sin clasificación verificada**, no «Curso» ni «Pro».

Estas categorías son distintas de `level` y de las áreas temáticas existentes.
No conceden acceso al contenido ni cambian la puntuación de las recomendaciones.
La API las obtiene del curso del catálogo, nunca de una solicitud de guardar ruta
ni de la respuesta del modelo de IA.

## Fuente y carga inicial

`CourseCatalogKinds.Public.json` conserva las URLs de las listas oficiales y la
fecha de consulta. `node backend/scripts/Collect-CourseCatalogKinds.mjs` permite
repetir la consulta pública sin conectarse a la base de datos.

La migración `AddCourseCatalogKinds` agrega la columna y asigna las categorías
mediante coincidencias exactas de `course_url`. No crea cursos, modifica URLs,
borra rutas ni reemplaza clasificaciones existentes. Su carga es una copia fija
de la fuente revisada; regenerar el JSON no cambia esa migración.

La base del equipo tiene **91 cursos activos**, comprobados en una transacción
de solo lectura. Las listas oficiales clasifican **90**. El curso
`https://cursos.devtalles.com/courses/Vue-intermedio` no aparece en ellas: el
responsable del proyecto autorizó clasificarlo como `course` («Curso»).
La carga incluye esta asignación explícita aparte de las 90 verificadas en la
fuente pública, para cubrir los **91 cursos** sin atribuirle una categoría Pro.

## Presentación y despliegue

Las etiquetas se traducen al español e inglés y tienen variantes claras/oscuras.
«Exclusivo Pro» usa una corona y un acabado destacado. Si hay categorías
específicas, se omite la etiqueta genérica «Curso» para evitar repetición;
«Gratuito» y «Mini-curso» se mantienen juntos cuando ambos están verificados.
Un curso sin clasificación muestra la etiqueta neutral «DevTalles».

Revisar `backend/artifacts/AddCourseCatalogKinds.sql` antes de aplicarlo.
**Aplicar la migración antes de desplegar el backend nuevo**, porque sus consultas
leen la columna. El frontend acepta respuestas antiguas sin `catalogKinds`.
El rollback elimina la nueva columna y sus clasificaciones: requiere revertir
también el backend a la versión anterior.
