"""CLO1 - Data collection: load the UCI Wine dataset and save it as raw CSV."""
from pathlib import Path

import pandas as pd
from sklearn.datasets import load_wine

RAW = Path("data/raw/wine.csv")


def collect() -> pd.DataFrame:
    ds = load_wine(as_frame=True)
    df = ds.frame.rename(columns={"target": "cultivar"})
    df["cultivar"] = df["cultivar"].map(dict(enumerate(ds.target_names)))
    RAW.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(RAW, index=False)
    print(f"[CLO1] collected {df.shape[0]} rows x {df.shape[1]} cols -> {RAW}")
    return df


if __name__ == "__main__":
    collect()
