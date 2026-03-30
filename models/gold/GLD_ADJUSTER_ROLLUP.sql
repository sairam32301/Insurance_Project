select
    adjuster_id,
    count(*) as total_claims_handled,
    round(sum(approved_amount), 2) as total_approved_amount,
    round(avg(approved_amount), 2) as avg_approved_amount,
    round(avg(case when documentation_complete then 1 else 0 end) * 100, 2) as documentation_completion_rate
from {{ ref('SLV_ADJUSTER') }}
group by adjuster_id