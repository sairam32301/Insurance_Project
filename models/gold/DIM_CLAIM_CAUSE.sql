select
    row_number() over (order by claim_cause, claim_subcause) as claim_cause_id,
    upper(claim_cause) as claim_cause,
    upper(claim_subcause) as claim_subcause,
    case
        when claim_cause in ('ACCIDENT', 'INJURY', 'LOSS') then 'PHYSICAL'
        when claim_cause in ('THEFT', 'FRAUD') then 'NON-PHYSICAL'
        else 'OTHER'
    end as cause_category
from {{ ref('SLV_CLAIM') }}
group by
    claim_cause,
    claim_subcause
