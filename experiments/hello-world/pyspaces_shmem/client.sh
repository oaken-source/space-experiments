#!/bin/bash

set -eu

pushd ../../../ >/dev/null
. prepare-pyspaces.sh
popd >/dev/null

mkdir -p logs

python client/producer.py 2> logs/producer.log
python client/consumer.py 2> logs/consumer.log
