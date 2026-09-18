"""Shared model and text preparation for course and preference embeddings."""

import math
import os
from threading import Lock


MODEL = os.getenv("EMBEDDING_MODEL", "Qwen/Qwen3-Embedding-0.6B")
REVISION = os.getenv("EMBEDDING_REVISION", "main")
DEVICE = os.getenv("EMBEDDING_DEVICE", "cpu")
QUERY_INSTRUCTION = "Represent the learning goal for retrieving relevant courses"


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
    # Existing skills describe readiness, not topics the user wants to learn.
    return "\n".join(lines)


class EmbeddingService:
    def __init__(self, model_name=MODEL, revision=REVISION, device=DEVICE):
        self.model_name = model_name
        self.revision = revision
        self.device = device
        self.model_id = f"hf/{model_name}@{revision}/course-text-v1"
        self._model = None
        self._load_lock = Lock()

    def load_model(self):
        if self._model is None:
            with self._load_lock:
                if self._model is None:
                    from sentence_transformers import SentenceTransformer

                    self._model = SentenceTransformer(
                        self.model_name, revision=self.revision, device=self.device)
        return self._model

    def embed(self, text, is_query=False):
        options = {"normalize_embeddings": True, "show_progress_bar": False}
        if is_query:
            options["prompt"] = f"Instruct: {QUERY_INSTRUCTION}\nQuery: "
        values = self.load_model().encode(text, **options).tolist()
        if not values or any(not isinstance(x, (int, float)) or not math.isfinite(x)
                             for x in values) or not any(values):
            raise EmbeddingUnavailable("The local model returned an invalid embedding")
        return values

    def embed_preferences(self, preference):
        values = self.embed(preference_text(preference), is_query=True)
        return {"model": self.model_id, "dimensions": len(values), "embedding": values}


embedding_service = EmbeddingService()
