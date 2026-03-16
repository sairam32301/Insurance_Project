{{ config(materialized='table') }}
select
   adjuster_id,
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
where
   adjuster_id is not null
   and documentation_complete is not null
   and try_cast(approved_amount as decimal(18,2)) is not null
   and try_cast(approved_amount as decimal(18,2)) >= 0
   and adjuster_comments is not null
   and underwriting_comments is not null