#!/bin/bash
# 가중치를 임의로 조정
# https://groups.google.com/forum/#!searchin/eunjeon/%EA%B8%B0%EB%B6%84%EC%84%9D%7Csort:relevance/eunjeon/aOVOlvxbSs0/jNgNwNGb7w0J
sed -i -E 's/^(가방,[0-9]+,[0-9]+),([0-9]+)/\1,500/' $1
