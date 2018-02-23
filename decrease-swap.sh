#!/bin/bash
cd "$(dirname "$0")"

LAST_SWAP="$((swapon --show | tail -n +2 | awk '{print $1}' && ls /swap.*) | sort | uniq -c | grep ' 2 ' | tail -1 | awk '{print $2}')"
if [ ! -z "$LAST_SWAP" ]
then
  sudo swapoff $LAST_SWAP
fi
