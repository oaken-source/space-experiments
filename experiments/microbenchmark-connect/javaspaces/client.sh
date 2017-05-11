#!/bin/bash

# build and execute the hello world javaspace client code.
# this requires the server to run.

set -e

pushd ../../../ >/dev/null
. prepare-javaspaces.sh
popd >/dev/null

cd client

make -s

reps=${1:-100}

# warmup runs - not timed
java $JVM_ARGS -jar $LIB/start.jar start-connect.config
java $JVM_ARGS -jar $LIB/start.jar start-connect.config
java $JVM_ARGS -jar $LIB/start.jar start-connect.config

for i in `seq 1 $reps`; do
  time java $JVM_ARGS -jar $LIB/start.jar start-connect.config
done
