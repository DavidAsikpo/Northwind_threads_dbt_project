-- tests/assert_excluded_subs_are_payment_failures.sql
select subscription_id, start_date, ended_at, cancel_reason
from {{ ref('int_subscriptions_priced') }}
where subscription_id not in (
    select distinct subscription_id from {{ ref('fct_mrr_movements') }}
)
and coalesce(cancel_reason, 'unknown') != 'payment_failed'