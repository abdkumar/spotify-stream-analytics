import os
import json
from kafka import KafkaConsumer

KAFKA_BOOTSTRAP_SERVER = os.getenv("KAFKA_BROKER_ADDRESS") + ":9092"
KAFKA_TOPIC_NAME = os.getenv("KAFKA_EVENTS_TOPIC")

print("starting")
consumer = KafkaConsumer(
 bootstrap_servers=KAFKA_BOOTSTRAP_SERVER,
 value_deserializer = lambda v: json.loads(v.decode('ascii')),
 auto_offset_reset='earliest'
)

print("setup")
consumer.subscribe(topics='spotify')
print("subscribed")
for message in consumer:
  print ("%d:%d: v=%s" % (message.partition,message.offset,message.value))