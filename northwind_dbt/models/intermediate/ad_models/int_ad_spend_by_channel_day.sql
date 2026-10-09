select date_day, 'meta_ads' as channel, amount_spent, purchases, purchase_value
from {{ ref('stg_ads__meta_ads_daily') }}

union all

select date_day, 'google_ads' as channel, amount_spent, conversions as purchases, conversions_value as purchase_value
from {{ ref('stg_ads__google_ads_daily') }}