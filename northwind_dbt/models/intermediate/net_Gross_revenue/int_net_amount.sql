with lines as (
    select
        order_line_id,
        order_id,
        price * quantity as gross_amount,
        total_discount as discount_amount
    from {{ ref('stg_shopify__order_lines') }}
),

refunds as (
    select
        order_line_id,
        sum(subtotal) as refunded_amount
    from {{ ref('stg_shopify__refunds') }}
    group by 1
)

select
    l.order_line_id,
    l.order_id,
    l.gross_amount,
    l.discount_amount,
    l.gross_amount - l.discount_amount as gross_after_discount,
    coalesce(r.refunded_amount, 0) as refunded_amount,
    (l.gross_amount - l.discount_amount) - coalesce(r.refunded_amount, 0) as net_revenue
from lines l
left join refunds r
    on l.order_line_id = r.order_line_id



