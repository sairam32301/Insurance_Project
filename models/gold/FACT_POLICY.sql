select
    policy_id,
    customer_id,
    agent_id,
    product_id,
    POLICY_START_DATE,
    POLICY_END_DATE,
    POLICY_STATUS,
    product_name,
    premium_amount,
    SUM_ASSURED,
    POLICY_TERM_YEARS
from {{ ref('SLV_POLICY') }}