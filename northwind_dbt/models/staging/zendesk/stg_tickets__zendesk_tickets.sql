with source as (

    select * from {{ source('zendesk', 'TICKETS') }}

),

cleaned as (

    select
        TICKET_ID::number                             as ticket_id,
        REQUESTER_ID::number                           as requester_id,
        lower(trim(REQUESTER_EMAIL::varchar))          as requester_email,
        CREATED_AT::timestamp_ntz                      as created_at,
        UPDATED_AT::timestamp_ntz                      as updated_at,
        SOLVED_AT::timestamp_ntz                       as solved_at,
        lower(trim(STATUS::varchar))                   as status,
        lower(trim(PRIORITY::varchar))                 as priority,
        lower(trim(TYPE::varchar))                     as ticket_type,
        lower(trim(CHANNEL::varchar))                  as channel,
        trim(SUBJECT::varchar)                          as subject,
        lower(trim(CATEGORY::varchar))                  as category,
        ORDER_ID::number                                as order_id,
        GROUP_NAME::varchar                             as group_name,
        ASSIGNEE_ID::number                             as assignee_id,
        lower(trim(SATISFACTION_RATING::varchar))       as satisfaction_rating,
        FIRST_REPLY_MINUTES::number                      as first_reply_minutes,
        RESOLUTION_MINUTES::number                       as resolution_minutes,
        (SOLVED_AT is not null)                          as is_solved,
        _FIVETRAN_SYNCED::timestamp_ntz                  as _fivetran_synced
    from source

)

select * from cleaned