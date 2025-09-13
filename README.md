# snowflake-flight-delays
**What this is:** My first Snowflake + GitHub project. I ingested a large DOT/BTS flights CSV into Snowflake, applied simple cleaning rules, and ran basic analyses.

**How to run (in Snowsight):**
1) Run `sql/01_workspace_setup.sql`
2) Upload `flights.csv.gz` to the stage shown in step 1
3) Run `sql/02_table_and_load.sql`
4) (Optional) `sql/03_cleaning.sql`
5) Run `sql/04_analysis.sql`

**Logs:** see `/logs` for ingestion, cleaning, and analysis notes.

**Notes:** Some KPIs read directly from the raw table while I harden the clean layer.
