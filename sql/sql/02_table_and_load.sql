USE DATABASE flight_project;
USE SCHEMA   flight_project_raw;

CREATE OR REPLACE TABLE flights (
  FL_DATE DATE,
  OP_CARRIER STRING,
  ORIGIN STRING,
  DEST STRING,
  DEP_DELAY INT,
  ARR_DELAY INT,
  CANCELLED INT,
  DISTANCE INT
);

-- Load from stage (maps columns, tolerates dirty rows)
COPY INTO flights
(FL_DATE, OP_CARRIER, ORIGIN, DEST, DEP_DELAY, ARR_DELAY, CANCELLED, DISTANCE)
FROM (
  SELECT
    TRY_TO_DATE($1),
    $2::STRING,
    $3::STRING,
    $4::STRING,
    TRY_TO_NUMBER($5)::INT,
    TRY_TO_NUMBER($6)::INT,
    TRY_TO_NUMBER($7)::INT,
    TRY_TO_NUMBER($8)::INT
  FROM @flight_stage
)
FILE_FORMAT = (
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('','NA')
)
ON_ERROR = 'CONTINUE';

-- Quick check
SELECT COUNT(*) AS row_count FROM flights;
SELECT * FROM flights LIMIT 10;
