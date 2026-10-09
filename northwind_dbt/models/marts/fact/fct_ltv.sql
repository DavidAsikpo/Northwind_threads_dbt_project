select
     a.channel,
     a.customer_id,
     SUM(l.net_revenue) as lifetime_revenue
from {{ ref('int_customer_channel_attribution') }} a
join {{ ref('stg_shopify__orders') }} o on a.customer_id = o.customer_id
join {{ ref('int_net_amount') }} l on o.order_id = l.order_id
group by 1, 2
