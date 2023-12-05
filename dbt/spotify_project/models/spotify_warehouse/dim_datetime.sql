
{{
  config(
    materialized='incremental',
    unique_key='dateKey',
    incremental_strategy = 'merge',
    transient=false
  )
}}

with cte as (
  select to_timestamp(listen_timestamp) as timestamp from {{ref('cdc_staging')}}
),
final as (
SELECT distinct
    to_date(timestamp) as date,
    EXTRACT( DAYOFWEEK FROM timestamp) AS dayOfWeek,
    EXTRACT( DAY FROM timestamp) AS dayOfMonth,
    EXTRACT( WEEK FROM timestamp) AS weekOfYear,
    EXTRACT( MONTH FROM timestamp) AS month,
    EXTRACT( YEAR FROM timestamp) AS year,
    CASE WHEN EXTRACT( DAYOFWEEK FROM timestamp) IN (6,7) THEN True ELSE False END AS weekendFlag
FROM  cte where exists (select 1 from cte)
)
select *, {{ dbt_utils.generate_surrogate_key(['date']) }} AS dateKey from final

