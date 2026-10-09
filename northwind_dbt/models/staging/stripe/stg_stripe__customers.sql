with source as (

    select * from {{ source('stripe', 'CUSTOMERS') }}

),

cleaned as (

    select
        CUSTOMER_ID::varchar                              as customer_id,
        lower(trim(EMAIL::varchar))                        as email,
        trim(NAME::varchar)                                as name,
        CREATED::timestamp_ntz                             as created_at,
        DELINQUENT::boolean                                as is_delinquent,
        upper(trim(CURRENCY::varchar))                     as currency,
        METADATA_SHOPIFY_CUSTOMER_ID::number               as shopify_customer_id,
        _FIVETRAN_SYNCED::timestamp_ntz                    as _fivetran_synced
    from source

)

select * from cleaned