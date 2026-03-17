{% snapshot claim_snapshot %}

{{
config(
    target_schema='snapshots',
    unique_key='claim_id',
    strategy='check',
    check_cols=['claim_status','claim_amount','fraud_score']
)
}}

select
    claim_id,
    claim_amount,
    claim_status,
    fraud_score,
    claim_date
from {{ ref('SLV_CLAIM') }}

{% endsnapshot %}