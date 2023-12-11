# https://dev.to/cloudx/kafka-docker-net-core-101-part-1-b0h
sudo service docker restart
cd ~/spotify-stream-analytics/kafka/
docker compose -f docker-compose.yml up -d

while true; do
    if docker ps | grep kafka; then
	echo "kafka started"
        break
    fi
done


# list topics
docker container exec kafka-kafka-1 kafka-topics --list --bootstrap-server ${KAFKA_BROKER_ADDRESS:-localhost}:9092    

# create topic
docker container exec kafka-kafka-1 kafka-topics --create --topic ${KAFKA_EVENTS_TOPIC:-sptofiy} --partitions 1 --replication-factor 1 --bootstrap-server ${KAFKA_ADDRESS:-localhost}:9092    

# describe topics
docker container exec kafka-kafka-1 kafka-topics --describe --bootstrap-server ${KAFKA_BROKER_ADDRESS:-localhost}:9092    

# produce events
# docker container exec -it kafka-kafka-1 /bin/bash
# kafka-console-producer --topic ${KAFKA_EVENTS_TOPIC:-sptofiy} --bootstrap-server ${KAFKA_BROKER_ADDRESS:-localhost}:9092


# consume events
# kafka-console-consumer --topic ${KAFKA_EVENTS_TOPIC:-sptofiy} --from-beginning --bootstrap-server ${KAFKA_BROKER_ADDRESS:-localhost}:9092