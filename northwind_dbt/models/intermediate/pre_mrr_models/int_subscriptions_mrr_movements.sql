-- models/intermediate/int_subscription_mrr_movements.sql

with monthly_subscriptions as (
    select
        subscription_id,
        customer_id,
        month_start,
        mrr_amount as mrr,
        plan_id,
        billing_interval
    from {{ ref('int_subscriptions_amount') }}
)
select
        subscription_id,
        customer_id,
        month_start,
        mrr as current_mrr,
        coalesce(
            lag(mrr) over (
                partition by subscription_id 
                order by month_start
            ), 
            0
        ) as previous_mrr,
        coalesce(
            lag(month_start) over (
                partition by subscription_id 
                order by month_start
            ),
            '1970-01-01'::date
        ) as previous_month_start,
        -- Detect first appearance of subscription across the entire dataset
        min(month_start) over (
            partition by subscription_id
        ) as first_active_month,
        plan_id,
        billing_interval
from monthly_subscriptions


