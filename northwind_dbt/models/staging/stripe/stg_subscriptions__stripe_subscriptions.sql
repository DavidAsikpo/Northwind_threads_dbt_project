with source as (

    select * from {{ source('stripe', 'SUBSCRIPTIONS') }}

),

cleaned as (

    select
        SUBSCRIPTION_ID::varchar                       as subscription_id,
        CUSTOMER_ID::varchar                            as customer_id,
        PLAN_ID::varchar                                as plan_id,
        lower(trim(STATUS::varchar))                    as status,
        CREATED::timestamp_ntz                          as created_at,
        START_DATE::timestamp_ntz                        as start_date,
        CURRENT_PERIOD_START::timestamp_ntz               as current_period_start,
        CURRENT_PERIOD_END::timestamp_ntz                 as current_period_end,
        CANCEL_AT_PERIOD_END::boolean                     as cancel_at_period_end,
        CANCELED_AT::timestamp_ntz                        as canceled_at,
        ENDED_AT::timestamp_ntz                           as ended_at,
        lower(trim(CANCEL_REASON::varchar))               as cancel_reason,
        upper(trim(COUPON_ID::varchar))                   as coupon_id,
        QUANTITY::number(10, 0)                           as quantity,
        LATEST_INVOICE_ID::varchar                        as latest_invoice_id,
        METADATA_SHOPIFY_CUSTOMER_ID::number              as shopify_customer_id,
        _FIVETRAN_SYNCED::timestamp_ntz                   as _fivetran_synced
    from source

)

select * from cleaned