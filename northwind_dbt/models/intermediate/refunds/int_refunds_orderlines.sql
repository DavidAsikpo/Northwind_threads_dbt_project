select
        order_line_id,
        sum(subtotal) as refunded_amount,
        sum(quantity) as refunded_quantity,
        count(*) as refund_event_count
from {{ ref('stg_shopify__refunds') }}
group by 1
