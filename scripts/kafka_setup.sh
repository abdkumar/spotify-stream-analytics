# https://dev.to/cloudx/kafka-docker-net-core-101-part-1-b0h
sudo service docker restart
cd ~/spotify-stream-analytics/kafka/
docker compose -f docker-compose.yml up -d

while true; do
    if docker ps | grep broker; then
	echo "kafka started"
        break
    fi
done


# list topics
docker container exec broker kafka-topics --list --bootstrap-server broker:29092

docker container exec broker kafka-consumer-groups --all-topics --bootstrap-server broker:29092 --list
# create topic
docker container exec broker kafka-topics --create --topic ${KAFKA_EVENTS_TOPIC:-sptofiy} --partitions 1 --replication-factor 1 --bootstrap-server broker:29092

# describe topics
docker container exec broker kafka-topics --describe --bootstrap-server broker:29092    

# produce events
# docker container exec -it broker /bin/bash
# kafka-console-producer --topic sptofiy --bootstrap-server broker:29092


# consume events
# docker container exec -it broker /bin/bash
# kafka-console-consumer --topic sptofiy --from-beginning --bootstrap-server broker:29092