{{ config(materialized='table') }}
select
   adjuster_comments,
   adjuster_id,
   try_cast(approved_amount as decimal(18,2)) as approved_amount,
   case
       when lower(documentation_complete) = 'yes' then true
       when lower(documentation_complete) = 'no' then false
       else null
   end as documentation_complete,
   try_cast(estimated_loss_amount as decimal(18,2)) as estimated_loss_amount,
   underwriting_comments
from {{ source('raw','BRZ_INSURANCE') }}
where
   adjuster_id is not null
   and try_cast(approved_amount as decimal(18,2)) is not null
   and try_cast(approved_amount as decimal(18,2)) >= 0