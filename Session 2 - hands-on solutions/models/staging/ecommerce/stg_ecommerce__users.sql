{{
    config(
      materialized='table',
      persist_docs={"relation":true, "columns": true}
    )
}}


with users as (
    select * from {{ ref('base_ecommerce__users') }}
), 
countries_continents_mapped as (
    select * from {{ ref('ISO_like_Countries-Continents')}}
),
user_with_countries_reforged as (

    select 
        *,
        case 
            when user_address_country = 'Brasil' then 'Brazil'
            when user_address_country = 'United States' then 'US'
            when user_address_country = 'South Korea' then 'Korea, South'
            when user_address_country = 'España' then'Spain'
            when user_address_country = 'Deutschland' then'Germany'
            else user_address_country
        end as country_reforged            
    
    from users
),
users_with_continents as (

    select 
        user_id,
        split(user_email, '@')[ORDINAL(2)]   as user_email_domain,
        user_age,
        user_gender,
        user_address_postal_code,
        user_address_city,
        country_reforged                     as user_address_country,
        c.Continent                          as user_address_continent,
        user_traffict_source,
        user_account_created_at

    from user_with_countries_reforged as u
    left join countries_continents_mapped as c 
    on u.country_reforged = c.Country
)

select * from users_with_continents
