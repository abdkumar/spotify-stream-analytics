# Setup Kafka VM
We will setup Kafka and data generator in a dedicated compute instance. Python Data Generator script will communicate with port 9092 of the broker container of Kafka to send/produce sptofy stream events.

![](../images/drawio/kafka_architecture.png)

- Establish SSH connection
SSH into the VM using username and public ip address
```
ssh user@ipaddress
```

- Clone git repo and cd into Kafka folder
```
https://github.com/abdkumar/spotify-stream-analytics.git
```

- Install docker & docker-compose
```
bash ~/spotify-stream-analytics/scripts/vm_setup.sh && \
exec newgrp docker
```
- Set environment variables
export KAFKA_BROKER_ADDRESS = IP.ADDRESS
export KAFKA_EVENTS_TOPIC = TOPIC_NAME


SPOTIPY_CLIENT_ID = os.environ.get("SPOTIPY_CLIENT_ID")
SPOTIPY_CLIENT_SECRET = os.environ.get("SPOTIPY_CLIENT_SECRET")




