-- tests/assert_active_sub_count_matches_reference.sql
select count(distinct subscription_id) as active_subs
from {{ ref('mrr_movements') }}
where month_start = date_trunc('month', '2026-08-01'::date)
having abs(count(distinct subscription_id) - 6898) > 50