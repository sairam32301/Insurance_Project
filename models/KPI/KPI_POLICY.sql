SELECT
    COUNT(DISTINCT POLICY_ID)  AS total_policies,
    round(SUM(PREMIUM_AMOUNT),2) AS total_premium,
    round(AVG(PREMIUM_AMOUNT),2) AS avg_premium,
    round(SUM(SUM_ASSURED),2) AS total_sum_assured
FROM {{ ref('FACT_POLICY') }}