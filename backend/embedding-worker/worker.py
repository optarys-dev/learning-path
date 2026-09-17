"""Index course embeddings and serve preference embeddings with a local HF model.

The .NET API only reads vectors and searches pgvector. This process owns all
embedding model calls. Run `python worker.py index` or `python worker.py serve`.
"""

import argparse
import hashlib
import json
import math
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


MODEL = os.getenv("EMBEDDING_MODEL", "Qwen/Qwen3-Embedding-0.6B")
REVISION = os.getenv("EMBEDDING_REVISION", "main")
DEVICE = os.getenv("EMBEDDING_DEVICE", "cpu")
MODEL_ID = f"hf/{MODEL}@{REVISION}/course-text-v1"
QUERY_INSTRUCTION = "Represent the learning goal for retrieving relevant courses"
_model = None


class EmbeddingUnavailable(Exception):
    pass


def add(lines, label, value):
    if isinstance(value, (list, tuple)):
        value = "; ".join(str(item).strip() for item in value if str(item).strip())
    if value and str(value).strip():
        lines.append(f"{label}: {str(value).strip()}")


def course_text(course):
    lines = []
    add(lines, "Título", course["title"])
    add(lines, "Nivel", course["level"])
    add(lines, "Categorías", ", ".join(sorted(course["categories"])))
    add(lines, "Etiquetas", ", ".join(sorted(course["tags"])))
    if course["metadata_origin"] != "inferred-seed-v1" and (
        course["metadata_source_url"] or course["metadata_verified_at"]
    ):
        add(lines, "Descripción", course["description"])
        add(lines, "Temario", course["syllabus"])
        add(lines, "Resultados", course["learning_outcomes"])
        add(lines, "Habilidades", course["skills_taught"])
        add(lines, "Requisitos", course["prerequisites"])
        add(lines, "Público", course["target_audience"])
    return "\n".join(lines)


def preference_text(preference):
    lines = []
    add(lines, "Objetivo", preference.get("goal"))
    add(lines, "Intereses", preference.get("interests") or [])
    add(lines, "Experiencia", preference.get("experienceLevel"))
    # Prior skills describe readiness, but should not drive semantic relevance.
    return "\n".join(lines)


def get_model():
    global _model
    if _model is None:
        from sentence_transformers import SentenceTransformer
        _model = SentenceTransformer(MODEL, revision=REVISION, device=DEVICE)
    return _model


def embed(text, is_query=False):
    model = get_model()
    options = {"normalize_embeddings": True, "show_progress_bar": False}
    if is_query:
        options["prompt"] = f"Instruct: {QUERY_INSTRUCTION}\nQuery: "
    values = model.encode(text, **options).tolist()
    if not values or any(not isinstance(x, (int, float)) or not math.isfinite(x)
                         for x in values) or not any(values):
        raise EmbeddingUnavailable("The local model returned an invalid embedding")
    return values


def get_database_connection_string():
    connection_string = os.getenv("DATABASE_URL")
    if not connection_string or not connection_string.strip():
        raise ValueError(
            "Set DATABASE_URL as a PostgreSQL URI or libpq connection string, "
            "for example: postgresql://user:password@localhost:5432/learning_path"
        )
    return connection_string.strip()


def index_courses():
    import psycopg
    from psycopg.rows import dict_row

    connection_string = get_database_connection_string()
    try:
        conn = psycopg.connect(connection_string, row_factory=dict_row)
    except Exception as exc:
        raise ValueError(
            "DATABASE_URL is invalid. Use a valid PostgreSQL URI or libpq connection string, "
            "for example: postgresql://user:password@localhost:5432/learning_path"
        ) from exc

    with conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT c.course_id, c.title, c.level, c.metadata_origin,
                       c.metadata_source_url, c.metadata_verified_at,
                       c.description, c.syllabus, c.learning_outcomes,
                       c.skills_taught, c.prerequisites, c.target_audience,
                       COALESCE((SELECT array_agg(a.name ORDER BY a.name)
                                 FROM course_categories cc JOIN categories a
                                   ON a.category_id = cc.category_id
                                 WHERE cc.course_id = c.course_id), ARRAY[]::text[]) AS categories,
                       COALESCE((SELECT array_agg(t.name ORDER BY t.name)
                                 FROM course_tags ct JOIN tags t ON t.tag_id = ct.tag_id
                                 WHERE ct.course_id = c.course_id), ARRAY[]::text[]) AS tags,
                       e.model AS stored_model, e.content_hash AS stored_hash
                  FROM courses c LEFT JOIN course_embeddings e ON e.course_id = c.course_id
                 WHERE c.is_active ORDER BY c.course_id
            """)
            courses = cursor.fetchall()
        created = skipped = 0
        for course in courses:
            content = course_text(course)
            content_hash = hashlib.sha256(content.encode("utf-8")).hexdigest()
            if course["stored_model"] == MODEL_ID and course["stored_hash"] == content_hash:
                skipped += 1
                continue
            values = embed(content)
            vector = "[" + ",".join(str(x) for x in values) + "]"
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO course_embeddings
                        (course_id, embedding, model, dimensions, content_hash, generated_at)
                    VALUES (%s, %s::vector, %s, %s, %s, now())
                    ON CONFLICT (course_id) DO UPDATE SET
                        embedding = EXCLUDED.embedding, model = EXCLUDED.model,
                        dimensions = EXCLUDED.dimensions, content_hash = EXCLUDED.content_hash,
                        generated_at = EXCLUDED.generated_at
                """, (course["course_id"], vector, MODEL_ID, len(values), content_hash))
            conn.commit()
            created += 1
            print(f"Indexed {course['course_id']}: {course['title']}", flush=True)
        print(f"Done: {created} indexed, {skipped} unchanged, {len(courses)} active")


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path != "/embed-preferences":
            return self.send_json(404, {"error": "not_found"})
        try:
            length = int(self.headers.get("Content-Length", "0"))
            if length < 1 or length > 16384:
                return self.send_json(400, {"error": "invalid_request"})
            preference = json.loads(self.rfile.read(length))
            if not isinstance(preference, dict) or not isinstance(preference.get("goal"), str) \
                    or not preference["goal"].strip():
                return self.send_json(400, {"error": "invalid_request"})
            values = embed(preference_text(preference), is_query=True)
            self.send_json(200, {"model": MODEL_ID, "dimensions": len(values), "embedding": values})
        except (ValueError, KeyError, TypeError):
            self.send_json(400, {"error": "invalid_request"})
        except (EmbeddingUnavailable, RuntimeError, OSError, ImportError) as error:
            print(f"Local embedding model unavailable: {error}", flush=True)
            self.send_json(503, {"error": "embedding_provider_unavailable"})

    def send_json(self, status, data):
        body = json.dumps(data).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=["index", "serve"])
    args = parser.parse_args()
    if args.command == "index":
        index_courses()
    else:
        get_model()
        host = os.getenv("EMBEDDING_HOST", "127.0.0.1")
        port = int(os.getenv("EMBEDDING_PORT", "8765"))
        print(f"Embedding service on http://{host}:{port}", flush=True)
        ThreadingHTTPServer((host, port), Handler).serve_forever()
