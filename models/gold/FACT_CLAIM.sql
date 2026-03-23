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
    c.claim_amount,
    c.payout_ratio,
    c.claim_date,
    p.policy_id,
    cust.customer_id

from claim c
left join policy p
    on c.policy_id = p.policy_id

left join customer cust
    on p.customer_id = cust.customer_id