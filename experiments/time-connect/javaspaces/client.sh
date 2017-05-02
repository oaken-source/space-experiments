#!/bin/bash

# build and execute the hello world javaspace client code.
# this requires the server to run.

set -e

pushd ../../../ >/dev/null
. prepare-javaspaces.sh
popd >/dev/null

cd client

make -s

# cold
time java $JVM_ARGS -jar $LIB/start.jar start-connect.config

# war
time java $JVM_ARGS -jar $LIB/start.jar start-connect.config
