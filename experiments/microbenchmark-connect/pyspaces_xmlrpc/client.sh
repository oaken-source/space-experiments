#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

reps=${1:-100}

# warmup runs - not timed
python client/connect.py
python client/connect.py
python client/connect.py

for i in `seq 1 $reps`; do
  time python client/connect.py
done
