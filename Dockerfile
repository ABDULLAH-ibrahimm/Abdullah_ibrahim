# CDS 2413 - Introduction to Data Science
# Reproducible environment for the project (CLO1-CLO3) and the Git/GitHub workflow (CLO4)
# Full Debian-based Python image: ships with git, curl & CA certificates
FROM python:3.12

LABEL org.opencontainers.image.title="cds2413-data-science-project" \
      org.opencontainers.image.description="Data science project + Git version control workflow" \
      org.opencontainers.image.authors="Abdullah Ibrahim"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    MPLBACKEND=Agg \
    PIP_NO_CACHE_DIR=1

WORKDIR /workspace/project

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Non-root user (best practice)
RUN useradd -m -s /bin/bash student && chown -R student:student /workspace
USER student

CMD ["python", "src/run_pipeline.py"]
