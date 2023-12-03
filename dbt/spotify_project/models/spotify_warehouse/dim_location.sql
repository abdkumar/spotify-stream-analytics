
{{
  config(
    materialized='incremental',
    unique_key='locationKey',
    incremental_strategy = 'merge',
    transient=false
  )
}}

with final as (
    SELECT distinct
    city,
    state,
    country,
    latitude,
    longitude
    FROM  {{ref('cdc_staging')}}
)

SELECT {{ dbt_utils.generate_surrogate_key(['latitude', 'longitude', 'city', 'state', 'country']) }} as locationKey,
*
FROM final where exists (select 1 from final)




