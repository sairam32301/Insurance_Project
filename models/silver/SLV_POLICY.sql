{{ config(
    materialized = 'table'
) }}

with source_data as (

    select 
        source_system,
        policy_id,
        customer_id,
        agent_id,
        policy_end_date,
        policy_number,
        policy_start_date,
        policy_status,
        policy_term_years,
        policy_type,
        product_name,
        premium_amount,
        sum_assured
    from {{ source('raw','BRZ_INSURANCE') }}

),

cleaned as (

    select 
        upper(coalesce(source_system, 'UNKNOWN')) as source_system,
        case when policy_id like '%E%' then cast(try_to_number(policy_id) as varchar)
        when policy_id is null or upper(policy_id) like '%P%' then 'UNKNOWN'
        else policy_id end as policy_id,
        TRIM(customer_id) AS customer_id,
        TRIM(agent_id) AS agent_id,
        coalesce(policy_number, 'NA') as policy_number,
        coalesce(
            try_to_date(policy_start_date, 'YYYY-MM-DD'),
            try_to_date(policy_start_date, 'DD-MM-YYYY'),
            to_date('1900-01-01')
        ) as policy_start_date,
        coalesce(
            try_to_date(policy_end_date, 'YYYY-MM-DD'),
            try_to_date(policy_end_date, 'DD-MM-YYYY'),
            to_date('1900-01-01')
        ) as policy_end_date,
        upper(coalesce(policy_status, 'UNKNOWN')) as policy_status,
        coalesce(try_to_number(policy_term_years), 0) as policy_term_years,
        coalesce(try_to_decimal(premium_amount, 18, 2), 0) as premium_amount,
        coalesce(try_to_decimal(sum_assured, 18, 2), 0) as sum_assured,
        upper(coalesce(policy_type, 'UNKNOWN')) as policy_type,
        upper(coalesce(product_name, 'UNKNOWN')) as product_name

    from source_data

)


select 
    source_system,
    policy_id,
    customer_id,
    agent_id,
    policy_number,
    policy_start_date,
    policy_end_date,
    policy_status,
    policy_term_years,
    policy_type,
    product_name,
    premium_amount,
    sum_assured
from cleaned
where customer_id IS NOT NULL
and agent_id IS NOT NULL
and policy_term_years > 0
and premium_amount  > 0
and sum_assured > 0
and regexp_like(policy_id, '^[0-9]+$')