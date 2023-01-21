#!/bin/bash
set -u
num=$1
factorial=1
for ((i = 1; i <= $num; i++)); do
  factorial=$(($factorial*$i))
done
echo "!$1=$factorial"
