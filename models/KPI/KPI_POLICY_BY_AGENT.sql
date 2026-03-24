SELECT
    A.AGENT_NAME,
    COUNT(F.POLICY_ID) AS total_policies,
    SUM(F.PREMIUM_AMOUNT) AS total_premium
FROM {{ ref('FACT_POLICY') }} F
JOIN {{ ref('DIM_AGENT') }} A
    ON F.AGENT_ID = A.AGENT_ID
GROUP BY A.AGENT_NAME