select 
    row_number() over (order by MODE_OF_PAYMENT) as payment_method_id
    ,CARD_TYPE
    ,CARD_NETWORK
    ,UPI_APP
    ,NETBANKING_BANK
    ,MODE_OF_PAYMENT
from {{ref('SLV_PAYMENTS')}}