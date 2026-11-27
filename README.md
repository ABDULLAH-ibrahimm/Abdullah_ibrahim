# CDS 2413 – Introduction to Data Science · Final Project

End-to-end data science project (CLO1–CLO3) with full **data versioning on Git/GitHub (CLO4)**,
packaged in a reproducible **Docker** image.

![Docker](https://img.shields.io/badge/Docker-ready-2496ED?logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)
![Git](https://img.shields.io/badge/Git-versioned-F05032?logo=git&logoColor=white)

## Project structure

```
.
├── Dockerfile               # reproducible environment (Python 3.12 + Git)
├── docker-compose.yml       # pipeline + git services
├── Makefile                 # shortcuts: make build / make run / make shell
├── requirements.txt         # pinned Python dependencies
├── data/
│   ├── raw/wine.csv         # CLO1 – collected dataset (UCI Wine, 178 rows)
│   └── processed/           # CLO2 – cleaned dataset
├── src/
│   ├── clo1_data_collection.py
│   ├── clo2_data_cleaning.py
│   ├── clo3_analysis.py     # EDA, figures, Random-Forest baseline
│   └── run_pipeline.py      # runs CLO1 → CLO2 → CLO3
├── reports/                 # summary statistics, model metrics, figures
├── scripts/git_workflow.sh  # CLO4 – configure / upload / clone / pull / push
└── docs/screenshots/        # evidence screenshots for the report
```

## Quick start

```bash
# 1. Build the image
docker build -t cds2413-data-science:1.0 .

# 2. Run the full pipeline (CLO1 → CLO3); outputs land in ./data and ./reports
docker run --rm -u root \
  -v "$PWD/data:/workspace/project/data" \
  -v "$PWD/reports:/workspace/project/reports" \
  cds2413-data-science:1.0
```

Or with Compose: `docker compose run --rm pipeline`

## CLO4 – Data versioning workflow (inside Docker)

```bash
docker run -d --name cds2413-git cds2413-data-science:1.0 sleep infinity
docker exec -it cds2413-git bash

# inside the container
export REPO_URL=https://github.com/<user>/<repo>.git BRANCH=main
export GIT_USER_NAME="Your Name" GIT_USER_EMAIL="you@example.com"
bash scripts/git_workflow.sh configure
bash scripts/git_workflow.sh upload
bash scripts/git_workflow.sh clone
#   -> add docs/CHANGELOG.md on GitHub (Add file → Create new file)
bash scripts/git_workflow.sh pull
bash scripts/git_workflow.sh push
```

> Pushing over HTTPS needs a GitHub **Personal Access Token** (Settings → Developer settings →
> Personal access tokens) used as the password, or `gh auth login`.

## Results

| Step | Output |
|------|--------|
| CLO1 – Collection | 178 samples × 14 columns (13 chemical features + cultivar) |
| CLO2 – Cleaning   | duplicates/missing removed, outliers (\|z\| > 4) filtered → 177 rows |
| CLO3 – Analysis   | correlation heatmap, class distribution, Random Forest test accuracy = 1.00 |

## Author
**Abdullah Ibrahim** – [GitHub](https://github.com/ABDULLAH-ibrahimm)
