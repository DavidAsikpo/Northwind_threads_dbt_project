-- tests/assert_mrr_matches_reference.sql
select
    sum(mrr_amount) as total_mrr
from {{ ref('mrr_movements') }}
where month_start = date_trunc('month', '2026-08-01'::date)
having abs(sum(mrr_amount) - 308000) > 5000  


