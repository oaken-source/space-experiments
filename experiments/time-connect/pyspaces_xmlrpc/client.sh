#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

reps=${1:-100}

export TIMEFORMAT="r: %lR, u: %lU, s: %lS"

for i in `seq 1 $reps`; do
  time python client/connect.py
done
