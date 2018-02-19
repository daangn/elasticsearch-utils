#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOWNLOADED=$( $DIR/download.rb )

if [ -z $DOWNLOADED ]; then
  echo "Not updated"
  exit 0
fi

$DIR/install.sh
$DIR/restart.rb
