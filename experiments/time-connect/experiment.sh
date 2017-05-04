#!/bin/bash

set -euo pipefail

EXP_NAME="Connect MicroBenchmark"

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

pyspaces_shmem_cold_teardown() {
  find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
}

pyspaces_shmem_warm_teardown() {
  find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
}

if [ -z "${1:-}" ]; then
  args="javaspaces pyspaces_xmlrpc pyspaces_shmem"
else
  args="$@"
fi

for target in $args; do
  case $target in
    javaspaces|pyspaces_xmlrpc|pyspaces_shmem_cold|pyspaces_shmem_warm)
      echo "$EXP_NAME :: $target"
      echo "  -> setup"
      type -p ${target}_setup >/dev/null && ${target}_setup | sed 's/^/    | /'

      echo "  -> run"
      rm -f $expdir/$target.time
      pushd $target >/dev/null
      ./client.sh 2>&1 | while read -r line; do
        if [[ $line =~ r:\ .*s,\ u:\ .*s,\ s:\ .*s ]]; then
          echo "$line" >> $expdir/$target.time
        fi
        echo "$line" | sed 's/^/    | /'
      done
      popd >/dev/null

      echo "  -> teardown"
      type -p ${target}_setup >/dev/null && ${target}_teardown | sed 's/^/    | /'
      ;;
    *)
      echo "$0: uncerognized target '$target'" >&2; exit 1
  esac
done



