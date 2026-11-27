"""CLO2 - Data cleaning & preparation."""
from pathlib import Path

import pandas as pd

RAW = Path("data/raw/wine.csv")
CLEAN = Path("data/processed/wine_clean.csv")
SUMMARY = Path("reports/summary_statistics.csv")


def clean() -> pd.DataFrame:
    df = pd.read_csv(RAW)
    before = len(df)
    df = df.drop_duplicates().dropna()
    df.columns = [c.strip().lower().replace("/", "_") for c in df.columns]
    # Remove extreme outliers (|z| > 4) on numeric features
    num = df.select_dtypes("number")
    z = (num - num.mean()) / num.std()
    df = df[(z.abs() <= 4).all(axis=1)]
    CLEAN.parent.mkdir(parents=True, exist_ok=True)
    SUMMARY.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(CLEAN, index=False)
    df.describe().T.round(3).to_csv(SUMMARY)
    print(f"[CLO2] cleaned {before} -> {len(df)} rows; missing values: {int(df.isna().sum().sum())} -> {CLEAN}")
    return df


if __name__ == "__main__":
    clean()
