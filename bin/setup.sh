#!/bin/bash

if [[ $PWD =~ .*oltp-olap-sync\/bin$ ]]
then
  cd ..
elif ! [[ $PWD =~ .*oltp-olap-sync$ ]]
then
  echo "This script needs to be executed from the root directory of the project! Aborting."
  exit 1
fi

#########################

mkdir logs

echo "Seting up kafka..."

echo "Downloading kafka (https://kafka.apache.org/downloads) ..."
curl https://downloads.apache.org/kafka/2.7.0/kafka_2.13-2.7.0.tgz --output kafka.tgz

echo "Extracting kafka..."
tar -xf ./kafka.tgz
rm -f ./kafka.tgz
mv ./kafka_* ./kafka

echo "Configuring kafka to store all logs within kafka directory and not under /tmp/ so that its easy to flush out kafka and zookeeper state..."
mkdir ./kafka/tmp_kafka_logs  # TODO review
mkdir ./kafka/tmp_zookeeper_logs  # TODO review

rm ./kafka/config/server.properties
rm ./kafka/config/zookeeper.properties

sed "s|###ROOT_DIR###|$PWD|g" ./bin/template/server.properties.template > ./kafka/config/server.properties  # TODO review
sed "s|###ROOT_DIR###|$PWD|g" ./bin/template/zookeeper.properties.template > ./kafka/config/zookeeper.properties  # TODO review

#########################

echo "Setting up debezium..."
mkdir debezium
cd debezium

echo "Checking out debezium compatible postgres image repo..."
git clone https://github.com/debezium/docker-images.git
echo "Building debezium compatible postgres image..."
docker build -t debezium-pg docker-images/postgres/12/

mkdir connects
cd connects

echo "Fetching debezium postgres connector plugin (https://debezium.io/documentation/reference/install.html) ..."
curl -L https://oss.sonatype.org/service/local/artifact/maven/redirect\?r\=snapshots\&g\=io.debezium\&a\=debezium-connector-postgres\&v\=LATEST\&c\=plugin\&e\=tar.gz --output postgres-connector.tar.gz
tar -xf ./postgres-connector.tar.gz
rm ./postgres-connector.tar.gz

cd ../..

echo "Setting up kafka connect properties file to load debezium connector plugin which will be used during startup"
sed "s|###DEBEZIUM_CONNECTS_DIR###|$PWD/debezium/connects|g" ./bin/template/pg-connect.properties.template > ./kafka/config/pg-connect.properties

echo "Setup complete"