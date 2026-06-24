\# Walmart Sales Analytics Pipeline



An end-to-end Data Engineering pipeline built on \*\*Databricks\*\*, using \*\*PySpark\*\*, \*\*Delta Lake\*\*, and \*\*SQL\*\*, following the \*\*Medallion Architecture\*\* (Bronze → Silver → Gold).



\## Project Overview



This project processes Walmart's historical weekly sales data (6,435 rows, 45 stores, 2010–2012) into a clean, query-ready analytics layer, complete with incremental loading, historical change tracking, business KPIs, automated scheduling, and performance optimization.



\## Architecture







\## Features Implemented



\- \*\*Medallion Architecture\*\* — Bronze, Silver, Gold layers with data quality checks

\- \*\*Star Schema Modeling\*\* — Fact and dimension tables for analytics-ready queries

\- \*\*Incremental Loading + MERGE/UPSERT\*\* — Simulated new data arrival, tested both INSERT and UPDATE paths of Delta Lake's MERGE

\- \*\*Slowly Changing Dimensions (SCD Type 1 \& 2)\*\* — Implemented both overwrite (Type 1) and full history tracking (Type 2) for store attribute changes

\- \*\*Advanced KPIs\*\* — Year-over-year growth, sales volatility (StdDev), holiday sales lift, quarterly store rankings using window functions

\- \*\*Interactive Dashboard\*\* — 3-page Databricks Lakeview dashboard (Sales Overview, Growth Trends, Holiday Analysis)

\- \*\*Workflow Automation\*\* — Scheduled Databricks Job to run the pipeline daily

\- \*\*Data Lineage\*\* — Verified automatic column-level lineage tracking across all tables and the dashboard

\- \*\*Performance Optimization\*\* — OPTIMIZE (file compaction), ZORDER (data co-location), VACUUM (storage cleanup)

\- \*\*Partitioning Strategy\*\* — Partitioned table by Year for partition pruning on time-based queries



\## Tech Stack



\- \*\*Platform:\*\* Databricks (Free Edition)

\- \*\*Processing:\*\* PySpark, Spark SQL

\- \*\*Storage:\*\* Delta Lake

\- \*\*Languages:\*\* Python, SQL

\- \*\*Visualization:\*\* Databricks Lakeview Dashboards



\## Repository Structure







\## Key Results



\- Reduced 3 small data files into 1 optimized file using `OPTIMIZE`

\- Verified MERGE correctly handles both new records (INSERT) and corrected records (UPDATE) without creating duplicates

\- Built a Star Schema with 1 fact table and 2 dimension tables for fast analytical queries

\- Automated daily pipeline execution via Databricks Workflows



\## Author



Shivashankar

