-- Investment Portfolio Analytics - analytical SQL

-- 1. Total net investor capital
SELECT ROUND(SUM(amount), 2) AS total_net_investor_capital
FROM investor_transactions;

-- 2. Net investor capital by fund
SELECT
    f.fund_id,
    f.fund_name,
    ROUND(SUM(t.amount), 2) AS net_capital
FROM investor_transactions t
JOIN funds f ON f.fund_id = t.fund_id
GROUP BY f.fund_id, f.fund_name
ORDER BY net_capital DESC;

-- 3. Active investors by country
SELECT
    c.country_name,
    COUNT(*) AS active_investors
FROM investors i
JOIN countries c ON c.country_id = i.country_id
WHERE i.status = 'Active'
GROUP BY c.country_name
ORDER BY active_investors DESC;

-- 4. Monthly capital-flow trend
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    ROUND(SUM(amount), 2) AS net_flow
FROM investor_transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;

-- 5. Latest fund performance
WITH latest AS (
    SELECT fund_id, MAX(nav_date) AS latest_date
    FROM fund_nav
    GROUP BY fund_id
)
SELECT
    f.fund_name,
    n.nav_date,
    n.nav_per_unit,
    n.aum,
    ROUND(n.monthly_return * 100, 2) AS monthly_return_pct,
    ROUND(n.benchmark_return * 100, 2) AS benchmark_return_pct,
    ROUND((n.monthly_return - n.benchmark_return) * 100, 2) AS excess_return_pct
FROM latest l
JOIN fund_nav n
  ON n.fund_id = l.fund_id
 AND n.nav_date = l.latest_date
JOIN funds f
  ON f.fund_id = n.fund_id
ORDER BY monthly_return_pct DESC;

-- 6. ROI by fund across the available period
WITH nav_bounds AS (
    SELECT
        fund_id,
        MIN(nav_date) AS first_date,
        MAX(nav_date) AS last_date
    FROM fund_nav
    GROUP BY fund_id
)
SELECT
    f.fund_name,
    ROUND(((last_nav.nav_per_unit / first_nav.nav_per_unit) - 1) * 100, 2) AS roi_pct
FROM nav_bounds b
JOIN fund_nav first_nav
  ON first_nav.fund_id = b.fund_id
 AND first_nav.nav_date = b.first_date
JOIN fund_nav last_nav
  ON last_nav.fund_id = b.fund_id
 AND last_nav.nav_date = b.last_date
JOIN funds f
  ON f.fund_id = b.fund_id
ORDER BY roi_pct DESC;

-- 7. Gross trading activity by sector
SELECT
    a.sector,
    ROUND(SUM(ft.gross_value), 2) AS gross_traded_value
FROM fund_trades ft
JOIN assets a
  ON a.asset_id = ft.asset_id
GROUP BY a.sector
ORDER BY gross_traded_value DESC;

-- 8. Top investors by net contribution
SELECT
    i.investor_id,
    i.first_name || ' ' || i.last_name AS investor_name,
    ROUND(SUM(t.amount), 2) AS net_contribution
FROM investor_transactions t
JOIN investors i
  ON i.investor_id = t.investor_id
GROUP BY i.investor_id, investor_name
ORDER BY net_contribution DESC
LIMIT 20;

-- 9. Data quality: duplicate emails
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM investors
GROUP BY email
HAVING COUNT(*) > 1;

-- 10. Data quality: incorrect amount sign
SELECT *
FROM investor_transactions
WHERE (transaction_type = 'Subscription' AND amount < 0)
   OR (transaction_type = 'Redemption' AND amount > 0);
