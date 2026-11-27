"""CLO3 - Exploratory analysis, visualisation and a baseline model."""
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split

CLEAN = Path("data/processed/wine_clean.csv")
FIG = Path("reports/figures")
METRICS = Path("reports/model_metrics.txt")


def analyse() -> float:
    df = pd.read_csv(CLEAN)
    FIG.mkdir(parents=True, exist_ok=True)

    sns.countplot(data=df, x="cultivar", hue="cultivar", palette="Set2")
    plt.title("Samples per cultivar"); plt.tight_layout()
    plt.savefig(FIG / "class_distribution.png", dpi=120); plt.close()

    plt.figure(figsize=(10, 8))
    sns.heatmap(df.drop(columns="cultivar").corr(), cmap="coolwarm", center=0)
    plt.title("Feature correlation"); plt.tight_layout()
    plt.savefig(FIG / "correlation_heatmap.png", dpi=120); plt.close()

    X, y = df.drop(columns="cultivar"), df["cultivar"]
    X_tr, X_te, y_tr, y_te = train_test_split(X, y, test_size=0.25, stratify=y, random_state=42)
    model = RandomForestClassifier(n_estimators=200, random_state=42).fit(X_tr, y_tr)
    pred = model.predict(X_te)
    acc = accuracy_score(y_te, pred)
    METRICS.write_text(f"accuracy: {acc:.4f}\n\n{classification_report(y_te, pred)}")
    print(f"[CLO3] RandomForest accuracy = {acc:.3f}; figures -> {FIG}/")
    return acc


if __name__ == "__main__":
    analyse()
