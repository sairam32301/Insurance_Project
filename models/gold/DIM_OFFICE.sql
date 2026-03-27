select 
    row_number() over (order by OFFICE_ADDRESS, OFFICE_CITY) as office_sk
    ,OFFICE_ADDRESS
    ,OFFICE_CITY
    ,OFFICE_COUNTRY
    ,OFFICE_ZIP
from {{ref('SLV_OFFICE')}}
qualify row_number() over (partition by OFFICE_ADDRESS order by OFFICE_CITY) = 1