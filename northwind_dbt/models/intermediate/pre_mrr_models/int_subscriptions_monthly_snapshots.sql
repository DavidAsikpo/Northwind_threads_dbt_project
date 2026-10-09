with subs as (
    select * from {{ ref('int_subscriptions_priced') }}
),

calendar as (
    select distinct date_trunc('month', date_day) as month_start  
    from {{ ref('fiscal_calendar') }}
    where date_day <= current_date()
)

select
    c.month_start,
    s.subscription_id,
    s.customer_id,
    s.shopify_customer_id,
    s.plan_id,
    s.billing_interval,
    s.mrr_amount
from calendar c
join subs s
    on c.month_start >= date_trunc('month', s.start_date)
    and c.month_start < date_trunc('month', coalesce(s.ended_at, current_date() + 1))



