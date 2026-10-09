
/* Validation Checks for the MRR model 
1. All subscriptions In Stripe.Subscriptions must have atleast one entry in the mrr model excluding failed payments 
2. 
*/

-- All subscriptions In Stripe.Subscriptions must have atleast one entry in the mrr model 
-- Number in stg_stripe__subscriptions = 15361
SELECT COUNT(DISTINCT SUBSCRIPTION_ID)
FROM  {{ ref('fct_mrr_movements') }}


-- singular test: confirm excluded subscriptions are all payment-failure cases,
-- not something else silently falling through the cracks
select subscription_id, start_date, ended_at, cancel_reason
from {{ ref('int_subscriptions_priced') }}
where subscription_id not in (
    select distinct subscription_id from {{ ref('int_subscriptions_monthly_snapshots') }}
)
and cancel_reason != 'payment_failed'



