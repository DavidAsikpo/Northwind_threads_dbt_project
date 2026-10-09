select
    s.channel,
    date_trunc('month', s.date_day) as month_start,
    sum(s.amount_spent) as total_spend,
    nc.new_customers,
    sum(s.amount_spent) / nullif(nc.new_customers, 0) as cac
from {{ ref('int_ad_spend_by_channel_day') }} s
left join {{ ref('int_new_customers_by_channel_month') }} nc
    on s.channel = nc.channel
    and date_trunc('month', s.date_day) = nc.month_start
group by 1, 2, 4 