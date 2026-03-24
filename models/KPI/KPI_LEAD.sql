SELECT
    COUNT(LEAD_ID) AS total_leads
FROM {{ ref('FACT_LEAD') }}