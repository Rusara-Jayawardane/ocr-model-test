FROM python:3.11-alpine

ENV POETRY_VERSION=2.1.2

RUN apk update && apk upgrade && apk add --no-cache \
    curl \
    build-base \
    tesseract-ocr \
    linux-headers \
    glib \
    libsm \
    libxrender \
    libxext \
    libx11 \
    && curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app
COPY api-gateway.py pyproject.toml poetry.lock /app/

RUN poetry config virtualenvs.create false \
    && poetry install --no-root

EXPOSE 8001

CMD ["python3", "api-gateway.py"]
