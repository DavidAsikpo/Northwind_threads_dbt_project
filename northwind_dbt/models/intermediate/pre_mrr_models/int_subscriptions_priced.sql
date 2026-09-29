with subscriptions as (
    select * from {{ ref('stg_stripe__subscriptions') }}
),

plans as (
    select * from {{ ref('stg_stripe__plans') }}
)

select
    s.subscription_id,
    s.customer_id,
    s.shopify_customer_id,
    s.plan_id,
    s.status,
    s.start_date,
    s.canceled_at,
    s.ended_at,
    s.cancel_reason,
    p.billing_interval,
    p.amount_usd,
    case
        when p.billing_interval = 'year' then round(p.amount_usd / 12.0, 2)
        else p.amount_usd
    end as mrr_amount
from subscriptions s
join plans p on s.plan_id = p.plan_id

