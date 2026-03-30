select
    agent_id,
    count(*) as total_customers,
    count(agent_branch) as total_branches,
    count(office_address) as office_count,
    performance_segment,
    agent_grade
from {{ ref('SLV_AGENT') }}
group by agent_id, performance_segment, agent_grade