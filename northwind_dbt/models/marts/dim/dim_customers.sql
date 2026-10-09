SELECT CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, COUNTRY_CODE from {{ ref('snap_customer') }}
WHERE dbt_valid_to IS NULL