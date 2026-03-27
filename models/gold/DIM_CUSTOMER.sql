select 
    customer_id
    ,CONCAT_WS(' ', NULLIF(first_name, ''), NULLIF(last_name, '')) AS full_name
    ,gender
    ,dob
    ,age
    ,marital_status
    ,annual_income
    ,income_segment
    ,lifestyle_segment
    ,smoking_frequency
    ,alcohol_consumption
    ,customer_city
    ,customer_country
    ,customer_pin_code
from {{ref('SLV_CUSTOMER')}}