import { writeFile } from 'node:fs/promises';

// Reads only public product cards. Never infers a classification from a course title.
// This script writes a reviewable snapshot; it does not connect to a database.
const pages = {
  course: 'todos-los-cursos',
  free: 'todos-los-cursos-gratuitos',
  'mini-course': 'todos-los-cursos-minicursos',
  'pro-exclusive': 'todos-los-cursos-exclusivos',
  legacy: 'todos-los-cursos-legacy',
  'in-development': 'todos-los-cursos-en-construccion',
};

const groups = await Promise.all(Object.entries(pages).map(async ([catalogKind, page]) => {
  const sourceUrl = `https://cursos.devtalles.com/pages/${page}`;
  const response = await fetch(sourceUrl, { signal: AbortSignal.timeout(30_000) });
  if (!response.ok || response.url !== sourceUrl) throw new Error(`Unexpected response from ${sourceUrl}`);
  const html = await response.text();
  const cards = [...html.matchAll(/<a\b[^>]*class="[^"]*\bcard\b[^"]*"[^>]*href="(\/courses\/[^"?#]+)"/g)];
  if (!cards.length) throw new Error(`No product cards in ${sourceUrl}; review the source markup.`);
  return [...new Set(cards.map(match => match[1]))].map(path => ({
    courseUrl: `https://cursos.devtalles.com${path}`, catalogKind, sourceUrl,
  }));
}));

const records = groups.flat();
const assignments = new Map();
for (const record of records) {
  const previous = assignments.get(record.courseUrl) ?? { courseUrl: record.courseUrl, catalogKinds: [], sourceUrls: [] };
  previous.catalogKinds.push(record.catalogKind);
  previous.sourceUrls.push(record.sourceUrl);
  assignments.set(record.courseUrl, previous);
}

const snapshot = {
  verifiedAt: new Date().toISOString(),
  courses: [...assignments.values()].sort((a, b) => a.courseUrl.localeCompare(b.courseUrl)),
};
await writeFile(new URL('../Infrastructure/DataSource/CourseCatalogKinds.Public.json', import.meta.url), `${JSON.stringify(snapshot, null, 2)}\n`);
console.log(`Collected ${snapshot.courses.length} verified course classifications.`);
