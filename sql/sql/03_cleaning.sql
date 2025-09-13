USE DATABASE flight_project;
USE SCHEMA   flight_project_raw;

-- Basic cleaning into a new table
CREATE OR REPLACE TABLE flights_clean AS
SELECT
  FL_DATE,
  UPPER(OP_CARRIER) AS OP_CARRIER,
  UPPER(ORIGIN)     AS ORIGIN,
  UPPER(DEST)       AS DEST,
  CASE WHEN DEP_DELAY < 0 THEN 0
       WHEN DEP_DELAY > 1000 THEN NULL
       ELSE DEP_DELAY END AS DEP_DELAY,
  CASE WHEN ARR_DELAY < 0 THEN 0
       WHEN ARR_DELAY > 1000 THEN NULL
       ELSE ARR_DELAY END AS ARR_DELAY,
  IFF(CANCELLED IN (1,'1',TRUE,'TRUE'), TRUE, FALSE) AS CANCELLED,
  NULLIF(DISTANCE, 0) AS DISTANCE
FROM flights;

-- Quick check
SELECT COUNT(*) AS rows_clean FROM flights_clean;
SELECT * FROM flights_clean LIMIT 10;

## Results (from my run)
- rows_total: **3,000,000**
- DEP delay min/max: **19393 / 20452**  ← looks off (mapping to fix later)
- ARR delay min/max: **1 / 9562**       ← looks off (mapping to fix later)
- CANCELLED counts: **TRUE=0, FALSE=0** ← indicates CANCELLED not populated

_Note:_ Delay and cancelled columns need remapping; analysis uses robust queries that don’t depend on them until fixed.
