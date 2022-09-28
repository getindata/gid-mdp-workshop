{{
    config(
      materialized='table',
      persist_docs={"relation":true, "columns": true}
    )
}}

with users as (
    select * from {{ ref('stg_ecommerce__users') }}
),
events as (
    select * from {{ ref('int_events_traffic_sources_pivoted')}}
),
users_and_events as (

    select 

        u.user_id,
        u.user_age,
        u.user_gender,
        u.user_email_domain,
        u.user_address_postal_code,
        u.user_address_city,
        u.user_address_country,
        e.total_traffic,
        e.first_event,
        e.most_recent_event,
        e.adwords_traffic,
        e.email_traffic,
        e.facebook_traffic,
        e.organic_traffic,
        e.youtube_traffic

    from users as u
    left join events as e
    on u.user_id = e.user_id
)

select * from users_and_events






