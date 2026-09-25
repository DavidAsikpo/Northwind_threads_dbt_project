with source as (

    select * from {{ source('stripe', 'REFUNDS') }}

),

cleaned as (

    select
        REFUND_ID::varchar                             as refund_id,
        CHARGE_ID::varchar                              as charge_id,
        AMOUNT::number(12, 0)                           as amount_cents,
        round(AMOUNT::number(12, 0) / 100.0, 2)         as amount_usd,
        upper(trim(CURRENCY::varchar))                  as currency,
        lower(trim(STATUS::varchar))                    as status,
        lower(trim(REASON::varchar))                    as reason,
        CREATED::timestamp_ntz                          as created_at,
        METADATA_SHOPIFY_REFUND_ID::number              as shopify_refund_id,
        _FIVETRAN_SYNCED::timestamp_ntz                 as _fivetran_synced
    from source

)

select * from cleaned