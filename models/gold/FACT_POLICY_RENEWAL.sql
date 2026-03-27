select
    p.policy_id,
    p.customer_id,
    p.agent_id,
    p.policy_start_date,
    p.policy_end_date,
    datediff(day, p.policy_end_date, current_date) as days_since_expiry,
    case
        when p.policy_status = 'ACTIVE' then 'NOT_DUE'
        when current_date <= p.policy_end_date then 'UPCOMING'
        when current_date > p.policy_end_date then 'OVERDUE'
        else 'UNKNOWN'
    end as renewal_stage,
    p.premium_amount,
    p.sum_assured,
    p.policy_term_years
from {{ ref('SLV_POLICY') }} p