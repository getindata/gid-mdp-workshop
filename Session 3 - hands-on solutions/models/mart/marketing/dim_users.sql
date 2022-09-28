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
orders as (
    select * from {{ ref('int_order_items_sale_pivoted')}}
),
users_events_orders_joined as (

    select 

        u.user_id,
        u.user_age,
        u.user_gender,
        u.user_email_domain,
        u.user_address_postal_code,
        u.user_address_city,
        u.user_address_country,
        u.user_address_continent,
        e.total_traffic,
        e.first_event,
        e.most_recent_event,
        e.adwords_traffic,
        e.email_traffic,
        e.facebook_traffic,
        e.organic_traffic,
        e.youtube_traffic,
        o.customer_total_value,
        o.order_cnt,
        o.first_order_date,
        o.most_recent_order_date,
        o.customer_lifespan

    from users as u
    left join events as e
    on u.user_id = e.user_id
    left join orders as o
    on u.user_id = o.user_id
)

select * from users_events_orders_joined






