
{{
  config(
    materialized='incremental',
    unique_key='songKey',
    incremental_strategy = 'merge',
    transient=false
  )
}}

with unique_songs as (
    SELECT distinct
    song_id,
    artist_name as artistName,
    artist_id as artistId,
    song_title,
    album_name,
    release_date,
    duration_ms,
    danceability,
    energy,
    key,
    loudness,
    mode,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo
    FROM  {{ref('cdc_staging')}}
),
final as (
    select songs.* exclude (artistName, artistId), artists.artistKey,
    ROW_NUMBER() over (partition by songs.song_id order by artists.artistName) as rnk
    from unique_songs AS songs
    INNER JOIN
    {{ref('dim_artists')}} AS artists
    ON songs.artistId=artists.artistId 
)
SELECT {{ dbt_utils.generate_surrogate_key(['song_id', 'song_title', 'album_name']) }} as songKey,
final.* exclude(rnk) from final WHERE rnk=1
