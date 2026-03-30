
select
    mode_of_payment,
    count(*) as total_payments,
    count(distinct netbanking_bank) as unique_banks,
    round(avg(case when card_number != 'UNKNOWN' then 1 else 0 end), 2) as card_usage_rate,
    round(avg(case when upi_vpa != 'NA' then 1 else 0 end), 2) as upi_usage_rate
from {{ ref('SLV_PAYMENTS') }}
group by mode_of_payment