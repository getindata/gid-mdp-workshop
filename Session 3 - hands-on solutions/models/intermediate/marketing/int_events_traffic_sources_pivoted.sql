{{
    config(
      materialized='table',
      persist_docs={"relation":true, "columns": true}
    )
}}

with events as (
    select * from {{ ref('stg_ecommerce__events') }}
),
pivot_event_traffic_source_aggd_by_user as (
    select 

        user_id,
        sum(case when event_traffic_source = 'Adwords' then 1 else 0 end)   as adwords_traffic,
        sum(case when event_traffic_source = 'Email' then 1 else 0 end)     as email_traffic,
        sum(case when event_traffic_source = 'Facebook' then 1 else 0 end)  as facebook_traffic,
        sum(case when event_traffic_source = 'Organic' then 1 else 0 end)   as organic_traffic,
        sum(case when event_traffic_source = 'YouTube' then 1 else 0 end)   as youtube_traffic,
        count(event_traffic_source)                                         as total_traffic,
        min(event_created_at)                                               as first_event,
        max(event_created_at)                                               as most_recent_event

    from events
    where user_id is not null
    group by user_id
)

select * from pivot_event_traffic_source_aggd_by_user