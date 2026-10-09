
--- CHECK FOR DUPLICATES IN ADS.GOOGLE_ADS_DAILY
WITH BASE AS
(SELECT DATE,
       CAMPAIGN_ID,
       ROW_NUMBER() OVER (PARTITION BY DATE, CAMPAIGN_ID ORDER BY DATE) AS occurence 
FROM {{ source('ads_source', 'GOOGLE_ADS_DAILY') }})
SELECT * FROM BASE 
WHERE occurence = 2

--- CHECK FOR DUPLICATES IN ADS.META_ADS_DAILY
WITH BASE AS
(SELECT DATE,
       CAMPAIGN_ID,
       ROW_NUMBER() OVER (PARTITION BY DATE, CAMPAIGN_ID ORDER BY DATE) AS occurence 
FROM {{ source('ads_source', 'META_ADS_DAILY') }})
SELECT * FROM BASE 
WHERE occurence = 2
-- NO DUPLICATES FOUND IN ADS SOURCE DATA


-- CHECKING FOR DUPLICATES IN SHOPIFY_ORDERS
SELECT * 
FROM {{ source('shopify', 'ORDERS') }}
WHERE ORDER_ID IN
(SELECT
ORDER_ID
FROM
(SELECT *,
      ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY CREATED_AT) AS RN
FROM {{ source('shopify', 'ORDERS') }})
WHERE RN = 2 )


-- CHECKING FOR DUPLICATES EMAILS FOR SAME CUSTOMER_ID IN SHOPIFY_CUSTOMERS 
SELECT
    LOWER(TRIM(EMAIL)) AS clean_email,
    COUNT(DISTINCT CUSTOMER_ID) AS customer_count
FROM {{ source('shopify', 'CUSTOMERS') }}
GROUP BY 1
HAVING COUNT(DISTINCT CUSTOMER_ID) > 1
ORDER BY 2 DESC

--- LOOKING AT CUSTOMER EMAILS WITH REPEATS ACROSS CUSTOMERS ID'S
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY EMAIL ORDER BY EMAIL) 
FROM {{ source('shopify', 'CUSTOMERS') }}
WHERE EMAIL IN
(SELECT
    EMAIL,
FROM {{ source('shopify', 'CUSTOMERS') }}
GROUP BY 1
HAVING COUNT(DISTINCT CUSTOMER_ID) > 1)

       
-----
SELECT * FROM {{ ref('stg_stripe__invoices') }}
where CUSTOMER_ID = 'cus_78dde6e5fd29f05f'


SELECT SUBSCRIPTION_ID,
       COUNT(SUBSCRIPTION_ID) AS  COUNT
FROM {{ ref('stg_stripe__subscription_plan_changes') }}
GROUP BY 1
ORDER BY COUNT(SUBSCRIPTION_ID) DESC

--checking if stripe_subscriptions table has duplicates
SELECT COUNT(SUBSCRIPTION_ID) AS No_count,
       SUBSCRIPTION_ID
FROM {{ ref('stg_stripe__subscriptions') }}
GROUP BY 2
HAVING COUNT(SUBSCRIPTION_ID) > 1


SELECT * FROM {{ ref('stg_stripe__subscriptions') }}
WHERE SUBSCRIPTION_ID = 'sub_cce004cd52fe4419'

SELECT * FROM {{ ref('stg_stripe__subscription_plan_changes') }}
WHERE SUBSCRIPTION_ID = 'sub_cce004cd52fe4419'


SELECT * FROM {{ ref('stg_stripe__invoices') }}
WHERE subscription_id = 'sub_cce004cd52fe4419'



WITH monthly AS 
(SELECT * FROM 
           {{ ref('int_subscriptions_monthly_snapshots') }} ),

plan_changes AS
(SELECT * FROM 
        {{ ref('stg_stripe__subscription_plan_changes') }} ),

invoice_changes AS
(SELECT * FROM 
        {{ ref('stg_stripe__invoices')}} )

select
    s.month_start,
    s.subscription_id,
    s.customer_id,
    s.shopify_customer_id,
    s.billing_interval,
    s.mrr_amount,
    CASE WHEN c.new_plan_id is null THEN s.plan_id
         ELSE c.new_plan_id 
    END AS plan_id
FROM  monthly s
left join invoice_changes c on  s.subscription_id = c.subscription_id and 
          date_trunc('month', c.period_start) = s.month_start


WITH orders AS (
    SELECT * FROM {{ ref('stg_shopify__orders') }}
),

order_lines AS (
    SELECT * FROM {{ ref('stg_shopify__order_lines') }}
)

SELECT * 
FROM order_lines l
LEFT JOIN orders p ON  p.order_id = l.order_id
where p.order_id is null



-------
SELECT * FROM {{ ref('stg_shopify__refunds') }} shf
LEFT JOIN  {{ ref('stg_stripe__refunds') }} stf ON shf.refund_id = stf.shopify_refund_id
WHERE stf.shopify_refund_id is null

SELECT * FROM {{ ref('stg_stripe__refunds') }}
where shopify_refund_id is null

SELECT count(*) FROM {{ ref('stg_stripe__charges')}}

-- checking where gaps in the stripe_refunds occured in orders
with unrecorded_stripe_refunds as (
    -- Shopify refunds that do not have a matching Stripe refund record
    select
        r.order_id,
        r.order_line_id
    from {{ ref('stg_shopify__refunds') }} r
    left join {{ ref('stg_stripe__refunds') }} sr
        on r.refund_id = sr.shopify_refund_id
    where sr.refund_id is null
),

relevant_orders as (
    -- Distinct orders impacted by these unrecorded refunds
    select distinct order_id
    from unrecorded_stripe_refunds
),

refunded_lines as (
    -- Specific order lines already refunded in these unrecorded refunds
    select distinct order_line_id
    from unrecorded_stripe_refunds
    where order_line_id is not null
)

select oli.*
from {{ ref('stg_shopify__order_lines') }} oli
inner join relevant_orders ro
    on oli.order_id = ro.order_id
where oli.order_line_id not in (
    select order_line_id from refunded_lines
);


--------------------------------
SELECT * FROM {{ ref('stg_shopify__orders') }}
WHERE ORDER_ID = '5100000079677'


SELECT * FROM {{ ref('stg_stripe__charges') }}
where order_id = '5100000000004'



-- checking orders that where not accounted for but refunded/partially refunded 
with unrecorded_stripe_refunds as (
    -- Shopify refunds that do not have a matching Stripe refund record
    select
        r.order_id,
        r.order_line_id
    from {{ ref('stg_shopify__refunds') }} r
    left join {{ ref('stg_stripe__refunds') }} sr
        on r.refund_id = sr.shopify_refund_id
    where sr.refund_id is null
)

SELECT * FROM {{ ref('stg_shopify__orders') }}
WHERE ORDER_ID IN  (select distinct order_id
    from unrecorded_stripe_refunds)


SELECT * FROM {{ ref('stg_stripe__refunds') }}
WHERE SHOPIFY_REFUND_ID = '9000000000001'

SELECT * FROM {{ ref('stg_shopify__refunds') }}
WHERE REFUND_ID = '9000000000001'

SELECT * FROM {{ ref('stg_shopify__orders') }}
WHERE ORDER_ID = '5100000000012'

SELECT * FROM {{ ref('stg_stripe__charges') }}
WHERE CHARGE_ID = 'ch_08d12e6b76c84d3a'



