with source as (

    select * from {{ source('stripe', 'CHARGES') }}

),

cleaned as (

    select
        CHARGE_ID::varchar                             as charge_id,
        CUSTOMER_ID::varchar                            as customer_id,
        AMOUNT::number(12, 0)                           as amount_cents,
        round(AMOUNT::number(12, 0) / 100.0, 2)         as amount_usd,
        AMOUNT_REFUNDED::number(12, 0)                  as amount_refunded_cents,
        upper(trim(CURRENCY::varchar))                  as currency,
        lower(trim(STATUS::varchar))                    as status,
        PAID::boolean                                   as is_paid,
        REFUNDED::boolean                               as is_refunded,
        CREATED::timestamp_ntz                          as created_at,
        INVOICE_ID::varchar                             as invoice_id,
        trim(DESCRIPTION::varchar)                      as description,
        lower(trim(FAILURE_CODE::varchar))              as failure_code,
        lower(trim(PAYMENT_METHOD_TYPE::varchar))       as payment_method_type,
        FEE::number(12, 0)                              as fee_cents,
        METADATA_ORDER_ID::number                       as order_id,
        METADATA_ORDER_NUMBER::number                   as order_number,
        _FIVETRAN_SYNCED::timestamp_ntz                 as _fivetran_synced
    from source

)

select * from cleaned