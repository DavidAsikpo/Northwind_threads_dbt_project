
-- fct_refund_rate_by_product.sql
WITH products AS (
    SELECT PRODUCT_ID,
           SKU,
           PRODUCT_NAME,
           CATEGORY
    FROM {{ ref('stg_app_db__products') }}
),

ORDERS AS (
SELECT ORDER_LINE_ID,
       ORDER_ID, 
       QUANTITY, 
       PRODUCT_ID
FROM {{ ref('stg_shopify__order_lines') }}
),

refunds AS (
    SELECT refund_id,
           order_line_id,
           order_id,
           subtotal AS refunded_amount,
           quantity AS refunded_quantity
    FROM {{ ref('stg_shopify__refunds') }}
)

SELECT 
o.product_id,
sum(o.quantity) as total_units_sold, 
count(distinct(o.order_line_id)) as total_lines_sold,
sum(r.refunded_quantity) as units_refunded,
count(distinct(r.order_line_id)) as lines_refunded,
sum(r.refunded_amount) as total_refunded_amount,
100.0 * (count(distinct(r.order_line_id)) / nullif(count(distinct(o.order_line_id)), 0)) as refund_rate_pct
FROM orders o
LEFT JOIN refunds r
    ON o.order_line_id = r.order_line_id
LEFT JOIN products p
    ON o.product_id = p.product_id
WHERE o.product_id = '157'
GROUP BY 1



