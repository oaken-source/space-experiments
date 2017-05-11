#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

rm -r logs
mkdir -p logs

reps=${1:-100}

# run once to initialize the shmem
python client/connect.py 2> logs/connect_i.log

# warmup runs - not timed
python client/connect.py 2> logs/connect_ii.log
python client/connect.py 2> logs/connect_iii.log
python client/connect.py 2> logs/connect_iv.log

for i in `seq 1 $reps`; do
  time python client/connect.py 2> logs/connect_$i.log
done
