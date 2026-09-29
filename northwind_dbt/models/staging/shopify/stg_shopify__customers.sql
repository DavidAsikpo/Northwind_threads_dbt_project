with source as (

    select * from {{ source('shopify', 'CUSTOMERS') }}

),

cleaned as (

    select
        CUSTOMER_ID::number                        as customer_id,
        lower(trim(EMAIL::varchar))                as email,
        trim(FIRST_NAME::varchar)                  as first_name,
        trim(LAST_NAME::varchar)                   as last_name,
        CREATED_AT::timestamp_ntz                  as created_at,
        UPDATED_AT::timestamp_ntz                  as updated_at,
        ACCEPTS_MARKETING::boolean                 as accepts_marketing,
        upper(trim(COUNTRY_CODE::varchar))         as country_code,
        upper(trim(PROVINCE_CODE::varchar))        as province_code,
        STATE::varchar                             as state,
        TAGS::varchar                              as tags,
        _FIVETRAN_DELETED::boolean                 as _fivetran_deleted,
        _FIVETRAN_SYNCED::timestamp_ntz            as _fivetran_synced
    from source
    where coalesce(_FIVETRAN_DELETED, false) = false

)

select * from cleaned



