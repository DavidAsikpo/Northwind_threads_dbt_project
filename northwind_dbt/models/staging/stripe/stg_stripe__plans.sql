with source as (

    select * from {{ source('stripe', 'PLANS') }}

),

cleaned as (

    select
        PLAN_ID::varchar                           as plan_id,
        PRODUCT::varchar                           as product,
        trim(NICKNAME::varchar)                    as plan_nickname,
        AMOUNT::number(12, 0)                      as amount_cents,
        round(AMOUNT::number(12, 0) / 100.0, 2)     as amount_usd,
        lower(trim(INTERVAL::varchar))             as billing_interval,
        upper(trim(CURRENCY::varchar))             as currency,
        ACTIVE::boolean                            as is_active,
        _FIVETRAN_SYNCED::timestamp_ntz            as _fivetran_synced
    from source

)

select * from cleaned