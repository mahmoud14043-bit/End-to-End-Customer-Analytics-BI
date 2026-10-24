-- =======================================================
-- 1. EXPLORE DATABASE OBJECTS & SCHEMA
-- =======================================================

-- List all tables within the marketing schema
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'marketing'

-- Inspect column metadata, data types, nullability, and ordinal position
SELECT
TABLE_NAME,
COLUMN_NAME,
DATA_TYPE,
CHARACTER_MAXIMUM_LENGTH,
IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'marketing'
order by TABLE_NAME, ORDINAL_POSITION

-- =======================================================
-- 2. CATEGORICAL DISTRIBUTIONS & UNIQUE VALUES AUDIT
-- =======================================================

-- Check distribution of customer education levels
select 
education,
count(*) as total_customers
from marketing.dim_customer
group by education 
order by total_customers desc

-- Check distribution of marital status
select 
marital_status,
count(*) as total_customers
from marketing.dim_customer
group by marital_status 
order by total_customers desc





-- =======================================================
-- 3. DATA INTEGRITY & MISSING VALUE CHECKS
-- =======================================================

--check for income
SELECT 
COUNT(*) as total_row,
COUNT(income) as non_null_income,
sum(case when income is null then 1 else 0 end) as missing_income_count
FROM marketing.dim_customer

--check for kidhome and teenhome
SELECT
COUNT(*) as total_row,
COUNT(kidhome) as non_null_kidhome,
sum(case when kidhome is null then 1 else 0 end) as  issing_kidhome_count
from
marketing.dim_customer

SELECT
COUNT(*) as total_row,
COUNT(teenhome) as non_null_teenhome,
sum(case when teenhome is null then 1 else 0 end) as  issing_teenhome_count
from
marketing.dim_customer


-- =======================================================
-- 4. OUTLIER & BOUNDARY DETECTION
-- =======================================================

-- Check age and birth year boundaries
select
min(year_birth) as oldest_customer,
max(year_birth) as youngest_customer,
min(age) as youngest,
max(age) as oldest,
avg(age) as avg_age
from marketing.dim_customer

-- Check income boundaries
select 
min(income) as lowerst_value,
max(income)  as heighest_value,
avg(income) as Avg_value
from 
marketing.dim_customer





-- Check date range boundaries for customer enrollments
SELECT
min(dt_customer) AS earliest_date,
max(dt_customer) AS latest_date
FROM
marketing.dim_customer

--Check for invalid/negative values in monetary and activity metrics
select
MIN(total_spend) AS min_total_spend,
MAX(total_spend) AS max_total_spend,
AVG(total_spend) AS avg_total_spend,
MIN(recency) AS min_recency_days,
Max(recency) AS max_recency_days,
AVG(recency) AS avg_recency_days,
SUM(total_spend) AS gross_revenue
from
marketing.fact_customer_activity


--Check boundary values for overall purchase counts
select
min(total_purchases) as min_purchases,
MAX(total_purchases) as max_purchases,
AVG(total_purchases) as avg_purchases
from 
marketing.fact_customer_activity



-- Check granular purchase channel metrics for negatives or anomalies
SELECT 
    MIN(NumWebPurchases) AS min_web,
    MAX(NumWebPurchases) AS max_web,
    MIN(NumCatalogPurchases) AS min_catalog,
    MAX(NumCatalogPurchases) AS max_catalog,
    MIN(NumStorePurchases) AS min_store,
    MAX(NumStorePurchases) AS max_store,
    MIN(NumDealsPurchases) AS min_deals,
    MAX(NumDealsPurchases) AS max_deals,
    MIN(total_purchases)   AS min_total,
    MAX(total_purchases)   AS max_total
FROM marketing.fact_customer_activity;



-- Verify campaign acceptance values are strictly binary (0 or 1)
SELECT 
    MIN(AcceptedCmp1) AS min_cmp1, 
    MAX(AcceptedCmp1) AS max_cmp1,
    MIN(Response) AS min_resp, 
    MAX(Response) AS max_resp,
    MIN(Complain) AS min_comp, 
    MAX(Complain) AS max_comp
FROM marketing.fact_customer_activity;




