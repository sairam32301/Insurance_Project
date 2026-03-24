select 
    row_number() over (order by office_address) as office_id
    ,OFFICE_ADDRESS
    ,OFFICE_CITY
    ,OFFICE_COUNTRY
    ,OFFICE_ZIP
from {{ref('SLV_OFFICE')}}