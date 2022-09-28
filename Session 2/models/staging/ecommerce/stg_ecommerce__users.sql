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
        split(email, '@')[ORDINAL(2)]   as user_email_domain,
        age                             as user_age,
        gender                          as user_gender,
        postal_code                     as user_address_postal_code,
        city                            as user_address_city,
        country                         as user_address_country,
        traffic_source                  as user_traffict_source,
        created_at                      as user_account_created_at

    from source
)

select * from users
