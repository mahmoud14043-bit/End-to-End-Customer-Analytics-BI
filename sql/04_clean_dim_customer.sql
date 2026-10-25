/*
===============================================================================
Script Name   : 04_create_vw_dim_customer.sql
Description   : Cleans customer demographics, imputes extreme birth year outliers,
                dynamically computes current age, standardizes academic degrees 
                and marital statuses, and excludes invalid income anomalies.
Source Table  : marketing.dim_customer
Target View   : marketing.vw_dim_customer
===============================================================================
*/

CREATE OR ALTER VIEW marketing.vw_dim_customer
AS
select
customer_id,

-- Impute pre-1936 entry typos (e.g., 1893, 1899, 1900) using the median birth year (1969)
CASE
WHEN year_birth < 1936 THEN 1969
ELSE year_birth
END AS year_birth,


-- Calculate current age dynamically based on the normalized birth year
CASE 
WHEN year_birth < 1936 THEN (YEAR(GETDATE()) - 1969)
ELSE  (YEAR(GETDATE()) - year_birth)
END AS age,

-- Standardize academic levels (mapping Bologna process '2n Cycle' to Master and 'Graduation' to Bachelor)
CASE 
WHEN education = 'Basic' THEN 'High School'
WHEN education = 'PhD' THEN 'Doctorate'
WHEN education = 'Graduation' THEN 'Bachelor'
WHEN education IN ('2n Cycle' , 'Master') THEN 'Master'
ELSE 'N/A'
END AS education,

-- Group marital statuses into consolidated household purchasing units
CASE
WHEN marital_status  IN ('Married','Together') THEN 'Partner'
ELSE 'Single'
END AS marital_status,


income,
kidhome,
teenhome,
dt_customer,
total_children
from 
marketing.dim_customer

-- Exclude extreme typo anomaly ($666,666) while preserving valid NULL income records
WHERE income IS NULL OR income < 600000
GO
