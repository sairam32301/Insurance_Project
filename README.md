# Insurance_Project

## Overview
This is a dbt project for insurance analytics, transforming raw data into silver and gold layers for reporting and KPIs.

## Recent Changes
- **2026-03-30**: Fixed dbt model issues
  - Handled 'NaN' values in `payout_ratio` (SLV_CLAIM) by using `TRY_TO_NUMBER()` to convert invalid strings to 0
  - Deduplicated `policy_id` in SLV_POLICY using row_number to keep latest record per policy
  - Fixed exploding joins in FACT_CLAIM by correcting join conditions (added claim_id to adjuster join, deduplicated policy_id)
  - Added new gold rollup models: GLD_ADJUSTER_ROLLUP, GLD_AGENT_ROLLUP, GLD_PAYMENTS_ROLLUP, GLD_POLICY_ROLLUP
  - Renamed seeds/policy_status_mapping.sql to .csv
  - Added seeds/products_seed.csv