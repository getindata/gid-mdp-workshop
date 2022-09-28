{{
    config(
      materialized='table',
      persist_docs={"relation":true, "columns": true}
    )
}}

with source as (
    select * from {{ source('raw_ecommerce_eu', 'events') }}
),
renamed as (
    select
        id                          as event_id,
        user_id                     as user_id,
        sequence_number             as event_sequence_number,
        session_id                  as event_session_id,
        created_at                  as event_created_at,
        ip_address                  as event_ip_address,
        city                        as event_city,
        state                       as event_state,
        postal_code                 as postal_code,
        browser                     as event_browser,
        traffic_source              as event_traffic_source,
        uri                         as event_uri,
        event_type                  as event_type
    
    from source
)

select * from renamed