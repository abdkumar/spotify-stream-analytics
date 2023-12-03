
{{
  config(
    materialized='incremental',
    unique_key='userKey',
    incremental_strategy = 'merge',
    transient=false
  )
}}

with unique_users as (
    SELECT distinct
    first_name,
    last_name,
    full_name,
    gender,
    city,
    state,
    country,
    latitude,
    longitude
    FROM  {{ref('cdc_staging')}}
),
final as (
    select users.first_name, users.last_name, users.full_name, users.gender, location.locationKey
    from unique_users AS users
    INNER JOIN
    {{ref('dim_location')}} AS location
    ON users.city=location.city AND users.state=location.state AND users.country=location.country 
    AND users.latitude=location.latitude AND users.longitude=location.longitude
)

SELECT {{ dbt_utils.generate_surrogate_key(['first_name', 'last_name', 'full_name', 'locationKey']) }} as userKey,
*
FROM final where exists (select 1 from final)