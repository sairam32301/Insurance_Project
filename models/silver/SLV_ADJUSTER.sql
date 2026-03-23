{{ config(materialized='table') }}
select
    case when ADJUSTER_ID like '%E%' then cast(try_to_number(ADJUSTER_ID) as varchar)
        else coalesce(ADJUSTER_ID,'UNKNOWN')
        end as ADJUSTER_ID,
    trim(claim_id) as claim_id,
    case
       when lower(documentation_complete) = 'yes' then true
       when lower(documentation_complete) = 'no' then false
       else null
    end as documentation_complete,
   try_cast(estimated_loss_amount as decimal(18,2)) as estimated_loss_amount,
   try_cast(approved_amount as decimal(18,2)) as approved_amount,
   adjuster_comments,
   underwriting_comments
from {{ source('raw','BRZ_INSURANCE') }}
where claim_id is not null
   and adjuster_id is not null
   and documentation_complete is not null
   and try_cast(approved_amount as decimal(18,2)) is not null
   and try_cast(approved_amount as decimal(18,2)) >= 0
   and adjuster_comments is not null
   and underwriting_comments is not null