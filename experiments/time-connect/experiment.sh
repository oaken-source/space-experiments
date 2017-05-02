#!/bin/bash

set -euo pipefail

EXP_NAME="Connect MicroBenchmark"


javaspaces_setup() {
  pushd ../../servers/javaspaces/ >/dev/null
  ./server.sh start
  popd >/dev/null
}

javaspaces_teardown() {
  pushd ../../servers/javaspaces/ >/dev/null
  ./server.sh stop
  popd >/dev/null
}

pyspaces_xmlrpc_setup() {
  pushd ../../servers/pyspaces/ >/dev/null
  ./server.sh start
  popd >/dev/null
}

pyspaces_xmlrpc_teardown() {
  pushd ../../servers/pyspaces/ >/dev/null
  ./server.sh stop
  popd >/dev/null
}

pyspaces_shmem_setup() {
  find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
}

pyspaces_shmem_teardown() {
  find /dev/shm -iname '*connectmicrobenchpyspace*' -delete
}

if [ -z "${1:-}" ]; then
  args="javaspaces pyspaces_xmlrpc pyspaces_shmem"
else
  args="$@"
fi

for target in $args; do
  case $target in
    javaspaces|pyspaces_xmlrpc|pyspaces_shmem)
      echo "$EXP_NAME :: $target"
      echo "  -> setup"
      ${target}_setup | sed 's/^/    | /'

      echo "  -> run"
      pushd $target >/dev/null
      ./client.sh 2>&1 | sed 's/^/    | /'
      popd >/dev/null

      echo "  -> teardown"
      ${target}_teardown | sed 's/^/    | /'
      ;;
    *)
      echo "$0: uncerognized target '$target'" >&2; exit 1
  esac
done



