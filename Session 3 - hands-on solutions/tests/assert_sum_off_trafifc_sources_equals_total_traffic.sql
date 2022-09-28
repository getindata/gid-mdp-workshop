with users as (
  select * from {{ ref('dim_users') }}
)

select 
  *
from users
where
  adwords_traffic + 
  email_traffic + 
  facebook_traffic + 
  organic_traffic + 
  youtube_traffic != total_traffic