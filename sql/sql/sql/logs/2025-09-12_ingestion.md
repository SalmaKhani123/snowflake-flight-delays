Ingestion Log — 2025-09-12

Worksheet: Flight_Project_Main
Goal: Ingest DOT/BTS flights CSV into Snowflake.
Issue & Fix: CSV ~537 MB > UI 250 MB → compressed to flights.csv.gz (7-Zip) and uploaded to stage.

Setup
CREATE OR REPLACE DATABASE flight_project;
CREATE OR REPLACE SCHEMA  flight_project.flight_project_raw;
CREATE OR REPLACE STAGE   flight_project.flight_project_raw.flight_stage;

USE DATABASE flight_project;
USE SCHEMA   flight_project_raw;

LIST @flight_project.flight_project_raw.flight_stage;  -- expect: flights.csv.gz

Landing table + load
CREATE OR REPLACE TABLE flights (
  FL_DATE DATE, OP_CARRIER STRING, ORIGIN STRING, DEST STRING,
  DEP_DELAY INT, ARR_DELAY INT, CANCELLED INT, DISTANCE INT
);

COPY INTO flights
(FL_DATE, OP_CARRIER, ORIGIN, DEST, DEP_DELAY, ARR_DELAY, CANCELLED, DISTANCE)
FROM (
  SELECT
    TRY_TO_DATE($1),
    $2::STRING, $3::STRING, $4::STRING,
    TRY_TO_NUMBER($5)::INT, TRY_TO_NUMBER($6)::INT,
    TRY_TO_NUMBER($7)::INT, TRY_TO_NUMBER($8)::INT
  FROM @flight_stage
)
FILE_FORMAT=(TYPE=CSV SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"' NULL_IF=('','NA'))
ON_ERROR='CONTINUE';

Checks
SELECT COUNT(*) AS row_count FROM flights;
SELECT * FROM flights LIMIT 10;


Notes: Inline file format + safe casts; ON_ERROR='CONTINUE' loads good rows; blanks/“NA” → NULL.
