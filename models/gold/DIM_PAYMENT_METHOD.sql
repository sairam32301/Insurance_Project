select 
    row_number() over (order by MODE_OF_PAYMENT, CARD_TYPE, CARD_NETWORK) as payment_method_id,
    CARD_TYPE,
    card_number,
    CARD_NETWORK,
    UPI_APP,
    NETBANKING_BANK,
    MODE_OF_PAYMENT
from {{ ref('SLV_PAYMENTS') }}