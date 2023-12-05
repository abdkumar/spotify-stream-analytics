
{{
  config(
    materialized='view',
    transient=false,
    on_schema_change='fail',
    partition_by={
    "field": "timestamp",
    "data_type": "timestamp",
    "granularity": "hour"
  }
  )
}}

SELECT
    fact_streams.eventId AS eventId,        
    fact_streams.userKey AS userKey,
    fact_streams.artistKey AS artistKey,
    fact_streams.songKey AS songKey ,
    fact_streams.dateKey AS dateKey,
    fact_streams.locationKey AS locationKey,
    fact_streams.timestamp AS timestamp,

    dim_users.first_name AS first_name,
    dim_users.last_name AS last_name,
    dim_users.full_name AS full_name,
    dim_users.gender AS gender,
    
    dim_songs.*  exclude(songKey, artistKey),

    dim_location.city AS city,
    dim_location.state AS state,
    dim_location.country AS country,
    dim_location.latitude AS latitude,
    dim_location.longitude AS longitude,

    dim_datetime.* exclude(dateKey),

    dim_artists.artistName AS artistName,
    dim_artists.artistId AS artistId
    
FROM
    {{ ref('fact_streams') }}
JOIN
    {{ ref('dim_users') }} ON fact_streams.userKey = dim_users.userKey
JOIN
    {{ ref('dim_songs') }} ON fact_streams.songKey = dim_songs.songKey
JOIN
    {{ ref('dim_location') }} ON fact_streams.locationKey = dim_location.locationKey
JOIN
    {{ ref('dim_datetime') }} ON fact_streams.dateKey = dim_datetime.dateKey
JOIN
    {{ ref('dim_artists') }} ON fact_streams.artistKey = dim_artists.artistKey