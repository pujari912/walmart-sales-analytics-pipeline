-- ============================================
-- Optimization: OPTIMIZE, ZORDER, VACUUM
-- ============================================

-- Compact small files into fewer, larger files
OPTIMIZE silver_walmart_incremental;

-- Physically co-locate rows by Store for faster filtered queries
OPTIMIZE silver_walmart_incremental
ZORDER BY (Store);

-- Remove old, unreferenced files (respects 7-day retention by default)
VACUUM silver_walmart_incremental;


-- ============================================
-- Partitioning Strategy
-- ============================================

-- Partition table by Year for partition pruning on time-based queries
CREATE OR REPLACE TABLE silver_walmart_partitioned
USING DELTA
PARTITIONED BY (Year)
AS
SELECT *, YEAR(Date) AS Year
FROM silver_walmart;

-- Verify partitions were created correctly
SHOW PARTITIONS silver_walmart_partitioned;