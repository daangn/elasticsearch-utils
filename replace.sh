#!/bin/bash
# 가중치를 임의로 조정
# https://groups.google.com/forum/#!searchin/eunjeon/%EA%B8%B0%EB%B6%84%EC%84%9D%7Csort:relevance/eunjeon/aOVOlvxbSs0/jNgNwNGb7w0J

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while read line; do
  if [[ ! -z $line ]]; then
    sed -i -E "s/^(${line},[0-9]+,[0-9]+),([0-9]+)/\1,500/" $1
  fi
done <"${DIR}/high_priority_words.txt"
