select
    row_number() over (order by product_name) as product_id,
    upper(COALESCE(nullif(trim(product_name), ''), 'NA')) as product_name,
    upper(COALESCE(nullif(trim(policy_type), ''), 'NA')) as policy_type,
    case
        when sum_assured < 250000 then 'LOW COVER'
        when sum_assured between 250000 and 1000000 then 'MEDIUM COVER'
        else 'HIGH COVER'
    end as coverage_segment,
    COALESCE(nullif(trim(source_system), ''), 'NA') as source_system
from {{ ref('SLV_POLICY') }}
where product_name is not null
  and policy_type is not null
  and sum_assured is not null
group by
    product_name,
    policy_type,
    sum_assured,
    source_system