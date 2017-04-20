#!/bin/bash

set -eu

. pyspaces-prepare.sh

python client/producer.py
python client/consumer.py
