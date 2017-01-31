#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOWNLOADED=$( $DIR/download.rb )

if [ -z $DOWNLOADED ]; then
  cd /opt/mecab-ko-dic-2.0.1-20150920 && \
    tools/add-userdic.sh && \
    make install
  $DIR/restart.rb
fi
