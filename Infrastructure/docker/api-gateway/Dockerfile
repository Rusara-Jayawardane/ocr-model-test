FROM python:3.11-slim

ENV POETRY_VERSION=2.1.2

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    tesseract-ocr \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 && curl -sSL https://install.python-poetry.org | python3 - && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app
COPY api-gateway.py pyproject.toml poetry.lock /app/

RUN poetry config virtualenvs.create false \
    && poetry install --no-root

EXPOSE 8001

CMD ["python3", "api-gateway.py"]
