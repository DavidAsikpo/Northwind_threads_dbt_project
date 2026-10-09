with revenue as (
    SELECT
    cca.channel,
    date_trunc('month', o.created_at) as month_start,
    sum(nm.net_revenue) as total_revenue,
    FROM {{ ref('int_net_amount') }} nm
    LEFT JOIN {{ ref('stg_shopify__orders') }} o
    ON o.order_id = nm.order_id
    LEFT JOIN {{ ref('int_customer_channel_attribution') }} cca
    ON cca.customer_id = o.customer_id
    GROUP BY 1, 2

)

select
    s.channel,
    date_trunc('month', s.date_day) as month_start,
    sum(s.amount_spent) as total_spend,
    r.total_revenue,
    r.total_revenue / nullif(sum(s.amount_spent), 0) as roas
from {{ ref('int_ad_spend_by_channel_day') }} s
left join revenue r
    on s.channel = r.channel and date_trunc('month', s.date_day) = r.month_start
group by 1, 2, 4