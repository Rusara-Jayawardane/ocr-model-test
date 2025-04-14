FROM python:3.11-alpine

ENV POETRY_VERSION=2.1.2

RUN apk update && apk upgrade && apk add --no-cache \
    curl \
    build-base \
    tesseract-ocr \
    tesseract-ocr-data-eng \
    linux-headers \
    && curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app
COPY model.py pyproject.toml /app/

RUN poetry config virtualenvs.create false \
    && poetry install --no-root

EXPOSE 8080

CMD ["python3", "model.py"]
