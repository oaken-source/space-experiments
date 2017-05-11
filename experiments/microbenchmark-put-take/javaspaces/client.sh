#!/bin/bash

# build and execute the hello world javaspace client code.
# this requires the server to run.

set -e

pushd ../../../ >/dev/null
. prepare-javaspaces.sh
popd >/dev/null

cd client

make -s

export operation=$1
export tupletype=$2
export level=$3
reps=${4:-1}

for i in `seq 1 $reps`; do
  java $JVM_ARGS -jar $LIB/start.jar start-client.config
done
