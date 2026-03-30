select 
    policy_id
    ,OFFICE_ADDRESS
    ,OFFICE_CITY
    ,OFFICE_COUNTRY
    ,OFFICE_ZIP
from {{ref('SLV_OFFICE')}}
