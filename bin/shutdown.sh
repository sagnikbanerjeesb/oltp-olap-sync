#!/bin/bash

if [[ $PWD =~ .*oltp-olap-sync\/bin$ ]]
then
  cd ..
elif ! [[ $PWD =~ .*oltp-olap-sync$ ]]
then
  echo "This script needs to be executed from the root directory of the project! Aborting."
  exit 1
fi

echo "Killing kafka consumer..."
kill $(cat bin/kafka-consumer_pid.txt)
rm bin/kafka-consumer_pid.txt

echo "De-registering debezium connector"
curl -X DELETE localhost:8083/connectors/debezium-connector

echo "Killing kafka connect and broker..."
kill $(cat bin/kafka-connect_pid.txt)
rm bin/kafka-connect_pid.txt
kill -9 $(cat bin/kafka_pid.txt) #not able to shutdown kafka gracefully. even this command will have issues restarting kafka next time. need to shutdown and startup once again the next time.
rm bin/kafka_pid.txt

echo "Killing zookeeper..."
kill $(cat bin/zookeeper_pid.txt)
rm bin/zookeeper_pid.txt

echo "Removing postgres containers and volumes..."
cd postgres
docker-compose down
docker volume rm postgres_oltp-olap-sync_oltp-data
docker volume rm postgres_oltp-olap-sync_olap-data
cd ..

echo "Sleeping for 5s to allow kafka, zookeeper to stop"
sleep 5s

echo "Purging kafka and zookeeper logs..."
rm -rf kafka/tmp_kafka_logs/*
rm -rf kafka/tmp_zookeeper_logs/*
rm -rf kafka/logs/*
rm -rf logs/*