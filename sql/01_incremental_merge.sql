-- ============================================
-- Incremental Loading + MERGE/UPSERT
-- ============================================

-- Step 1: Create incoming data table (simulates new batch arriving)
CREATE OR REPLACE TABLE incoming_walmart_data AS
SELECT *
FROM silver_walmart
WHERE Date >= '2012-10-01';

-- Step 2: Create main incremental target table (existing historical data)
CREATE OR REPLACE TABLE silver_walmart_incremental AS
SELECT *
FROM silver_walmart
WHERE Date < '2012-10-01';

-- Step 3: MERGE / UPSERT - core incremental load logic
MERGE INTO silver_walmart_incremental AS target
USING incoming_walmart_data AS source
ON target.Store = source.Store AND target.Date = source.Date
WHEN MATCHED THEN
  UPDATE SET *
WHEN NOT MATCHED THEN
  INSERT *;

-- Verification
SELECT COUNT(*) AS total_after_merge FROM silver_walmart_incremental;