-- ============================================
-- Slowly Changing Dimensions (SCD Type 1 & Type 2)
-- ============================================

-- ---------- SCD TYPE 1 (Overwrite, no history) ----------
ALTER TABLE dim_store ADD COLUMN Region STRING;

UPDATE dim_store SET Region = 'South' WHERE Store_ID BETWEEN 1 AND 15;
UPDATE dim_store SET Region = 'North' WHERE Store_ID BETWEEN 16 AND 30;
UPDATE dim_store SET Region = 'East' WHERE Store_ID BETWEEN 31 AND 45;
UPDATE dim_store SET Region = 'West' WHERE Store_ID > 45;

-- Simulate a region change (overwrite, no history kept)
UPDATE dim_store
SET Region = 'North'
WHERE Store_ID = 12;


-- ---------- SCD TYPE 2 (Keep full history) ----------
CREATE OR REPLACE TABLE dim_store_scd2 (
    Store_ID INT,
    Region STRING,
    Start_Date DATE,
    End_Date DATE,
    Is_Current BOOLEAN
);

-- Insert original baseline
INSERT INTO dim_store_scd2
SELECT Store_ID,
       CASE
         WHEN Store_ID BETWEEN 1 AND 15 THEN 'South'
         WHEN Store_ID BETWEEN 16 AND 30 THEN 'North'
         WHEN Store_ID BETWEEN 31 AND 45 THEN 'East'
         ELSE 'West'
       END AS Region,
       DATE('2010-02-05') AS Start_Date,
       NULL AS End_Date,
       TRUE AS Is_Current
FROM dim_store;

-- Simulate a change: Store 12 moves South -> North
-- Step 1: Expire the old row
UPDATE dim_store_scd2
SET End_Date = DATE('2022-01-01'),
    Is_Current = FALSE
WHERE Store_ID = 12 AND Is_Current = TRUE;

-- Step 2: Insert the new current row
INSERT INTO dim_store_scd2
VALUES (12, 'North', DATE('2022-01-01'), NULL, TRUE);

-- Verification - should show 2 rows for Store 12 (history preserved)
SELECT * FROM dim_store_scd2 WHERE Store_ID = 12 ORDER BY Start_Date;