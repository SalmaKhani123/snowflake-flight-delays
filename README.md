# snowflake-flight-delays
**What this is:** My first solo Snowflake project. I ingested a large DOT/BTS flights CSV into Snowflake, applied simple cleaning rules, and ran basic analyses.

**How to run (in Snowsight):**
1) Run `sql/01_workspace_setup.sql`
2) Upload `flights.csv.gz` to the stage shown in step 1
3) Run `sql/02_table_and_load.sql`
4) (Optional) `sql/03_cleaning.sql`
5) Run `sql/04_analysis.sql`

**Logs:** see `/logs` for ingestion, cleaning, and analysis notes.

**Notes:** Some KPIs read directly from the raw table while I harden the clean layer.

## Problems & Fixes (from my run)
- Web upload limit (250MB) → Compressed to `flights.csv.gz` with 7-Zip.
- `COPY INTO` type issues → Used `TRY_TO_DATE/TRY_TO_NUMBER`, `NULL_IF`, `ON_ERROR='CONTINUE'`.
- `IFF` error → `CANCELLED` is 0/1, so I used `CANCELLED = 1` / `CANCELLED = 0`.
- “No results” on some queries → Removed strict HAVING filters; used `ARR_DELAY IS NOT NULL`.
- Current caveat → `ARR_DELAY/DEP_DELAY` look noisy; KPIs run from raw table while I refine cleaning.

## Findings (from my run)
- Overall on-time (A15): **0.34%**
- Note: ARR/DEP delays look off in v1 (mapping quirk). KPIs run from raw table; mapping fix planned in v2.
