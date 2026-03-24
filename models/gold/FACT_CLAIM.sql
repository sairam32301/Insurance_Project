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

select
    c.claim_id,
    p.policy_id,
    cust.customer_id,
    c.claim_date,
    c.claim_amount,
    c.claim_status,
    c.fraud_score,
    c.payout_ratio
  
from claim c
left join policy p
    on c.policy_id = p.policy_id

left join customer cust
    on p.customer_id = cust.customer_id