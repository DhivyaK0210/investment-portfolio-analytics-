"""
Investment Portfolio Analytics & Reporting Platform
Python / Pandas ETL and data-validation pipeline.

Install:
    pip install pandas openpyxl

Run:
    python etl_pipeline.py
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parent
INPUT_FILE = ROOT / "investment_portfolio_dataset.xlsx"
OUTPUT_DIR = ROOT / "processed"
OUTPUT_DIR.mkdir(exist_ok=True)

SHEETS = [
    "Countries",
    "Investors",
    "Funds",
    "Assets",
    "InvestorTransactions",
    "FundTrades",
    "FundNAV",
]

def clean_columns(df):
    df = df.copy()
    df.columns = (
        df.columns
        .str.strip()
        .str.replace(" ", "_", regex=False)
        .str.replace(r"[^A-Za-z0-9_]", "", regex=True)
        .str.lower()
    )
    return df

def validate_unique(df, column, table):
    if df[column].duplicated().any():
        raise ValueError(f"{table}: duplicate key values found in {column}")

def main():
    workbook = pd.ExcelFile(INPUT_FILE)
    data = {}

    for sheet in SHEETS:
        df = pd.read_excel(workbook, sheet_name=sheet)
        df = clean_columns(df)
        df = df.drop_duplicates().copy()
        data[sheet] = df

    # Primary-key checks
    validate_unique(data["Countries"], "countryid", "Countries")
    validate_unique(data["Investors"], "investorid", "Investors")
    validate_unique(data["Funds"], "fundid", "Funds")
    validate_unique(data["Assets"], "assetid", "Assets")
    validate_unique(data["InvestorTransactions"], "transactionid", "InvestorTransactions")
    validate_unique(data["FundTrades"], "tradeid", "FundTrades")

    # Referential integrity checks
    tx = data["InvestorTransactions"]
    trades = data["FundTrades"]

    assert set(tx["investorid"]).issubset(set(data["Investors"]["investorid"]))
    assert set(tx["fundid"]).issubset(set(data["Funds"]["fundid"]))
    assert set(trades["fundid"]).issubset(set(data["Funds"]["fundid"]))
    assert set(trades["assetid"]).issubset(set(data["Assets"]["assetid"]))

    # Transaction business rules
    invalid_sign = (
        ((tx["transactiontype"] == "Subscription") & (tx["amount"] < 0))
        | ((tx["transactiontype"] == "Redemption") & (tx["amount"] > 0))
    )
    if invalid_sign.any():
        raise ValueError("InvestorTransactions: invalid amount sign detected.")

    if (trades["quantity"] <= 0).any() or (trades["tradeprice"] <= 0).any():
        raise ValueError("FundTrades: quantity and trade price must be positive.")

    # Derived analytical fields
    trades["signed_gross_value"] = trades["grossvalue"].where(
        trades["tradetype"].eq("Buy"),
        -trades["grossvalue"]
    )

    nav = data["FundNAV"].copy()
    nav["excess_return"] = nav["monthlyreturn"] - nav["benchmarkreturn"]

    # Export cleaned files
    for sheet, df in data.items():
        df.to_csv(OUTPUT_DIR / f"{sheet.lower()}.csv", index=False)

    trades.to_csv(OUTPUT_DIR / "fundtrades_enriched.csv", index=False)
    nav.to_csv(OUTPUT_DIR / "fundnav_enriched.csv", index=False)

    print("ETL completed successfully.")
    print(f"Processed files saved to: {OUTPUT_DIR}")

if __name__ == "__main__":
    main()
