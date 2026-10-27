# Customer Analytics Executive Dashboard

An end-to-end Business Intelligence project demonstrating the complete data lifecycle: data extraction and transformation in **Excel (Power Query)**, relational staging and modeling in **SQL Server**, and interactive executive reporting in **Power BI Desktop**.

---

## Dashboard Preview

![Dashboard Preview](powerBI/images/dashboard_preview.png)

---

## End-to-End Pipeline

---

##  What This Analytics Project Delivers

This project processes raw customer demographics, transactional histories, and marketing response records to help business stakeholders make data-driven growth decisions:

1. **Customer Value Segmentation:** Identifies high-value customer brackets (earning $90K+) that generate the largest share of total revenue and exhibit the highest response rates to promotional campaigns.
2. **Channel Performance Evaluation:** Compares transaction volumes across In-Store, Web, Catalog, and Deal purchases to determine the most cost-effective sales channels.
3. **Campaign Conversion Tracking:** Analyzes how educational background and family structure influence conversion rates, optimizing future marketing budget allocation.
4. **Historical Growth Trends:** Tracks customer acquisition over time to detect seasonal patterns and monitor long-term retention dynamics.

---

## Repository Structure

```text
├── power_query/
│   └── excel_transformations.m          # Deduplication & initial data preparation
├── sql/
│   ├── 01_data_cleaning_etl.sql         # Data cleaning & transformation scripts
│   └── 02_analytical_views.sql          # Final analytical views for reporting
├── power_bi/
│   └── dax_measures.md                  # Core DAX formulas & calculated business metrics
├── images/
│   └── dashboard_preview.png            # High-resolution dashboard screenshot
└── README.md                            # 

Main project overview


---

## 👤 Author & Contact
- **Author:** Mahmoud
- **LinkedIn:** www.linkedin.com/in/mahmoud-ibrahim-6bb00b377
- **GitHub:** https://github.com/mahmoud14043-bit/End-to-End-Customer-Analytics-BI.git

---

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
