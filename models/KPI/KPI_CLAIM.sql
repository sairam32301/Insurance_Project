SELECT
    COUNT(CLAIM_ID) AS total_claims,
    SUM(CLAIM_AMOUNT) AS total_claim_amount,
    ROUND(AVG(CLAIM_AMOUNT),2) AS avg_claim_amount,
    ROUND(AVG(FRAUD_SCORE),2) AS avg_fraud_score
FROM {{ ref('FACT_CLAIM') }}