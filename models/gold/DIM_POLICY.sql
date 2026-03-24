select 
    POLICY_ID
    ,POLICY_TYPE
    ,PRODUCT_NAME
    ,SOURCE_SYSTEM
from {{ref('SLV_POLICY')}}