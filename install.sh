#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd /opt/mecab-ko-dic-2.0.1-20150920 && \
  tools/add-userdic.sh && \
  $DIR/replace.sh user-servicecustom.csv && \
  make clean all && make install
