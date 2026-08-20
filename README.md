# Investment Portfolio Analytics & Reporting Platform

An end-to-end analytics project simulating the reporting workflow of an investment management firm.

## Business Problem

Investment, fund, and transaction data can be scattered across spreadsheets and operational systems. This project centralises the data into a relational SQL model, validates it with Python, analyses it with SQL, and prepares it for Power BI reporting.

## Tech Stack

- SQL / PostgreSQL
- Python / Pandas
- Excel
- Power BI / Power Query / DAX
- Git & GitHub

## Dataset

The project uses a **synthetic, fictional dataset** created specifically for portfolio demonstration.

The workbook contains:

- Countries
- Investors
- Funds
- Assets
- InvestorTransactions
- FundTrades
- FundNAV

## Analytics Scope

- Investor capital flows
- Investor segmentation
- Fund-level reporting
- NAV and AUM trends
- Fund ROI
- Benchmark comparison
- Sector exposure
- Trading activity
- Data-quality validation

## Architecture

Raw Excel Data  
→ Python / Pandas ETL  
→ PostgreSQL Relational Model  
→ Analytical SQL Queries  
→ Power BI Model  
→ Executive Dashboard

## Dashboard Plan

### Executive Overview
- AUM
- Net Investor Capital
- Latest Fund Return
- Best Performing Fund
- ROI by Fund
- Monthly Capital Flow

### Fund Performance
- NAV trend
- AUM trend
- Fund vs benchmark
- Excess return

### Portfolio Exposure
- Trading activity by sector
- Top traded assets
- Fund / asset exposure

### Investor Analytics
- Active investors
- Investors by country
- Risk profile
- Investor type
- Top contributors

## Project Status

**In Progress**

Completed:
- Business/data model
- Synthetic Excel dataset
- SQL schema
- Core analytical SQL
- Python ETL and validation

Next:
- Load data into PostgreSQL
- Build Power BI relationships
- Create DAX measures
- Build dashboard
- Add screenshots and findings

## Disclaimer

All investor data and investment-performance figures are synthetic. Nothing in this repository represents real client information or investment advice.
