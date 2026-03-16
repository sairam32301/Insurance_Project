{{ config(
    materialized='table'
) }}

WITH source_data AS (

    SELECT
        TRIM(customer_id) AS customer_id,
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        UPPER(TRIM(gender)) AS gender,
        UPPER(TRIM(marital_status)) AS marital_status,
        TRY_TO_DATE(dob,'DD-MM-YYYY') AS dob,
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
        AND first_name IS NOT NULL
        AND last_name IS NOT NULL
        AND dob IS NOT NULL
        AND customer_email IS NOT NULL
        AND annual_income IS NOT NULL

),

transformed AS (

    SELECT
        customer_id,
        INITCAP(first_name) AS first_name,
        INITCAP(last_name) AS last_name,
        gender,
        marital_status,
        dob,
        DATEDIFF(year, dob, CURRENT_DATE()) AS age,
        customer_email,
        CONCAT(customer_address, ', ', customer_city, ', ', customer_country) AS customer_address,
        INITCAP(customer_city) AS customer_city,
        INITCAP(customer_country) AS customer_country,
        customer_pin_code,
        annual_income,
        alcohol_consumption,
        smoking_frequency,
        CASE
            WHEN annual_income > 100000 THEN 'High Income'
            WHEN annual_income BETWEEN 50000 AND 100000 THEN 'Middle Income'
            ELSE 'Low Income'
        END AS income_segment,
        
        CASE
            WHEN alcohol_consumption = 'High' OR smoking_frequency = 'Daily'
            THEN 'High Risk'
            WHEN alcohol_consumption = 'Moderate'
            THEN 'Moderate Risk'
            ELSE 'Low Risk'
        END AS lifestyle_segment

    FROM cleaned_data

)

SELECT * FROM transformed