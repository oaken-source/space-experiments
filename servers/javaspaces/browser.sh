#!/bin/bash

# start the service registrar explorer gui.
# this requires X forwarding.

set -eu

pushd ../../ >/dev/null
. prepare-javaspaces.sh
popd >/dev/null

JVM_ARGS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true $JVM_ARGS"

cd $RIVER_EXAMPLES_HOME/home/target/home-1.0-bin/
java $JVM_ARGS -jar lib/start.jar start-browser.config
