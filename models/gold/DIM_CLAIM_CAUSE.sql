select
    claim_id,
    upper(claim_cause) as claim_cause,
    upper(claim_subcause) as claim_subcause,
    case
        when claim_cause in ('Flood-Damage', 'Accidental-Damage', 'Earthquake','Glass-Damage','Burglary', 'Lost-Baggage', 'Theft', 'Flood', 'Fire') then 'PHYSICAL'
        when claim_cause in ('Trip-Cancellation', 'Medical-Emergency', 'Hospitalization', 'Critical-Illness', 'Maternity', 'Death-Natural', 'Surgery', 'Death-Accidental', 'Chronic-Disease') then 'NON-PHYSICAL'
        else 'OTHER'
    end as cause_category
from {{ ref('SLV_CLAIM') }}
group by
    claim_id,
    claim_cause,
    claim_subcause
having claim_id is not null