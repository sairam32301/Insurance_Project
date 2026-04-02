{{ config(materialized='table') }}

WITH source_data AS (

SELECT
    TRIM(agent_id) AS agent_id,
    TRIM(office_address) AS office_address,
    TRIM(agent_branch) AS agent_branch,
    TRIM(agent_grade) AS agent_grade,
    TRIM(agent_name) AS agent_name,
    TRIM(issuer_type) AS issuer_type,
    TRIM(sales_channel) AS sales_channel

FROM {{ source('raw','BRZ_INSURANCE') }}

),

cleaned_data AS (

SELECT *
FROM source_data
WHERE
    agent_id IS NOT NULL
    AND agent_name IS NOT NULL

),

transformed AS (

SELECT

    agent_id,
    INITCAP(agent_name) AS agent_name,
    coalesce(INITCAP(agent_branch),'UNKNOWN') AS agent_branch,
    CASE 
        WHEN office_address IS NULL THEN 'UNKNOWN'
        WHEN REGEXP_LIKE(office_address, '^[\/]+$') THEN 'UNKNOWN'  
        WHEN UPPER(TRIM(office_address)) = 'ADDR' THEN 'UNKNOWN'     
        ELSE TRIM(REGEXP_REPLACE(office_address, '[\\/]', ''))  
    END AS office_address,
    coalesce(UPPER(agent_grade), 'UNKNOWN') AS agent_grade,
    INITCAP(issuer_type) AS issuer_type,
    INITCAP(sales_channel) AS sales_channel,
    CASE
        WHEN agent_grade IN ('A','A+') THEN 'Top Performer'
        WHEN agent_grade = 'B' THEN 'Average Performer'
        ELSE 'Low Performer'
    END AS performance_segment
FROM cleaned_data

)

SELECT * FROM transformed
