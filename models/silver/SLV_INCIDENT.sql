{{ config(
    materialized = 'table'
) }}
   
with source_data as (

    select 
            incident_address,
            incident_city,
            incident_country,
            incident_date,
            incident_location,
            incident_zip,
            investigation_required
    from {{ source('raw', 'BRZ_INSURANCE') }}

),

cleaned as (

    select
        trim(incident_address) as incident_address,
        coalesce(trim(incident_city), 'UNKNOWN_CITY') as incident_city,
        case 
            when upper(trim(incident_country)) in ('INDIA') then 'INDIA'
            else 'INVALID_COUNTRY'
        end as incident_country,
        incident_date,
        trim(incident_location) as incident_location,
        case 
            when regexp_like(incident_zip, '^[0-9]{6}$') then incident_zip   -- India PIN = 6 digits
            else null
        end as incident_zip,
        coalesce(investigation_required, false) as investigation_required,
        -- Data quality flags
        case 
            when incident_date is null then 'Y'
            else 'N'
        end as is_bad_incident_date,
        case 
            when upper(trim(incident_country)) not in ('INDIA') then 'Y'
            else 'N'
        end as is_invalid_country
    from source_data

)

select *
from cleaned
where incident_date is not null
and incident_country = 'INDIA'