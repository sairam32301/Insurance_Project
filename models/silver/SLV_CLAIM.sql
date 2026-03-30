{{ config(
    materialized = 'incremental',
    unique_key = 'claim_id',
    on_schema_change = 'sync_all_columns',
    tags = ['claims', 'silver']
) }}

select
    TO_VARCHAR(TRY_TO_NUMBER(REGEXP_REPLACE(claim_id, '[^0-9]', ''))) AS claim_id,
    REGEXP_REPLACE(UPPER(TRIM(policy_id)), '[^0-9]', '') AS policy_id,
    case when ADJUSTER_ID like '%E%' then cast(try_to_number(ADJUSTER_ID) as varchar)
        else coalesce(ADJUSTER_ID,'UNKNOWN')
        end as ADJUSTER_ID,
    TRY_TO_NUMBER(claim_amount) AS claim_amount,
    claim_cause,
    claim_date,
    claim_status,
    claim_subcause,
    COALESCE(fault_party, 'NA') AS fault_party,
    COALESCE(injury_severity, 'NA') AS injury_severity,
    COALESCE(loss_type, 'NA') AS loss_type,
    COALESCE(TRY_TO_NUMBER(payout_ratio), 0) AS payout_ratio,
    police_report_filed,
    COALESCE(
    CASE 
        WHEN REGEXP_LIKE(fraud_score, '^[0-9]+$') 
        THEN TO_NUMBER(fraud_score)
        ELSE NULL
    END,0) AS fraud_score,
    CASE 
        WHEN REGEXP_LIKE(fraud_score, '^[0-9]+$') THEN
            CASE 
                WHEN TO_NUMBER(fraud_score) >= 80 THEN 'HIGH'
                WHEN TO_NUMBER(fraud_score) >= 50 THEN 'MEDIUM'
                ELSE 'LOW'
            END
        ELSE UPPER(fraud_score)
    END AS fraud_risk_category,
    current_timestamp as load_timestamp

from {{ source('raw','BRZ_INSURANCE') }}

where claim_id is not null
and policy_id is not null
and adjuster_id is not null
and claim_amount is not null
and claim_date is not null
and claim_status is not null
and claim_subcause is not null
and fraud_score is not null

{% if is_incremental() %}

and claim_date > coalesce(
        (select max(claim_date) from {{ this }}),
        '1900-01-01'
)

{% endif %}