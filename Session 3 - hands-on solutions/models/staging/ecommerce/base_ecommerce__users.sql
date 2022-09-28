{{
    config(
      materialized='table',
      persist_docs={"relation":true, "columns": true}
    )
}}


with source as (
    select * from {{ source('raw_ecommerce_eu', 'users') }}
), 
users as (

    select 
        id                              as user_id,
        first_name                      as user_first_name,
        last_name                       as user_last_name,
        email                           as user_email,
        age                             as user_age,
        gender                          as user_gender,
        state                           as user_address_state,
        street_address                  as user_street_address,
        postal_code                     as user_address_postal_code,
        city                            as user_address_city,
        country                         as user_address_country,
        latitude                        as user_address_latitude,
        longitude                       as user_address_longitude,
        traffic_source                  as user_traffict_source,
        created_at                      as user_account_created_at

    from source
)

select * from users
