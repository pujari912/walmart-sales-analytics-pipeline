-- ============================================
-- Advanced Gold-Layer KPI Tables
-- ============================================

-- KPI 1: Year-over-Year Growth per Store
CREATE OR REPLACE TABLE gold_yoy_growth AS
WITH yearly_sales AS (
  SELECT
    Store,
    YEAR(Date) AS Year,
    SUM(Weekly_Sales) AS Total_Sales
  FROM silver_walmart
  GROUP BY Store, YEAR(Date)
)
SELECT
  curr.Store,
  curr.Year,
  curr.Total_Sales AS Current_Year_Sales,
  prev.Total_Sales AS Previous_Year_Sales,
  ROUND(((curr.Total_Sales - prev.Total_Sales) / prev.Total_Sales) * 100, 2) AS YoY_Growth_Percent
FROM yearly_sales curr
LEFT JOIN yearly_sales prev
  ON curr.Store = prev.Store AND curr.Year = prev.Year + 1;


-- KPI 2: Average Weekly Sales + Volatility per Store
CREATE OR REPLACE TABLE gold_avg_weekly_sales AS
SELECT
  Store,
  ROUND(AVG(Weekly_Sales), 2) AS Avg_Weekly_Sales,
  ROUND(STDDEV(Weekly_Sales), 2) AS Sales_Std_Dev,
  ROUND(MIN(Weekly_Sales), 2) AS Min_Weekly_Sales,
  ROUND(MAX(Weekly_Sales), 2) AS Max_Weekly_Sales
FROM silver_walmart
GROUP BY Store
ORDER BY Avg_Weekly_Sales DESC;


-- KPI 3: Holiday Sales Lift per Store
CREATE OR REPLACE TABLE gold_holiday_lift AS
WITH holiday_avg AS (
  SELECT Store, Holiday_Flag, AVG(Weekly_Sales) AS Avg_Sales
  FROM silver_walmart
  GROUP BY Store, Holiday_Flag
)
SELECT
  h.Store,
  ROUND(h.Avg_Sales, 2) AS Avg_Holiday_Sales,
  ROUND(n.Avg_Sales, 2) AS Avg_Non_Holiday_Sales,
  ROUND(((h.Avg_Sales - n.Avg_Sales) / n.Avg_Sales) * 100, 2) AS Holiday_Lift_Percent
FROM holiday_avg h
JOIN holiday_avg n
  ON h.Store = n.Store
WHERE h.Holiday_Flag = 1 AND n.Holiday_Flag = 0
ORDER BY Holiday_Lift_Percent DESC;


-- KPI 4: Store Ranking by Quarter (window function)
CREATE OR REPLACE TABLE gold_quarterly_ranking AS
WITH quarterly_sales AS (
  SELECT
    Store,
    YEAR(Date) AS Year,
    QUARTER(Date) AS Quarter,
    SUM(Weekly_Sales) AS Total_Sales
  FROM silver_walmart
  GROUP BY Store, YEAR(Date), QUARTER(Date)
)
SELECT
  Year,
  Quarter,
  Store,
  Total_Sales,
  RANK() OVER (PARTITION BY Year, Quarter ORDER BY Total_Sales DESC) AS Quarter_Rank
FROM quarterly_sales;