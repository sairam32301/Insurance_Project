{{ config(
    materialized = 'table'
)}}

with source_data as (

        select 
            is_lead
            ,is_leaving_policy	
            ,is_new_policy	
            ,record_category	
            ,rejection_date	
            ,rejection_reason
        from {{source('raw','BRZ_INSURANCE')}}
        
    ),

cleaned as (
        select
            trim(is_lead) as is_lead
           ,trim(is_leaving_policy) as is_leaving_policy
           ,trim(record_category) as record_category
           ,trim(
                    to_varchar(
                        coalesce(
                            try_to_date(rejection_date, 'DD-MM-YYYY'),
                            try_to_date(rejection_date, 'YYYY-MM-DD'),
                            try_to_date(rejection_date, 'DD/MM/YYYY'),
                            try_to_date(rejection_date, 'YYYY/MM/DD')
                        ),
                        'DD-MM-YYYY'
                    )
                ) as rejection_date
           ,trim(initcap(rejection_reason)) as rejection_reason
        from source_data
        where is_lead is not null
        and is_leaving_policy is not null
        and record_category is not null
        and rejection_date is not null
        and rejection_reason is not null
    )

select * from cleaned