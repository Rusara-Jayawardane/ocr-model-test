FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    POETRY_VERSION=1.8.2

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    tesseract-ocr \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

COPY api-gateway.py pyproject.toml poetry.lock /app/

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

EXPOSE 8001

CMD ["python3", "api-gateway.py"]
