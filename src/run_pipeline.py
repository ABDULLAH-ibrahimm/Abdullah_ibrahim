"""Run the full project pipeline: CLO1 -> CLO2 -> CLO3."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from clo1_data_collection import collect
from clo2_data_cleaning import clean
from clo3_analysis import analyse

if __name__ == "__main__":
    collect()
    clean()
    analyse()
    print("Pipeline finished successfully.")
