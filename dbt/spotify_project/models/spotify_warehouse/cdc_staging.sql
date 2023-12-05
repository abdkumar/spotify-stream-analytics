{{ config(materialized='table')}}

SELECT distinct * from {{source('spotify_staging', 'staging_stream')}} 