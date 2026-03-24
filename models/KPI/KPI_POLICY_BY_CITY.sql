select 
  customer_city,
  count(policy_id) as total_policies,
  sum(premium_amount) as total_premium
from {{ ref('FACT_POLICY')}} F
JOIN {{ ref('DIM_CUSTOMER')}} C 
on F.customer_id = C.customer_id
group by 1
