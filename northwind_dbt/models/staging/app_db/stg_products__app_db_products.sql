with source as (

    select * from {{ source('app_db', 'PRODUCTS') }}

),

cleaned as (

    select
        PRODUCT_ID::number                          as product_id,
        upper(trim(SKU::varchar))                   as sku,
        trim(NAME::varchar)                          as product_name,
        trim(CATEGORY::varchar)                       as category,
        PRICE::number(12, 2)                          as price,
        UNIT_COST::number(12, 2)                      as unit_cost,
        LAUNCHED_ON::date                             as launched_on,
        IS_ACTIVE::boolean                            as is_active,
        trim(SUPPLIER::varchar)                       as supplier,
        CREATED_AT::timestamp_ntz                     as created_at,
        UPDATED_AT::timestamp_ntz                     as updated_at,
        _FIVETRAN_SYNCED::timestamp_ntz               as _fivetran_synced
    from source

)

select * from cleaned