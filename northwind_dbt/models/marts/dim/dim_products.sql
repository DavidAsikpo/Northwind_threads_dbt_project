SELECT PRODUCT_ID,
       PRODUCT_NAME,
       SKU,
       CATEGORY,
       PRICE
FROM {{ ref('snap_product') }}
WHERE dbt_valid_to IS NULL