select 
    row_number() over (order by MODE_OF_PAYMENT, CARD_TYPE, CARD_NETWORK) as payment_method_id
    ,CARD_TYPE
    ,CARD_NETWORK
    ,UPI_APP
    ,NETBANKING_BANK
    ,MODE_OF_PAYMENT
from {{ref('SLV_PAYMENTS')}}
qualify row_number() over (partition by MODE_OF_PAYMENT order by CARD_TYPE, CARD_NETWORK) = 1