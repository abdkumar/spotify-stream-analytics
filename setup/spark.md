# spark steaming processing
1. Extract date, day, month, year, week from timestamp column
2. convert duration_ms, durastion_seconds and duration_minutes
3. Round latitude, longitude to 3 decimal places
4. Create full_name from first_name, last_name

# spark-submit command
spark-submit \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0,io.delta:delta-spark_2.12:3.0.0,io.delta:delta-core_2.12:2.4.0,org.apache.hadoop:hadoop-azure:3.3.6,org.apache.hadoop:hadoop-azure-datalake:3.3.6,org.apache.hadoop:hadoop-common:3.3.6 stream_events.py