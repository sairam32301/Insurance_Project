with adjuster_base as (
    select 
        ADJUSTER_ID
        ,COALESCE(nullif(trim(ADJUSTER_COMMENTS), ''), 'NA') AS ADJUSTER_COMMENTS
        ,COALESCE(nullif(trim(UNDERWRITING_COMMENTS), ''), 'NA') AS UNDERWRITING_COMMENTS
    from {{ref('SLV_ADJUSTER')}}
    where ADJUSTER_ID is not null
),

adjuster_with_fact_link as (
    select
        ab.ADJUSTER_ID,
        ab.ADJUSTER_COMMENTS,
        ab.UNDERWRITING_COMMENTS,
        COALESCE(count(distinct fc.claim_id), 0) as total_claims_handled
    from adjuster_base ab
    left join {{ ref('FACT_CLAIM') }} fc
        on ab.ADJUSTER_ID = fc.ADJUSTER_ID
    group by
        ab.ADJUSTER_ID,
        ab.ADJUSTER_COMMENTS,
        ab.UNDERWRITING_COMMENTS
)

select * from adjuster_with_fact_link
