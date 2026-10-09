select
    c.customer_id,
    c.created_at,
    coalesce(cm_utm.channel, cm_ref.channel,
        case when u.shopify_customer_id is null then 'unattributed_guest' else 'direct' end
    ) as channel
from {{ ref('stg_shopify__customers') }} c
left join {{ ref('stg_app_db__users') }} u on c.customer_id = u.shopify_customer_id
left join {{ ref('channel_mapping') }} cm_utm
    on u.utm_source = cm_utm.utm_source and u.utm_medium = cm_utm.utm_medium 
left join {{ ref('channel_mapping') }} cm_ref
    on u.referrer_domain = cm_ref.referrer_domain



