"""FastAPI service for preference embeddings."""

import logging
from contextlib import asynccontextmanager
from typing import Annotated

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from pydantic import BaseModel, ConfigDict, Field, StringConstraints

from embedding_service import EmbeddingUnavailable, embedding_service


logger = logging.getLogger(__name__)
Goal = Annotated[str, StringConstraints(strip_whitespace=True, min_length=1, max_length=1000)]
Interest = Annotated[str, StringConstraints(strip_whitespace=True, min_length=1, max_length=100)]
ExperienceLevel = Annotated[str, StringConstraints(strip_whitespace=True, max_length=40)]


class PreferenceRequest(BaseModel):
    model_config = ConfigDict(extra="ignore")

    goal: Goal
    interests: list[Interest] = Field(default_factory=list, max_length=30)
    experienceLevel: ExperienceLevel | None = None


class EmbeddingResponse(BaseModel):
    model: str
    dimensions: int
    embedding: list[float]


@asynccontextmanager
async def lifespan(application: FastAPI):
    embedding_service.load_model()
    application.state.model_ready = True
    try:
        yield
    finally:
        application.state.model_ready = False


app = FastAPI(title="CodeQuest Embeddings", lifespan=lifespan)


@app.exception_handler(RequestValidationError)
async def invalid_request(_request: Request, _error: RequestValidationError):
    return JSONResponse(status_code=400, content={"error": "invalid_request"})


@app.get("/health")
def health(request: Request):
    if not getattr(request.app.state, "model_ready", False):
        return JSONResponse(status_code=503, content={"error": "embedding_provider_unavailable"})
    return {"status": "ok", "model": embedding_service.model_id}


@app.post("/embed-preferences", response_model=EmbeddingResponse)
def embed_preferences(preference: PreferenceRequest):
    try:
        result = embedding_service.embed_preferences(preference.model_dump())
    except (EmbeddingUnavailable, RuntimeError, OSError, ImportError, ValueError, TypeError):
        logger.exception("Local embedding model unavailable")
        return JSONResponse(status_code=503, content={"error": "embedding_provider_unavailable"})
    return EmbeddingResponse(**result)
