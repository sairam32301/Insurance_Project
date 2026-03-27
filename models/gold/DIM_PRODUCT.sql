select
    row_number() over (order by product_name) as product_id,
    upper(product_name) as product_name,
    upper(policy_type) as policy_type,
    case
        when sum_assured < 250000 then 'LOW COVER'
        when sum_assured between 250000 and 1000000 then 'MEDIUM COVER'
        else 'HIGH COVER'
    end as coverage_segment,
    source_system
from {{ ref('SLV_POLICY') }}
group by
    product_name,
    policy_type,
    sum_assured,
    source_system