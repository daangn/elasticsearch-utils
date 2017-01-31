#!/bin/bash
NUM=$1
NODE_NAME="es1-data${NUM}"

if [ -z $NUM ]; then
  echo "Start an elasticsearch data node"
  echo "Usage: start_data_node.sh [node number]"
  echo "The node number is 1 or 2."
  exit 1
fi

export LD_LIBRARY_PATH=/usr/local/lib; /usr/share/elasticsearch/bin/elasticsearch \
  -Des.security.manager.enabled=false -d \
  -p "/var/run/elasticsearch/${NODE_NAME}.pid" \
  --node.name $NODE_NAME --node.data true --node.master false
