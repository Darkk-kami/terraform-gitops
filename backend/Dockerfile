FROM python:3.12-slim AS build

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH="/app:$PYTHONPATH"

RUN apt-get update && apt-get install -y \
    libpq-dev

WORKDIR /app

RUN pip install poetry

COPY pyproject.toml poetry.lock /app/

RUN poetry config virtualenvs.create true \
    && poetry install --no-dev --no-interaction --no-ansi

COPY . /app/

RUN chmod +x /app/prestart.py

FROM gcr.io/distroless/python3:latest

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH="/app:$PYTHONPATH"

COPY --from=build /usr/local /usr/local
COPY --from=build /root/.cache/pypoetry/virtualenvs /root/.cache/pypoetry/virtualenvs

WORKDIR /app

COPY --from=build /app /app
# COPY --from=build /bin/bash /bin/bash

ENV PATH="/usr/local/bin:$PATH"

EXPOSE 8000

ENTRYPOINT ["poetry", "run", "python", "/app/prestart.py"]
