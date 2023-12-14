"""Schema for processing and storing streams
"""
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, LongType, IntegerType

EVENTS_SCHEMA = StructType(
    [
        StructField("first_name", StringType(), False),
        StructField("last_name", StringType(), True),
        StructField("gender", StringType(), True),
        StructField("city", StringType(), True),
        StructField("state", StringType(), True),
        StructField("country", StringType(), True),
        StructField("latitude", DoubleType(), True),
        StructField("longitude", DoubleType(), True),
        StructField("listen_timestamp", LongType(), True),
        StructField("song_id", StringType(), True),
        StructField("artist_name", StringType(), True),
        StructField("artist_id", StringType(), True),
        StructField("song_title", StringType(), True),
        StructField("album_name", StringType(), True),
        StructField("release_date", StringType(), True),
        StructField("duration_ms", LongType(), True),
        StructField("danceability", DoubleType(), True),
        StructField("energy", DoubleType(), True),
        StructField("key", IntegerType(), True),
        StructField("loudness", DoubleType(), True),
        StructField("mode", IntegerType(), True),
        StructField("speechiness", DoubleType(), True),
        StructField("acousticness", DoubleType(), True),
        StructField("instrumentalness", DoubleType(), True),
        StructField("liveness", DoubleType(), True),
        StructField("valence", DoubleType(), True),
        StructField("tempo", DoubleType(), True),
    ]
)


PROCESSED_SCHEMA = StructType(
    [
        StructField("first_name", StringType(), True),
        StructField("last_name", StringType(), True),
        StructField("gender", StringType(), True),
        StructField("city", StringType(), True),
        StructField("state", StringType(), True),
        StructField("country", StringType(), True),
        StructField("latitude", DoubleType(), True),
        StructField("longitude", DoubleType(), True),
        StructField("listen_timestamp", LongType(), True),
        StructField("song_id", StringType(), True),
        StructField("artist_name", StringType(), True),
        StructField("artist_id", StringType(), True),
        StructField("song_title", StringType(), True),
        StructField("album_name", StringType(), True),
        StructField("release_date", StringType(), True),
        StructField("duration_ms", LongType(), True),
        StructField("danceability", DoubleType(), True),
        StructField("energy", DoubleType(), True),
        StructField("key", IntegerType(), True),
        StructField("loudness", DoubleType(), True),
        StructField("mode", IntegerType(), True),
        StructField("speechiness", DoubleType(), True),
        StructField("acousticness", DoubleType(), True),
        StructField("instrumentalness", DoubleType(), True),
        StructField("liveness", DoubleType(), True),
        StructField("valence", DoubleType(), True),
        StructField("tempo", DoubleType(), True),
        StructField("year", IntegerType(), True),
        StructField("month", IntegerType(), True),
        StructField("hour", IntegerType(), True),
        StructField("day", IntegerType(), True),
        StructField("duration_minutes", DoubleType(), True),
        StructField("full_name", StringType(), True),
    ]
)
