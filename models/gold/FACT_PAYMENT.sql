select 
    p.policy_id
   ,p.customer_id
   ,p.mode_of_payment
   ,P.PAYMENT_FREQUENCY
   ,pol.PREMIUM_AMOUNT
   ,pol.POLICY_START_DATE as PAYMENT_DATE
from {{ref('SLV_PAYMENTS')}} p
left join {{ref('SLV_POLICY')}} pol
    on p.policy_id = pol.policy_id






