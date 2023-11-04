# spotify-stream-analytics
Generate synthetic Spotify music stream dataset to create dashboards. Spotify API generates fake event data emitted to Kafka. Spark consumes and processes Kafka data, saving it to the Datalake. Airflow orchestrates the pipeline. dbt moves data to Snowflake, transforms it, and creates dashboards.
