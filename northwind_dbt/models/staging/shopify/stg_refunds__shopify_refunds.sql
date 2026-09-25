with source as (

    select * from {{ source('shopify', 'REFUNDS') }}

),

cleaned as (

    select
        REFUND_ID::number                    as refund_id,
        ORDER_ID::number                     as order_id,
        ORDER_LINE_ID::number                as order_line_id,
        QUANTITY::number(10, 0)              as quantity,
        SUBTOTAL::number(12, 2)              as subtotal,
        lower(trim(REASON::varchar))         as reason,
        lower(trim(RESTOCK_TYPE::varchar))   as restock_type,
        CREATED_AT::timestamp_ntz            as created_at,
        _FIVETRAN_SYNCED::timestamp_ntz      as _fivetran_synced
    from source

)

select * from cleaned