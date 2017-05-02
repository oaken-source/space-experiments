#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

# cold
time python client/connect.py

# warm
time python client/connect.py
