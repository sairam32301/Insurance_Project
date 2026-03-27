select 
    row_number() over (order by p.policy_id, p.customer_id, p.netbanking_txn_ref) as payment_id
   ,p.policy_id
   ,p.customer_id
   ,p.mode_of_payment
   ,P.PAYMENT_FREQUENCY
   ,pol.PREMIUM_AMOUNT
   ,pol.POLICY_START_DATE as PAYMENT_DATE
from {{ref('SLV_PAYMENTS')}} p
inner join {{ref('SLV_POLICY')}} pol
    on p.policy_id = pol.policy_id
where p.policy_id is not null
and pol.policy_id is not null






