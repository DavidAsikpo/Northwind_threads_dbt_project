with source_shopify as (
    select * from {{ ref('stg_shopify__customers') }}
),

source_app_db as (
    select * from {{ ref('stg_app_db__users') }}
)
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.country_code,
        u.utm_source,
        u.utm_campaign
    from source_shopify c 
    left join source_app_db u  on c.customer_id = u.shopify_customer_id
  
