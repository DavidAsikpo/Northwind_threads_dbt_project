with source as (

    select * from {{ source('stripe', 'INVOICES') }}

),

cleaned as (

    select
        INVOICE_ID::varchar                            as invoice_id,
        SUBSCRIPTION_ID::varchar                        as subscription_id,
        CUSTOMER_ID::varchar                            as customer_id,
        PLAN_ID::varchar                                as plan_id,
        SUBTOTAL::number(12, 0)                         as subtotal_cents,
        DISCOUNT_AMOUNT::number(12, 0)                  as discount_amount_cents,
        AMOUNT_DUE::number(12, 0)                       as amount_due_cents,
        AMOUNT_PAID::number(12, 0)                      as amount_paid_cents,
        round(AMOUNT_DUE::number(12, 0) / 100.0, 2)     as amount_due_usd,
        round(AMOUNT_PAID::number(12, 0) / 100.0, 2)    as amount_paid_usd,
        upper(trim(CURRENCY::varchar))                  as currency,
        lower(trim(STATUS::varchar))                    as status,
        lower(trim(BILLING_REASON::varchar))            as billing_reason,
        ATTEMPT_COUNT::number(10, 0)                    as attempt_count,
        upper(trim(COUPON_ID::varchar))                 as coupon_id,
        PERIOD_START::timestamp_ntz                     as period_start,
        PERIOD_END::timestamp_ntz                       as period_end,
        CREATED::timestamp_ntz                          as created_at,
        PAID_AT::timestamp_ntz                          as paid_at,
        _FIVETRAN_SYNCED::timestamp_ntz                 as _fivetran_synced
    from source

)

select * from cleaned