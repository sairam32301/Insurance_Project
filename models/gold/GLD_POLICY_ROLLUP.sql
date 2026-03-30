with policy_data as (
    select
        COALESCE(nullif(trim(policy_type), ''), 'NA') as policy_type,
        COALESCE(nullif(trim(product_name), ''), 'NA') as product_name,
        count(*) as total_policies,
        round(sum(premium_amount), 2) as total_premium,
        round(sum(sum_assured), 2) as total_sum_assured,
        round(avg(policy_term_years), 2) as avg_policy_term
    from {{ ref('SLV_POLICY') }}
    where policy_type is not null
      and product_name is not null
      and premium_amount is not null
    group by policy_type, product_name
    having count(*) > 0
),

dim_policy_join as (
    select
        pd.policy_type,
        pd.product_name,
        pd.total_policies,
        pd.total_premium,
        pd.total_sum_assured,
        pd.avg_policy_term,
        dp.POLICY_ID
    from policy_data pd
    inner join {{ ref('DIM_POLICY') }} dp
        on pd.policy_type = dp.POLICY_TYPE
        and pd.product_name = dp.PRODUCT_NAME
    where dp.POLICY_ID is not null
)

select * from dim_policy_join
-- Connected to DIM_POLICY dimension table for policy classification
-- NULLs and blanks replaced with 'NA', only policies with complete data included
