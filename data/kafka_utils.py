import time
import json
import pandas as pd
from kafka import KafkaProducer


class KafkaStreamer:
    def __init__(self, broker_address: str) -> None:
        self.producer = KafkaProducer(
            bootstrap_servers=[broker_address],
            value_serializer=lambda x: json.dumps(x).encode("utf-8"),
        )

    def produce_dataframe(self, topic: str, dataframe: pd.DataFrame) -> bool:
        for row in dataframe.itertuples(index=False):
            print(row)
            key_bytes = str(time.time()).encode("utf-8")

            self.producer.send(topic, value=row._asdict(), key=key_bytes)
            # add delay
            time.sleep(0.5)

        self.producer.flush()
