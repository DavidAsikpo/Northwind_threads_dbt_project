{{ config(
    materialized = 'incremental',
    unique_key = 'order_month',
    on_schema_change = 'sync_all_columns'
) }}

select
    date_trunc('month', o.created_at) as order_month,
    l.gross_amount as gross_revenue,
    l.discount_amount as total_discounts,
    l.gross_after_discount as gross_after_discount,
    l.refunded_amount as total_refunds,
    l.net_revenue as net_revenue
from {{ ref('int_net_amount') }} l
join {{ ref('stg_shopify__orders') }} o
    on l.order_id = o.order_id
{% if is_incremental() %}
where date_trunc('month', o.created_at) > (select coalesce(max(order_month), '1900-01-01') from {{ this }})
{% endif %}
order by 1 asc





