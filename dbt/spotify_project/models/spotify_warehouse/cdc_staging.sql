{{ config(materialized='table')}}

SELECT * from {{source('spotify_staging', 'staging_stream')}} 