{{ config(
    materialized = 'table'
) }}

with source_data as (

    select
        policy_id,
        office_address,
        office_city,
        office_country,
        office_zip
    from {{ source('raw', 'BRZ_INSURANCE') }}

),

cleaned as (

    select
        REGEXP_REPLACE(UPPER(TRIM(policy_id)), '[^0-9]', '') AS policy_id,
        CASE 
        WHEN office_address IS NULL THEN NULL
        WHEN REGEXP_LIKE(office_address, '^[\/]+$') THEN NULL  
        WHEN UPPER(TRIM(office_address)) = 'ADDR' THEN NULL     
        ELSE TRIM(REGEXP_REPLACE(office_address, '[\\/]', ''))  
        END AS office_address,
        trim(office_city) as office_city,
        upper(trim(office_country)) as office_country,
        trim(office_zip) as office_zip
    from source_data

),

filtered as (

    select *
    from cleaned
    where policy_id is not null
        and office_address is not null
        and office_city is not null
        and office_country is not null
        and office_zip is not null
        and office_address <> ''
        and office_city <> ''
        and office_country <> ''
        and office_zip <> ''
        and regexp_like(office_zip, '^[0-9]{6}$')

)

select * from filtered
