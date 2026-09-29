
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
FROM orders_lines l
LEFT JOIN orders p
where p.order_id is null
       
