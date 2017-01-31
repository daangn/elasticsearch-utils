#!/bin/bash
# Add this script to /etc/rc.local
# for running on reboot

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# start master
export LD_LIBRARY_PATH=/usr/local/lib; /usr/share/elasticsearch/bin/elasticsearch \
  -Des.security.manager.enabled=false -d \
  -p /var/run/elasticsearch/es1-master.pid \
  --node.name es1-master --node.data false --node.master true

# start node
$DIR/start_data_node 1
