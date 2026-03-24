{{ config(materialized = 'table') }}

select 
  lead_id, 
  customer_id,
  lead_created_date,
  lead_source,
  {{ standardize_status('lead_status') }} as lead_status

from {{ source('raw','BRZ_INSURANCE') }}
where
lead_id is not null
and customer_id is not null
and lead_created_date is not null
and lead_source is not null
and lead_status is not null