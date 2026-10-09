{% snapshot snap_customer %}
{{ 
    config(
        target_schema='snapshots',
        unique_key='CUSTOMER_ID',
        strategy='check',
        check_cols=['FIRST_NAME', 'LAST_NAME', 'EMAIL', 'COUNTRY_CODE']
    )
}}
SELECT 
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    COUNTRY_CODE
FROM {{ ref('int_customers_deduped') }}

{% endsnapshot %}