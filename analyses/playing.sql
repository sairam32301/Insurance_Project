select 
    count(*) as total_rows,
    count(payout_ratio) as non_null_values
from {{ ref('SLV_CLAIM') }}