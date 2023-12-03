
{{
  config(
    materialized='incremental',
    unique_key='artistKey',
    incremental_strategy = 'merge',
    merge_update_columns = ['artistName', 'artistId'],
    transient=false
  )
}}
SELECT distinct artist_id as artistId, artist_name as artistName,
        {{ dbt_utils.generate_surrogate_key(['artistId']) }} AS artistKey
    from {{ref('cdc_staging')}}