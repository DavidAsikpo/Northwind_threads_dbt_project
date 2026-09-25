with source as (

    select * from {{ source('shopify', 'ORDERS') }}

),

deduped as (

    
    select *
    from source
    qualify row_number() over (
        partition by ORDER_ID
        order by _FIVETRAN_SYNCED desc
    ) = 1

),

cleaned as (

    select
        ORDER_ID::number                             as order_id,
        ORDER_NUMBER::number                          as order_number,
        CUSTOMER_ID::number                           as customer_id,
        lower(trim(EMAIL::varchar))                   as email,
        CREATED_AT::timestamp_ntz                      as created_at,
        UPDATED_AT::timestamp_ntz                      as updated_at,
        PROCESSED_AT::timestamp_ntz                     as processed_at,
        CANCELLED_AT::timestamp_ntz                     as cancelled_at,
        upper(trim(CURRENCY::varchar))                  as currency,
        TOTAL_LINE_ITEMS_PRICE::number(12, 2)            as total_line_items_price,
        TOTAL_DISCOUNTS::number(12, 2)                   as total_discounts,
        TOTAL_SHIPPING::number(12, 2)                    as total_shipping,
        TOTAL_TAX::number(12, 2)                         as total_tax,
        TOTAL_PRICE::number(12, 2)                       as total_price,
        lower(trim(FINANCIAL_STATUS::varchar))           as financial_status,
        lower(trim(FULFILLMENT_STATUS::varchar))         as fulfillment_status,
        SHIPPED_AT::timestamp_ntz                        as shipped_at,
        lower(trim(SOURCE_NAME::varchar))                as source_name,
        upper(trim(DISCOUNT_CODE::varchar))              as discount_code,
        upper(trim(SHIPPING_COUNTRY_CODE::varchar))      as shipping_country_code,
        upper(trim(SHIPPING_PROVINCE_CODE::varchar))     as shipping_province_code,
        TEST::boolean                                    as is_test_order,
        _FIVETRAN_DELETED::boolean                       as _fivetran_deleted,
        _FIVETRAN_SYNCED::timestamp_ntz                  as _fivetran_synced
    from deduped
    where coalesce(TEST, false) = false
      and coalesce(_FIVETRAN_DELETED, false) = false

)

select * from cleaned