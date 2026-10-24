-- =======================================================
-- 1. CREATE SCHEMA
-- =======================================================


IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'marketing')
	BEGIN
		EXEC('CREATE SCHEMA marketing');

	END

-- =======================================================
-- 2. DROP TABLES
-- =======================================================

--drop fact_customer_activity
IF OBJECT_ID ('marketing.fact_customer_activity','U') IS NOT NULL
	DROP TABLE marketing.fact_customer_activity

--drop dim_customer
IF OBJECT_ID ('marketing.dim_customer','U') IS NOT NULL
	DROP TABLE marketing.dim_customer

--drop dim_date
IF OBJECT_ID ('marketing.dim_date','U') IS NOT NULL
	DROP TABLE marketing.dim_date

-- =======================================================
-- 3. CREATE DIMENSIONS
-- =======================================================

--create dim_customer
CREATE TABLE marketing.dim_customer (
	customer_id INT PRIMARY KEY,
	year_birth INT,
	age INT,
	education NVARCHAR(50) not null,
	marital_status NVARCHAR(50) not null,
	income INT  ,
	kidhome TINYINT not null,
	teenhome TINYINT not null,
	dt_customer DATE  not null,
	total_children INT
)


--create dim_date
CREATE TABLE marketing.dim_date (
	[date] DATE PRIMARY KEY,
	[year] INT,
	[month] INT,
	month_name NVARCHAR(50),
	[quarter] int
)

-- =======================================================
-- 4. CREATE FACT TABLE
-- =======================================================


--create fact_customer_activity
CREATE TABLE marketing.fact_customer_activity (
	customer_id INT PRIMARY KEY,
	[date] DATE,
	recency INT,
	MntWines INT,
	MntFruits INT,
	MntMeatProducts INT,
	MntFishProducts INT ,
	MntSweetProducts INT,
	MntGoldProds INT,
	total_spend INT,
	NumDealsPurchases INT,
	NumWebPurchases INT,
	NumCatalogPurchases INT,
	NumStorePurchases INT,
	total_purchases INT,
	NumWebVisitsMonth INT,
	Response INT,
	AcceptedCmp1 INT,
	AcceptedCmp2 INT,
	AcceptedCmp3 INT,
	AcceptedCmp4 INT,
	AcceptedCmp5 INT,
	Complain INT,
	--constraint
	CONSTRAINT fk_fact_customer FOREIGN KEY (customer_id) REFERENCES marketing.dim_customer (customer_id),
	CONSTRAINT fk_fact_date FOREIGN KEY ([date]) REFERENCES marketing.dim_date([date])
)
