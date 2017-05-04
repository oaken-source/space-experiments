#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

rm -r logs
mkdir -p logs

reps=${1:-100}

export TIMEFORMAT="r: %lR, u: %lU, s: %lS"

# run once to initialize the shmem
python client/connect.py 2> logs/connect_0.log

for i in `seq 1 $reps`; do
  time python client/connect.py 2> logs/connect_$i.log
done
