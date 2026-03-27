{{config(tags = ['claims', 'silver'])}}

with claim as (
    select * from {{ ref('SLV_CLAIM') }}
),

policy as (
    select * from {{ ref('SLV_POLICY') }}
),

customer as (
    select * from {{ ref('SLV_CUSTOMER') }}
)
,
adjuster as (
    select * from {{ ref('SLV_ADJUSTER')}}
)

select
    c.claim_id,
    a.ADJUSTER_ID,
    p.policy_id,
    cust.customer_id,
    c.claim_date,
    c.claim_amount,
    c.claim_status,
    c.fraud_score,
    c.payout_ratio
  
from claim c
inner join policy p
    on c.policy_id = p.policy_id
inner join customer cust
    on p.customer_id = cust.customer_id
inner join adjuster a
     on a.ADJUSTER_ID  = c.ADJUSTER_ID
where c.claim_id is not null
and p.policy_id is not null
and cust.customer_id is not null
and a.adjuster_id is not null