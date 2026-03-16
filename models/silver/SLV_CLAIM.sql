{{ config(
    materialized = 'incremental',
    unique_key = 'claim_id',
    on_schema_change = 'sync_all_columns'
) }}

select
    claim_id,
    claim_amount,
    claim_cause,
    claim_date,
    claim_status,
    claim_subcause,
    fault_party,
    injury_severity,
    loss_type,
    payout_ratio,
    police_report_filed,
    fraud_score,
    case
        when try_to_number(fraud_score) >= 80 then 'HIGH'
        when try_to_number(fraud_score) >= 50 then 'MEDIUM'
        else 'LOW'
    end as fraud_risk_category,
    current_timestamp as load_timestamp
from {{ source('raw','BRZ_INSURANCE') }}
where claim_id is not null
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