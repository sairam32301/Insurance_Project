select
    lead_id,
    customer_id,
    lead_source,
    lead_status,
    lead_created_date
from {{ ref('SLV_LEAD')}}