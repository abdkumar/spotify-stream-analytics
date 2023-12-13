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
docker container exec kafka kafka-topics --list --bootstrap-server kafka:9092

docker container exec kafka kafka-consumer-groups --all-topics --bootstrap-server kafka:9092 --list
# create topic
docker container exec kafka kafka-topics --create --topic ${KAFKA_EVENTS_TOPIC:-spotify} --partitions 1 --replication-factor 1 --bootstrap-server kafka:9092

# describe topics
docker container exec kafka kafka-topics --describe --bootstrap-server kafka:9092    

# produce events
# docker container exec -it broker /bin/bash
# kafka-console-producer --topic mytopic --bootstrap-server broker:29092

# kafka-console-producer --topic mytopic --bootstrap-server broker:29092
# consume events
# docker container exec -it broker /bin/bash
# kafka-console-consumer --topic mytopic --from-beginning --bootstrap-server broker:29092


# docker container exec broker kafka-topics --create --topic mytopic --partitions 1 --replication-factor 1 --bootstrap-server broker:29092

# docker container exec broker  kafka-broker-api-versions --bootstrap-server broker:29092

# same network conumption
# docker run -it --rm --network kafka_docker_example_net confluentinc/cp-kafka kafka-console-consumer --topic spotify --from-beginning --bootstrap-server localhost:29092

# delete topic
# docker exec kafka kafka-topics --delete --topic spotify --bootstrap-server broker:29092