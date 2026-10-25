/*
===============================================================================
Script Name   : 06_exploratory_customer_analytics.sql
Description   : Comprehensive marketing analysis portfolio covering:
                1. Customer Income Tiering & Monetary Distribution
                2. Marketing Campaign Conversion Benchmarks
                3. Historical Engagement & Customer Loyalty Segmentation
                4. Channel Preference & Digital Conversion Dynamics
                5. Product Category Contribution & Share of Wallet
Target Views  : marketing.vw_dim_customer, marketing.vw_fact_customer_activity
Target Tool   : SQL Server / Power BI
===============================================================================
*/




-- ============================================================================
-- Analysis 01: Customer Income Tiering & Monetary Distribution
-- Description: Segments customers by income brackets to evaluate spending power,
--              transaction frequency, and revenue contribution.
-- ============================================================================

select
	CASE
	WHEN income < 35000 THEN 'Low Income (<35k)'
	WHEN income between 35000 AND 65000 THEN 'Middle Income (35k-65k)'
	ELSE 'High Income (>65k)'
	END AS income_tier,

	count(c.customer_id) as total_customer,
	cast(avg(f.total_spend) as decimal(15,2)) AS avg_spend,
	cast(avg(f.total_purchases) as decimal(15,2)) as avg_purchases,

	concat(cast(sum(f.total_spend) * 100.0 / (select sum(total_spend) from marketing.vw_fact_customer_activity) as decimal(15,2)), '%')  AS revenue_share_pct


	from 
	marketing.vw_dim_customer c
	join marketing.vw_fact_customer_activity f
	on c.customer_id = f.customer_id
	WHERE c.income IS NOT NULL

	group by
		CASE
	WHEN income < 35000 THEN 'Low Income (<35k)'
	WHEN income between 35000 AND 65000 THEN 'Middle Income (35k-65k)'
	ELSE 'High Income (>65k)'
	END 
	ORDER BY avg_spend DESC;


	-- ============================================================================
-- Analysis 02: Campaign Conversion Rates
-- Description: Measures overall acceptance rates across historical campaigns 
--              (1 to 5) compared against the latest promotional campaign.
-- ============================================================================

	select
	count(*) as total_customer,
	concat(cast(avg(cast(acceptedcmp1 as float)) * 100 as decimal(15,2)), '%') AS cmp1_rate_pct,
	concat(cast(avg(cast(acceptedcmp2 as float)) * 100 as decimal(15,2)), '%') AS cmp2_rate_pct,
	concat(cast(avg(cast(acceptedcmp3 as float)) * 100 as decimal(15,2)), '%') AS cmp3_rate_pct,
	concat(cast(avg(cast(acceptedcmp4 as float)) * 100 as decimal(15,2)), '%') AS cmp4_rate_pct,
	concat(cast(avg(cast(acceptedcmp5 as float)) * 100 as decimal(15,2)), '%') AS cmp5_rate_pct,
	concat(cast(avg(cast(response as float)) * 100 as decimal(15,2)), '%') AS latest_campaign_rate_pct
	from marketing.vw_fact_customer_activity;




-- ============================================================================
-- Analysis 03: Historical Affinity vs. Latest Campaign Conversion
-- Description: Analyzes whether prior campaign engagement directly drives 
--              higher conversion rates and spending in the latest campaign.
-- ============================================================================

	-- Part 1: Granular Analysis (Exploratory - Validating the 2+ threshold)
	SELECT
	count(*) as total_customer,
	historical_accepted_campaigns,
	sum(response) as latest_accepted,
	CAST(AVG(total_spend) AS DECIMAL(10, 2)) AS avg_spend,
	concat(cast(sum(response) * 100.0 / count(*) as decimal(10,2)),'%') as conversion_rate_pct,
	CASE 
	WHEN historical_accepted_campaigns >= 2 THEN 'High Loyalty (Frequent Responders)'
	WHEN historical_accepted_campaigns = 1 THEN 'Moderate Loyalty (Trial Responders)'
	ELSE 'Low Loyalty (Non-Responders)'
	END AS loyalty_segment
	FROM
	marketing.vw_fact_customer_activity
	group by historical_accepted_campaigns
	order by historical_accepted_campaigns;






-- Part 2: Executive Summary by Loyalty Segment (Business Interpretation)
	SELECT
	CASE 
		WHEN historical_accepted_campaigns >= 2 THEN 'High Loyalty (Frequent Responders)'
		WHEN historical_accepted_campaigns = 1  THEN 'Moderate Loyalty (Trial Responders)'
		ELSE 'Low Loyalty (Non-Responders)'
    END AS loyalty_segment,

    COUNT(*) AS total_customer,
    SUM(response) AS latest_accepted,
    CAST(AVG(total_spend) AS DECIMAL(10, 2)) AS avg_spend,
    CAST(SUM(response) * 100.0 / COUNT(*) AS DECIMAL(10, 2)) AS conversion_rate_pct
	FROM
    marketing.vw_fact_customer_activity
	GROUP BY 
    CASE 
        WHEN historical_accepted_campaigns >= 2 THEN 'High Loyalty (Frequent Responders)'
        WHEN historical_accepted_campaigns = 1  THEN 'Moderate Loyalty (Trial Responders)'
        ELSE 'Low Loyalty (Non-Responders)'
    END
ORDER BY 
    avg_spend DESC;




-- ============================================================================
-- Analysis 04: Channel Preference & Purchase Behavior
-- Description: Assesses transaction volumes, channel market share, and digital 
--              browsing-to-purchase conversion efficiency.
-- ============================================================================

SELECT
count(*) as total_customer,
SUM(total_purchases) AS total_all_purchases,
sum(catalog_purchases) as  catalog_purchases,
concat(cast(sum(catalog_purchases) * 100.0 / sum(total_purchases) as decimal(10,2)),'%') as catalog_purchases_share_pct,

sum(deal_purchases)  as deal_purchases,
concat(cast(sum(deal_purchases) * 100.0 / sum(total_purchases) as decimal(10,2)),'%') as deal_purchases_share_pct,


sum(store_purchases) as store_purchases,
concat(cast(sum(store_purchases) * 100.0 / sum(total_purchases) as decimal(10,2)),'%') as store_purchases_share_pct,


sum(web_purchases) as web_purchases,
concat(cast(sum(web_purchases) * 100.0 / sum(total_purchases) as decimal(10,2)),'%') as web_purchases_share_pct,


concat(cast(sum(web_purchases) *100.0/ sum(web_visit) as decimal(10,2)),'%') as web_conversion_ratio
FROM
marketing.vw_fact_customer_activity;




-- ============================================================================
-- Analysis 05: Product Category Contribution & Share of Wallet
-- Description: Measures total revenue and percentage share of total spend 
--              across all product categories to identify key revenue drivers.
-- ============================================================================
SELECT
    COUNT(*) AS total_customers,
    SUM(total_spend) AS overall_total_spend,
    CAST(AVG(total_spend) AS DECIMAL(10, 2)) AS avg_spend_per_customer,

    -- 1. Wines (Hero Product)
    SUM(wines_spend) AS total_wines_spend,
    CONCAT(CAST(SUM(wines_spend) * 100.0 / SUM(total_spend) AS DECIMAL(10, 2)), '%') AS wines_share_pct,

    -- 2. Meat Products
    SUM(meat_spend) AS total_meat_spend,
    CONCAT(CAST(SUM(meat_spend) * 100.0 / SUM(total_spend) AS DECIMAL(10, 2)), '%') AS meat_share_pct,

    -- 3. Gold Products
    SUM(goldprods_spend) AS total_goldprods_spend,
    CONCAT(CAST(SUM(goldprods_spend) * 100.0 / SUM(total_spend) AS DECIMAL(10, 2)), '%') AS goldprods_share_pct,

    -- 4. Fish Products
    SUM(fish_spend) AS total_fish_spend,
    CONCAT(CAST(SUM(fish_spend) * 100.0 / SUM(total_spend) AS DECIMAL(10, 2)), '%') AS fish_share_pct,

    -- 5. Sweet Products
    SUM(sweet_spend) AS total_sweet_spend,
    CONCAT(CAST(SUM(sweet_spend) * 100.0 / SUM(total_spend) AS DECIMAL(10, 2)), '%') AS sweet_share_pct,

    -- 6. Fruits
    SUM(fruits_spend) AS total_fruits_spend,
    CONCAT(CAST(SUM(fruits_spend) * 100.0 / SUM(total_spend) AS DECIMAL(10, 2)), '%') AS fruits_share_pct

FROM
    marketing.vw_fact_customer_activity;
