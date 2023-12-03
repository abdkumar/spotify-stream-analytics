
{{
  config(
    materialized='incremental',
    unique_key='dateKey',
    incremental_strategy = 'merge',
    transient=false
  )
}}

SELECT distinct
    DATE_PART(epoch_second, release_date) AS dateKey,
    release_date as date,
    EXTRACT( DAYOFWEEK FROM release_date) AS dayOfWeek,
    EXTRACT( DAY FROM release_date) AS dayOfMonth,
    EXTRACT( WEEK FROM release_date) AS weekOfYear,
    EXTRACT( MONTH FROM release_date) AS month,
    EXTRACT( YEAR FROM release_date) AS year,
    CASE WHEN EXTRACT( DAYOFWEEK FROM release_date) IN (6,7) THEN True ELSE False END AS weekendFlag
FROM  {{ref('cdc_staging')}}
where exists (select 1 from {{ref('cdc_staging')}})
