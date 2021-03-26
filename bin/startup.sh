#!/bin/bash

if [[ $PWD =~ .*oltp-olap-sync\/bin$ ]]
then
  cd ..
elif ! [[ $PWD =~ .*oltp-olap-sync$ ]]
then
  echo "This script needs to be executed from the root directory of the project! Aborting."
  exit 1
fi

echo "Starting up postgres containes - OLTP and OLAP..."
cd postgres
docker-compose up -d
cd ..

rm logs/zookeeper.out
rm logs/kafka.out

echo "Starting up zookeeper. Check logs in logs/zookeeper.out"
nohup kafka/bin/zookeeper-server-start.sh kafka/config/zookeeper.properties > logs/zookeeper.out 2>&1 &
echo $! > bin/zookeeper_pid.txt

echo "Sleeping for 3 secs to let zookeeper come up"
sleep 3s

echo "Starting up kafka broker. Check logs in logs/kafka.out"
nohup kafka/bin/kafka-server-start.sh kafka/config/server.properties > logs/kafka.out 2>&1 &
echo $! > bin/kafka_pid.txt

echo "Starting up kafka connect. Check logs in logs/kafka-connect.out"
nohup kafka/bin/connect-distributed.sh kafka/config/pg-connect.properties > logs/kafka-connect.out 2>&1 &
echo $! > bin/kafka-connect_pid.txt

echo "Sleeping for 10 secs to let kafka broker and connect come up"
sleep 10s

echo "Starting up debezium kafka connect to track student and contact tables in OLTP DB..."
curl -X POST localhost:8083/connectors -H "Content-Type: application/json" -d @bin/template/pg-connector-config.json