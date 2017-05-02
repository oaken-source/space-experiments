#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

mkdir -p logs

# cold
time python client/connect.py 2> logs/connect_cold.log

# warm
time python client/connect.py 2> logs/connect_warm.log
