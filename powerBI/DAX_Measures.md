#  DAX Measures & Calculations

This document lists and documents the core DAX measures and calculated columns implemented in the **Customer Analytics Dashboard**.

---

## 1. Key Performance Indicators (KPIs)

#### Total Customers
Counts the total distinct customers in the dataset:
```dax
Total customer = DISTINCTCOUNT(Dim_Customer[customer_id])
```

#### Total Spend
Calculates the overall revenue generated across all product categories:
```dax
Total spend = SUM(fact_customer_activity[total_spend])
```

#### Average Spend
Calculates the average spending per customer safely using `DIVIDE`:
```dax
Avg Spend = 
DIVIDE(
    [Total spend], 
    [Total customer], 
    0
)
```

#### Total Purchases
Aggregates all completed purchase transactions across channels:
```dax
Total purchases = SUM(fact_customer_activity[total_purchases])
```

---

## 2. Marketing & Campaign Performance

#### Total Campaign Engagements
Calculates the sum of all historical accepted offers combined with the latest campaign responses:
```dax
Total Camp = 
SUM(fact_customer_activity[historical_accepted_campaigns]) + 
SUM(fact_customer_activity[response])
```

#### Latest Campaign Conversion Rate
Measures the proportion of customers who responded positively to the most recent campaign:
```dax
Latest Campaign Conversion Rate = 
DIVIDE(
    SUM(fact_customer_activity[response]),
    [Total customer],
    0
)
```

---

## 3. Channel Distribution & Dynamic Visuals

#### Web Purchase Share
Measures the percentage of total transactions generated via the website:
```dax
Web Purchase Share = 
DIVIDE(
    SUM(fact_customer_activity[web_purchases]), 
    [Total purchases], 
    0
)
```

#### Dynamic Purchases by Channel
Dynamically switches channel metrics for the clustered horizontal bar chart using the `Dim_Channels` helper dimension:
```dax
Purchases_By_Channel = 
SWITCH(
    SELECTEDVALUE(Dim_Channels[Channel Name]),
    "Store", SUM(fact_customer_activity[store_purchases]),
    "Web", SUM(fact_customer_activity[web_purchases]),
    "Catalog", SUM(fact_customer_activity[catalog_purchases]),
    "Deals", SUM(fact_customer_activity[deal_purchases]),
    BLANK()
)
```

---

## 4. Calculated Columns (Data Modeling)

#### Income Tier
Segments customers into structured income brackets within the `Dim_Customer` table:
```dax
income_tier = 
SWITCH(
    TRUE(),
    ISBLANK(Dim_Customer[income]), "Unknown",
    Dim_Customer[income] < 30000, "Under 30K",
    Dim_Customer[income] < 60000, "30K - 60K",
    Dim_Customer[income] < 90000, "60K - 90K",
    "90K+"
)
```

#### Income Tier Sort
Ensures chronological sorting for `income_tier` instead of alphabetical order:
```dax
income_tier_sort = 
SWITCH(
    TRUE(),
    ISBLANK(Dim_Customer[income]), 5,
    Dim_Customer[income] < 30000, 1,
    Dim_Customer[income] < 60000, 2,
    Dim_Customer[income] < 90000, 3,
    4
)
```
