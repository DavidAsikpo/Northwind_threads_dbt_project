WITH monthly AS 
(SELECT * FROM 
           {{ ref('int_subscriptions_monthly_snapshots') }} ),

invoice_changes AS
(SELECT * FROM 
        {{ ref('stg_stripe__invoices')}} )

select
    s.month_start,
    s.subscription_id,
    s.customer_id,
    s.shopify_customer_id,
    s.billing_interval,
    s.mrr_amount,
    c.plan_id 
FROM  monthly s
left join invoice_changes c on  s.subscription_id = c.subscription_id and 
          date_trunc('month', c.period_start) = s.month_start

