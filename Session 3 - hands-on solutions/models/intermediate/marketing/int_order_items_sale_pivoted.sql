{{
    config(
      materialized='table',
      persist_docs={"relation":true, "columns": true}
    )
}}

with order_items as (
    select * from {{ ref('stg_ecommerce__order_items')}}
),
pivot_order_items_agg_by_user as (
    
    select 
        
        user_id,
        sum(case when order_item_status = 'Complete' then order_item_sale_price else 0 end)     as customer_total_value,
        count(distinct order_id)                                                                as order_cnt,
        min(order_item_created_at)                                                              as first_order_date,
        max(order_item_created_at)                                                              as most_recent_order_date,
        date_diff(max(date(order_item_created_at)), min(date(order_item_created_at)), year)     as customer_lifespan


    from order_items
    group by user_id
)

select * from pivot_order_items_agg_by_user