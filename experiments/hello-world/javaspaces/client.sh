#!/bin/bash

# build and execute the hello world javaspace client code.
# this requires the server to run.

set -e

pushd ../../../ >/dev/null
. prepare-javaspaces.sh
popd >/dev/null

cd client

make

java $JVM_ARGS -jar $LIB/start.jar start-producer.config
java $JVM_ARGS -jar $LIB/start.jar start-consumer.config
