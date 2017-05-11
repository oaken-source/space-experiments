#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

operation=$1
tupletype=$2
level=$3
reps=${4:-1}

for i in `seq 1 $reps`; do
  python client/client.py $operation $tupletype $level
done
