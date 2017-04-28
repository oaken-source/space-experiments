#!/bin/bash

set -eu

pushd ../../ >/dev/null
. prepare-javaspaces.sh
popd >/dev/null

mkdir -p logs

usage() {
  echo "usage: $0 <start|stop|status>"
  exit 2
}

if [ -z "${1:-}" ]; then
  usage
fi

running() {
  if [ -z "${1:-}" ]; then
    if running "outrigger" && running "reggie"; then
      return 0
    else
      return 1
    fi
  fi

  if [ -f logs/$1.pid ] && ps $(cat logs/$1.pid) &> /dev/null; then
    return 0
  else
    return 1
  fi
}

do_start() {
  if [ -z "${1:-}" ]; then
    do_start "reggie" && sleep 5 && do_start "outrigger"
    return 0
  fi

  if ! running "$1"; then
    cd server
    java $JVM_ARGS -jar $LIB/start.jar start-$1.config &> ../logs/$1.log &
    echo $! > ../logs/$1.pid
    cd ..
  fi
}

do_stop() {
  if [ -z "${1:-}" ]; then
    do_stop "outrigger" && do_stop "reggie"
    return 0
  fi

  if running "$1"; then
    kill $(cat logs/$1.pid)
  fi
}

case $1 in
  start)
      if ! running; then
        do_start
      fi
      sleep 1
      if ! running; then
        echo "ERROR: failed to start javaspaces-server" >&2
        exit 1
      fi
    ;;
  stop)
      if running; then
        do_stop && sleep 1
      fi
      if running; then
        echo "ERROR: failed to stop javaspaces-server" >&2
        exit 1
      fi
    ;;
  status)
      if running; then
        echo "javaspaces-server is running"
      else
        echo "javaspaces-server is stopped"
      fi
    ;;
  *)
    usage
    ;;
esac
