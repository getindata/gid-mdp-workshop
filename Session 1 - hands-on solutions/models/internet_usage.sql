{{
   config(
      materialized = 'table'
  )
}}

with users_table as (
  select
    id, 
    age,
    case 
      when age between 16 and 24 then '16-24'
      when age between 25 and 34 then '25-34'
      when age between 35 and 44 then '35-44'
      when age between 45 and 54 then '45-54'
      when age between 55 and 64 then '55-64'
      else 'lack of data'
    end as user_age_range,
     from {{ source('raw_ecommerce_eu', 'users') }}
),
internet_usage as (
  select
    age_range,
    daily_mobile_usage,
    daily_pc_usage
  from {{ ref('daily_internet_usage') }}
),
modif as (
select 
  id as user_id_,
  user_age_range,
  daily_mobile_usage,
  daily_pc_usage
from users_table
left join internet_usage
on user_age_range=age_range
)
select 
  user_age_range,
  daily_mobile_usage,
  daily_pc_usage,
  count(*) as num_of_purchase
from {{ source('raw_ecommerce_eu', 'events') }}
left join modif
on modif.user_id_=user_id
where event_type='purchase'
group by user_age_range,daily_mobile_usage,daily_pc_usage
order by count(*) desc