#!/bin/bash

set -euo pipefail

EXP_NAME="MicroBenchmark Put/Take"

expdir=$(pwd)
basedir=$expdir/../..
serverdir=$basedir/servers/

javaspaces_setup() {
  pushd $serverdir/javaspaces/ >/dev/null
  ./server.sh start
  popd >/dev/null
}

javaspaces_teardown() {
  pushd $serverdir/javaspaces/ >/dev/null
  ./server.sh stop
  popd >/dev/null
}

pyspaces_xmlrpc_setup() {
  pushd $serverdir/pyspaces/ >/dev/null
  ./server.sh start
  popd >/dev/null
}

pyspaces_xmlrpc_teardown() {
  pushd $serverdir/pyspaces/ >/dev/null
  ./server.sh stop
  popd >/dev/null
}

pyspaces_shmem_teardown() {
  find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
}

if [ -z "${1:-}" ]; then
  args="javaspaces pyspaces_xmlrpc pyspaces_shmem"
else
  args="$@"
fi

export TIMEFORMAT="time: %lR"

for target in $args; do
  case $target in
    javaspaces|pyspaces_xmlrpc|pyspaces_shmem)
      for operation in put take; do
        for tupletype in null int string doublearray; do
          for level in empty filled; do
            echo "$EXP_NAME :: $target [$operation] [$tupletype] [$level]"
            echo "  -> setup"
            type -p ${target}_setup >/dev/null && ${target}_setup | sed 's/^/    | /'

            echo "  -> run"
            rm -f $expdir/$target-$operation-$tupletype-$level.time
            pushd $target >/dev/null
            ./client.sh $operation $tupletype $level 2>&1 | while read -r line; do
              if [[ $line =~ time:\ .*s ]]; then
                echo "$line" | cut -d' ' -f2- >> $expdir/$target-$operation-$tupletype-$level.time
              fi
              echo "$line" | sed 's/^/    | /'
            done
            popd >/dev/null

            echo "  -> teardown"
            type -p ${target}_setup >/dev/null && ${target}_teardown | sed 's/^/    | /'
          done
        done
      done
      ;;
    *)
      echo "$0: uncerognized target '$target'" >&2; exit 1
      ;;
  esac
done



