FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HF_HOME=/home/app/.cache/huggingface

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && useradd --create-home --uid 10001 app \
    && mkdir -p "$HF_HOME" \
    && chown -R app:app /home/app

COPY --chown=app:app api.py embedding_cli.py embedding_service.py ./

USER app
EXPOSE 8765
CMD ["python", "embedding_cli.py", "serve"]
