With classified_movements as (
    select
        subscription_id,
        customer_id,
        month_start,
        previous_mrr,
        current_mrr,
        (current_mrr - previous_mrr) as mrr_delta,

        case
            -- 1. Brand new subscription (first time ever seen)
            when (previous_mrr = 0 or previous_mrr is null) 
                 and current_mrr > 0 
                 and month_start = first_active_month 
                then 'NEW'

            -- 2. Reactivated subscription (was 0/churned, returns in a later month)
            when previous_mrr = 0 
                 and current_mrr > 0 
                 and month_start > first_active_month 
                then 'REACTIVATION'

            -- 3. Expansion (MRR increased)
            when previous_mrr > 0 
                 and current_mrr > previous_mrr 
                then 'EXPANSION'

            -- 4. Contraction (MRR decreased, but still active)
            when previous_mrr > 0 
                 and current_mrr < previous_mrr 
                 and current_mrr > 0 
                then 'CONTRACTION'

            -- 5. Churn (was active, now 0)
            when previous_mrr > 0 
                 and current_mrr = 0 
                then 'CHURN'

            -- 6. Retained / Flat renewal
            when previous_mrr > 0 
                 and current_mrr = previous_mrr 
                then 'RETAINED'

            else 'OTHER'
        end as movement_type
    from {{ ref('int_subscriptions_mrr_movements') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['subscription_id', 'month_start']) }} as mrr_movement_id,
    subscription_id,
    customer_id,
    month_start,
    previous_mrr,
    current_mrr,
    mrr_delta,
    movement_type

from classified_movements
