{{ config(
    materialized='table'
) }}

WITH source_data AS (

    SELECT
        TRIM(customer_id) AS customer_id,
        REGEXP_REPLACE(UPPER(TRIM(policy_id)), '[^0-9]', '') AS policy_id,
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        UPPER(TRIM(gender)) AS gender,
        UPPER(TRIM(marital_status)) AS marital_status,
        TRY_TO_DATE(dob,'DD-MM-YYYY') AS dob,
        customer_phone,
        TRIM(alcohol_consumption) AS alcohol_consumption,
        TRIM(smoking_frequency) AS smoking_frequency,
        TRY_TO_NUMBER(annual_income) AS annual_income,
        LOWER(TRIM(customer_email)) AS customer_email,
        TRIM(customer_address) AS customer_address,
        TRIM(customer_city) AS customer_city,
        TRIM(customer_country) AS customer_country,
        TRIM(customer_pin_code) AS customer_pin_code

    FROM {{ source('raw', 'BRZ_INSURANCE') }}

),

cleaned_data AS (

    SELECT *
    FROM source_data
    WHERE
        customer_id IS NOT NULL
        AND policy_id IS NOT NULL
        AND first_name IS NOT NULL
        AND last_name IS NOT NULL
        AND dob IS NOT NULL
        AND customer_email IS NOT NULL
        AND annual_income IS NOT NULL
        AND customer_phone IS NOT NULL
        AND upper(customer_phone) NOT LIKE '%P%'

),

transformed AS (

    SELECT
        customer_id,
        policy_id,
        INITCAP(first_name) AS first_name,
        INITCAP(last_name) AS last_name,
        case when gender in ('FEMLE,FMALE') then 'FEMALE'
            when gender IS NULL then 'UNKNOWN' else GENDER end as gender,
        COALESCE(c.CORRECTED_VALUE,cleaned_data.marital_status) AS marital_status,
        dob,
        DATEDIFF(year, dob, CURRENT_DATE()) AS age,
        case when customer_phone  like '%E%' then
        concat(
        substr(concat('+', try_to_number(customer_phone)), 1, 3), ' ',substr(concat('+', try_to_number(customer_phone)), 4))      
        else concat(substr(customer_phone, 1, 3),' ',substr(customer_phone,4))  end as customer_phone,
        customer_email,
        CONCAT(customer_address, ', ', customer_city, ', ', customer_country) AS customer_address,
        CASE WHEN REGEXP_LIKE(CUSTOMER_CITY, '[^A-Za-z0-9]+$') OR CUSTOMER_CITY IS NULL OR UPPER(CUSTOMER_CITY)='CITY' THEN 'Unknown'
            ELSE INITCAP(CUSTOMER_CITY) END as CUSTOMER_CITY,
        CASE WHEN customer_country = 'Inda' THEN 'India'
            WHEN customer_country IS NULL THEN 'Unknown'  ELSE INITCAP(customer_country) END AS customer_country,
        CASE WHEN REGEXP_LIKE(CUSTOMER_PIN_CODE, '^[0-9]{6}$') THEN CUSTOMER_PIN_CODE ELSE 'UNKNOWN' END  AS CUSTOMER_PIN_CODE,   
        annual_income,
        case when alcohol_consumption is null or alcohol_consumption = 'NaN' then 'UNKNOWN' 
            when alcohol_consumption = '0' then 'Never' else alcohol_consumption end as alcohol_consumption,
        case when smoking_frequency is null or smoking_frequency = 'NaN' then 'UNKNOWN' else smoking_frequency end as smoking_frequency,
        CASE
            WHEN annual_income IS NULL THEN NULL
            WHEN annual_income > 100000 THEN 'High Income'
            WHEN annual_income BETWEEN 50000 AND 100000 THEN 'Middle Income'
            ELSE 'Low Income'
        END AS income_segment,
        
        CASE
            WHEN alcohol_consumption IS NULL OR smoking_frequency IS NULL THEN 'UNKNOWN'
            WHEN alcohol_consumption = 'High' OR smoking_frequency = 'Daily'
            THEN 'High Risk'
            WHEN alcohol_consumption = 'Moderate'
            THEN 'Moderate Risk'
            ELSE 'Low Risk'
        END AS lifestyle_segment

    FROM cleaned_data
    left join {{ ref('marital_status_standardized')}} c
    on upper(cleaned_data.marital_status) = upper(c.raw_value)
    WHERE REGEXP_LIKE(CUSTOMER_ID, '^[0-9]+$')
    AND annual_income > 0

)

SELECT * FROM transformed