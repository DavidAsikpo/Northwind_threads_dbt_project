SELECT 
    s.month_start,
    s.subscription_id,
    s.customer_id,
    s.shopify_customer_id,
    i.plan_id,
    s.billing_interval,
    s.mrr_amount
From {{ ref('int_subscriptions_monthly_snapshots') }} s
inner join {{ ref('stg_stripe__invoices') }} i on s.subscription_id = i.subscription_id and date_trunc('month', i.period_start) = s.month_start


