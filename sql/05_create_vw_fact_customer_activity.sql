	/*
===============================================================================
Script Name   : 05_create_vw_fact_customer_activity.sql
Description   : Formats customer transactional metrics, granular spending, 
                channel touchpoints, and computes historical vs. current campaign acceptance.
Source Table  : marketing.fact_customer_activity
Target View   : marketing.vw_fact_customer_activity
===============================================================================
*/
CREATE OR ALTER VIEW marketing.vw_fact_customer_activity
AS

SELECT
customer_id,
[date],

-- Monetary breakdown by product category
    mntwines,
    mntfruits,
    mntmeatproducts,
    mntfishproducts,
    mntsweetproducts,
    mntgoldprods,
    total_spend,

    -- Channel purchases and user engagement
    numdealspurchases,
    numwebpurchases,
    numcatalogpurchases,
    numstorepurchases,
    numwebvisitsmonth,
    total_purchases,
    recency,

	acceptedcmp1,
    acceptedcmp2,
    acceptedcmp3,
    acceptedcmp4,
    acceptedcmp5,


    -- Historical Engagement: Number of past campaigns accepted (0 to 5)
    (acceptedcmp1 + acceptedcmp2 + acceptedcmp3 + acceptedcmp4 + acceptedcmp5) AS historical_accepted_campaigns,

    -- Current Target: Response to the latest marketing campaign (0 or 1)
    response,

    -- Customer service indicator
    complain

from
marketing.fact_customer_activity

go
