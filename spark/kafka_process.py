import pyspark.sql
import delta.tables

# Create a SparkSession
spark = pyspark.sql.SparkSession.builder.getOrCreate()

# Set the configuration for the SparkSession to access ADLS Gen 2 and Kafka
spark.conf.set('fs.azure.account.key.<ACCOUNT_NAME>', '<ACCOUNT_KEY>')
spark.conf.set('spark.hadoop.fs.azure.account.key.<ACCOUNT_NAME>', '<ACCOUNT_KEY>')
spark.conf.set('spark.sql.kafka.bootstrap.servers', '<KAFKA_BROKER_LIST>')

# Create a DataFrame from the Kafka stream
kafkaStream = spark.readStream.format('kafka').option('subscribe', '<KAFKA_TOPIC>').load()

# Convert the Kafka stream to a DataFrame
df = kafkaStream.selectExpr('CAST(value AS STRING)')

# Process the DataFrame
df = df.process(df)

# Enable CDC for the Delta Lake table
deltaTable = DeltaTable.forPath(spark, 'adl://<ACCOUNT_NAME>.azuredatalakestore.net/<CONTAINER_NAME>/<PATH_TO_DELTA_TABLE>')
if not deltaTable.cdcIsEnabled():
    deltaTable.enableChangeDataFeed()
    
# Write the DataFrame to Delta Lake in ADLS Gen 2
df.writeStream.outputMode('append').format('delta').save('adl://<ACCOUNT_NAME>.azuredatalakestore.net/<CONTAINER_NAME>/<PATH_TO_DELTA_TABLE>')

# Start the Spark streaming job
kafkaStream.writeStream.format('console').outputMode('append').trigger(processingTime='2 minutes').start()
