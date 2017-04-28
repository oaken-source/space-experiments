#!/bin/bash

set -euo pipefail

do_javaspaces() {
  echo "hello world experiment :: JavaSpaces"

  echo "  -> starting server"
  pushd ../../../servers/javaspaces/ >/dev/null
  ./server.sh start | sed 's/^/    | /'
  popd >/dev/null

  echo "  -> running experiment"
  ./client.sh | sed 's/^/    | /'

  echo "  -> stopping server"
  pushd ../../../servers/javaspaces/ >/dev/null
  ./server.sh stop | sed 's/^/    | /'
  popd >/dev/null
}

do_pyspaces_xmlrpc() {
  echo "hello world experiment :: PySpacesXMLRPC"

  echo "  -> starting server"
  pushd ../../../servers/pyspaces/ >/dev/null
  ./server.sh start | sed 's/^/    | /'
  popd >/dev/null

  echo "  -> running experiment"
  ./client.sh | sed 's/^/    | /'

  echo "  -> stopping server"
  pushd ../../../servers/pyspaces/ >/dev/null
  ./server.sh stop | sed 's/^/    | /'
  popd >/dev/null
}

do_pyspaces_shmem() {
  echo "hello world experiment :: PySpacesShMem"

  echo "  -> clear shmems"
  find /dev/shm -iname '*helloworldpyspace*' -print -delete | sed 's/^/    | /'

  echo "  -> running experiment"
  ./client.sh | sed 's/^/    | /'

  echo "  -> clear shmems"
  find /dev/shm -iname '*helloworldpyspace*' -print -delete | sed 's/^/    | /'
}

if [ -z "${1:-}" ]; then
  args=$(find -mindepth 1 -maxdepth 1 -type d -printf '%P\n')
else
  args="$@"
fi

for target in $args; do
  case $target in
    javaspaces|pyspaces_xmlrpc|pyspaces_shmem)
      pushd $target >/dev/null
      do_$target
      popd >/dev/null
      ;;
    *)
      echo "$0: uncerognized target '$target'" >&2; exit 1
  esac
done



