-- Investment Portfolio Analytics & Reporting Platform
-- PostgreSQL-compatible schema

DROP TABLE IF EXISTS fund_nav;
DROP TABLE IF EXISTS fund_trades;
DROP TABLE IF EXISTS investor_transactions;
DROP TABLE IF EXISTS assets;
DROP TABLE IF EXISTS funds;
DROP TABLE IF EXISTS investors;
DROP TABLE IF EXISTS countries;

CREATE TABLE countries (
    country_id VARCHAR(10) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    region VARCHAR(100) NOT NULL
);

CREATE TABLE investors (
    investor_id VARCHAR(12) PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(160) NOT NULL,
    phone_number VARCHAR(40),
    country_id VARCHAR(10) NOT NULL REFERENCES countries(country_id),
    date_joined DATE NOT NULL,
    risk_profile VARCHAR(20) NOT NULL CHECK (risk_profile IN ('Low','Medium','High')),
    investor_type VARCHAR(30) NOT NULL CHECK (investor_type IN ('Individual','Corporate','Institutional')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('Active','Inactive'))
);

CREATE TABLE funds (
    fund_id VARCHAR(10) PRIMARY KEY,
    fund_name VARCHAR(150) NOT NULL UNIQUE,
    fund_type VARCHAR(50) NOT NULL,
    risk_level VARCHAR(20) NOT NULL CHECK (risk_level IN ('Low','Medium','High')),
    base_currency VARCHAR(10) NOT NULL,
    launch_date DATE NOT NULL,
    fund_manager VARCHAR(120) NOT NULL,
    status VARCHAR(20) NOT NULL,
    benchmark VARCHAR(150)
);

CREATE TABLE assets (
    asset_id VARCHAR(10) PRIMARY KEY,
    asset_name VARCHAR(150) NOT NULL,
    asset_type VARCHAR(50) NOT NULL,
    sector VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    market VARCHAR(100),
    currency VARCHAR(10) NOT NULL,
    ticker VARCHAR(20)
);

CREATE TABLE investor_transactions (
    transaction_id VARCHAR(20) PRIMARY KEY,
    investor_id VARCHAR(12) NOT NULL REFERENCES investors(investor_id),
    fund_id VARCHAR(10) NOT NULL REFERENCES funds(fund_id),
    transaction_date DATE NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('Subscription','Redemption')),
    amount NUMERIC(18,2) NOT NULL,
    currency VARCHAR(10) NOT NULL
);

CREATE TABLE fund_trades (
    trade_id VARCHAR(20) PRIMARY KEY,
    fund_id VARCHAR(10) NOT NULL REFERENCES funds(fund_id),
    asset_id VARCHAR(10) NOT NULL REFERENCES assets(asset_id),
    trade_date DATE NOT NULL,
    trade_type VARCHAR(10) NOT NULL CHECK (trade_type IN ('Buy','Sell')),
    quantity NUMERIC(18,4) NOT NULL CHECK (quantity > 0),
    trade_price NUMERIC(18,4) NOT NULL CHECK (trade_price > 0),
    gross_value NUMERIC(18,2) NOT NULL
);

CREATE TABLE fund_nav (
    fund_id VARCHAR(10) NOT NULL REFERENCES funds(fund_id),
    nav_date DATE NOT NULL,
    nav_per_unit NUMERIC(18,4) NOT NULL,
    aum NUMERIC(20,2) NOT NULL,
    monthly_return NUMERIC(12,8),
    benchmark_return NUMERIC(12,8),
    PRIMARY KEY (fund_id, nav_date)
);

CREATE INDEX idx_investor_transactions_investor
ON investor_transactions(investor_id);

CREATE INDEX idx_investor_transactions_fund
ON investor_transactions(fund_id);

CREATE INDEX idx_investor_transactions_date
ON investor_transactions(transaction_date);

CREATE INDEX idx_fund_trades_fund
ON fund_trades(fund_id);

CREATE INDEX idx_fund_trades_asset
ON fund_trades(asset_id);

CREATE INDEX idx_fund_nav_date
ON fund_nav(nav_date);
