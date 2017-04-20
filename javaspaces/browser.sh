#!/bin/bash

# start the service registrar explorer gui.
# this requires X forwarding.

set -eu

. javaspaces-prepare.sh

cd $RIVER_EXAMPLES_HOME/home/target/home-1.0-bin/

JVM_ARGS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true $JVM_ARGS"

java $JVM_ARGS -jar lib/start.jar start-browser.config
