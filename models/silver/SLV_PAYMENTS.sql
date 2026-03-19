{{ config(
    materialized = 'incremental',
    unique_key = 'netbanking_txn_ref'
) }}

with source_data as (

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

),

cleaned as (

    select 
        coalesce(card_expiry, 'NA') as card_expiry,
        coalesce(upper(card_issuer_bank), 'UNKNOWN') as card_issuer_bank,
        case when card_number like '%E%' then cast(try_to_number(card_number) as varchar)
             else coalesce(card_number,'UNKNOWN') end as card_number,
        coalesce(card_last4, '0000') as card_last4,
        coalesce(upper(card_network), 'UNKNOWN') as card_network,
        coalesce(upper(card_type), 'UNKNOWN') as card_type,
        coalesce(netbanking_account_mask, 'NA') as netbanking_account_mask,
        coalesce(upper(netbanking_bank), 'UNKNOWN') as netbanking_bank,
        coalesce(upper(netbanking_gateway), 'UNKNOWN') as netbanking_gateway,
        coalesce(netbanking_ifsc, 'NA') as netbanking_ifsc,
        coalesce(netbanking_txn_ref, 'NO_TXN') as netbanking_txn_ref,
        coalesce(mode_of_payment, 'UNKNOWN') as mode_of_payment,
        lower(coalesce(mode_of_payment, 'unknown')) as cleaned_mode,
        coalesce(upper(payment_frequency), 'UNKNOWN') as payment_frequency,
        coalesce(upper(upi_app), 'UNKNOWN') as upi_app,
        coalesce(upi_txn_ref, 'NA') as upi_txn_ref,
        coalesce(upi_vpa, 'NA') as upi_vpa

    from source_data

),

mapped as (

    select 
        a.*,
        coalesce(b.standard_mode, 'UNKNOWN') as standardized_payment_mode
    from cleaned a
    left join {{ ref('payment_mode_mapping') }} b
        on lower(a.mode_of_payment) = lower(b.raw_value)

)

select 
    card_expiry,
    card_issuer_bank,
    card_number,
    card_last4,
    card_network,
    card_type,
    netbanking_account_mask,
    netbanking_bank,
    netbanking_gateway,
    netbanking_ifsc,
    netbanking_txn_ref,
    standardized_payment_mode as mode_of_payment,
    payment_frequency,
    upi_app,
    upi_txn_ref,
    upi_vpa

from mapped

{% if is_incremental() %}
where netbanking_txn_ref not in (select netbanking_txn_ref from {{ this }})
{% endif %}