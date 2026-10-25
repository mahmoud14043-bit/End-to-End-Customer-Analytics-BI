CREATE OR ALTER VIEW marketing.vw_dim_customer
AS
select
customer_id,
CASE
WHEN year_birth < 1936 THEN 1969
ELSE year_birth
END AS year_birth,
CASE 
WHEN year_birth < 1936 THEN (YEAR(GETDATE()) - 1969)
ELSE  (YEAR(GETDATE()) - year_birth)
END AS age,
CASE 
WHEN education = 'Basic' THEN 'High School'
WHEN education = 'PhD' THEN 'Doctorate'
WHEN education = 'Graduation' THEN 'Bachelor'
WHEN education IN ('2n Cycle' , 'Master') THEN 'Master'
ELSE 'N/A'
END AS education,
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
WHERE income IS NULL OR income < 600000
