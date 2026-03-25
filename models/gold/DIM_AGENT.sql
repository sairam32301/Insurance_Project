select 
    AGENT_ID
    ,row_number() over (order by office_address) as office_id
    ,AGENT_NAME
    ,AGENT_BRANCH
    ,AGENT_GRADE
    ,SALES_CHANNEL
    ,PERFORMANCE_SEGMENT
from {{ref('SLV_AGENT')}}