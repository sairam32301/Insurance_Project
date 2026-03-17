 select 
        card_expiry,
        card_issuer_bank,
        card_last4,
        card_network,
        card_number,
        card_type,
        netbanking_account_mask,
        netbanking_bank,
        netbanking_gateway,
        netbanking_ifsc,
        netbanking_txn_ref,
        mode_of_payment,
        payment_frequency,
        upi_app,
        upi_txn_ref,
        upi_vpa

    from {{ source('raw','BRZ_INSURANCE') }}