#!/bin/bash

if [[ $PWD =~ .*oltp_olap_sync\/bin$ ]]
then
  cd ..
elif ! [[ $PWD =~ .*oltp_olap_sync$ ]]
then
  echo "wrong directory"
  exit 1
fi

curl https://downloads.apache.org/kafka/2.7.0/kafka_2.13-2.7.0.tgz --output kafka.tgz
tar -xf ./kafka.tgz
rm -f ./kafka.tgz
mv ./kafka_* ./kafka
mkdir ./kafka/tmp_kafka_logs
mkdir ./kafka/tmp_zookeeper_logs

rm ./kafka/config/server.properties
rm ./kafka/config/zookeeper.properties

sed "s|###ROOT_DIR###|$PWD|g" ./bin/template/server.properties.template > ./kafka/config/server.properties
sed "s|###ROOT_DIR###|$PWD|g" ./bin/template/zookeeper.properties.template > ./kafka/config/zookeeper.properties