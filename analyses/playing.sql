select distinct(source_system)
from {{ source('raw','BRZ_INSURANCE') }}