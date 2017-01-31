#!/bin/bash
NUM=$1
NODE_NAME="es1-data${NUM}"
PID_FILE="/var/run/elasticsearch/${NODE_NAME}.pid"

if [ -z $NUM ]; then
  echo "Stop an elasticsearch data node"
  echo "Usage: stop_data_node.sh [node number]"
  echo "The node number is 1 or 2."
  exit 1
fi

kill -SIGTERM `cat $PID_FILE`
