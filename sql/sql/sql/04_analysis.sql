-- A) Monthly trend (exclude cancelled)
SELECT DATE_TRUNC('month', FL_DATE) AS month,
       ROUND(AVG(IFF(CANCELLED, NULL, ARR_DELAY)),2) AS avg_arr_delay
FROM flights_clean GROUP BY month ORDER BY month;

-- B) Cancellation rate by airline
SELECT OP_CARRIER,
       ROUND(100.0*AVG(IFF(CANCELLED,1,0)),2) AS cancel_rate_pct,
       COUNT(*) AS total_flights
FROM flights_clean
GROUP BY OP_CARRIER
HAVING COUNT(*)>=100
ORDER BY cancel_rate_pct DESC;

-- C) Worst routes (exclude cancelled; min 100)
SELECT ORIGIN, DEST,
       COUNT(*) AS flights,
       ROUND(AVG(IFF(CANCELLED,NULL,ARR_DELAY)),2) AS avg_arr_delay
FROM flights_clean
GROUP BY ORIGIN, DEST
HAVING COUNT(*)>=100
   AND AVG(IFF(CANCELLED,NULL,ARR_DELAY)) IS NOT NULL
ORDER BY avg_arr_delay DESC
LIMIT 20;

-- D) KPIs per airline from raw (arrival excl cancelled; dep = all valid)
SELECT OP_CARRIER,
       ROUND(AVG(IFF(CANCELLED IN (1,'1',TRUE,'TRUE'), NULL, ARR_DELAY)),2) AS avg_arr_delay,
       ROUND(AVG(DEP_DELAY),2) AS avg_dep_delay,
       COUNT(*) AS rows_total,
       COUNT(IFF(CANCELLED IN (1,'1',TRUE,'TRUE'), NULL, ARR_DELAY)) AS valid_arrivals,
       COUNT(DEP_DELAY) AS valid_departures
FROM flight_project.flight_project_raw.flights
GROUP BY OP_CARRIER
HAVING COUNT(DEP_DELAY)>0
ORDER BY avg_arr_delay DESC NULLS LAST;

-- E) On-time arrival (A15) by airline (completed = ARR_DELAY IS NOT NULL)
SELECT OP_CARRIER,
       COUNT_IF(ARR_DELAY IS NOT NULL) AS completed_flights,
       COUNT_IF(ARR_DELAY IS NOT NULL AND ARR_DELAY<=15) AS ontime_flights,
       ROUND(100.0*COUNT_IF(ARR_DELAY IS NOT NULL AND ARR_DELAY<=15)
/ NULLIF(COUNT_IF(ARR_DELAY IS NOT NULL),0),2) AS on_time_arrival_pct
FROM flight_project.flight_project_raw.flights
GROUP BY OP_CARRIER
ORDER BY on_time_arrival_pct DESC;
