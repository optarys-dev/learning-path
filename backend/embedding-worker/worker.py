"""Compatibility entry point; use embedding_cli.py for new commands."""

from embedding_cli import get_database_connection_string, index_courses, main
from embedding_service import (
    DEVICE, MODEL, QUERY_INSTRUCTION, REVISION, EmbeddingUnavailable,
    course_text, embedding_service, preference_text,
)

MODEL_ID = embedding_service.model_id


def get_model():
    return embedding_service.load_model()


def embed(text, is_query=False):
    return embedding_service.embed(text, is_query=is_query)


if __name__ == "__main__":
    main()
