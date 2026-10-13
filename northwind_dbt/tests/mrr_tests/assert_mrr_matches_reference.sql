-- tests/assert_mrr_matches_reference.sql
select
    sum(current_mrr) as total_mrr
from {{ ref('fct_mrr_movements') }}
where month_start = date_trunc('month', '2026-08-01'::date)
having abs(sum(current_mrr) - 308000) > 5000  


