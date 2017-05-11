#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

rm -r logs
mkdir -p logs

reps=${1:-100}

# warmup runs - not timed
find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
python client/connect.py 2> logs/connect_i.log
find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
python client/connect.py 2> logs/connect_ii.log
find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
python client/connect.py 2> logs/connect_iii.log

for i in `seq 1 $reps`; do
  find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
  time python client/connect.py 2> logs/connect_$i.log
done
