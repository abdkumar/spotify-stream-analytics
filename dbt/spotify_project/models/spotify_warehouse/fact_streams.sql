
{{
  config(
    materialized='incremental',
    unique_key='eventId',
    incremental_strategy = 'append',
    transient=false,
    on_schema_change='fail',
    partition_by={
    "field": "timestamp",
    "data_type": "timestamp",
    "granularity": "hour"
  }
  )
}}

with final as (
    select 
    dim_users.userKey AS userKey, dim_songs.songKey AS songKey,
     dim_datetime.dateKey AS dateKey,
    to_timestamp(staging_stream.listen_timestamp) as timestamp
    from {{ref("cdc_staging")}} AS staging_stream
    LEFT JOIN {{ref('dim_location')}}
    ON staging_stream.latitude=dim_location.latitude AND staging_stream.longitude=dim_location.longitude
    AND staging_stream.city=dim_location.city AND staging_stream.state=dim_location.state
    AND staging_stream.country=dim_location.country
    LEFT JOIN {{ref('dim_users')}}
    ON staging_stream.first_name=dim_users.first_name AND staging_stream.last_name=dim_users.last_name
    AND staging_stream.gender=dim_users.gender AND dim_location.locationKey=dim_users.locationKey
    LEFT JOIN {{ref('dim_songs')}}
    ON staging_stream.song_id=dim_songs.song_id 
    LEFT JOIN {{ref("dim_datetime")}}
    ON to_date(to_timestamp(staging_stream.listen_timestamp))=dim_datetime.date
)

SELECT {{ dbt_utils.generate_surrogate_key(['userKey', 'songKey', 'dateKey','timestamp']) }} as eventId,
*
FROM final