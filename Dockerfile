# Use slim Python base for smaller image size
FROM python:3.13-slim

RUN apt-get update && apt-get install -y \
    pkg-config \
    default-libmysqlclient-dev \
    build-essential

COPY --from=ghcr.io/astral-sh/uv:0.8.15 /uv /uvx /bin/

# Avoid .pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /dockerdjuvsetup

# Copy pyproject.toml and uv.lock first (for caching deps)
COPY pyproject.toml /dockerdjuvsetup/
COPY uv.lock /dockerdjuvsetup/

# Sync dependencies with uv
RUN uv sync --locked

# Copy project files
COPY . /dockerdjuvsetup/



