-- If this test fail it means not all users who have purchased any item has created their user account

with customers_who_purchased_items as (
  select 
    distinct user_id 
  from {{ ref('stg_ecommerce__order_items') }}
),
customers_who_created_user_account as (
  select 
    distinct user_id
  from {{ ref('stg_ecommerce__users')}}
)
select * from customers_who_purchased_items
except distinct
select * from customers_who_created_user_account