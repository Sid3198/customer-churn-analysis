-- =========================================================
-- Customer Churn Analysis — SQL Queries
-- Dataset: Telco Customer Churn (7,043 customer records)
-- =========================================================

-- 1. Overall churn rate
-- Establishes the baseline churn rate across the full customer base
SELECT 
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM customers;

-- Result: 7,043 total | 1,869 churned | 26.54% churn rate


-- 2. Churn rate by contract type
-- Checks whether contract length/type affects how likely a customer is to churn
SELECT 
  Contract, 
  COUNT(*) AS total, 
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY Contract;

-- Result:
-- Month-to-month | 3,875 total | 1,655 churned | 42.71%
-- One year       | 1,472 total |   166 churned | 11.27%
-- Two year       | 1,695 total |    48 churned |  2.83%


-- 3. Churn rate by tenure group
-- Groups customers into tenure buckets to see if newer customers churn more
SELECT 
  CASE 
    WHEN tenure <= 12 THEN '0-12 months'
    WHEN tenure <= 24 THEN '13-24 months'
    WHEN tenure <= 48 THEN '25-48 months'
    ELSE '49+ months'
  END AS tenure_group,
  COUNT(*) AS total,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY tenure_group
ORDER BY MIN(tenure);

-- Result:
-- 0-12 months   | 2,186 total | 1,037 churned | 47.44%
-- 13-24 months  | 1,024 total |   294 churned | 28.71%
-- 25-48 months  | 1,594 total |   325 churned | 20.39%
-- 49+ months    | 2,239 total |   213 churned |  9.51%


-- 4. Churn rate by tech support access
-- Checks whether having tech support reduces churn (proxy for unresolved friction)
SELECT 
  TechSupport,
  COUNT(*) AS total,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY TechSupport;

-- Result:
-- No                   | 3,473 total | 1,446 churned | 41.64%
-- Yes                  | 2,044 total |   310 churned | 15.17%
-- No internet service  | 1,526 total |   113 churned |  7.40%
