{% snapshot claim_snapshot %}

{{
config(
    target_schema='snapshots',
    unique_key='claim_id',
    strategy='check',
    check_cols=['claim_status','claim_amount','fraud_score']
)
}}

with deduped as (
    select
        *,
        row_number() over (partition by claim_id order by claim_date desc) as rn
    from {{ ref('SLV_CLAIM') }}
)

select
    claim_id,
    TRY_TO_NUMBER(claim_amount) AS claim_amount,
    claim_status,
    TRY_TO_NUMBER(fraud_score) AS fraud_score,
    claim_date
from deduped
where rn = 1

{% endsnapshot %}