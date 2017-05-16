#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

rm -rf logs
mkdir -p logs

operation=$1
tupletype=$2
level=$3
reps=${4:-1}

for i in `seq 1 $reps`; do
  find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
  python client/client.py $operation $tupletype $level 2> logs/client_$i.log
done
