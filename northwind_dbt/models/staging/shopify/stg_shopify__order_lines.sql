with source as (

    select * from {{ source('shopify', 'ORDER_LINES') }}

),

cleaned as (

    select
        ORDER_LINE_ID::number                  as order_line_id,
        ORDER_ID::number                       as order_id,
        PRODUCT_ID::number                     as product_id,
        upper(trim(SKU::varchar))              as sku,
        trim(TITLE::varchar)                   as title,
        trim(VARIANT_TITLE::varchar)           as variant_title,
        QUANTITY::number(10, 0)                as quantity,
        PRICE::number(12, 2)                   as price,
        TOTAL_DISCOUNT::number(12, 2)          as total_discount,
        TAX_AMOUNT::number(12, 2)              as tax_amount,
        _FIVETRAN_SYNCED::timestamp_ntz        as _fivetran_synced
    from source

)

select * from cleaned
where order_id not in (
select
    order_id
from {{ source('shopify', 'ORDERS') }} 
WHERE  TEST = 'true')





