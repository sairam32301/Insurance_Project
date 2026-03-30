{{config(tags = ['claims', 'silver'])}}

with claim as (
    select * from {{ ref('SLV_CLAIM') }}
),

policy as (
    select * from {{ ref('SLV_POLICY') }}
),

adjuster as (
    select * from {{ ref('SLV_ADJUSTER')}}
)

select
    c.claim_id,
    a.ADJUSTER_ID,
    p.policy_id,
    P.customer_id,
    c.claim_date,
    c.claim_amount,
    c.claim_status,
    c.fraud_score,
    c.payout_ratio
  
from claim c
inner join policy p
    on c.policy_id = p.policy_id
    and c.claim_id = p.claim_id
inner join adjuster a
    on a.claim_id = c.claim_id
    and a.ADJUSTER_ID = c.ADJUSTER_ID
where c.claim_id is not null
and p.policy_id is not null
and p.customer_id is not null
and a.adjuster_id is not null