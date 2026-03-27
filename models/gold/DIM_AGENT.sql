select 
    AGENT_ID
    ,row_number() over (order by AGENT_ID) as agent_sk
    ,AGENT_NAME
    ,AGENT_BRANCH
    ,AGENT_GRADE
    ,SALES_CHANNEL
    ,PERFORMANCE_SEGMENT
from {{ref('SLV_AGENT')}}
qualify row_number() over (partition by AGENT_ID order by AGENT_ID) = 1