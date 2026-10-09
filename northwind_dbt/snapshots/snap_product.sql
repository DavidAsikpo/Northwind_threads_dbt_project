{% snapshot snap_product %}
{{ 
    config(
        target_schema='snapshots',
        unique_key='PRODUCT_ID',
        strategy='check',
        check_cols=['PRODUCT_NAME', 'SKU', 'CATEGORY', 'PRICE']
    )
}}

SELECT PRODUCT_ID,
       PRODUCT_NAME,
       SKU,
       CATEGORY,
       PRICE
FROM {{ ref('int_products_deduped') }}

{% endsnapshot %}