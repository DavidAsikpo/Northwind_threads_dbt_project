-- int_new_customers_by_channel_month.sql
select
    channel,
    date_trunc('month', created_at) as month_start,
    count(distinct customer_id) as new_customers
from {{ ref('int_customer_channel_attribution') }}
group by 1, 2
order by 2