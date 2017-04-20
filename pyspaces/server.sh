#!/bin/bash

set -eu

. pyspaces-prepare.sh
mkdir -p logs

usage() {
  echo "usage: $0 <start|stop|status>"
  exit 2
}

if [ -z ${1:-} ]; then
  usage
fi

logfile=logs/pyspaces-server.log
pidfile=logs/pyspaces-server.pid

running() {
  if [ -f $pidfile ] && ps $(cat $pidfile) &> /dev/null; then
    return 0
  else
    return 1
  fi
}

case $1 in
  start)
      if ! running; then
        python -m pyspaces &> $logfile &
        echo $! > $pidfile
      fi
      sleep 1
      if ! running; then
        echo "ERROR: failed to start pyspaces-server" >&2
        exit 1
      fi
    ;;
  stop)
      if running; then
        kill $(cat $pidfile)
      fi
      if running; then
        echo "ERROR: failed to stop pyspaces-server" >&2
        exit 1
      fi
    ;;
  status)
      if running; then
        echo "pyspaces-server is running"
      else
        echo "pyspaces-server is stopped"
      fi
    ;;
  *)
    usage
    ;;
esac
