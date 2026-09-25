with source as (

    select * from {{ source('app_db', 'USERS') }}

),

cleaned as (

    select
        USER_ID::number                                as user_id,
        SHOPIFY_CUSTOMER_ID::number                     as shopify_customer_id,
        lower(trim(EMAIL::varchar))                     as email,
        trim(FIRST_NAME::varchar)                       as first_name,
        trim(LAST_NAME::varchar)                        as last_name,
        CREATED_AT::timestamp_ntz                       as created_at,
        UPDATED_AT::timestamp_ntz                       as updated_at,
        EMAIL_VERIFIED::boolean                         as is_email_verified,
        MARKETING_OPT_IN::boolean                       as is_marketing_opt_in,
        lower(trim(UTM_SOURCE::varchar))                as utm_source,
        lower(trim(UTM_MEDIUM::varchar))                as utm_medium,
        lower(trim(UTM_CAMPAIGN::varchar))              as utm_campaign,
        lower(trim(REFERRER_DOMAIN::varchar))           as referrer_domain,
        LANDING_PAGE::varchar                           as landing_page,
        LAST_LOGIN_AT::timestamp_ntz                    as last_login_at,
        DELETED_AT::timestamp_ntz                       as deleted_at,
        (DELETED_AT is not null)                        as is_gdpr_deleted,
        _FIVETRAN_SYNCED::timestamp_ntz                 as _fivetran_synced
    from source

)

select * from cleaned