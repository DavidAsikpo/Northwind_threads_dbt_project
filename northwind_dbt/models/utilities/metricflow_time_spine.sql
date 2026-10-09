{{
    config(
        materialized = 'view'
    )
}}

select
    cast(date_day as date) as date_day
from {{ ref('fiscal_calendar') }}