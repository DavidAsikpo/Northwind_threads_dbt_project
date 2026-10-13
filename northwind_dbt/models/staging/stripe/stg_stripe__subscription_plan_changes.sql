with source as (

    select * from {{ source('stripe', 'SUBSCRIPTION_PLAN_CHANGES') }}

),

cleaned as (

    select
        SUBSCRIPTION_ID::varchar                as subscription_id,
        CHANGED_AT::timestamp_ntz               as changed_at,
        OLD_PLAN_ID::varchar                    as old_plan_id,
        NEW_PLAN_ID::varchar                    as new_plan_id,
        lower(trim(CHANGE_TYPE::varchar))       as change_type,
        _FIVETRAN_SYNCED::timestamp_ntz         as _fivetran_synced
    from source

)

select * from cleaned


