WITH monthly AS 
(SELECT * FROM 
           {{ ref('int_subscriptions_main') }} ),

invoice AS
(SELECT * FROM 
        {{ ref('stg_stripe__invoices')}} 
)

select
    s.month_start,
    s.subscription_id,
    s.customer_id,
    s.shopify_customer_id,
    s.plan_id,
    s.billing_interval,
    i.amount_due_usd as mrr_amount
FROM  monthly s
left join invoice i on  s.subscription_id = i.subscription_id and 
          date_trunc('month', i.period_start) = s.month_start

